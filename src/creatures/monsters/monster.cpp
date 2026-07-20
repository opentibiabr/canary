/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/monsters/monster_combat_intention.hpp"
#include "creatures/monsters/monster_pathfinding.hpp"
#include "creatures/monsters/monster_targeting.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/monster_compute_service.hpp"
#include "items/tile.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "map/map.hpp"
#include "map/spectators.hpp"
#include "io/iobestiary.hpp"

int32_t Monster::despawnRange;
int32_t Monster::despawnRadius;

uint32_t Monster::monsterAutoID = 0x50000001;

namespace {
	constexpr uint8_t MAX_BACKGROUND_FOLLOW_PATH_RADIUS = 12;
	constexpr size_t MAX_COMBAT_INTENTION_SPELLS = 256;
	constexpr size_t MAX_TARGET_RANK_CANDIDATES = 256;
	constexpr auto WALK_PLAYER_VISIBLE_HOLD = std::chrono::seconds(3);

	bool isMonsterPerfTestFriendlyFireTarget(const Monster &monster, const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) {
		const auto* targetMonster = creature ? creature->getMonsterRaw() : nullptr;
		return monsterPerfTestFriendlyFire && monster.isHostile() && !monster.isSummon() && targetMonster && targetMonster->isHostile()
			&& creature.get() != static_cast<const Creature*>(&monster)
			&& !creature->isSummon();
	}

	[[nodiscard]] bool pathReachesEndpoint(const NavRegionSnapshot &navigation, const Position &start, const std::vector<Direction> &directions, const Position &expectedEndpoint) {
		Position position = start;
		for (auto it = directions.rbegin(); it != directions.rend(); ++it) {
			if (*it > DIRECTION_LAST) {
				return false;
			}
			position = getNextPosition(*it, position);
			if (!navigation.getCell(position)) {
				return false;
			}
		}
		return position == expectedEndpoint;
	}

	bool isPlayerControlledCreature(const std::shared_ptr<Creature> &creature) {
		if (!creature) {
			return false;
		}
		if (creature->getPlayerRaw()) {
			return true;
		}
		const auto &master = creature->getMaster();
		return master && master->getPlayerRaw();
	}
}

bool Monster::FollowPathComputeRequest::matches(const FollowPathComputeRequest &other) const {
	return start == other.start && target == other.target && targetId == other.targetId && executeOnFollow == other.executeOnFollow
		&& params.fullPathSearch == other.params.fullPathSearch && params.clearSight == other.params.clearSight
		&& params.allowDiagonal == other.params.allowDiagonal && params.keepDistance == other.params.keepDistance
		&& params.maxSearchDist == other.params.maxSearchDist && params.minTargetDist == other.params.minTargetDist
		&& params.maxTargetDist == other.params.maxTargetDist;
}

std::shared_ptr<Monster> Monster::createMonster(const std::string &name) {
	const auto &mType = g_monsters().getMonsterType(name);
	if (!mType) {
		return nullptr;
	}
	return std::make_shared<Monster>(mType);
}

Monster::Monster(const std::shared_ptr<MonsterType> &mType) :
	m_lowerName(asLowerCaseString(mType->name)),
	nameDescription(asLowerCaseString(mType->nameDescription)),
	m_monsterType(mType) {
	defaultOutfit = mType->info.outfit;
	currentOutfit = mType->info.outfit;
	skull = mType->info.skull;
	health = mType->info.health * mType->getHealthMultiplier();
	healthMax = mType->info.healthMax * mType->getHealthMultiplier();
	runAwayHealth = mType->info.runAwayHealth * mType->getHealthMultiplier();
	baseSpeed = mType->getBaseSpeed();
	internalLight = mType->info.light;
	hiddenHealth = mType->info.hiddenHealth;
	targetDistance = mType->info.targetDistance;
	attackSpells = mType->info.attackSpells;
	defenseSpells = mType->info.defenseSpells;

	// Register creature events
	for (const std::string &scriptName : mType->info.scripts) {
		if (!registerCreatureEvent(scriptName)) {
			g_logger().warn("[Monster::Monster] - "
			                "Unknown event name: {}",
			                scriptName);
		}
	}
}

std::shared_ptr<Monster> Monster::getMonster() {
	return static_self_cast<Monster>();
}

std::shared_ptr<const Monster> Monster::getMonster() const {
	return static_self_cast<Monster>();
}

void Monster::setID() {
	if (id == 0) {
		id = monsterAutoID++;
	}
}

void Monster::addList() {
	g_game().addMonster(static_self_cast<Monster>());
}

void Monster::removeList() {
	g_game().removeMonster(static_self_cast<Monster>());
}

const std::string &Monster::getName() const {
	if (name.empty()) {
		return m_monsterType->name;
	}
	return name;
}

void Monster::setName(const std::string &name) {
	if (getName() == name) {
		return;
	}

	this->name = name;

	// NOTE: Due to how client caches known creatures,
	// it is not feasible to send creature update to everyone that has ever met it
	auto spectators = Spectators().find<Player>(position, true);
	for (const auto &spectator : spectators) {
		if (const auto &tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendUpdateTileCreature(static_self_cast<Monster>());
		}
	}
}

// Real monster name, set on monster creation "createMonsterType(typeName)"

const std::string &Monster::getTypeName() const {
	return m_monsterType->typeName;
}

const std::string &Monster::getNameDescription() const {
	if (nameDescription.empty()) {
		return m_monsterType->nameDescription;
	}
	return nameDescription;
}

void Monster::setNameDescription(std::string_view newNameDescription) {
	this->nameDescription = newNameDescription;
}

std::string Monster::getDescription(int32_t) {
	return nameDescription + '.';
}

CreatureType_t Monster::getType() const {
	return CREATURETYPE_MONSTER;
}

const Position &Monster::getMasterPos() const {
	return masterPos;
}

void Monster::setMasterPos(Position pos) {
	masterPos = pos;
}

bool Monster::canWalkOnFieldType(CombatType_t combatType) const {
	switch (combatType) {
		case COMBAT_ENERGYDAMAGE:
			return m_monsterType->info.canWalkOnEnergy;
		case COMBAT_FIREDAMAGE:
			return m_monsterType->info.canWalkOnFire;
		case COMBAT_EARTHDAMAGE:
			return m_monsterType->info.canWalkOnPoison;
		default:
			return true;
	}
}

double_t Monster::getReflectPercent(CombatType_t reflectType, bool useCharges) const {
	// Monster type reflect
	auto result = Creature::getReflectPercent(reflectType, useCharges);
	if (result != 0) {
		g_logger().debug("[{}] before mtype reflect element {}, percent {}", __FUNCTION__, fmt::underlying(reflectType), result);
	}
	auto it = m_monsterType->info.reflectMap.find(reflectType);
	if (it != m_monsterType->info.reflectMap.end()) {
		result += it->second;
	}

	if (result != 0) {
		g_logger().debug("[{}] after mtype reflect element {}, percent {}", __FUNCTION__, fmt::underlying(reflectType), result);
	}

	// Monster reflect
	auto monsterReflectIt = m_reflectElementMap.find(reflectType);
	if (monsterReflectIt != m_reflectElementMap.end()) {
		result += monsterReflectIt->second;
	}

	if (result != 0) {
		g_logger().debug("[{}] (final) after monster reflect element {}, percent {}", __FUNCTION__, fmt::underlying(reflectType), result);
	}

	return result;
}

void Monster::addReflectElement(CombatType_t combatType, int32_t percent) {
	g_logger().debug("[{}] added reflect element {}, percent {}", __FUNCTION__, fmt::underlying(combatType), percent);
	m_reflectElementMap[combatType] += percent;
}

int32_t Monster::getDefense(bool) const {
	auto mtypeDefense = m_monsterType->info.defense;
	if (mtypeDefense != 0) {
		g_logger().trace("[{}] old defense {}", __FUNCTION__, mtypeDefense);
	}
	mtypeDefense += m_defense;
	if (mtypeDefense != 0) {
		g_logger().trace("[{}] new defense {}", __FUNCTION__, mtypeDefense);
	}
	return mtypeDefense * getDefenseMultiplier();
}

void Monster::addDefense(int32_t defense) {
	g_logger().trace("[{}] adding defense {}", __FUNCTION__, defense);
	m_defense += defense;
	g_logger().trace("[{}] new defense {}", __FUNCTION__, m_defense);
}

Faction_t Monster::getFaction() const {
	if (const auto &master = getMaster()) {
		return master->getFaction();
	}
	return m_monsterType->info.faction;
}

bool Monster::isEnemyFaction(Faction_t faction) const {
	const auto &master = getMaster();
	if (master && master->getMonster()) {
		return master->getMonster()->isEnemyFaction(faction);
	}
	return m_monsterType->info.enemyFactions.empty() ? false : m_monsterType->info.enemyFactions.contains(faction);
}

bool Monster::isPushable() {
	return m_monsterType->info.pushable && baseSpeed != 0;
}

bool Monster::isAttackable() const {
	return m_monsterType->info.isAttackable;
}

bool Monster::canPushItems() const {
	return m_monsterType->info.canPushItems;
}

bool Monster::canPushCreatures() const {
	return m_monsterType->info.canPushCreatures;
}

bool Monster::isRewardBoss() const {
	return m_monsterType->info.isRewardBoss;
}

bool Monster::isHostile() const {
	return m_monsterType->info.isHostile;
}

bool Monster::isFamiliar() const {
	return m_monsterType->info.isFamiliar;
}

bool Monster::canSeeInvisibility() const {
	return isImmune(CONDITION_INVISIBLE);
}

void Monster::setCriticalDamage(uint16_t damage) {
	criticalDamage = damage;
}

uint16_t Monster::getCriticalDamage() const {
	return criticalDamage;
}

void Monster::setCriticalChance(uint16_t chance) {
	criticalChance = chance;
}

uint16_t Monster::getCriticalChance() const {
	return m_monsterType->info.critChance + criticalChance;
}

uint32_t Monster::getManaCost() const {
	return m_monsterType->info.manaCost;
}

RespawnType Monster::getRespawnType() const {
	return m_monsterType->info.respawnType;
}

void Monster::setSpawnMonster(const std::shared_ptr<SpawnMonster> &newSpawnMonster) {
	this->spawnMonster = newSpawnMonster;
}

uint32_t Monster::getHealingCombatValue(CombatType_t healingType) const {
	auto it = m_monsterType->info.healingMap.find(healingType);
	if (it != m_monsterType->info.healingMap.end()) {
		return it->second;
	}
	return 0;
}

void Monster::onAttackedCreatureDisappear(bool) {
	attackTicks = 0;
	extraMeleeAttack = true;
}

void Monster::onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin) {
	Creature::onCreatureAppear(creature, isLogin);

	if (m_monsterType->info.creatureAppearEvent != -1) {
		// onCreatureAppear(self, creature)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("[Monster::onCreatureAppear - Monster {} creature {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(m_monsterType->info.creatureAppearEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.creatureAppearEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);

		if (scriptInterface->callFunction(2)) {
			return;
		}
	}

	if (creature.get() == this) {
		updateTargetList();
		updateIdleStatus();
	} else {
		if (creature->getPlayerRaw() && canSee(creature->getPosition())) {
			observeVisiblePlayerForScheduling(creature);
		}
		addAsyncTask([this, creature] {
			onCreatureEnter(creature);
		});
	}
}

void Monster::onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout) {
	Creature::onRemoveCreature(creature, isLogout);

	if (m_monsterType->info.creatureDisappearEvent != -1) {
		// onCreatureDisappear(self, creature)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("[Monster::onCreatureDisappear - Monster {} creature {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(m_monsterType->info.creatureDisappearEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.creatureDisappearEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);

		if (scriptInterface->callFunction(2)) {
			return;
		}
	}

	if (creature.get() == this) {
		if (const auto &spawn = spawnMonster.lock()) {
			spawn->startSpawnMonsterCheck();
		}

		setIdle(true);
	} else {
		addAsyncTask([this, creature] {
			onCreatureLeave(creature);
		});
	}
}

void Monster::onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) {
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	if (m_monsterType->info.creatureMoveEvent != -1) {
		// onCreatureMove(self, creature, oldPosition, newPosition)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("[Monster::onCreatureMove - Monster {} creature {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(m_monsterType->info.creatureMoveEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.creatureMoveEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);

		LuaScriptInterface::pushPosition(L, oldPos);
		LuaScriptInterface::pushPosition(L, newPos);

		if (scriptInterface->callFunction(4)) {
			return;
		}
	}

	if (creature.get() == this) {
		updateTargetList();
		updateIdleStatus();
	} else {
		if (g_dispatcher().context().isMovementCommit()) {
			queueMovementAiRefresh(creature, oldPos, newPos);
		} else {
			processMovementAiRefresh(creature, oldPos, newPos);
		}
	}
}

void Monster::queueMovementAiRefresh(const std::shared_ptr<Creature> &creature, const Position &oldPos, const Position &newPos) {
	if (creature->getPlayerRaw() && canSee(newPos) && !canSee(oldPos)) {
		observeVisiblePlayerForScheduling(creature);
	}

	if (!pendingMovementAiRefresh.state.tryEnqueue()) {
		pendingMovementAiRefresh.needsFullRefresh = true;
		return;
	}

	pendingMovementAiRefresh.creature = creature;
	pendingMovementAiRefresh.oldPos = oldPos;
	pendingMovementAiRefresh.newPos = newPos;
	pendingMovementAiRefresh.needsFullRefresh = false;

	addAsyncTask([this] {
		executeMovementAiRefresh();
	});
}

void Monster::executeMovementAiRefresh() {
	const auto readyAt = pendingMovementAiRefresh.state.consume();
	if (!readyAt) {
		return;
	}

	const bool needsFullRefresh = pendingMovementAiRefresh.needsFullRefresh;
	const auto movedCreature = pendingMovementAiRefresh.creature.lock();
	const Position oldPos = pendingMovementAiRefresh.oldPos;
	const Position newPos = pendingMovementAiRefresh.newPos;

	pendingMovementAiRefresh.creature.reset();
	pendingMovementAiRefresh.needsFullRefresh = false;
	g_dispatcher().observeInternalWork(
		DispatcherInternalWork::MonsterMovementRefreshLateness,
		1,
		DispatcherPolicy::elapsed(*readyAt, Task::Clock::now())
	);

	if (needsFullRefresh || !movedCreature) {
		updateTargetList();
		updateIdleStatus();
		return;
	}

	processMovementAiRefresh(movedCreature, oldPos, newPos);
}

void Monster::processMovementAiRefresh(const std::shared_ptr<Creature> &creature, const Position &oldPos, const Position &newPos) {
	const bool canSeeNewPos = canSee(newPos);
	const bool canSeeOldPos = canSee(oldPos);

	if (canSeeNewPos && !canSeeOldPos) {
		onCreatureEnter(creature);
	} else if (!canSeeNewPos && canSeeOldPos) {
		onCreatureLeave(creature);
	}

	if (isIdle) {
		updateIdleStatus();
	}

	if (isSummon()) {
		return;
	}

	if (const auto &followCreature = getFollowCreature()) {
		const Position &followPosition = followCreature->getPosition();
		const Position &pos = getPosition();

		int32_t offset_x = Position::getDistanceX(followPosition, pos);
		int32_t offset_y = Position::getDistanceY(followPosition, pos);
		if ((offset_x > 1 || offset_y > 1) && m_monsterType->info.changeTargetChance > 0) {
			Direction dir = getDirectionTo(pos, followPosition);
			const auto &checkPosition = getNextPosition(dir, pos);

			if (const auto &nextTile = g_game().map.getTile(checkPosition)) {
				const auto &topCreature = nextTile->getTopCreature();
				if (followCreature != topCreature && isOpponent(topCreature)) {
					deferTargetSelection(topCreature->getID());
				}
			}
		}
	} else if (isOpponent(creature)) {
		// We have no target, so try to pick this one.
		deferTargetSelection(creature->getID());
	}
}

void Monster::onCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text) {
	Creature::onCreatureSay(creature, type, text);

	if (m_monsterType->info.creatureSayEvent != -1) {
		// onCreatureSay(self, creature, type, message)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("Monster {} creature {}] Call stack overflow. Too many lua "
			                 "script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(m_monsterType->info.creatureSayEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.creatureSayEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);

		lua_pushnumber(L, type);
		LuaScriptInterface::pushString(L, text);

		scriptInterface->callVoidFunction(4);
	}
}

void Monster::onAttackedByPlayer(const std::shared_ptr<Player> &attackerPlayer) {
	if (m_monsterType->info.monsterAttackedByPlayerEvent != -1) {
		// onPlayerAttack(self, attackerPlayer)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!scriptInterface->reserveScriptEnv()) {
			g_logger().error("Monster {} creature {}] Call stack overflow. Too many lua "
			                 "script calls being nested.",
			                 getName(), this->getName());
			return;
		}

		ScriptEnvironment* env = scriptInterface->getScriptEnv();
		env->setScriptId(m_monsterType->info.monsterAttackedByPlayerEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.monsterAttackedByPlayerEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Player>(L, attackerPlayer);
		LuaScriptInterface::setMetatable(L, -1, "Player");

		scriptInterface->callVoidFunction(2);
	}
}

void Monster::onSpawn(const Position &position) {
	if (m_monsterType->info.spawnEvent != -1) {
		// onSpawn(self, spawnPosition)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!scriptInterface->reserveScriptEnv()) {
			g_logger().error("Monster {} creature {}] Call stack overflow. Too many lua "
			                 "script calls being nested.",
			                 getName(), this->getName());
			return;
		}

		ScriptEnvironment* env = scriptInterface->getScriptEnv();
		env->setScriptId(m_monsterType->info.spawnEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.spawnEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");
		LuaScriptInterface::pushPosition(L, position);

		scriptInterface->callVoidFunction(2);
	}
}

bool Monster::addFriend(const std::shared_ptr<Creature> &creature) {
	if (creature.get() == this) {
		g_logger().error("[{}]: adding creature is same of monster", __FUNCTION__);
		return false;
	}

	assert(creature.get() != this);
	return friendList.try_emplace(creature->getID(), creature).second;
}

bool Monster::removeFriend(const std::shared_ptr<Creature> &creature) {
	return friendList.erase(creature->getID()) > 0;
}

bool Monster::countsAsPlayerOnScreenTarget(const std::shared_ptr<Creature> &creature) const {
	const auto &master = getMaster();
	return !master && getFaction() != FACTION_DEFAULT && creature && creature->getPlayerRaw();
}

void Monster::forgetTargetReference(const TargetReference &ref) {
	if (ref.countsAsPlayerOnScreen && totalPlayersOnScreen > 0) {
		totalPlayersOnScreen--;
	}
}

bool Monster::addTarget(const std::shared_ptr<Creature> &creature, bool pushFront /* = false*/) {
	if (creature.get() == this) {
		g_logger().error("[{}]: adding creature is same of monster", __FUNCTION__);
		return false;
	}

	assert(creature.get() != this);

	auto it = getTargetIterator(creature);
	if (it != targetList.end()) {
		if (!it->creature.expired()) {
			return false;
		}

		forgetTargetReference(*it);
		targetList.erase(it);
	}

	const bool countsAsPlayer = countsAsPlayerOnScreenTarget(creature);
	if (pushFront) {
		targetList.push_front(TargetReference { creature->getID(), creature, countsAsPlayer });
	} else {
		targetList.push_back(TargetReference { creature->getID(), creature, countsAsPlayer });
	}

	if (countsAsPlayer) {
		totalPlayersOnScreen++;
	}

	markTargetStateChanged();
	return true;
}

bool Monster::removeTarget(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return false;
	}

	auto it = getTargetIterator(creature);
	if (it == targetList.end()) {
		return false;
	}

	const auto &target = it->creature.lock();
	if (!target) {
		forgetTargetReference(*it);
		targetList.erase(it);
		markTargetStateChanged();
		return false;
	}

	forgetTargetReference(*it);
	targetList.erase(it);
	markTargetStateChanged();

	return true;
}

void Monster::updateTargetList() {
	if (!g_dispatcher().context().isBarrierParallel()) {
		setAsyncTaskFlag(UpdateTargetList, true);
		return;
	}

	std::erase_if(friendList, [this](const auto &it) {
		const auto &target = it.second.lock();
		return !target || target->getHealth() <= 0 || !canSee(target->getPosition());
	});

	const auto targetCountBeforeCleanup = targetList.size();
	std::erase_if(targetList, [this](const TargetReference &ref) {
		const auto &target = ref.creature.lock();
		const bool shouldErase = !target || target->getHealth() <= 0 || !canSee(target->getPosition());
		if (shouldErase) {
			forgetTargetReference(ref);
		}
		return shouldErase;
	});
	if (targetList.size() != targetCountBeforeCleanup) {
		markTargetStateChanged();
	}

	if (!visiblePlayerSpectatorIds.empty()) {
		playerVisibleUntil = MonsterRelevancePolicy::Clock::now() + WALK_PLAYER_VISIBLE_HOLD;
		visiblePlayerSpectatorIds.clear();
	}
	const bool monsterPerfTestFriendlyFire = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE);
	for (const auto &spectator : Spectators().find<Creature>(position, true, 0, 0, 0, 0, false)) {
		if (spectator.get() != this && canSee(spectator->getPosition())) {
			addVisiblePlayerSpectator(spectator);
			onCreatureFound(spectator, false, monsterPerfTestFriendlyFire);
		}
	}
}

void Monster::clearTargetList() {
	if (!targetList.empty()) {
		markTargetStateChanged();
	}
	targetList.clear();
	totalPlayersOnScreen = 0;
}

void Monster::clearFriendList() {
	friendList.clear();
}

void Monster::onCreatureFound(const std::shared_ptr<Creature> &creature, bool pushFront /* = false*/) {
	onCreatureFound(creature, pushFront, g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE));
}

void Monster::onCreatureFound(const std::shared_ptr<Creature> &creature, bool pushFront, bool monsterPerfTestFriendlyFire) {
	bool listChanged = false;
	if (isFriend(creature, monsterPerfTestFriendlyFire)) {
		listChanged = addFriend(creature) || listChanged;
	}

	if (isOpponent(creature, monsterPerfTestFriendlyFire)) {
		listChanged = addTarget(creature, pushFront) || listChanged;
	}

	if (listChanged || isIdle) {
		updateIdleStatus();
	}
}

void Monster::onCreatureEnter(const std::shared_ptr<Creature> &creature) {
	observeVisiblePlayerForScheduling(creature);
	onCreatureFound(creature, true);
}

bool Monster::isFriend(const std::shared_ptr<Creature> &creature) const {
	return isFriend(creature, g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE));
}

bool Monster::isFriend(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) const {
	const auto &master = getMaster();
	const auto &masterPlayer = master ? master->getPlayer() : nullptr;
	if (isSummon() && masterPlayer) {
		auto tmpPlayer = creature->getPlayer();
		if (!tmpPlayer) {
			const auto &creatureMaster = creature->getMaster();
			if (creatureMaster && creatureMaster->getPlayer()) {
				tmpPlayer = creatureMaster->getPlayer();
			}
		}

		if (tmpPlayer && (tmpPlayer == master || masterPlayer->isPartner(tmpPlayer))) {
			return true;
		}
	}

	if (isMonsterPerfTestFriendlyFireTarget(*this, creature, monsterPerfTestFriendlyFire)) {
		return false;
	}

	return creature->getMonsterRaw() && !creature->isSummon();
}

bool Monster::isOpponent(const std::shared_ptr<Creature> &creature) const {
	return isOpponent(creature, g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE));
}

bool Monster::isOpponent(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) const {
	if (!creature) {
		return false;
	}

	const auto &master = getMaster();
	const auto &masterPlayer = master ? master->getPlayer() : nullptr;
	if (isSummon() && masterPlayer) {
		return creature != master;
	}

	const auto &player = creature ? creature->getPlayer() : nullptr;
	if (player && player->hasFlag(PlayerFlags_t::IgnoredByMonsters)) {
		return false;
	}

	if (isMonsterPerfTestFriendlyFireTarget(*this, creature, monsterPerfTestFriendlyFire)) {
		return true;
	}

	if (getFaction() != FACTION_DEFAULT) {
		return isEnemyFaction(creature->getFaction()) || creature->getFaction() == FACTION_PLAYER;
	}

	const auto &creatureMaster = creature->getMaster();
	const auto &creaturePlayer = creatureMaster ? creatureMaster->getPlayer() : nullptr;
	if (player || creaturePlayer) {
		return true;
	}

	return false;
}

uint64_t Monster::getLostExperience() const {
	float extraExperience = forgeStack <= 15 ? (forgeStack + 10) / 10 : 28;
	return skillLoss ? static_cast<uint64_t>(std::round(m_monsterType->info.experience * extraExperience)) : 0;
}

uint16_t Monster::getLookCorpse() const {
	return m_monsterType->info.lookcorpse;
}

void Monster::onCreatureLeave(const std::shared_ptr<Creature> &creature) {
	const bool monsterPerfTestFriendlyFire = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE);
	removeVisiblePlayerSpectator(creature);

	// update friendList
	if (isFriend(creature, monsterPerfTestFriendlyFire)) {
		removeFriend(creature);
	}

	// update targetList
	if (isOpponent(creature, monsterPerfTestFriendlyFire)) {
		if (removeTarget(creature) && targetList.empty()) {
			updateIdleStatus();
		}
	}
}

bool Monster::searchTarget(TargetSearchType_t searchType /*= TARGETSEARCH_DEFAULT*/) {
	if (g_dispatcher().context().isBarrierParallel()) {
		return requestTargetSearchCompute(searchType);
	}
	return searchTargetImmediate(searchType);
}

bool Monster::searchTargetImmediate(TargetSearchType_t searchType) {
	if (searchType == TARGETSEARCH_DEFAULT) {
		int32_t rnd = uniform_random(1, 100);

		searchType = TARGETSEARCH_NEAREST;

		int32_t sum = this->m_monsterType->info.strategiesTargetNearest;
		if (rnd > sum) {
			searchType = TARGETSEARCH_HP;
			sum += this->m_monsterType->info.strategiesTargetHealth;

			if (rnd > sum) {
				searchType = TARGETSEARCH_DAMAGE;
				sum += this->m_monsterType->info.strategiesTargetDamage;
				if (rnd > sum) {
					searchType = TARGETSEARCH_RANDOM;
				}
			}
		}
	}

	std::vector<std::shared_ptr<Creature>> resultList;
	resultList.reserve(targetList.size());
	const Position &myPos = getPosition();
	const bool monsterPerfTestFriendlyFire = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE);

	// When the current melee target is path-blocked (magic wall, untraversable field),
	// exclude it so a reachable alternative can be chosen instead of repeatedly picking
	// the same unreachable creature as "nearest".
	const auto &currentAttacked = getAttackedCreature();
	const bool skipCurrentUnreachable = currentAttacked && targetDistance <= 1 && !hasFollowPath;

	for (const auto &targetRef : targetList) {
		const auto &creature = targetRef.creature.lock();
		if (creature && isTarget(creature, monsterPerfTestFriendlyFire)) {
			if (skipCurrentUnreachable && creature == currentAttacked) {
				continue;
			}
			if ((targetDistance == 1) || canUseAttack(myPos, creature)) {
				resultList.emplace_back(creature);
			}
		}
	}

	if (resultList.empty()) {
		return false;
	}

	std::shared_ptr<Creature> getTarget = nullptr;

	switch (searchType) {
		case TARGETSEARCH_NEAREST: {
			getTarget = nullptr;
			if (!resultList.empty()) {
				auto it = resultList.begin();
				getTarget = *it;

				if (++it != resultList.end()) {
					const Position &targetPosition = getTarget->getPosition();
					int32_t minRange = std::max<int32_t>(Position::getDistanceX(myPos, targetPosition), Position::getDistanceY(myPos, targetPosition))
						+ static_cast<int32_t>(getTarget->getFaction()) * 100;
					do {
						const Position &pos = (*it)->getPosition();

						int32_t distance = std::max<int32_t>(Position::getDistanceX(myPos, pos), Position::getDistanceY(myPos, pos))
							+ static_cast<int32_t>((*it)->getFaction()) * 100;
						if (distance < minRange) {
							getTarget = *it;
							minRange = distance;
						}
					} while (++it != resultList.end());
				}
			} else {
				int32_t minRange = std::numeric_limits<int32_t>::max();
				for (const auto &creature : getTargetList()) {
					if (!isTarget(creature, monsterPerfTestFriendlyFire)) {
						continue;
					}

					const Position &pos = creature->getPosition();
					int32_t factionOffset = static_cast<int32_t>(getTarget->getFaction()) * 100;
					int32_t distance = std::max<int32_t>(Position::getDistanceX(myPos, pos), Position::getDistanceY(myPos, pos)) + factionOffset;
					if (distance < minRange) {
						getTarget = creature;
						minRange = distance;
					}
				}
			}

			if (getTarget && selectTarget(getTarget, monsterPerfTestFriendlyFire)) {
				return true;
			}
			break;
		}
		case TARGETSEARCH_HP: {
			getTarget = nullptr;
			if (!resultList.empty()) {
				auto it = resultList.begin();
				getTarget = *it;
				if (++it != resultList.end()) {
					int32_t minHp = getTarget->getHealth() + static_cast<int32_t>(getTarget->getFaction()) * 100000;
					do {
						auto hp = (*it)->getHealth() + static_cast<int32_t>((*it)->getFaction()) * 100000;
						if (hp < minHp) {
							getTarget = *it;
							minHp = hp;
						}
					} while (++it != resultList.end());
				}
			}
			if (getTarget && selectTarget(getTarget, monsterPerfTestFriendlyFire)) {
				return true;
			}
			break;
		}
		case TARGETSEARCH_DAMAGE: {
			getTarget = nullptr;
			if (!resultList.empty()) {
				auto it = resultList.begin();
				getTarget = *it;
				if (++it != resultList.end()) {
					const auto firstDamage = damageMap.find(getTarget->getID());
					int32_t mostDamage = firstDamage == damageMap.end()
						? std::numeric_limits<int32_t>::min()
						: firstDamage->second.total + static_cast<int32_t>(getTarget->getFaction()) * 100000;
					do {
						int32_t factionOffset = static_cast<int32_t>((*it)->getFaction()) * 100000;
						const auto dmg = damageMap.find((*it)->getID());
						if (dmg != damageMap.end() && dmg->second.total + factionOffset > mostDamage) {
							mostDamage = dmg->second.total + factionOffset;
							getTarget = *it;
						}
					} while (++it != resultList.end());
				}
			}
			if (getTarget && selectTarget(getTarget, monsterPerfTestFriendlyFire)) {
				return true;
			}
			break;
		}
		case TARGETSEARCH_RANDOM:
		default: {
			if (!resultList.empty()) {
				auto it = resultList.begin();
				std::advance(it, uniform_random(0, resultList.size() - 1));
				return selectTarget(*it, monsterPerfTestFriendlyFire);
			}
			break;
		}
	}

	// lets just pick the first target in the list
	return std::ranges::any_of(getTargetList(), [this, skipCurrentUnreachable, &currentAttacked, monsterPerfTestFriendlyFire](const std::shared_ptr<Creature> &creature) {
		if (skipCurrentUnreachable && creature == currentAttacked) {
			return false;
		}
		return selectTarget(creature, monsterPerfTestFriendlyFire);
	});
}

bool Monster::requestTargetSearchCompute(TargetSearchType_t searchType) {
	if (targetSearchComputeOutstanding && pendingTargetSearchCompute && pendingTargetSearchCompute->searchType == searchType && pendingTargetSearchCompute->stateEpoch == targetStateEpoch && pendingTargetSearchCompute->decisionEpoch == targetDecisionEpoch) {
		return true;
	}

	pendingTargetSearchCompute = TargetSearchComputeRequest { searchType, targetStateEpoch, targetDecisionEpoch };
	const auto generation = nextTargetSearchComputeGeneration();
	if (targetSearchComputeOutstanding) {
		return true;
	}

	targetSearchComputeOutstanding = true;
	activeTargetSearchComputeGeneration = generation;
	const auto monsterId = getID();
	const bool accepted = safeCall([monsterId, generation] {
		if (const auto &monster = g_game().getMonsterByID(monsterId)) {
			monster->prepareTargetSearchCompute(generation);
		}
	});
	if (!accepted) {
		clearTargetSearchCompute();
		return false;
	}
	return true;
}

void Monster::prepareTargetSearchCompute(uint64_t generation) {
	if (!targetSearchComputeOutstanding || activeTargetSearchComputeGeneration != generation || !pendingTargetSearchCompute) {
		return;
	}
	if (generation != targetSearchComputeGeneration) {
		activeTargetSearchComputeGeneration = targetSearchComputeGeneration;
		prepareTargetSearchCompute(activeTargetSearchComputeGeneration);
		return;
	}
	if (pendingTargetSearchCompute->decisionEpoch != targetDecisionEpoch) {
		clearTargetSearchCompute();
		return;
	}
	pendingTargetSearchCompute->stateEpoch = targetStateEpoch;
	if (isRemoved() || isDead()) {
		clearTargetSearchCompute();
		return;
	}

	auto searchType = pendingTargetSearchCompute->searchType;
	if (searchType == TARGETSEARCH_DEFAULT) {
		const int32_t randomValue = uniform_random(1, 100);
		searchType = TARGETSEARCH_NEAREST;
		int32_t strategyTotal = m_monsterType->info.strategiesTargetNearest;
		if (randomValue > strategyTotal) {
			searchType = TARGETSEARCH_HP;
			strategyTotal += m_monsterType->info.strategiesTargetHealth;
			if (randomValue > strategyTotal) {
				searchType = TARGETSEARCH_DAMAGE;
				strategyTotal += m_monsterType->info.strategiesTargetDamage;
				if (randomValue > strategyTotal) {
					searchType = TARGETSEARCH_RANDOM;
				}
			}
		}
	}

	const Position origin = getPosition();
	const uint64_t stateEpoch = targetStateEpoch;
	const uint64_t decisionEpoch = targetDecisionEpoch;
	const bool monsterPerfTestFriendlyFire = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE);
	const auto &currentAttacked = getAttackedCreature();
	const bool skipCurrentUnreachable = currentAttacked && targetDistance <= 1 && !hasFollowPath;
	std::vector<std::shared_ptr<Creature>> eligibleTargets;
	std::vector<uint32_t> fallbackIds;
	MonsterTargetRankingRequest rankingRequest;
	rankingRequest.origin = origin;
	eligibleTargets.reserve(std::min(targetList.size(), MAX_TARGET_RANK_CANDIDATES));
	fallbackIds.reserve(std::min(targetList.size(), MAX_TARGET_RANK_CANDIDATES));
	rankingRequest.candidates.reserve(std::min(targetList.size(), MAX_TARGET_RANK_CANDIDATES));

	for (const auto &targetRef : targetList) {
		const auto &creature = targetRef.creature.lock();
		if (!creature || creature->getHealth() <= 0 || !isTarget(creature, monsterPerfTestFriendlyFire)) {
			continue;
		}
		if (fallbackIds.size() < MAX_TARGET_RANK_CANDIDATES) {
			fallbackIds.emplace_back(creature->getID());
		}
		if (rankingRequest.candidates.size() >= MAX_TARGET_RANK_CANDIDATES) {
			continue;
		}
		if (skipCurrentUnreachable && creature == currentAttacked) {
			continue;
		}
		if (targetDistance != 1 && !canUseAttack(origin, creature)) {
			continue;
		}

		int32_t damage = 0;
		const auto damageIt = damageMap.find(creature->getID());
		const bool hasDamage = damageIt != damageMap.end();
		if (hasDamage) {
			damage = damageIt->second.total;
		}
		rankingRequest.candidates.emplace_back(MonsterTargetCandidate {
			.creatureId = creature->getID(),
			.position = creature->getPosition(),
			.faction = static_cast<int32_t>(creature->getFaction()),
			.health = creature->getHealth(),
			.damage = damage,
			.hasDamage = hasDamage,
		});
		eligibleTargets.emplace_back(creature);
	}

	if (rankingRequest.candidates.empty()) {
		clearTargetSearchCompute();
		return;
	}

	if (searchType == TARGETSEARCH_RANDOM || (searchType != TARGETSEARCH_NEAREST && searchType != TARGETSEARCH_HP && searchType != TARGETSEARCH_DAMAGE)) {
		const auto selectedIndex = static_cast<size_t>(uniform_random(0, eligibleTargets.size() - 1));
		const auto selectedTarget = eligibleTargets[selectedIndex];
		clearTargetSearchCompute();
		selectTarget(selectedTarget, monsterPerfTestFriendlyFire);
		return;
	}

	switch (searchType) {
		case TARGETSEARCH_HP:
			rankingRequest.mode = MonsterTargetRankMode::Health;
			break;
		case TARGETSEARCH_DAMAGE:
			rankingRequest.mode = MonsterTargetRankMode::Damage;
			break;
		case TARGETSEARCH_NEAREST:
		default:
			rankingRequest.mode = MonsterTargetRankMode::Nearest;
			break;
	}

	if (rankingRequest.candidates.size() == 1) {
		MonsterTargetRankingResult result;
		result.suggestedCreatureId = rankingRequest.candidates.front().creatureId;
		completeTargetSearchCompute(generation, stateEpoch, decisionEpoch, origin, searchType, std::move(fallbackIds), result);
		return;
	}

	const auto monsterId = getID();
	const auto priority = isPlayerVisibleForScheduling() || isComputeRelevant() ? MonsterComputePriority::Visible : MonsterComputePriority::Background;
	const auto submission = g_monsterComputeService().submit(
		priority,
		[monsterId, generation, stateEpoch, decisionEpoch, origin, searchType, fallbackIds = std::move(fallbackIds), rankingRequest = std::move(rankingRequest)](MonsterComputeToken, std::stop_token stopToken) mutable {
			auto result = MonsterTargetRanker::rank(rankingRequest, stopToken);
			return [monsterId, generation, stateEpoch, decisionEpoch, origin, searchType, fallbackIds = std::move(fallbackIds), result]() mutable {
				if (const auto &monster = g_game().getMonsterByID(monsterId)) {
					monster->completeTargetSearchCompute(generation, stateEpoch, decisionEpoch, origin, searchType, std::move(fallbackIds), result);
				}
			};
		},
		"Monster::targetRanking",
		[monsterId, generation, stateEpoch, decisionEpoch, origin, searchType] {
			if (const auto &monster = g_game().getMonsterByID(monsterId)) {
				monster->completeTargetSearchCompute(generation, stateEpoch, decisionEpoch, origin, searchType, {}, { .canceled = true });
			}
		}
	);
	if (!submission.accepted()) {
		clearTargetSearchCompute();
	}
}

void Monster::completeTargetSearchCompute(uint64_t generation, uint64_t stateEpoch, uint64_t decisionEpoch, Position origin, TargetSearchType_t searchType, std::vector<uint32_t> fallbackIds, MonsterTargetRankingResult result) {
	if (!targetSearchComputeOutstanding || activeTargetSearchComputeGeneration != generation || !pendingTargetSearchCompute) {
		return;
	}
	if (generation != targetSearchComputeGeneration) {
		const auto latestSearchType = pendingTargetSearchCompute->searchType;
		retryTargetSearchCompute(latestSearchType);
		return;
	}
	if (result.canceled) {
		clearTargetSearchCompute();
		return;
	}
	if (isRemoved() || isDead()) {
		clearTargetSearchCompute();
		return;
	}
	if (targetDecisionEpoch != decisionEpoch) {
		clearTargetSearchCompute();
		return;
	}
	if (targetStateEpoch != stateEpoch || getPosition() != origin) {
		if (targetList.empty()) {
			clearTargetSearchCompute();
		} else {
			retryTargetSearchCompute(searchType);
		}
		return;
	}

	clearTargetSearchCompute();
	const bool monsterPerfTestFriendlyFire = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE);
	const auto &currentAttacked = getAttackedCreature();
	const bool skipCurrentUnreachable = currentAttacked && targetDistance <= 1 && !hasFollowPath;
	if (const auto &suggested = g_game().getCreatureByID(result.suggestedCreatureId)) {
		const bool eligible = suggested->getHealth() > 0
			&& isTarget(suggested, monsterPerfTestFriendlyFire)
			&& (!skipCurrentUnreachable || suggested != currentAttacked)
			&& (targetDistance == 1 || canUseAttack(origin, suggested));
		if (eligible && selectTarget(suggested, monsterPerfTestFriendlyFire)) {
			return;
		}
	}

	for (const auto creatureId : fallbackIds) {
		if (creatureId == result.suggestedCreatureId) {
			continue;
		}
		const auto &candidate = g_game().getCreatureByID(creatureId);
		if (!candidate || candidate->getHealth() <= 0 || !isTarget(candidate, monsterPerfTestFriendlyFire) || (skipCurrentUnreachable && candidate == currentAttacked)) {
			continue;
		}
		if (selectTarget(candidate, monsterPerfTestFriendlyFire)) {
			return;
		}
	}
}

void Monster::retryTargetSearchCompute(TargetSearchType_t searchType) {
	clearTargetSearchCompute(false);
	if (isRemoved() || isDead()) {
		return;
	}
	pendingTargetSearchCompute = TargetSearchComputeRequest { searchType, targetStateEpoch, targetDecisionEpoch };
	setAsyncTaskFlag(TargetRanking, true);
}

void Monster::clearTargetSearchCompute(bool releasePostThink) {
	targetSearchComputeOutstanding = false;
	activeTargetSearchComputeGeneration = 0;
	pendingTargetSearchCompute.reset();
	if (releasePostThink && postThinkWaitingForTargetDecision) {
		postThinkWaitingForTargetDecision = false;
		queuePostThinkAfterAsync();
	}
}

void Monster::markTargetStateChanged() {
	if (++targetStateEpoch == 0) {
		targetStateEpoch = 1;
	}
}

void Monster::markTargetDecisionChanged() {
	markTargetStateChanged();
	if (++targetDecisionEpoch == 0) {
		targetDecisionEpoch = 1;
	}
}

uint64_t Monster::nextTargetSearchComputeGeneration() {
	if (++targetSearchComputeGeneration == 0) {
		targetSearchComputeGeneration = 1;
	}
	return targetSearchComputeGeneration;
}

void Monster::updateSummonTarget() {
	const auto &attackedCreature = getAttackedCreature();
	const auto &followCreature = getFollowCreature();
	const auto &master = getMaster();
	if (attackedCreature.get() == this) {
		setFollowCreature(nullptr);
	} else if (attackedCreature && followCreature != attackedCreature) {
		setFollowCreature(attackedCreature);
	} else if (master && master->getAttackedCreature()) {
		selectTarget(master->getAttackedCreature());
	} else if (master && master != followCreature) {
		setFollowCreature(master);
	}
}

void Monster::deferTargetSelection(uint32_t creatureId) {
	if (creatureId == 0) {
		return;
	}
	const auto monsterId = getID();
	const auto decisionEpoch = targetDecisionEpoch;
	safeCall([monsterId, creatureId, decisionEpoch] {
		const auto &monster = g_game().getMonsterByID(monsterId);
		const auto &creature = g_game().getCreatureByID(creatureId);
		if (monster && creature && monster->targetDecisionEpoch == decisionEpoch) {
			monster->selectTarget(creature);
		}
	});
}

void Monster::onFollowCreatureComplete(const std::shared_ptr<Creature> &creature) {
	if (removeTarget(creature) && (hasFollowPath || !isSummon())) {
		addTarget(creature, hasFollowPath);
	}
}

bool Monster::setAttackedCreature(const std::shared_ptr<Creature> &creature) {
	const auto previous = getAttackedCreature();
	const bool result = Creature::setAttackedCreature(creature);
	if (previous != getAttackedCreature()) {
		markTargetDecisionChanged();
	}
	return result;
}

bool Monster::setFollowCreature(const std::shared_ptr<Creature> &creature) {
	const auto previous = getFollowCreature();
	const bool result = Creature::setFollowCreature(creature);
	if (previous != getFollowCreature()) {
		markTargetDecisionChanged();
	}
	return result;
}

RaceType_t Monster::getRace() const {
	return m_monsterType->info.race;
}

float Monster::getMitigation() const {
	float mitigation = m_monsterType->info.mitigation * getDefenseMultiplier();
	if (g_configManager().getBoolean(DISABLE_MONSTER_ARMOR)) {
		mitigation += std::ceil(static_cast<float>(getDefense() + getArmor()) / 100.f) * getDefenseMultiplier() * 2.f;
	}
	return std::min<float>(mitigation, 30.f);
}

int32_t Monster::getArmor() const {
	return m_monsterType->info.armor * getDefenseMultiplier();
}

BlockType_t Monster::blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense /* = false*/, bool checkArmor /* = false*/, bool /* field = false */) {
	BlockType_t blockType = Creature::blockHit(attacker, combatType, damage, checkDefense, checkArmor);

	if (damage != 0) {
		int32_t elementMod = 0;
		auto it = m_monsterType->info.elementMap.find(combatType);
		if (it != m_monsterType->info.elementMap.end()) {
			elementMod = it->second;
		}

		// Wheel of destiny
		const auto &player = attacker ? attacker->getPlayer() : nullptr;
		if (player && player->wheel().getInstant("Ballistic Mastery")) {
			elementMod -= player->wheel().checkElementSensitiveReduction(combatType);
		}

		if (elementMod != 0) {
			damage = static_cast<int32_t>(std::round(damage * ((100 - elementMod) / 100.)));
			if (damage <= 0) {
				damage = 0;
				blockType = BLOCK_ARMOR;
			}
		}
	}

	return blockType;
}

bool Monster::isTarget(const std::shared_ptr<Creature> &creature) {
	return isTarget(creature, g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE));
}

bool Monster::isTarget(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) {
	if (creature->isRemoved() || !creature->isAttackable() || creature->getZoneType() == ZONE_PROTECTION || !canSeeCreature(creature)) {
		return false;
	}

	if (creature->getPosition().z != getPosition().z) {
		return false;
	}

	if (isMonsterPerfTestFriendlyFireTarget(*this, creature, monsterPerfTestFriendlyFire)) {
		return true;
	}

	if (!isSummon()) {
		if (getFaction() != FACTION_DEFAULT) {
			return isEnemyFaction(creature->getFaction());
		}
	}

	return true;
}

void Monster::setFatalHoldDuration(int32_t value) {
	fatalHoldDuration = value;
}

int32_t Monster::getRunAwayHealth() const {
	return runAwayHealth;
}

void Monster::setRunAwayHealth(int32_t value) {
	runAwayHealth = value;
}

bool Monster::isFleeing() const {
	return !isSummon() && getHealth() <= runAwayHealth && challengeFocusDuration <= 0 && challengeMeleeDuration <= 0 && fatalHoldDuration <= 0;
}

bool Monster::selectTarget(const std::shared_ptr<Creature> &creature) {
	return selectTarget(creature, g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE));
}

bool Monster::selectTarget(const std::shared_ptr<Creature> &creature, bool monsterPerfTestFriendlyFire) {
	if (!isTarget(creature, monsterPerfTestFriendlyFire)) {
		return false;
	}

	const auto &player = creature ? creature->getPlayer() : nullptr;
	if (player && player->isLoginProtected()) {
		return false;
	}

	auto it = getTargetIterator(creature);
	if (it == targetList.end()) {
		// Target not found in our target list.
		return false;
	}

	if (it->creature.expired()) {
		forgetTargetReference(*it);
		targetList.erase(it);
		markTargetStateChanged();
		return false;
	}

	if (isHostile() || isSummon()) {
		if (setAttackedCreature(creature)) {
			checkCreatureAttack();
		}
	}
	return setFollowCreature(creature);
}

void Monster::setIdle(bool idle) {
	if (isRemoved() || getHealth() <= 0) {
		return;
	}

	if (!idle && !isIdle) {
		g_game().addCreatureCheck(getMonster());
		return;
	}

	isIdle = idle;

	if (!isIdle) {
		g_game().addCreatureCheck(getMonster());
	} else {
		onIdleStatus();
		clearTargetList();
		clearFriendList();
		Game::removeCreatureCheck(static_self_cast<Monster>());
	}
}

void Monster::updateIdleStatus() {
	const bool forceActive = g_configManager().getBoolean(MONSTER_PERF_TEST_FORCE_ACTIVE);
	if (forceActive && !g_dispatcher().context().isBarrierParallel()) {
		// The stress flag must wake idle monsters before background AI service;
		// otherwise the benchmark activates only after visibility promotion.
		setIdle(false);
		return;
	}

	if (!g_dispatcher().context().isBarrierParallel()) {
		setAsyncTaskFlag(UpdateIdleStatus, true);
		return;
	}

	if (forceActive) {
		setIdle(false);
		return;
	}

	bool idle = false;
	if (conditions.empty()) {
		if (!isSummon() && targetList.empty()) {
			if (isInSpawnLocation()) {
				idle = true;
			} else {
				isWalkingBack = true;
			}
		} else if (const auto &master = getMaster()) {
			if (((!isSummon() && totalPlayersOnScreen == 0) || (isSummon() && master->getMonster() && master->getMonster()->totalPlayersOnScreen == 0)) && getFaction() != FACTION_DEFAULT) {
				idle = true;
			}
		}
	}

	setIdle(idle);
}

bool Monster::getIdleStatus() const {
	return isIdle;
}

bool Monster::isInSpawnLocation() const {
	if (spawnMonster.expired()) {
		return true;
	}
	return position == masterPos || masterPos == Position();
}

void Monster::onAddCondition(ConditionType_t type) {
	onConditionStatusChange(type);
}

void Monster::onConditionStatusChange(ConditionType_t /*type*/) {
	updateIdleStatus();
}

void Monster::onEndCondition(ConditionType_t type) {
	onConditionStatusChange(type);
}

void Monster::onThink(uint32_t interval) {
	Creature::onThink(interval);

	if (m_monsterType->info.thinkEvent != -1) {
		// onThink(self, interval)
		LuaScriptInterface* scriptInterface = m_monsterType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("Monster {} Call stack overflow. Too many lua script calls "
			                 "being nested.",
			                 getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(m_monsterType->info.thinkEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(m_monsterType->info.thinkEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		lua_pushnumber(L, interval);

		if (scriptInterface->callFunction(2)) {
			return;
		}
	}

	if (challengeMeleeDuration != 0) {
		challengeMeleeDuration -= interval;
		if (challengeMeleeDuration <= 0) {
			challengeMeleeDuration = 0;
			targetDistance = m_monsterType->info.targetDistance;
			g_game().updateCreatureIcon(static_self_cast<Monster>());
		}
	}

	if (!m_monsterType->canSpawn(position)) {
		g_game().removeCreature(static_self_cast<Monster>());
	}

	if (!isInSpawnRange(position)) {
		g_game().internalTeleport(static_self_cast<Monster>(), masterPos);
		setIdle(true);
		return;
	}

	updateIdleStatus();
	setAsyncTaskFlag(OnThink, true);
}

bool Monster::trySchedulePostThink() {
	if (!hasAsyncTaskFlag(OnThink)) {
		return false;
	}
	return pendingPostThink.tryEnqueue();
}

void Monster::cancelScheduledPostThink(bool playerVisible) {
	if (!postThinkQueued || postThinkPlayerVisible != playerVisible) {
		return;
	}

	postThinkQueued = false;
	postThinkWaitingForTargetDecision = false;
	(void)pendingPostThink.consume();
}

void Monster::executePostThink(uint32_t interval, bool playerVisible) {
	if (!postThinkQueued || postThinkPlayerVisible != playerVisible) {
		return;
	}

	if (targetSearchComputeOutstanding) {
		postThinkQueued = false;
		postThinkWaitingForTargetDecision = true;
		return;
	}

	postThinkQueued = false;
	const auto readyAt = pendingPostThink.consume();
	if (!readyAt) {
		return;
	}

	g_dispatcher().observeInternalWork(
		DispatcherInternalWork::MonsterPostThinkLateness,
		1,
		DispatcherPolicy::elapsed(*readyAt, Task::Clock::now())
	);
	if (isRemoved() || !isAlive()) {
		return;
	}

	// A coalesced tick advances combat and conditions once. Missed wall-clock
	// intervals are intentionally not replayed as a catch-up burst.
	onAttacking(interval);
	executeConditions(interval);
}

void Monster::queuePostThinkAfterAsync() {
	if (!pendingPostThink.isPending() || postThinkQueued) {
		return;
	}
	if (targetSearchComputeOutstanding) {
		postThinkWaitingForTargetDecision = true;
		return;
	}

	postThinkWaitingForTargetDecision = false;
	postThinkQueued = true;
	postThinkPlayerVisible = isPlayerVisibleForScheduling();
	if (!g_game().queueMonsterPostThink(getID(), postThinkPlayerVisible)) {
		cancelScheduledPostThink(postThinkPlayerVisible);
	}
}

void Monster::promotePostThinkToPlayerVisibleQueue() {
	if (!postThinkQueued || !pendingPostThink.isPending()) {
		return;
	}

	postThinkQueued = false;
	queuePostThinkAfterAsync();
}

bool Monster::onThink_async() {
	if (isIdle) { // updateIdleStatus(); is executed before this method
		return false;
	}

	addEventWalk();

	if (isSummon()) {
		const auto monsterId = getID();
		const auto decisionEpoch = targetDecisionEpoch;
		safeCall([monsterId, decisionEpoch] {
			if (const auto &monster = g_game().getMonsterByID(monsterId); monster && monster->targetDecisionEpoch == decisionEpoch) {
				monster->updateSummonTarget();
			}
		});
	} else {
		const auto &attackedCreature = getAttackedCreature();
		const auto &followCreature = getFollowCreature();
		const bool monsterPerfTestFriendlyFire = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE);
		if (monsterPerfTestFriendlyFire && targetList.empty()) {
			updateTargetList();
		}

		if (!targetList.empty()) {
			const bool attackedCreatureIsUnattackable = attackedCreature && !canUseAttack(getPosition(), attackedCreature);
			const bool attackedCreatureIsUnreachable = targetDistance <= 1 && attackedCreature && followCreature && !hasFollowPath;
			if (!attackedCreature || attackedCreatureIsUnattackable || attackedCreatureIsUnreachable) {
				if (!followCreature || !hasFollowPath) {
					searchTarget(monsterPerfTestFriendlyFire ? TARGETSEARCH_RANDOM : TARGETSEARCH_NEAREST);
				} else if (attackedCreature && isFleeing() && !canUseAttack(getPosition(), attackedCreature)) {
					searchTarget(TARGETSEARCH_DEFAULT);
				}
			}
		}
	}

	onThinkTarget(EVENT_CREATURE_THINK_INTERVAL);

	return safeCall([this] {
		onThinkYell(EVENT_CREATURE_THINK_INTERVAL);
		onThinkDefense(EVENT_CREATURE_THINK_INTERVAL);
		onThinkSound(EVENT_CREATURE_THINK_INTERVAL);
		queuePostThinkAfterAsync();
	});
}

void Monster::doAttacking(uint32_t interval) {
	const auto &attackedCreature = getAttackedCreature();
	if (!attackedCreature || attackedCreature->isLifeless() || (isSummon() && attackedCreature.get() == this)) {
		return;
	}

	const auto &player = attackedCreature->getPlayer();
	if (player && player->isLoginProtected()) {
		return;
	}

	attackTicks += interval;
	requestCombatIntention(interval, attackedCreature);
}

void Monster::requestCombatIntention(uint32_t interval, const std::shared_ptr<Creature> &target) {
	CombatIntentionComputeRequest request;
	request.generation = nextCombatIntentionGeneration();
	request.targetDecisionEpoch = targetDecisionEpoch;
	request.monsterReloadEpoch = g_monsters().getReloadEpoch();
	request.interval = interval;
	request.targetId = target->getID();
	request.attackTicksSnapshot = attackTicks;
	request.origin = getPosition();
	request.target = target->getPosition();
	request.fleeing = isFleeing();
	pendingCombatIntention = request;

	if (!combatIntentionOutstanding) {
		startPendingCombatIntention();
	}
}

void Monster::startPendingCombatIntention() {
	if (combatIntentionOutstanding || !pendingCombatIntention) {
		return;
	}

	combatIntentionOutstanding = true;
	activeCombatIntentionGeneration = pendingCombatIntention->generation;
	const auto monsterId = getID();
	const auto generation = activeCombatIntentionGeneration;
	const bool accepted = safeCall([monsterId, generation] {
		if (const auto &monster = g_game().getMonsterByID(monsterId)) {
			monster->prepareCombatIntention(generation);
		}
	});
	if (!accepted) {
		clearCombatIntention();
	}
}

void Monster::prepareCombatIntention(uint64_t generation) {
	if (!combatIntentionOutstanding || activeCombatIntentionGeneration != generation || !pendingCombatIntention) {
		return;
	}
	if (pendingCombatIntention->generation != generation || combatIntentionGeneration != generation) {
		combatIntentionOutstanding = false;
		activeCombatIntentionGeneration = 0;
		startPendingCombatIntention();
		return;
	}

	const auto request = *pendingCombatIntention;
	const auto &target = g_game().getCreatureByID(request.targetId);
	const auto &currentTarget = getAttackedCreature();
	const bool invalid = isRemoved() || isDead() || !target || target != currentTarget
		|| target->isLifeless() || targetDecisionEpoch != request.targetDecisionEpoch
		|| g_monsters().getReloadEpoch() != request.monsterReloadEpoch
		|| getPosition() != request.origin || target->getPosition() != request.target
		|| attackTicks != request.attackTicksSnapshot || isFleeing() != request.fleeing;
	if (invalid) {
		clearCombatIntention();
		return;
	}

	if (attackSpells.empty() || attackSpells.size() > MAX_COMBAT_INTENTION_SPELLS) {
		clearCombatIntention();
		commitCombatIntention(request, target, {}, false);
		return;
	}

	MonsterCombatIntentionRequest workerRequest;
	workerRequest.origin = request.origin;
	workerRequest.target = request.target;
	workerRequest.fleeing = request.fleeing;
	workerRequest.spells.reserve(attackSpells.size());
	for (size_t index = 0; index < attackSpells.size(); ++index) {
		const auto &spell = attackSpells[index];
		workerRequest.spells.emplace_back(MonsterCombatSpellGeometry {
			.index = static_cast<uint32_t>(index),
			.range = spell.range,
			.enabled = spell.spell != nullptr,
			.melee = spell.isMelee,
		});
	}

	const auto monsterId = getID();
	const auto priority = isPlayerVisibleForScheduling() || isComputeRelevant() ? MonsterComputePriority::Visible : MonsterComputePriority::Background;
	const auto submission = g_monsterComputeService().submit(
		priority,
		[monsterId, generation, workerRequest = std::move(workerRequest)](MonsterComputeToken, std::stop_token stopToken) mutable {
			auto result = MonsterCombatIntentionEvaluator::evaluate(workerRequest, stopToken);
			return [monsterId, generation, result = std::move(result)]() mutable {
				if (const auto &monster = g_game().getMonsterByID(monsterId)) {
					monster->completeCombatIntention(generation, std::move(result));
				}
			};
		},
		"Monster::combatIntention",
		[monsterId, generation] {
			if (const auto &monster = g_game().getMonsterByID(monsterId)) {
				monster->completeCombatIntention(generation, { .geometricallyEligibleSpellIndices = {}, .canceled = true });
			}
		}
	);
	if (!submission.accepted()) {
		clearCombatIntention();
		updateLookDirection();
	}
}

void Monster::completeCombatIntention(uint64_t generation, MonsterCombatIntentionResult result) {
	if (!combatIntentionOutstanding || activeCombatIntentionGeneration != generation || !pendingCombatIntention) {
		return;
	}
	if (pendingCombatIntention->generation != generation || combatIntentionGeneration != generation) {
		deferPendingCombatIntention();
		return;
	}
	if (result.canceled) {
		clearCombatIntention();
		return;
	}

	const auto request = *pendingCombatIntention;
	const auto &target = g_game().getCreatureByID(request.targetId);
	const auto &currentTarget = getAttackedCreature();
	const auto &player = target ? target->getPlayer() : nullptr;
	const bool invalid = isRemoved() || isDead() || !target || target != currentTarget
		|| target->isLifeless() || (player && player->isLoginProtected())
		|| targetDecisionEpoch != request.targetDecisionEpoch
		|| g_monsters().getReloadEpoch() != request.monsterReloadEpoch
		|| getPosition() != request.origin || target->getPosition() != request.target
		|| attackTicks != request.attackTicksSnapshot || isFleeing() != request.fleeing
		|| getZoneType() == ZONE_PROTECTION || target->getZoneType() == ZONE_PROTECTION
		|| !isTarget(target) || !g_game().isSightClear(request.origin, request.target, true);
	if (invalid) {
		clearCombatIntention();
		return;
	}

	uint32_t previousIndex = 0;
	bool firstIndex = true;
	for (const auto index : result.geometricallyEligibleSpellIndices) {
		if (index >= attackSpells.size() || (!firstIndex && index <= previousIndex)) {
			clearCombatIntention();
			return;
		}
		firstIndex = false;
		previousIndex = index;
	}

	clearCombatIntention();
	commitCombatIntention(request, target, result.geometricallyEligibleSpellIndices, true);
}

void Monster::deferPendingCombatIntention() {
	combatIntentionOutstanding = false;
	activeCombatIntentionGeneration = 0;
	if (pendingCombatIntention) {
		setAsyncTaskFlag(CombatIntention, true);
	}
}

void Monster::clearCombatIntention() {
	combatIntentionOutstanding = false;
	activeCombatIntentionGeneration = 0;
	pendingCombatIntention.reset();
}

void Monster::commitCombatIntention(const CombatIntentionComputeRequest &request, const std::shared_ptr<Creature> &target, const std::vector<uint32_t> &geometricallyEligibleSpellIndices, bool requireGeometryHint) {
	bool updateLook = true;
	bool resetTicks = request.interval != 0;
	size_t eligibleIndex = 0;

	for (size_t spellIndex = 0; spellIndex < attackSpells.size(); ++spellIndex) {
		if (combatIntentionGeneration != request.generation || isRemoved() || isDead() || !target || target->isLifeless() || getAttackedCreature() != target) {
			break;
		}
		if (targetDecisionEpoch != request.targetDecisionEpoch || g_monsters().getReloadEpoch() != request.monsterReloadEpoch || getPosition() != request.origin || target->getPosition() != request.target || isFleeing() != request.fleeing) {
			break;
		}
		const auto &player = target->getPlayer();
		if ((player && player->isLoginProtected()) || getZoneType() == ZONE_PROTECTION || target->getZoneType() == ZONE_PROTECTION || !isTarget(target) || !g_game().isSightClear(getPosition(), target->getPosition(), true)) {
			break;
		}

		const spellBlock_t &spellBlock = attackSpells[spellIndex];
		bool inRange = false;

		if (spellBlock.spell == nullptr || (spellBlock.isMelee && isFleeing())) {
			continue;
		}

		while (eligibleIndex < geometricallyEligibleSpellIndices.size() && geometricallyEligibleSpellIndices[eligibleIndex] < spellIndex) {
			++eligibleIndex;
		}
		const bool geometrySuggested = !requireGeometryHint
			|| (eligibleIndex < geometricallyEligibleSpellIndices.size() && geometricallyEligibleSpellIndices[eligibleIndex] == spellIndex);

		if (canUseSpell(getPosition(), target->getPosition(), spellBlock, request.interval, inRange, resetTicks) && geometrySuggested) {
			if (spellBlock.chance >= static_cast<uint32_t>(uniform_random(1, 100))) {
				if (updateLook) {
					updateLookDirection();
					updateLook = false;
				}

				minCombatValue = spellBlock.minCombatValue;
				maxCombatValue = spellBlock.maxCombatValue;

				if (spellBlock.spell == nullptr) {
					continue;
				}

				spellBlock.spell->castSpell(getMonster(), target);

				if (spellBlock.isMelee) {
					extraMeleeAttack = false;
				}
			}
		}

		if (!inRange && spellBlock.isMelee) {
			// melee swing out of reach
			extraMeleeAttack = true;
		}
	}

	if (updateLook && !isRemoved()) {
		updateLookDirection();
	}

	if (resetTicks && combatIntentionGeneration == request.generation) {
		attackTicks = 0;
	}
}

uint64_t Monster::nextCombatIntentionGeneration() {
	if (++combatIntentionGeneration == 0) {
		combatIntentionGeneration = 1;
	}
	return combatIntentionGeneration;
}

MonsterRelevanceSnapshot Monster::captureComputeRelevance() const {
	MonsterRelevanceSnapshot snapshot;
	const auto observe = [this, &snapshot](const std::shared_ptr<Creature> &creature) {
		if (!isPlayerControlledCreature(creature)) {
			return;
		}

		if (snapshot.playerSpectators < std::numeric_limits<uint16_t>::max()) {
			++snapshot.playerSpectators;
		}
		const auto distance = std::max<uint32_t>(
			Position::getDistanceX(getPosition(), creature->getPosition()),
			Position::getDistanceY(getPosition(), creature->getPosition())
		);
		snapshot.nearestPlayerDistance = static_cast<uint16_t>(std::min<uint32_t>(
			std::numeric_limits<uint16_t>::max(),
			std::min<uint32_t>(snapshot.nearestPlayerDistance, distance)
		));
	};

	for (const auto &target : targetList) {
		observe(target.creature.lock());
	}
	for (const auto &friendEntry : friendList) {
		observe(friendEntry.second.lock());
	}

	snapshot.engagedWithPlayer = isPlayerControlledCreature(getAttackedCreature()) || isPlayerControlledCreature(getFollowCreature());
	return snapshot;
}

bool Monster::isComputeRelevant() {
	computeRelevance = MonsterRelevancePolicy::update(computeRelevance, captureComputeRelevance(), MonsterRelevancePolicy::Clock::now());
	return computeRelevance.tier == MonsterRelevanceTier::Visible;
}

bool Monster::isPlayerVisibleForScheduling() {
	const auto now = MonsterRelevancePolicy::Clock::now();
	if (!visiblePlayerSpectatorIds.empty()) {
		playerVisibleUntil = now + WALK_PLAYER_VISIBLE_HOLD;
		return true;
	}
	return now < playerVisibleUntil;
}

void Monster::observeVisiblePlayerForScheduling(const std::shared_ptr<Creature> &creature) {
	if (!creature || !creature->getPlayerRaw()) {
		return;
	}

	const bool wasPlayerVisible = isPlayerVisibleForScheduling();
	const bool becamePlayerVisible = addVisiblePlayerSpectator(creature);
	if (becamePlayerVisible && !wasPlayerVisible) {
		promoteWalkEventToPlayerVisibleLane();
		promotePostThinkToPlayerVisibleQueue();
	}
}

bool Monster::addVisiblePlayerSpectator(const std::shared_ptr<Creature> &creature) {
	if (!creature || !creature->getPlayerRaw()) {
		return false;
	}

	const auto playerId = creature->getID();
	if (std::ranges::find(visiblePlayerSpectatorIds, playerId) != visiblePlayerSpectatorIds.end()) {
		return false;
	}

	const bool becameVisible = visiblePlayerSpectatorIds.empty();
	visiblePlayerSpectatorIds.emplace_back(playerId);
	return becameVisible;
}

void Monster::removeVisiblePlayerSpectator(const std::shared_ptr<Creature> &creature) {
	if (creature && creature->getPlayerRaw()) {
		const auto removed = std::erase(visiblePlayerSpectatorIds, creature->getID());
		if (removed > 0 && visiblePlayerSpectatorIds.empty()) {
			playerVisibleUntil = MonsterRelevancePolicy::Clock::now() + WALK_PLAYER_VISIBLE_HOLD;
		}
	}
}

bool Monster::hasExtraSwing() {
	return extraMeleeAttack;
}

bool Monster::canUseAttack(const Position &pos, const std::shared_ptr<Creature> &target) const {
	if (isHostile()) {
		const Position &targetPos = target->getPosition();
		uint32_t distance = std::max<uint32_t>(Position::getDistanceX(pos, targetPos), Position::getDistanceY(pos, targetPos));
		for (const spellBlock_t &spellBlock : attackSpells) {
			if (spellBlock.range != 0 && distance <= spellBlock.range) {
				return g_game().isSightClear(pos, targetPos, true);
			}
		}
		return false;
	}
	return true;
}

bool Monster::canUseSpell(const Position &pos, const Position &targetPos, const spellBlock_t &sb, uint32_t interval, bool &inRange, bool &resetTicks) {
	inRange = true;

	if (sb.isMelee && isFleeing()) {
		return false;
	}

	if (extraMeleeAttack) {
		lastMeleeAttack = OTSYS_TIME();
	} else if (sb.isMelee && (OTSYS_TIME() - lastMeleeAttack) < 1500) {
		return false;
	}

	if (!sb.isMelee || !extraMeleeAttack) {
		if (sb.speed > attackTicks) {
			resetTicks = false;
			return false;
		}

		if (attackTicks % sb.speed >= interval) {
			// already used this spell for this round
			return false;
		}
	}

	if (sb.range != 0 && std::max<uint32_t>(Position::getDistanceX(pos, targetPos), Position::getDistanceY(pos, targetPos)) > sb.range) {
		inRange = false;
		return false;
	}
	return true;
}

void Monster::onThinkTarget(uint32_t interval) {
	if (!isSummon()) {
		if (m_monsterType->info.changeTargetSpeed != 0) {
			bool canChangeTarget = true;

			if (challengeFocusDuration > 0) {
				challengeFocusDuration -= interval;
				canChangeTarget = false;

				if (challengeFocusDuration <= 0) {
					challengeFocusDuration = 0;
				}
			}

			if (fatalHoldDuration > 0 && runAwayHealth > 0) {
				fatalHoldDuration -= interval;

				if (fatalHoldDuration <= 0) {
					fatalHoldDuration = 0;
				}
			}

			if (m_targetChangeCooldown > 0) {
				m_targetChangeCooldown -= interval;

				if (m_targetChangeCooldown <= 0) {
					m_targetChangeCooldown = 0;
					targetChangeTicks = m_monsterType->info.changeTargetSpeed;
				} else {
					canChangeTarget = false;
				}
			}

			if (canChangeTarget) {
				targetChangeTicks += interval;

				if (targetChangeTicks >= m_monsterType->info.changeTargetSpeed) {
					targetChangeTicks = 0;
					m_targetChangeCooldown = m_monsterType->info.changeTargetSpeed;

					if (challengeFocusDuration > 0) {
						challengeFocusDuration = 0;
					}

					const bool useRandomSearch = g_configManager().getBoolean(MONSTER_PERF_TEST_FRIENDLY_FIRE)
						|| m_monsterType->info.targetDistance <= 1;
					const auto searchType = useRandomSearch ? TARGETSEARCH_RANDOM : TARGETSEARCH_NEAREST;
					const auto changeTargetChance = m_monsterType->info.changeTargetChance;
					const auto monsterId = getID();
					const auto decisionEpoch = targetDecisionEpoch;
					safeCall([monsterId, searchType, changeTargetChance, decisionEpoch] {
						if (const auto &monster = g_game().getMonsterByID(monsterId); monster && monster->targetDecisionEpoch == decisionEpoch && changeTargetChance >= uniform_random(1, 100)) {
							monster->requestTargetSearchCompute(searchType);
						}
					});
				}
			}
		}
	}
}

void Monster::onThinkDefense(uint32_t interval) {
	bool resetTicks = true;
	defenseTicks += interval;

	for (const spellBlock_t &spellBlock : defenseSpells) {
		if (spellBlock.speed > defenseTicks) {
			resetTicks = false;
			continue;
		}

		if (spellBlock.spell == nullptr || defenseTicks % spellBlock.speed >= interval) {
			// already used this spell for this round
			continue;
		}

		if ((spellBlock.chance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			minCombatValue = spellBlock.minCombatValue;
			maxCombatValue = spellBlock.maxCombatValue;
			spellBlock.spell->castSpell(getMonster(), getMonster());
		}
	}

	if (!isSummon() && m_summons.size() < m_monsterType->info.maxSummons && hasFollowPath) {
		for (const auto &[summonName, summonChance, summonSpeed, summonCount, summonForce] : m_monsterType->info.summons) {
			if (summonSpeed > defenseTicks) {
				resetTicks = false;
				continue;
			}

			if (m_summons.size() >= m_monsterType->info.maxSummons) {
				continue;
			}

			if (defenseTicks % summonSpeed >= interval) {
				// already used this spell for this round
				continue;
			}

			uint32_t summonsCount = 0;
			for (const auto &summon : m_summons) {
				if (summon && summon->getName() == summonName) {
					++summonsCount;
				}
			}

			if (summonsCount >= summonCount) {
				continue;
			}

			if (summonChance < static_cast<uint32_t>(uniform_random(1, 100))) {
				continue;
			}

			const auto &summon = Monster::createMonster(summonName);
			if (summon && g_game().placeCreature(summon, getPosition(), false, summonForce)) {
				if (getSoulPit()) {
					const auto stack = getForgeStack();
					summon->setSoulPitStack(stack, true);
				}
				summon->setMaster(static_self_cast<Monster>(), true);
				g_game().addMagicEffect(getPosition(), CONST_ME_MAGIC_BLUE);
				g_game().addMagicEffect(summon->getPosition(), CONST_ME_TELEPORT);
				g_game().sendSingleSoundEffect(summon->getPosition(), SoundEffect_t::MONSTER_SPELL_SUMMON, getMonster());
			}
		}
	}

	if (resetTicks) {
		defenseTicks = 0;
	}
}

void Monster::onThinkYell(uint32_t interval) {
	if (m_monsterType->info.yellSpeedTicks == 0) {
		return;
	}

	yellTicks += interval;
	if (yellTicks >= m_monsterType->info.yellSpeedTicks) {
		yellTicks = 0;

		if (!m_monsterType->info.voiceVector.empty() && (m_monsterType->info.yellChance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			const uint32_t index = uniform_random(0, m_monsterType->info.voiceVector.size() - 1);
			const auto &[text, yellText] = m_monsterType->info.voiceVector[index];

			if (yellText) {
				g_game().internalCreatureSay(static_self_cast<Monster>(), TALKTYPE_MONSTER_YELL, text, false);
			} else {
				g_game().internalCreatureSay(static_self_cast<Monster>(), TALKTYPE_MONSTER_SAY, text, false);
			}
		}
	}
}

void Monster::onThinkSound(uint32_t interval) {
	if (m_monsterType->info.soundSpeedTicks == 0) {
		return;
	}

	soundTicks += interval;
	if (soundTicks >= m_monsterType->info.soundSpeedTicks) {
		soundTicks = 0;

		if (!m_monsterType->info.soundVector.empty() && (m_monsterType->info.soundChance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			int64_t index = uniform_random(0, static_cast<int64_t>(m_monsterType->info.soundVector.size() - 1));
			g_game().sendSingleSoundEffect(static_self_cast<Monster>()->getPosition(), m_monsterType->info.soundVector[index], getMonster());
		}
	}
}

bool Monster::pushItem(const std::shared_ptr<Item> &item, const Direction &dir) {
	if (!item) {
		return false;
	}

	auto fromTile = item->getTile();
	if (!fromTile) {
		return false;
	}

	if (fromTile->getHouse()) {
		return false;
	}

	const Position &fromPos = fromTile->getPosition();
	std::shared_ptr<Cylinder> fromCyl = fromTile;

	for (auto [dx, dy] : getPushItemLocationOptions(dir)) {
		Position toPos(fromPos.x + dx, fromPos.y + dy, fromPos.z);
		auto toTile = g_game().map.getTile(toPos);

		if (toTile && g_game().canThrowObjectTo(fromPos, toPos) && g_game().internalMoveItem(fromCyl, toTile, INDEX_WHEREEVER, item, item->getItemCount(), nullptr) == RETURNVALUE_NOERROR) {
			return true;
		}
	}
	return false;
}

void Monster::pushItems(const std::shared_ptr<Tile> &tile, const Direction &nextDirection) {
	if (!tile) {
		return;
	}

	const auto* items = tile->getItemList();
	if (!items || items->empty()) {
		return;
	}

	if (tile->getHouse()) {
		return;
	}

	uint32_t moveCount = 0;
	uint32_t removeCount = 0;
	int32_t downItemSize = tile->getDownItemCount();
	std::vector<std::shared_ptr<Item>> downItems;
	downItems.reserve(downItemSize);
	for (int32_t i = 0; i < downItemSize; ++i) {
		downItems.push_back(items->at(i));
	}

	for (auto i = static_cast<int32_t>(downItems.size()); --i >= 0;) {
		const auto &item = downItems.at(i);
		if (!item || !item->hasProperty(CONST_PROP_MOVABLE) || !item->canBeMoved()) {
			continue;
		}
		if (item->getTile() != tile) {
			continue;
		}
		if (!item->hasProperty(CONST_PROP_BLOCKPATH) && !item->hasProperty(CONST_PROP_BLOCKSOLID)) {
			continue;
		}

		if (moveCount < 20 && pushItem(item, nextDirection)) {
			++moveCount;
		} else if (removeCount < 10 && !item->isCorpse() && g_game().internalRemoveItem(item) == RETURNVALUE_NOERROR) {
			++removeCount;
		}
	}

	if (removeCount > 0) {
		g_game().addMagicEffect(tile->getPosition(), CONST_ME_POFF);
	}
}

bool Monster::pushCreature(const std::shared_ptr<Creature> &creature) {
	static std::vector<Direction> dirList {
		DIRECTION_NORTH,
		DIRECTION_WEST, DIRECTION_EAST,
		DIRECTION_SOUTH
	};
	[[maybe_unused]] auto last = std::ranges::shuffle(dirList, getRandomGenerator());

	for (const Direction &dir : dirList) {
		const Position &tryPos = Spells::getCasterPosition(creature, dir);
		const auto &toTile = g_game().map.getTile(tryPos);
		if (toTile && !toTile->hasFlag(TILESTATE_BLOCKPATH) && g_game().internalMoveCreature(creature, dir) == RETURNVALUE_NOERROR) {
			return true;
		}
	}
	return false;
}

void Monster::pushCreatures(const std::shared_ptr<Tile> &tile) {
	if (!tile) {
		return;
	}

	const CreatureVector* creatures = tile->getCreatures();
	if (!creatures || creatures->empty()) {
		return;
	}

	CreatureVector creaturesCopy = *creatures;
	uint32_t killedCount = 0;
	std::shared_ptr<Monster> lastPushedMonster = nullptr;

	for (int i = static_cast<int>(creaturesCopy.size()) - 1; i >= 0; --i) {
		const auto &creature = creaturesCopy[i];
		if (!creature) {
			continue;
		}

		const std::shared_ptr<Monster> monster = creature->getMonster();
		if (monster && monster->isPushable()) {
			if (monster != lastPushedMonster && Monster::pushCreature(monster)) {
				lastPushedMonster = monster;
				continue;
			}

			monster->changeHealth(-monster->getHealth());
			monster->setDropLoot(true);
			killedCount++;
		}
	}

	if (killedCount > 0) {
		g_game().addMagicEffect(tile->getPosition(), CONST_ME_BLOCKHIT);
	}
}

bool Monster::getNextStep(Direction &nextDirection, uint32_t &flags) {
	if (isIdle || getHealth() <= 0) {
		// we dont have anyone watching might aswell stop walking
		eventWalk = 0;
		return false;
	}

	bool result = false;

	if (getFollowCreature() && hasFollowPath) {
		doFollowCreature(flags, nextDirection, result);
	} else if (isWalkingBack) {
		doWalkBack(flags, nextDirection, result);
	} else {
		doRandomStep(nextDirection, result);
	}

	if (!result || (!canPushItems() && !canPushCreatures())) {
		return result;
	}

	const Position &pos = getNextPosition(nextDirection, getPosition());
	const auto &posTile = g_game().map.getTile(pos);
	if (!posTile) {
		return result;
	}

	if (canPushItems()) {
		Monster::pushItems(posTile, nextDirection);
	}

	if (!canPushCreatures()) {
		return result;
	}
	if (g_dispatcher().context().isMovementCommit()) {
		Monster::pushCreatures(posTile);
		return result;
	}

	const auto lane = isPlayerVisibleForScheduling() ? DispatcherLane::VisibleMonster : DispatcherLane::BackgroundMonster;
	if (!g_dispatcher().addCreatureWalkEvent([posTile] {
			Monster::pushCreatures(posTile);
		},
	                                         lane)) {
		forceUpdateFollowPath = true;
		result = false;
	}

	return result;
}

void Monster::doRandomStep(Direction &nextDirection, bool &result) {
	if (getTimeSinceLastMove() >= 1000) {
		randomStepping = true;
		result = getRandomStep(getPosition(), nextDirection);
	}
}

void Monster::doWalkBack(uint32_t &flags, Direction &nextDirection, bool &result) {
	if (totalPlayersOnScreen > 0) {
		isWalkingBack = false;
		return;
	}

	result = Creature::getNextStep(nextDirection, flags);
	if (result) {
		flags |= FLAG_PATHFINDING;
	} else {
		if (ignoreFieldDamage) {
			ignoreFieldDamage = false;
		}

		int32_t distance = std::max<int32_t>(Position::getDistanceX(position, masterPos), Position::getDistanceY(position, masterPos));
		if (distance == 0) {
			isWalkingBack = false;
			return;
		}

		std::vector<Direction> listDir;
		if (!getPathTo(masterPos, listDir, 0, std::max<int32_t>(0, distance - 5), true, true, distance)) {
			isWalkingBack = false;
			return;
		}
		startAutoWalk(listDir);
	}
}

void Monster::doFollowCreature(uint32_t &flags, Direction &nextDirection, bool &result) {
	randomStepping = false;
	result = Creature::getNextStep(nextDirection, flags);
	if (result) {
		flags |= FLAG_PATHFINDING;
	} else {
		if (ignoreFieldDamage) {
			ignoreFieldDamage = false;
		}
		// target dancing
		const auto &attackedCreature = getAttackedCreature();
		const auto &followCreature = getFollowCreature();
		if (attackedCreature && attackedCreature == followCreature) {
			if (isFleeing()) {
				result = getDanceStep(getPosition(), nextDirection, false, false);
			} else if (m_monsterType->info.staticAttackChance < static_cast<uint32_t>(uniform_random(1, 100))) {
				result = getDanceStep(getPosition(), nextDirection);
			}
		}
	}
}

bool Monster::getRandomStep(const Position &creaturePos, Direction &moveDirection) {
	static std::vector<Direction> dirList {
		DIRECTION_NORTH,
		DIRECTION_WEST, DIRECTION_EAST,
		DIRECTION_SOUTH
	};
	[[maybe_unused]] auto last = std::ranges::shuffle(dirList, getRandomGenerator());

	MapCacheFloorCursor floorCursor;
	for (const Direction &dir : dirList) {
		if (canWalkTo(creaturePos, dir, floorCursor)) {
			moveDirection = dir;
			return true;
		}
	}
	return false;
}

bool Monster::getDanceStep(const Position &creaturePos, Direction &moveDirection, bool keepAttack /*= true*/, bool keepDistance /*= true*/) {
	const auto &attackedCreature = getAttackedCreature();
	if (!attackedCreature) {
		return false;
	}
	bool canDoAttackNow = canUseAttack(creaturePos, attackedCreature);
	const Position &centerPos = attackedCreature->getPosition();

	int_fast32_t offset_x = Position::getOffsetX(creaturePos, centerPos);
	int_fast32_t offset_y = Position::getOffsetY(creaturePos, centerPos);

	int_fast32_t distance_x = std::abs(offset_x);
	int_fast32_t distance_y = std::abs(offset_y);

	uint32_t centerToDist = std::max<uint32_t>(distance_x, distance_y);

	// monsters not at targetDistance shouldn't dancestep
	if (centerToDist < static_cast<uint32_t>(targetDistance)) {
		return false;
	}

	std::vector<Direction> dirList;
	MapCacheFloorCursor floorCursor;
	auto tryAddDirection = [&](Direction direction, int_fast32_t newX, int_fast32_t newY) {
		uint32_t tmpDist = std::max<uint32_t>(std::abs(newX - centerPos.getX()), std::abs(newY - centerPos.getY()));
		if (tmpDist == centerToDist && canWalkTo(creaturePos, direction, floorCursor)) {
			bool result = true;

			if (keepAttack) {
				result = (!canDoAttackNow || canUseAttack(Position(newX, newY, creaturePos.z), attackedCreature));
			}

			if (result) {
				dirList.emplace_back(direction);
			}
		}
	};

	if (!keepDistance || offset_y >= 0) {
		tryAddDirection(DIRECTION_NORTH, creaturePos.getX(), creaturePos.getY() - 1);
	}

	if (!keepDistance || offset_y <= 0) {
		tryAddDirection(DIRECTION_SOUTH, creaturePos.getX(), creaturePos.getY() + 1);
	}

	if (!keepDistance || offset_x <= 0) {
		tryAddDirection(DIRECTION_EAST, creaturePos.getX() + 1, creaturePos.getY());
	}

	if (!keepDistance || offset_x >= 0) {
		tryAddDirection(DIRECTION_WEST, creaturePos.getX() - 1, creaturePos.getY());
	}

	if (!dirList.empty()) {
		[[maybe_unused]] auto last = std::ranges::shuffle(dirList, getRandomGenerator());
		moveDirection = dirList[uniform_random(0, dirList.size() - 1)];
		return true;
	}
	return false;
}

bool Monster::getDistanceStep(const Position &targetPos, Direction &moveDirection, bool flee /* = false */) {
	const Position &creaturePos = getPosition();
	MapCacheFloorCursor floorCursor;
	auto canWalkTo = [this, &floorCursor](const Position &pos, Direction direction) {
		return this->canWalkTo(pos, direction, floorCursor);
	};

	int_fast32_t dx = Position::getDistanceX(creaturePos, targetPos);
	int_fast32_t dy = Position::getDistanceY(creaturePos, targetPos);

	if (int32_t distance = std::max<int32_t>(static_cast<int32_t>(dx), static_cast<int32_t>(dy)); !flee && (distance > targetDistance || !g_game().isSightClear(creaturePos, targetPos, true))) {
		return false; // let the A* calculate it
	} else if (!flee && distance == targetDistance) {
		return true; // we don't really care here, since it's what we wanted to reach (a dancestep will take of dancing in that position)
	}

	int_fast32_t offsetx = Position::getOffsetX(creaturePos, targetPos);
	int_fast32_t offsety = Position::getOffsetY(creaturePos, targetPos);

	if (dx <= 1 && dy <= 1) {
		// seems like a target is near, it this case we need to slow down our movements (as a monster)
		if (stepDuration < 2) {
			stepDuration++;
		}
	} else if (stepDuration > 0) {
		stepDuration--;
	}

	if (offsetx == 0 && offsety == 0) {
		return getRandomStep(creaturePos, moveDirection); // player is "on" the monster so let's get some random step and rest will be taken care later.
	}

	if (dx == dy) {
		// player is diagonal to the monster
		if (offsetx >= 1 && offsety >= 1) {
			// player is NW
			// escape to SE, S or E [and some extra]
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);

			if (s && e) {
				moveDirection = boolean_random() ? DIRECTION_SOUTH : DIRECTION_EAST;
				return true;
			} else if (s) {
				moveDirection = DIRECTION_SOUTH;
				return true;
			} else if (e) {
				moveDirection = DIRECTION_EAST;
				return true;
			} else if (canWalkTo(creaturePos, DIRECTION_SOUTHEAST)) {
				moveDirection = DIRECTION_SOUTHEAST;
				return true;
			}

			/* fleeing */
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);

			if (flee) {
				if (n && w) {
					moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_WEST;
					return true;
				} else if (n) {
					moveDirection = DIRECTION_NORTH;
					return true;
				} else if (w) {
					moveDirection = DIRECTION_WEST;
					return true;
				}
			}

			/* end of fleeing */

			if (w && canWalkTo(creaturePos, DIRECTION_SOUTHWEST)) {
				moveDirection = DIRECTION_WEST;
			} else if (n && canWalkTo(creaturePos, DIRECTION_NORTHEAST)) {
				moveDirection = DIRECTION_NORTH;
			}

			return true;
		} else if (offsetx <= -1 && offsety <= -1) {
			// player is SE
			// escape to NW , W or N [and some extra]
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);

			if (w && n) {
				moveDirection = boolean_random() ? DIRECTION_WEST : DIRECTION_NORTH;
				return true;
			} else if (w) {
				moveDirection = DIRECTION_WEST;
				return true;
			} else if (n) {
				moveDirection = DIRECTION_NORTH;
				return true;
			}

			if (canWalkTo(creaturePos, DIRECTION_NORTHWEST)) {
				moveDirection = DIRECTION_NORTHWEST;
				return true;
			}

			/* fleeing */
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);

			if (flee) {
				if (s && e) {
					moveDirection = boolean_random() ? DIRECTION_SOUTH : DIRECTION_EAST;
					return true;
				} else if (s) {
					moveDirection = DIRECTION_SOUTH;
					return true;
				} else if (e) {
					moveDirection = DIRECTION_EAST;
					return true;
				}
			}

			/* end of fleeing */

			if (s && canWalkTo(creaturePos, DIRECTION_SOUTHWEST)) {
				moveDirection = DIRECTION_SOUTH;
			} else if (e && canWalkTo(creaturePos, DIRECTION_NORTHEAST)) {
				moveDirection = DIRECTION_EAST;
			}

			return true;
		} else if (offsetx >= 1 && offsety <= -1) {
			// player is SW
			// escape to NE, N, E [and some extra]
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);
			if (n && e) {
				moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_EAST;
				return true;
			} else if (n) {
				moveDirection = DIRECTION_NORTH;
				return true;
			} else if (e) {
				moveDirection = DIRECTION_EAST;
				return true;
			}

			if (canWalkTo(creaturePos, DIRECTION_NORTHEAST)) {
				moveDirection = DIRECTION_NORTHEAST;
				return true;
			}

			/* fleeing */
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);

			if (flee) {
				if (s && w) {
					moveDirection = boolean_random() ? DIRECTION_SOUTH : DIRECTION_WEST;
					return true;
				} else if (s) {
					moveDirection = DIRECTION_SOUTH;
					return true;
				} else if (w) {
					moveDirection = DIRECTION_WEST;
					return true;
				}
			}

			/* end of fleeing */

			if (w && canWalkTo(creaturePos, DIRECTION_NORTHWEST)) {
				moveDirection = DIRECTION_WEST;
			} else if (s && canWalkTo(creaturePos, DIRECTION_SOUTHEAST)) {
				moveDirection = DIRECTION_SOUTH;
			}

			return true;
		} else if (offsetx <= -1 && offsety >= 1) {
			// player is NE
			// escape to SW, S, W [and some extra]
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			if (w && s) {
				moveDirection = boolean_random() ? DIRECTION_WEST : DIRECTION_SOUTH;
				return true;
			} else if (w) {
				moveDirection = DIRECTION_WEST;
				return true;
			} else if (s) {
				moveDirection = DIRECTION_SOUTH;
				return true;
			} else if (canWalkTo(creaturePos, DIRECTION_SOUTHWEST)) {
				moveDirection = DIRECTION_SOUTHWEST;
				return true;
			}

			/* fleeing */
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);

			if (flee) {
				if (n && e) {
					moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_EAST;
					return true;
				} else if (n) {
					moveDirection = DIRECTION_NORTH;
					return true;
				} else if (e) {
					moveDirection = DIRECTION_EAST;
					return true;
				}
			}

			/* end of fleeing */

			if (e && canWalkTo(creaturePos, DIRECTION_SOUTHEAST)) {
				moveDirection = DIRECTION_EAST;
			} else if (n && canWalkTo(creaturePos, DIRECTION_NORTHWEST)) {
				moveDirection = DIRECTION_NORTH;
			}

			return true;
		}
	}

	// Now let's decide where the player is located to the monster (what direction) so we can decide where to escape.
	if (dy > dx) {
		Direction playerDir = offsety < 0 ? DIRECTION_SOUTH : DIRECTION_NORTH;
		switch (playerDir) {
			case DIRECTION_NORTH: {
				// Player is to the NORTH, so obviously we need to check if we can go SOUTH, if not then let's choose WEST or EAST and again if we can't we need to decide about some diagonal movements.
				if (canWalkTo(creaturePos, DIRECTION_SOUTH)) {
					moveDirection = DIRECTION_SOUTH;
					return true;
				}

				bool w = canWalkTo(creaturePos, DIRECTION_WEST);
				bool e = canWalkTo(creaturePos, DIRECTION_EAST);
				if (w && e && offsetx == 0) {
					moveDirection = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
					return true;
				} else if (w && offsetx <= 0) {
					moveDirection = DIRECTION_WEST;
					return true;
				} else if (e && offsetx >= 0) {
					moveDirection = DIRECTION_EAST;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (w && e) {
						moveDirection = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
						return true;
					} else if (w) {
						moveDirection = DIRECTION_WEST;
						return true;
					} else if (e) {
						moveDirection = DIRECTION_EAST;
						return true;
					}
				}

				/* end of fleeing */

				bool sw = canWalkTo(creaturePos, DIRECTION_SOUTHWEST);
				bool se = canWalkTo(creaturePos, DIRECTION_SOUTHEAST);
				if (sw || se) {
					// we can move both dirs
					if (sw && se) {
						moveDirection = boolean_random() ? DIRECTION_SOUTHWEST : DIRECTION_SOUTHEAST;
					} else if (w) {
						moveDirection = DIRECTION_WEST;
					} else if (sw) {
						moveDirection = DIRECTION_SOUTHWEST;
					} else if (e) {
						moveDirection = DIRECTION_EAST;
					} else if (se) {
						moveDirection = DIRECTION_SOUTHEAST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_NORTH)) {
					// towards player, yea
					moveDirection = DIRECTION_NORTH;
					return true;
				}

				/* end of fleeing */
				break;
			}

			case DIRECTION_SOUTH: {
				if (canWalkTo(creaturePos, DIRECTION_NORTH)) {
					moveDirection = DIRECTION_NORTH;
					return true;
				}

				bool w = canWalkTo(creaturePos, DIRECTION_WEST);
				bool e = canWalkTo(creaturePos, DIRECTION_EAST);
				if (w && e && offsetx == 0) {
					moveDirection = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
					return true;
				} else if (w && offsetx <= 0) {
					moveDirection = DIRECTION_WEST;
					return true;
				} else if (e && offsetx >= 0) {
					moveDirection = DIRECTION_EAST;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (w && e) {
						moveDirection = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
						return true;
					} else if (w) {
						moveDirection = DIRECTION_WEST;
						return true;
					} else if (e) {
						moveDirection = DIRECTION_EAST;
						return true;
					}
				}

				/* end of fleeing */

				bool nw = canWalkTo(creaturePos, DIRECTION_NORTHWEST);
				bool ne = canWalkTo(creaturePos, DIRECTION_NORTHEAST);
				if (nw || ne) {
					// we can move both dirs
					if (nw && ne) {
						moveDirection = boolean_random() ? DIRECTION_NORTHWEST : DIRECTION_NORTHEAST;
					} else if (w) {
						moveDirection = DIRECTION_WEST;
					} else if (nw) {
						moveDirection = DIRECTION_NORTHWEST;
					} else if (e) {
						moveDirection = DIRECTION_EAST;
					} else if (ne) {
						moveDirection = DIRECTION_NORTHEAST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_SOUTH)) {
					// towards player, yea
					moveDirection = DIRECTION_SOUTH;
					return true;
				}

				/* end of fleeing */
				break;
			}

			default:
				break;
		}
	} else {
		Direction playerDir = offsetx < 0 ? DIRECTION_EAST : DIRECTION_WEST;
		switch (playerDir) {
			case DIRECTION_WEST: {
				if (canWalkTo(creaturePos, DIRECTION_EAST)) {
					moveDirection = DIRECTION_EAST;
					return true;
				}

				bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
				bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
				if (n && s && offsety == 0) {
					moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
					return true;
				} else if (n && offsety <= 0) {
					moveDirection = DIRECTION_NORTH;
					return true;
				} else if (s && offsety >= 0) {
					moveDirection = DIRECTION_SOUTH;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (n && s) {
						moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
						return true;
					} else if (n) {
						moveDirection = DIRECTION_NORTH;
						return true;
					} else if (s) {
						moveDirection = DIRECTION_SOUTH;
						return true;
					}
				}

				/* end of fleeing */

				bool se = canWalkTo(creaturePos, DIRECTION_SOUTHEAST);
				bool ne = canWalkTo(creaturePos, DIRECTION_NORTHEAST);
				if (se || ne) {
					if (se && ne) {
						moveDirection = boolean_random() ? DIRECTION_SOUTHEAST : DIRECTION_NORTHEAST;
					} else if (s) {
						moveDirection = DIRECTION_SOUTH;
					} else if (se) {
						moveDirection = DIRECTION_SOUTHEAST;
					} else if (n) {
						moveDirection = DIRECTION_NORTH;
					} else if (ne) {
						moveDirection = DIRECTION_NORTHEAST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_WEST)) {
					// towards player, yea
					moveDirection = DIRECTION_WEST;
					return true;
				}

				/* end of fleeing */
				break;
			}

			case DIRECTION_EAST: {
				if (canWalkTo(creaturePos, DIRECTION_WEST)) {
					moveDirection = DIRECTION_WEST;
					return true;
				}

				bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
				bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
				if (n && s && offsety == 0) {
					moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
					return true;
				} else if (n && offsety <= 0) {
					moveDirection = DIRECTION_NORTH;
					return true;
				} else if (s && offsety >= 0) {
					moveDirection = DIRECTION_SOUTH;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (n && s) {
						moveDirection = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
						return true;
					} else if (n) {
						moveDirection = DIRECTION_NORTH;
						return true;
					} else if (s) {
						moveDirection = DIRECTION_SOUTH;
						return true;
					}
				}

				/* end of fleeing */

				bool nw = canWalkTo(creaturePos, DIRECTION_NORTHWEST);
				bool sw = canWalkTo(creaturePos, DIRECTION_SOUTHWEST);
				if (nw || sw) {
					if (nw && sw) {
						moveDirection = boolean_random() ? DIRECTION_NORTHWEST : DIRECTION_SOUTHWEST;
					} else if (n) {
						moveDirection = DIRECTION_NORTH;
					} else if (nw) {
						moveDirection = DIRECTION_NORTHWEST;
					} else if (s) {
						moveDirection = DIRECTION_SOUTH;
					} else if (sw) {
						moveDirection = DIRECTION_SOUTHWEST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_EAST)) {
					// towards player, yea
					moveDirection = DIRECTION_EAST;
					return true;
				}

				/* end of fleeing */
				break;
			}

			default:
				break;
		}
	}

	return true;
}

bool Monster::isTargetNearby() const {
	return stepDuration >= 1;
}

bool Monster::isIgnoringFieldDamage() const {
	return ignoreFieldDamage;
}

bool Monster::israndomStepping() const {
	return randomStepping;
}

void Monster::setIgnoreFieldDamage(bool ignore) {
	ignoreFieldDamage = ignore;
}

bool Monster::getIgnoreFieldDamage() const {
	return ignoreFieldDamage;
}

uint16_t Monster::getRaceId() const {
	return m_monsterType->info.raceid;
}

// Hazard system
bool Monster::getHazard() const {
	return hazard;
}

void Monster::setHazard(bool value) {
	hazard = value;
}

bool Monster::getHazardSystemCrit() const {
	return hazardCrit;
}

void Monster::setHazardSystemCrit(bool value) {
	hazardCrit = value;
}

bool Monster::getHazardSystemDodge() const {
	return hazardDodge;
}

void Monster::setHazardSystemDodge(bool value) {
	hazardDodge = value;
}

bool Monster::getHazardSystemDamageBoost() const {
	return hazardDamageBoost;
}

void Monster::setHazardSystemDamageBoost(bool value) {
	hazardDamageBoost = value;
}

bool Monster::getHazardSystemDefenseBoost() const {
	return hazardDefenseBoost;
}

void Monster::setHazardSystemDefenseBoost(bool value) {
	hazardDefenseBoost = value;
}

bool Monster::getSoulPit() const {
	return soulPit;
}

void Monster::setSoulPit(bool value) {
	soulPit = value;
}

void Monster::setSoulPitStack(uint8_t stack, bool isSummon /* = false */) {
	const bool isBoss = stack == 40;
	const CreatureIconModifications_t icon = isBoss ? CreatureIconModifications_t::ReducedHealthExclamation : CreatureIconModifications_t::ReducedHealth;
	setForgeStack(stack);
	setIcon("soulpit", CreatureIcon(icon, isBoss ? 0 : stack));
	setSoulPit(true);
	setDropLoot(false);
	setSkillLoss(isBoss && !isSummon);
}

bool Monster::canWalkTo(Position pos, Direction moveDirection) {
	MapCacheFloorCursor floorCursor;
	return canWalkTo(pos, moveDirection, floorCursor);
}

bool Monster::canWalkTo(Position pos, Direction moveDirection, MapCacheFloorCursor &floorCursor) {
	pos = getNextPosition(moveDirection, pos);
	if (isInSpawnRange(pos)) {
		const auto &tile = g_game().map.getTileWithFloorCursor(pos, floorCursor);
		if (tile && tile->getTopVisibleCreature(getMonster()) == nullptr && tile->queryAdd(0, getMonster(), 1, FLAG_PATHFINDING | FLAG_IGNOREFIELDDAMAGE) == RETURNVALUE_NOERROR) {
			return true;
		}
	}
	return false;
}

void Monster::death(const std::shared_ptr<Creature> &lastHitCreature) {
	if (monsterForgeClassification > ForgeClassifications_t::FORGE_NORMAL_MONSTER) {
		g_game().removeForgeMonster(getID(), monsterForgeClassification, true);
	}
	const auto &attackedCreature = getAttackedCreature();
	std::shared_ptr<Player> resolvedPlayer;

	if (lastHitCreature) {
		resolvedPlayer = lastHitCreature->getPlayer();
		if (!resolvedPlayer) {
			const auto &lastHitMaster = lastHitCreature->getMaster();
			if (lastHitMaster) {
				resolvedPlayer = lastHitMaster->getPlayer();
			}
		}
	}
	if (!resolvedPlayer && attackedCreature) {
		resolvedPlayer = attackedCreature->getPlayer();
		if (!resolvedPlayer) {
			const auto &attackedMaster = attackedCreature->getMaster();
			if (attackedMaster) {
				resolvedPlayer = attackedMaster->getPlayer();
			}
		}
	}

	const auto &targetPlayer = resolvedPlayer;

	for (const auto &summon : m_summons) {
		if (!summon) {
			continue;
		}
		summon->changeHealth(-summon->getHealth());
		summon->removeMaster();
	}
	m_summons.clear();

	clearTargetList();
	clearFriendList();
	onIdleStatus();

	setDead(true);

	if (!m_monsterType) {
		return;
	}

	g_game().sendSingleSoundEffect(static_self_cast<Monster>()->getPosition(), m_monsterType->info.deathSound, getMonster());

	if (!targetPlayer) {
		return;
	}

	targetPlayer->weaponProficiency().applyOn(WeaponProficiencyHealth_t::LIFE, WeaponProficiencyGain_t::KILL);
	targetPlayer->weaponProficiency().applyOn(WeaponProficiencyHealth_t::MANA, WeaponProficiencyGain_t::KILL);

	auto [activeCharm, _] = g_iobestiary().getCharmFromTarget(targetPlayer, m_monsterType);
	if (activeCharm == CHARM_CARNAGE) {
		const auto &charm = g_iobestiary().getBestiaryCharm(activeCharm);
		const auto charmTier = targetPlayer->getCharmTier(activeCharm);
		if (charm && charm->chance[charmTier] >= normal_random(1, 10000) / 100.0) {
			g_iobestiary().parseCharmCombat(charm, targetPlayer, getMonster());
		}
	}

	const auto equippedWeaponId = targetPlayer->getWeaponId(true);

	const auto weaponExperienceFromBoss = targetPlayer->weaponProficiency().getBosstiaryExperience(m_monsterType->info.bosstiaryRace);
	if (weaponExperienceFromBoss > 0) {
		targetPlayer->weaponProficiency().addExperience(weaponExperienceFromBoss, equippedWeaponId);
	}

	const auto weaponExperienceFromBestiary = targetPlayer->weaponProficiency().getBestiaryExperience(m_monsterType->info.bestiaryStars);
	if (weaponExperienceFromBestiary > 0) {
		targetPlayer->weaponProficiency().addExperience(weaponExperienceFromBestiary, equippedWeaponId);
	}
}

std::shared_ptr<Item> Monster::getCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature) {
	const auto &corpse = Creature::getCorpse(lastHitCreature, mostDamageCreature);
	if (corpse) {
		if (mostDamageCreature) {
			if (mostDamageCreature->getPlayer()) {
				corpse->setAttribute(ItemAttribute_t::CORPSEOWNER, mostDamageCreature->getID());
			} else {
				const auto &mostDamageCreatureMaster = mostDamageCreature->getMaster();
				if (mostDamageCreatureMaster && mostDamageCreatureMaster->getPlayer()) {
					corpse->setAttribute(ItemAttribute_t::CORPSEOWNER, mostDamageCreatureMaster->getID());
				}
			}
		}
	}
	return corpse;
}

bool Monster::isInSpawnRange(const Position &pos) const {
	if (spawnMonster.expired()) {
		return true;
	}

	if (Monster::despawnRadius == 0) {
		return true;
	}

	if (!SpawnsMonster::isInZone(masterPos, Monster::despawnRadius, pos)) {
		return false;
	}

	if (Monster::despawnRange == 0) {
		return true;
	}

	if (Position::getDistanceZ(pos, masterPos) > Monster::despawnRange) {
		return false;
	}

	return true;
}

bool Monster::getCombatValues(int32_t &min, int32_t &max) {
	if (minCombatValue == 0 && maxCombatValue == 0) {
		return false;
	}

	min = minCombatValue;
	max = maxCombatValue;
	return true;
}

void Monster::updateLookDirection() {
	Direction newDir = getDirection();
	const auto &attackedCreature = getAttackedCreature();
	if (!attackedCreature) {
		return;
	}

	const Position &pos = getPosition();
	const Position &attackedCreaturePos = attackedCreature->getPosition();
	int_fast32_t offsetx = Position::getOffsetX(attackedCreaturePos, pos);
	int_fast32_t offsety = Position::getOffsetY(attackedCreaturePos, pos);

	int32_t dx = std::abs(offsetx);
	int32_t dy = std::abs(offsety);
	if (dx > dy) {
		// look EAST/WEST
		if (offsetx < 0) {
			newDir = DIRECTION_WEST;
		} else {
			newDir = DIRECTION_EAST;
		}
	} else if (dx < dy) {
		// look NORTH/SOUTH
		if (offsety < 0) {
			newDir = DIRECTION_NORTH;
		} else {
			newDir = DIRECTION_SOUTH;
		}
	} else {
		Direction dir = getDirection();
		if (offsetx < 0 && offsety < 0) {
			if (dir == DIRECTION_SOUTH) {
				newDir = DIRECTION_WEST;
			} else if (dir == DIRECTION_EAST) {
				newDir = DIRECTION_NORTH;
			}
		} else if (offsetx < 0 && offsety > 0) {
			if (dir == DIRECTION_NORTH) {
				newDir = DIRECTION_WEST;
			} else if (dir == DIRECTION_EAST) {
				newDir = DIRECTION_SOUTH;
			}
		} else if (offsetx > 0 && offsety < 0) {
			if (dir == DIRECTION_SOUTH) {
				newDir = DIRECTION_EAST;
			} else if (dir == DIRECTION_WEST) {
				newDir = DIRECTION_NORTH;
			}
		} else {
			if (dir == DIRECTION_NORTH) {
				newDir = DIRECTION_EAST;
			} else if (dir == DIRECTION_WEST) {
				newDir = DIRECTION_SOUTH;
			}
		}
	}
	g_game().internalCreatureTurn(getMonster(), newDir);
}

void Monster::dropLoot(const std::shared_ptr<Container> &corpse, const std::shared_ptr<Creature> &) {
	if (corpse && lootDrop) {
		// Only fiendish drops sliver
		if (ForgeClassifications_t classification = getMonsterForgeClassification();
		    // Condition
		    classification == ForgeClassifications_t::FORGE_FIENDISH_MONSTER) {
			auto minSlivers = g_configManager().getNumber(FORGE_MIN_SLIVERS);
			auto maxSlivers = g_configManager().getNumber(FORGE_MAX_SLIVERS);

			auto sliverCount = static_cast<uint16_t>(uniform_random(minSlivers, maxSlivers));

			const auto &sliver = Item::CreateItem(ITEM_FORGE_SLIVER, sliverCount);
			if (g_game().internalAddItem(corpse, sliver) != RETURNVALUE_NOERROR) {
				corpse->internalAddThing(sliver);
			}
		}
		if (!this->isRewardBoss() && g_configManager().getNumber(RATE_LOOT) > 0) {
			g_callbacks().executeCallback(EventCallback_t::monsterOnDropLoot, getMonster(), corpse);
			g_callbacks().executeCallback(EventCallback_t::monsterPostDropLoot, getMonster(), corpse);
		}
	}
}

void Monster::setNormalCreatureLight() {
	internalLight = m_monsterType->info.light;
}

void Monster::drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) {
	Creature::drainHealth(attacker, damage);

	// Allow walking through harmful fields when the monster is being damaged and either
	// has no target (random stepping) or its current target is unreachable. Without the
	// !hasFollowPath branch, a melee monster locked onto a target it cannot path to (magic
	// walled, behind a non-traversable field) stays unable to push through fields even
	// while taking damage from the very fields/bombs blocking its way.
	if (damage > 0 && (randomStepping || (!hasFollowPath && getFollowCreature()))) {
		ignoreFieldDamage = true;
	}

	if (isInvisible()) {
		removeCondition(CONDITION_INVISIBLE);
	}
}

void Monster::changeHealth(int32_t healthChange, bool sendHealthChange /* = true*/) {
	if (m_monsterType && !m_monsterType->info.soundVector.empty() && m_monsterType->info.soundChance >= static_cast<uint32_t>(uniform_random(1, 100))) {
		auto index = uniform_random(0, m_monsterType->info.soundVector.size() - 1);
		g_game().sendSingleSoundEffect(static_self_cast<Monster>()->getPosition(), m_monsterType->info.soundVector[index], getMonster());
	}

	// In case a player with ignore flag set attacks the monster
	setIdle(false);
	Creature::changeHealth(healthChange, sendHealthChange);
}

bool Monster::challengeCreature(const std::shared_ptr<Creature> &creature, int targetChangeCooldown) {
	if (isSummon()) {
		return false;
	}

	bool result = selectTarget(creature);
	if (result) {
		challengeFocusDuration = targetChangeCooldown;
		targetChangeTicks = 0;
		// Wheel of destiny
		const auto &player = creature ? creature->getPlayer() : nullptr;
		if (player && !player->isRemoved()) {
			player->wheel().healIfBattleHealingActive();
		}
	}
	return result;
}

bool Monster::changeTargetDistance(int32_t distance, uint32_t duration /* = 12000*/) {
	if (isSummon()) {
		return false;
	}

	if (m_monsterType->info.isRewardBoss) {
		return false;
	}

	bool shouldUpdate = m_monsterType->info.targetDistance > distance ? true : false;
	challengeMeleeDuration = duration;
	targetDistance = distance;

	if (shouldUpdate) {
		g_game().updateCreatureIcon(static_self_cast<Monster>());
	}
	return true;
}

bool Monster::isChallenged() const {
	return challengeFocusDuration > 0;
}

std::vector<CreatureIcon> Monster::getIcons() const {
	std::vector<CreatureIcon> icons;

	auto creatureIcons = Creature::getIcons();
	// this add pre existing icons, such as from forge system
	icons.insert(icons.end(), creatureIcons.begin(), creatureIcons.end());

	using enum CreatureIconModifications_t;

	if (challengeMeleeDuration > 0 && m_monsterType->info.targetDistance > targetDistance) {
		icons.emplace_back(CreatureIcon(TurnedMelee));
	}

	if (varBuffs[BUFF_DAMAGERECEIVED] > 100) {
		icons.emplace_back(CreatureIcon(HigherDamageReceived));
	}

	if (varBuffs[BUFF_DAMAGEDEALT] < 100) {
		icons.emplace_back(CreatureIcon(LowerDamageDealt));
	}

	return icons;
}

bool Monster::isImmune(ConditionType_t conditionType) const {
	return m_isImmune || m_monsterType->info.m_conditionImmunities[static_cast<size_t>(conditionType)];
}

bool Monster::isImmune(CombatType_t combatType) const {
	return m_isImmune || m_monsterType->info.m_damageImmunities[combatTypeToIndex(combatType)];
}

void Monster::setImmune(bool immune) {
	m_isImmune = immune;
}

bool Monster::isImmune() const {
	return m_isImmune;
}

float Monster::getAttackMultiplier() const {
	float multiplier = m_monsterType->getAttackMultiplier();
	if (auto stacks = getForgeStack(); stacks > 0) {
		multiplier *= (1.35 + (stacks - 1) * 0.1);
	}
	return multiplier;
}

float Monster::getDefenseMultiplier() const {
	float multiplier = m_monsterType->getDefenseMultiplier();
	if (auto stacks = getForgeStack(); stacks > 0) {
		multiplier *= (1 + (0.1 * stacks));
	}
	return multiplier;
}

bool Monster::requestFollowPathCompute(const std::shared_ptr<Creature> &followCreature, const FindPathParams &params, bool executeOnFollow) {
	if (!followCreature || followCreature->getID() == 0 || params.maxSearchDist <= 0 || params.maxSearchDist > MAX_BACKGROUND_FOLLOW_PATH_RADIUS) {
		return false;
	}

	FollowPathComputeRequest request;
	request.start = getPosition();
	request.target = followCreature->getPosition();
	request.params = params;
	request.targetId = followCreature->getID();
	request.executeOnFollow = executeOnFollow;
	if (followPathComputeOutstanding && pendingFollowPathCompute && pendingFollowPathCompute->matches(request)) {
		return true;
	}

	pendingFollowPathCompute = request;
	const auto generation = nextFollowPathComputeGeneration();
	followPathComputeSuperseded = false;
	if (followPathComputeOutstanding) {
		return true;
	}

	followPathComputeOutstanding = true;
	activeFollowPathComputeGeneration = generation;
	const auto monsterId = getID();
	const bool accepted = safeCall([monsterId, generation] {
		if (const auto &monster = g_game().getMonsterByID(monsterId)) {
			monster->prepareFollowPathCompute(generation);
		}
	});
	if (!accepted) {
		followPathComputeOutstanding = false;
		activeFollowPathComputeGeneration = 0;
		followPathComputeSuperseded = false;
		pendingFollowPathCompute.reset();
		forceUpdateFollowPath = true;
		return true;
	}
	return true;
}

void Monster::supersedeFollowPathCompute() {
	if (!followPathComputeOutstanding) {
		pendingFollowPathCompute.reset();
		followPathComputeSuperseded = false;
		return;
	}

	static_cast<void>(nextFollowPathComputeGeneration());
	pendingFollowPathCompute.reset();
	followPathComputeSuperseded = true;
}

void Monster::prepareFollowPathCompute(uint64_t generation) {
	if (!followPathComputeOutstanding || activeFollowPathComputeGeneration != generation) {
		return;
	}
	if (followPathComputeSuperseded && !pendingFollowPathCompute) {
		followPathComputeOutstanding = false;
		activeFollowPathComputeGeneration = 0;
		followPathComputeSuperseded = false;
		return;
	}
	if (!pendingFollowPathCompute) {
		discardFollowPathCompute(false);
		return;
	}
	if (generation != followPathComputeGeneration) {
		activeFollowPathComputeGeneration = followPathComputeGeneration;
		prepareFollowPathCompute(activeFollowPathComputeGeneration);
		return;
	}

	const auto request = *pendingFollowPathCompute;
	const auto &followCreature = getFollowCreature();
	if (isRemoved() || isDead() || getPosition() != request.start || !followCreature || followCreature->getID() != request.targetId || followCreature->getPosition() != request.target) {
		discardFollowPathCompute(followCreature != nullptr);
		return;
	}

	auto navigation = g_game().map.getNavigationSnapshot(request.start, MAX_BACKGROUND_FOLLOW_PATH_RADIUS);
	MonsterPathRequest workerRequest;
	workerRequest.navigation = navigation;
	workerRequest.start = request.start;
	workerRequest.target = request.target;
	workerRequest.params = request.params;
	workerRequest.traits = capturePathTraits(*navigation);

	const auto monsterId = getID();
	const auto priority = isPlayerVisibleForScheduling() || isComputeRelevant() ? MonsterComputePriority::Visible : MonsterComputePriority::Background;
	const auto submission = g_monsterComputeService().submit(
		priority,
		[monsterId, generation, workerRequest = std::move(workerRequest)](MonsterComputeToken, std::stop_token stopToken) mutable {
			auto result = MonsterPathfinder::find(workerRequest, stopToken);
			auto resultNavigation = std::move(workerRequest.navigation);
			return [monsterId, generation, navigation = std::move(resultNavigation), result = std::move(result)]() mutable {
				if (const auto &monster = g_game().getMonsterByID(monsterId)) {
					monster->completeFollowPathCompute(generation, std::move(navigation), std::move(result));
				}
			};
		},
		"Monster::followPath",
		[monsterId, generation] {
			if (const auto &monster = g_game().getMonsterByID(monsterId)) {
				monster->rejectFollowPathCompute(generation);
			}
		}
	);
	if (!submission.accepted()) {
		rejectFollowPathCompute(generation);
	}
}

void Monster::completeFollowPathCompute(uint64_t generation, std::shared_ptr<const NavRegionSnapshot> navigation, MonsterPathResult result) {
	if (!followPathComputeOutstanding || activeFollowPathComputeGeneration != generation) {
		return;
	}
	if (followPathComputeSuperseded && !pendingFollowPathCompute) {
		followPathComputeOutstanding = false;
		activeFollowPathComputeGeneration = 0;
		followPathComputeSuperseded = false;
		return;
	}
	if (!pendingFollowPathCompute) {
		discardFollowPathCompute(false);
		return;
	}
	if (generation != followPathComputeGeneration) {
		discardFollowPathCompute(true);
		return;
	}
	if (result.status == MonsterPathStatus::Cancelled) {
		discardFollowPathCompute(false);
		return;
	}

	const auto request = *pendingFollowPathCompute;
	const auto &followCreature = getFollowCreature();
	const auto &resolvedTarget = g_game().getCreatureByID(request.targetId);
	const bool identityIsCurrent = !isRemoved() && !isDead() && getPosition() == request.start && followCreature && resolvedTarget && followCreature == resolvedTarget && resolvedTarget->getPosition() == request.target;
	if (!identityIsCurrent || !navigation || !g_game().map.isNavigationTopologyCurrent(*navigation)) {
		discardFollowPathCompute(followCreature != nullptr);
		return;
	}

	if (result.found()) {
		int32_t bestMatchDistance = 0;
		const bool endpointIsCurrent = FrozenPathingConditionCall(request.target)(request.start, result.endpoint, request.params, bestMatchDistance);
		if (!endpointIsCurrent || !pathReachesEndpoint(*navigation, request.start, result.directions, result.endpoint)) {
			discardFollowPathCompute(true);
			return;
		}
	}

	followPathComputeOutstanding = false;
	activeFollowPathComputeGeneration = 0;
	followPathComputeSuperseded = false;
	pendingFollowPathCompute.reset();
	hasFollowPath = result.found();
	startAutoWalk(result.directions);
	if (request.executeOnFollow) {
		onFollowCreatureComplete(resolvedTarget);
	}
}

void Monster::rejectFollowPathCompute(uint64_t generation) {
	if (!followPathComputeOutstanding || activeFollowPathComputeGeneration != generation) {
		return;
	}
	if (followPathComputeSuperseded && !pendingFollowPathCompute) {
		followPathComputeOutstanding = false;
		activeFollowPathComputeGeneration = 0;
		followPathComputeSuperseded = false;
		return;
	}
	if (!pendingFollowPathCompute) {
		discardFollowPathCompute(false);
		return;
	}
	if (generation != followPathComputeGeneration) {
		activeFollowPathComputeGeneration = followPathComputeGeneration;
		prepareFollowPathCompute(activeFollowPathComputeGeneration);
		return;
	}

	const auto request = *pendingFollowPathCompute;
	const auto &followCreature = getFollowCreature();
	followPathComputeOutstanding = false;
	activeFollowPathComputeGeneration = 0;
	followPathComputeSuperseded = false;
	pendingFollowPathCompute.reset();
	hasFollowPath = false;
	startAutoWalk({});
	if (request.executeOnFollow && followCreature && followCreature->getID() == request.targetId) {
		onFollowCreatureComplete(followCreature);
	}
}

void Monster::discardFollowPathCompute(bool requestRefresh) {
	followPathComputeOutstanding = false;
	activeFollowPathComputeGeneration = 0;
	followPathComputeSuperseded = false;
	pendingFollowPathCompute.reset();
	if (requestRefresh && !isRemoved() && !isDead() && getFollowCreature()) {
		goToFollowCreature_async();
	}
}

MonsterPathTraits Monster::capturePathTraits(const NavRegionSnapshot &navigation) const {
	MonsterPathTraits traits;
	traits.canPushItems = canPushItems();
	traits.canPushCreatures = canPushCreatures();
	traits.isSummon = isSummon();
	traits.canSeeInvisibility = canSeeInvisibility();
	traits.moveLocked = isMoveLocked();
	const auto &master = getMaster();
	traits.canEnterProtectionZone = isFamiliar() && (!master || !master->getAttackedCreature());
	if (traits.isSummon && master) {
		if (const auto &masterPlayer = master->getPlayer()) {
			std::vector<uint32_t> checkedHouseIds;
			for (const auto &sector : navigation.getSectors()) {
				for (const auto &cell : sector->getCells()) {
					if (cell.houseId == 0 || std::ranges::find(checkedHouseIds, cell.houseId) != checkedHouseIds.end()) {
						continue;
					}
					checkedHouseIds.emplace_back(cell.houseId);
					if (const auto &house = g_game().map.houses.getHouse(cell.houseId); house && house->isInvited(masterPlayer)) {
						traits.summonInvitedHouseIds.emplace_back(cell.houseId);
					}
				}
			}
			std::ranges::sort(traits.summonInvitedHouseIds);
		}
	}

	const bool ignoresFieldDamage = getIgnoreFieldDamage();
	for (size_t index = 0; index < COMBAT_COUNT; ++index) {
		const auto combatType = static_cast<CombatType_t>(index);
		const bool immune = isImmune(combatType);
		const bool canWalk = canWalkOnFieldType(combatType);
		traits.fieldAllowed[index] = immune || ignoresFieldDamage || canWalk;
		traits.fieldPenalty[index] = !immune && !canWalk && !hasCondition(Combat::DamageToConditionType(combatType));
	}
	return traits;
}

uint64_t Monster::nextFollowPathComputeGeneration() {
	if (++followPathComputeGeneration == 0) {
		followPathComputeGeneration = 1;
	}
	return followPathComputeGeneration;
}

bool Monster::isDead() const {
	return m_isDead;
}

void Monster::setDead(bool isDead) {
	m_isDead = isDead;
}

void Monster::getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) {
	Creature::getPathSearchParams(creature, fpp);

	fpp.minTargetDist = 1;
	fpp.maxTargetDist = targetDistance;

	if (isSummon()) {
		const auto &master = getMaster();
		if (master && master == creature) {
			fpp.maxTargetDist = 2;
			fpp.fullPathSearch = true;
		} else if (targetDistance <= 1) {
			fpp.fullPathSearch = true;
		} else {
			fpp.fullPathSearch = !canUseAttack(getPosition(), creature);
		}
	} else if (isFleeing()) {
		// Distance should be higher than the client view range (MAP_MAX_CLIENT_VIEW_PORT_X/MAP_MAX_CLIENT_VIEW_PORT_Y)
		fpp.maxTargetDist = MAP_MAX_VIEW_PORT_X;
		fpp.clearSight = false;
		fpp.keepDistance = true;
		fpp.fullPathSearch = false;
	} else if (targetDistance <= 1) {
		fpp.fullPathSearch = true;
	} else {
		fpp.fullPathSearch = !canUseAttack(getPosition(), creature);
	}
}

void Monster::applyStacks() {
	// Change health based in stacks
	const auto percentToIncrement = 1 + (15 * forgeStack + 35) / 100.f;
	auto newHealth = static_cast<int32_t>(std::ceil(static_cast<float>(healthMax) * percentToIncrement));

	healthMax = newHealth;
	health = newHealth;
}

void Monster::configureForgeSystem(uint16_t stack /* = 0 */) {
	if (!canBeForgeMonster()) {
		return;
	}

	if (monsterForgeClassification == ForgeClassifications_t::FORGE_FIENDISH_MONSTER) {
		setForgeStack(15);
		setIcon("forge", CreatureIcon(CreatureIconModifications_t::Fiendish, 0 /* don't show stacks on fiends */));
		g_game().updateCreatureIcon(static_self_cast<Monster>());
	} else if (monsterForgeClassification == ForgeClassifications_t::FORGE_INFLUENCED_MONSTER) {
		if (stack == 0) {
			stack = static_cast<uint16_t>(normal_random(1, 5));
		}
		setForgeStack(stack);
		setIcon("forge", CreatureIcon(CreatureIconModifications_t::Influenced, stack));
		g_game().updateCreatureIcon(static_self_cast<Monster>());
	}

	// Event to give Dusts
	const std::string &Eventname = "ForgeSystemMonster";
	registerCreatureEvent(Eventname);

	g_game().sendUpdateCreature(static_self_cast<Monster>());
}

bool Monster::canBeForgeMonster() const {
	return getForgeStack() == 0 && !isSummon() && !isRewardBoss() && canDropLoot() && isForgeCreature() && getRaceId() > 0;
}

bool Monster::isForgeCreature() const {
	return m_monsterType->info.isForgeCreature;
}

void Monster::setForgeMonster(bool forge) const {
	m_monsterType->info.isForgeCreature = forge;
}

uint16_t Monster::getForgeStack() const {
	return forgeStack;
}

void Monster::setForgeStack(uint16_t stack) {
	forgeStack = stack;
	applyStacks();
}

ForgeClassifications_t Monster::getMonsterForgeClassification() const {
	return monsterForgeClassification;
}

void Monster::setMonsterForgeClassification(ForgeClassifications_t classification) {
	monsterForgeClassification = classification;
}

void Monster::setTimeToChangeFiendish(time_t time) {
	timeToChangeFiendish = time;
}

time_t Monster::getTimeToChangeFiendish() const {
	return timeToChangeFiendish;
}

std::shared_ptr<MonsterType> Monster::getMonsterType() const {
	return m_monsterType;
}

void Monster::clearFiendishStatus() {
	timeToChangeFiendish = 0;
	forgeStack = 0;
	monsterForgeClassification = ForgeClassifications_t::FORGE_NORMAL_MONSTER;

	health = m_monsterType->info.health * m_monsterType->getHealthMultiplier();
	healthMax = m_monsterType->info.healthMax * m_monsterType->getHealthMultiplier();

	removeIcon("forge");
	g_game().updateCreatureIcon(static_self_cast<Monster>());
	g_game().sendUpdateCreature(static_self_cast<Monster>());
}

bool Monster::canDropLoot() const {
	return !m_monsterType->info.lootItems.empty();
}

std::vector<std::pair<int8_t, int8_t>> Monster::getPushItemLocationOptions(const Direction &direction) {
	if (direction == DIRECTION_WEST || direction == DIRECTION_EAST) {
		return { { 0, -1 }, { 0, 1 } };
	}
	if (direction == DIRECTION_NORTH || direction == DIRECTION_SOUTH) {
		return { { -1, 0 }, { 1, 0 } };
	}
	if (direction == DIRECTION_NORTHWEST) {
		return { { 0, -1 }, { -1, 0 } };
	}
	if (direction == DIRECTION_NORTHEAST) {
		return { { 0, -1 }, { 1, 0 } };
	}
	if (direction == DIRECTION_SOUTHWEST) {
		return { { 0, 1 }, { -1, 0 } };
	}
	if (direction == DIRECTION_SOUTHEAST) {
		return { { 0, 1 }, { 1, 0 } };
	}

	return {};
}

void Monster::onExecuteAsyncTasks() {
	if (hasAsyncTaskFlag(UpdateTargetList)) {
		updateTargetList();
	}

	if (hasAsyncTaskFlag(UpdateIdleStatus)) {
		updateIdleStatus();
	}

	if (hasAsyncTaskFlag(TargetRanking) && pendingTargetSearchCompute) {
		const auto searchType = pendingTargetSearchCompute->searchType;
		pendingTargetSearchCompute.reset();
		requestTargetSearchCompute(searchType);
	}

	if (hasAsyncTaskFlag(CombatIntention)) {
		startPendingCombatIntention();
	}

	if (hasAsyncTaskFlag(OnThink)) {
		if (!onThink_async()) {
			queuePostThinkAfterAsync();
		}
	}
}

bool Monster::checkCanApplyCharm(const std::shared_ptr<Player> &player, charmRune_t charmRune) const {
	if (!player) {
		return false;
	}

	uint16_t playerCharmRaceid = player->parseRacebyCharm(charmRune, false, 0);
	if (playerCharmRaceid != 0) {
		if (m_monsterType && playerCharmRaceid == m_monsterType->info.raceid) {
			const auto &charm = g_iobestiary().getBestiaryCharm(charmRune);
			if (charm) {
				return true;
			}
		}
	}

	return false;
}
