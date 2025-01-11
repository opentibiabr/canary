/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/spells.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "items/tile.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "map/spectators.hpp"

int32_t Monster::despawnRange;
int32_t Monster::despawnRadius;

uint32_t Monster::monsterAutoID = 0x50000001;

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
	mType(mType) {
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
		return mType->name;
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
	return mType->typeName;
}

const std::string &Monster::getNameDescription() const {
	if (nameDescription.empty()) {
		return mType->nameDescription;
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
			return mType->info.canWalkOnEnergy;
		case COMBAT_FIREDAMAGE:
			return mType->info.canWalkOnFire;
		case COMBAT_EARTHDAMAGE:
			return mType->info.canWalkOnPoison;
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
	auto it = mType->info.reflectMap.find(reflectType);
	if (it != mType->info.reflectMap.end()) {
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

int32_t Monster::getDefense() const {
	auto mtypeDefense = mType->info.defense;
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
	return mType->info.faction;
}

bool Monster::isEnemyFaction(Faction_t faction) const {
	const auto &master = getMaster();
	if (master && master->getMonster()) {
		return master->getMonster()->isEnemyFaction(faction);
	}
	return mType->info.enemyFactions.empty() ? false : mType->info.enemyFactions.contains(faction);
}

bool Monster::isPushable() {
	return mType->info.pushable && baseSpeed != 0;
}

bool Monster::isAttackable() const {
	return mType->info.isAttackable;
}

bool Monster::canPushItems() const {
	return mType->info.canPushItems;
}

bool Monster::canPushCreatures() const {
	return mType->info.canPushCreatures;
}

bool Monster::isRewardBoss() const {
	return mType->info.isRewardBoss;
}

bool Monster::isHostile() const {
	return mType->info.isHostile;
}

bool Monster::isFamiliar() const {
	return mType->info.isFamiliar;
}

bool Monster::canSeeInvisibility() const {
	return isImmune(CONDITION_INVISIBLE);
}

uint16_t Monster::critChance() const {
	return mType->info.critChance;
}

uint32_t Monster::getManaCost() const {
	return mType->info.manaCost;
}

RespawnType Monster::getRespawnType() const {
	return mType->info.respawnType;
}

void Monster::setSpawnMonster(const std::shared_ptr<SpawnMonster> &newSpawnMonster) {
	this->spawnMonster = newSpawnMonster;
}

uint32_t Monster::getHealingCombatValue(CombatType_t healingType) const {
	auto it = mType->info.healingMap.find(healingType);
	if (it != mType->info.healingMap.end()) {
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

	if (mType->info.creatureAppearEvent != -1) {
		// onCreatureAppear(self, creature)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("[Monster::onCreatureAppear - Monster {} creature {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(mType->info.creatureAppearEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.creatureAppearEvent);

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
		addAsyncTask([this, creature] {
			onCreatureEnter(creature);
		});
	}
}

void Monster::onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout) {
	Creature::onRemoveCreature(creature, isLogout);

	if (mType->info.creatureDisappearEvent != -1) {
		// onCreatureDisappear(self, creature)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("[Monster::onCreatureDisappear - Monster {} creature {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(mType->info.creatureDisappearEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.creatureDisappearEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);

		if (scriptInterface->callFunction(2)) {
			return;
		}
	}

	if (creature.get() == this) {
		if (spawnMonster) {
			spawnMonster->startSpawnMonsterCheck();
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

	if (mType->info.creatureMoveEvent != -1) {
		// onCreatureMove(self, creature, oldPosition, newPosition)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("[Monster::onCreatureMove - Monster {} creature {}] "
			                 "Call stack overflow. Too many lua script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(mType->info.creatureMoveEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.creatureMoveEvent);

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
		auto action = [this, newPos, oldPos, creature] {
			bool canSeeNewPos = canSee(newPos);
			bool canSeeOldPos = canSee(oldPos);

			if (canSeeNewPos && !canSeeOldPos) {
				onCreatureEnter(creature);
			} else if (!canSeeNewPos && canSeeOldPos) {
				onCreatureLeave(creature);
			}

			updateIdleStatus();

			if (!isSummon()) {
				if (const auto &followCreature = getFollowCreature()) {
					const Position &followPosition = followCreature->getPosition();
					const Position &pos = getPosition();

					int32_t offset_x = Position::getDistanceX(followPosition, pos);
					int32_t offset_y = Position::getDistanceY(followPosition, pos);
					if ((offset_x > 1 || offset_y > 1) && mType->info.changeTargetChance > 0) {
						Direction dir = getDirectionTo(pos, followPosition);
						const auto &checkPosition = getNextPosition(dir, pos);

						if (const auto &nextTile = g_game().map.getTile(checkPosition)) {
							const auto &topCreature = nextTile->getTopCreature();
							if (followCreature != topCreature && isOpponent(topCreature)) {
								selectTarget(topCreature);
							}
						}
					}
				} else if (isOpponent(creature)) {
					// we have no target lets try pick this one
					selectTarget(creature);
				}
			}
		};

		if (g_dispatcher().context().getGroup() == TaskGroup::Walk) {
			addAsyncTask(std::move(action));
		} else {
			action();
		}
	}
}

void Monster::onCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text) {
	Creature::onCreatureSay(creature, type, text);

	if (mType->info.creatureSayEvent != -1) {
		// onCreatureSay(self, creature, type, message)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("Monster {} creature {}] Call stack overflow. Too many lua "
			                 "script calls being nested.",
			                 getName(), creature->getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(mType->info.creatureSayEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.creatureSayEvent);

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
	if (mType->info.monsterAttackedByPlayerEvent != -1) {
		// onPlayerAttack(self, attackerPlayer)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!scriptInterface->reserveScriptEnv()) {
			g_logger().error("Monster {} creature {}] Call stack overflow. Too many lua "
			                 "script calls being nested.",
			                 getName(), this->getName());
			return;
		}

		ScriptEnvironment* env = scriptInterface->getScriptEnv();
		env->setScriptId(mType->info.monsterAttackedByPlayerEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.monsterAttackedByPlayerEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");

		LuaScriptInterface::pushUserdata<Player>(L, attackerPlayer);
		LuaScriptInterface::setMetatable(L, -1, "Player");

		scriptInterface->callVoidFunction(2);
	}
}

void Monster::onSpawn(const Position &position) {
	if (mType->info.spawnEvent != -1) {
		// onSpawn(self, spawnPosition)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!scriptInterface->reserveScriptEnv()) {
			g_logger().error("Monster {} creature {}] Call stack overflow. Too many lua "
			                 "script calls being nested.",
			                 getName(), this->getName());
			return;
		}

		ScriptEnvironment* env = scriptInterface->getScriptEnv();
		env->setScriptId(mType->info.spawnEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.spawnEvent);

		LuaScriptInterface::pushUserdata<Monster>(L, getMonster());
		LuaScriptInterface::setMetatable(L, -1, "Monster");
		LuaScriptInterface::pushPosition(L, position);

		scriptInterface->callVoidFunction(2);
	}
}

void Monster::addFriend(const std::shared_ptr<Creature> &creature) {
	if (creature == getMonster()) {
		g_logger().error("[{}]: adding creature is same of monster", __FUNCTION__);
		return;
	}

	assert(creature != getMonster());
	friendList.try_emplace(creature->getID(), creature);
}

void Monster::removeFriend(const std::shared_ptr<Creature> &creature) {
	std::erase_if(friendList, [id = creature->getID()](const auto &it) {
		const auto &target = it.second.lock();
		return !target || target->getID() == id;
	});
}

bool Monster::addTarget(const std::shared_ptr<Creature> &creature, bool pushFront /* = false*/) {
	if (creature == getMonster()) {
		g_logger().error("[{}]: adding creature is same of monster", __FUNCTION__);
		return false;
	}

	assert(creature != getMonster());

	auto it = getTargetIterator(creature);
	if (it != targetList.end()) {
		return false;
	}

	if (pushFront) {
		targetList.emplace_front(creature);
	} else {
		targetList.emplace_back(creature);
	}

	const auto &master = getMaster();
	if (!master && getFaction() != FACTION_DEFAULT && creature->getPlayer()) {
		totalPlayersOnScreen++;
	}

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

	const auto &master = getMaster();
	if (!master && getFaction() != FACTION_DEFAULT && creature->getPlayer()) {
		totalPlayersOnScreen--;
	}

	if (auto shared = it->lock()) {
		targetList.erase(it);
	} else {
		return false;
	}

	return true;
}

void Monster::updateTargetList() {
	if (!g_dispatcher().context().isAsync()) {
		setAsyncTaskFlag(UpdateTargetList, true);
		return;
	}

	std::erase_if(friendList, [this](const auto &it) {
		const auto &target = it.second.lock();
		return !target || target->getHealth() <= 0 || !canSee(target->getPosition());
	});

	std::erase_if(targetList, [this](const std::weak_ptr<Creature> &ref) {
		const auto &target = ref.lock();
		return !target || target->getHealth() <= 0 || !canSee(target->getPosition());
	});

	for (const auto &spectator : Spectators().find<Creature>(position, true, 0, 0, 0, 0, false)) {
		if (spectator.get() != this && canSee(spectator->getPosition())) {
			onCreatureFound(spectator);
		}
	}
}

void Monster::clearTargetList() {
	targetList.clear();
}

void Monster::clearFriendList() {
	friendList.clear();
}

void Monster::onCreatureFound(const std::shared_ptr<Creature> &creature, bool pushFront /* = false*/) {
	if (isFriend(creature)) {
		addFriend(creature);
	}

	if (isOpponent(creature)) {
		addTarget(creature, pushFront);
	}

	updateIdleStatus();
}

void Monster::onCreatureEnter(const std::shared_ptr<Creature> &creature) {
	onCreatureFound(creature, true);
}

bool Monster::isFriend(const std::shared_ptr<Creature> &creature) const {
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

	return creature->getMonster() && !creature->isSummon();
}

bool Monster::isOpponent(const std::shared_ptr<Creature> &creature) const {
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
	return skillLoss ? mType->info.experience : 0;
}

uint16_t Monster::getLookCorpse() const {
	return mType->info.lookcorpse;
}

void Monster::onCreatureLeave(const std::shared_ptr<Creature> &creature) {
	// update friendList
	if (isFriend(creature)) {
		removeFriend(creature);
	}

	// update targetList
	if (isOpponent(creature)) {
		removeTarget(creature);
		if (targetList.empty()) {
			updateIdleStatus();
		}
	}
}

bool Monster::searchTarget(TargetSearchType_t searchType /*= TARGETSEARCH_DEFAULT*/) {
	if (searchType == TARGETSEARCH_DEFAULT) {
		int32_t rnd = uniform_random(1, 100);

		searchType = TARGETSEARCH_NEAREST;

		int32_t sum = this->mType->info.strategiesTargetNearest;
		if (rnd > sum) {
			searchType = TARGETSEARCH_HP;
			sum += this->mType->info.strategiesTargetHealth;

			if (rnd > sum) {
				searchType = TARGETSEARCH_DAMAGE;
				sum += this->mType->info.strategiesTargetDamage;
				if (rnd > sum) {
					searchType = TARGETSEARCH_RANDOM;
				}
			}
		}
	}

	std::vector<std::shared_ptr<Creature>> resultList;
	const Position &myPos = getPosition();

	for (const auto &cref : targetList) {
		const auto &creature = cref.lock();
		if (creature && isTarget(creature)) {
			if ((static_self_cast<Monster>()->targetDistance == 1) || canUseAttack(myPos, creature)) {
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
					int32_t minRange = std::max<int32_t>(Position::getDistanceX(myPos, targetPosition), Position::getDistanceY(myPos, targetPosition));
					int32_t factionOffset = static_cast<int32_t>(getTarget->getFaction()) * 100;
					do {
						const Position &pos = (*it)->getPosition();

						int32_t distance = std::max<int32_t>(Position::getDistanceX(myPos, pos), Position::getDistanceY(myPos, pos)) + factionOffset;
						if (distance < minRange) {
							getTarget = *it;
							minRange = distance;
						}
					} while (++it != resultList.end());
				}
			} else {
				int32_t minRange = std::numeric_limits<int32_t>::max();
				for (const auto &creature : getTargetList()) {
					if (!isTarget(creature)) {
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

			if (getTarget && selectTarget(getTarget)) {
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
					int32_t factionOffset = static_cast<int32_t>(getTarget->getFaction()) * 100000;
					int32_t minHp = getTarget->getHealth() + factionOffset;
					do {
						auto hp = (*it)->getHealth() + factionOffset;
						factionOffset = static_cast<int32_t>((*it)->getFaction()) * 100000;
						if (hp < minHp) {
							getTarget = *it;
							minHp = hp;
						}
					} while (++it != resultList.end());
				}
			}
			if (getTarget && selectTarget(getTarget)) {
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
					int32_t mostDamage = 0;
					do {
						int32_t factionOffset = static_cast<int32_t>((*it)->getFaction()) * 100000;
						const auto dmg = damageMap.find((*it)->getID());
						if (dmg != damageMap.end() && dmg->second.total + factionOffset > mostDamage) {
							mostDamage = dmg->second.total;
							getTarget = *it;
						}
					} while (++it != resultList.end());
				}
			}
			if (getTarget && selectTarget(getTarget)) {
				return true;
			}
			break;
		}
		case TARGETSEARCH_RANDOM:
		default: {
			if (!resultList.empty()) {
				auto it = resultList.begin();
				std::advance(it, uniform_random(0, resultList.size() - 1));
				return selectTarget(*it);
			}
			break;
		}
	}

	// lets just pick the first target in the list
	return std::ranges::any_of(getTargetList(), [this](const std::shared_ptr<Creature> &creature) {
		return selectTarget(creature);
	});
}

void Monster::onFollowCreatureComplete(const std::shared_ptr<Creature> &creature) {
	if (removeTarget(creature) && (hasFollowPath || !isSummon())) {
		addTarget(creature, hasFollowPath);
	}
}

RaceType_t Monster::getRace() const {
	return mType->info.race;
}

float Monster::getMitigation() const {
	float mitigation = mType->info.mitigation * getDefenseMultiplier();
	if (g_configManager().getBoolean(DISABLE_MONSTER_ARMOR)) {
		mitigation += std::ceil(static_cast<float>(getDefense() + getArmor()) / 100.f) * getDefenseMultiplier() * 2.f;
	}
	return std::min<float>(mitigation, 30.f);
}

int32_t Monster::getArmor() const {
	return mType->info.armor * getDefenseMultiplier();
}

BlockType_t Monster::blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense /* = false*/, bool checkArmor /* = false*/, bool /* field = false */) {
	BlockType_t blockType = Creature::blockHit(attacker, combatType, damage, checkDefense, checkArmor);

	if (damage != 0) {
		int32_t elementMod = 0;
		auto it = mType->info.elementMap.find(combatType);
		if (it != mType->info.elementMap.end()) {
			elementMod = it->second;
		}

		// Wheel of destiny
		const auto &player = attacker ? attacker->getPlayer() : nullptr;
		if (player && player->wheel()->getInstant("Ballistic Mastery")) {
			elementMod -= player->wheel()->checkElementSensitiveReduction(combatType);
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
	if (creature->isRemoved() || !creature->isAttackable() || creature->getZoneType() == ZONE_PROTECTION || !canSeeCreature(creature)) {
		return false;
	}

	if (creature->getPosition().z != getPosition().z) {
		return false;
	}

	if (!isSummon()) {
		if (getFaction() != FACTION_DEFAULT) {
			return isEnemyFaction(creature->getFaction());
		}
	}

	return true;
}

bool Monster::isFleeing() const {
	return !isSummon() && getHealth() <= runAwayHealth && challengeFocusDuration <= 0 && challengeMeleeDuration <= 0;
}

bool Monster::selectTarget(const std::shared_ptr<Creature> &creature) {
	if (!isTarget(creature)) {
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
	if (!g_dispatcher().context().isAsync()) {
		setAsyncTaskFlag(UpdateIdleStatus, true);
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
	if (!spawnMonster) {
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

	if (mType->info.thinkEvent != -1) {
		// onThink(self, interval)
		LuaScriptInterface* scriptInterface = mType->info.scriptInterface;
		if (!LuaScriptInterface::reserveScriptEnv()) {
			g_logger().error("Monster {} Call stack overflow. Too many lua script calls "
			                 "being nested.",
			                 getName());
			return;
		}

		ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
		env->setScriptId(mType->info.thinkEvent, scriptInterface);

		lua_State* L = scriptInterface->getLuaState();
		scriptInterface->pushFunction(mType->info.thinkEvent);

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
			targetDistance = mType->info.targetDistance;
			g_game().updateCreatureIcon(static_self_cast<Monster>());
		}
	}

	if (!mType->canSpawn(position)) {
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

void Monster::onThink_async() {
	if (isIdle) { // updateIdleStatus(); is executed before this method
		return;
	}

	addEventWalk();

	const auto &attackedCreature = getAttackedCreature();
	const auto &followCreature = getFollowCreature();
	if (isSummon()) {
		const auto &master = getMaster();
		if (attackedCreature.get() == this) {
			setFollowCreature(nullptr);
		} else if (attackedCreature && followCreature != attackedCreature) {
			// This happens just after a master orders an attack, so lets follow it aswell.
			setFollowCreature(attackedCreature);
		} else if (master && master->getAttackedCreature()) {
			// This happens if the monster is summoned during combat
			selectTarget(master->getAttackedCreature());
		} else if (master && master != followCreature) {
			// Our master has not ordered us to attack anything, lets follow him around instead.
			setFollowCreature(master);
		}
	} else if (!targetList.empty()) {
		const bool attackedCreatureIsUnattackable = attackedCreature && !canUseAttack(getPosition(), attackedCreature);
		const bool attackedCreatureIsUnreachable = targetDistance <= 1 && attackedCreature && followCreature && !hasFollowPath;
		if (!attackedCreature || attackedCreatureIsUnattackable || attackedCreatureIsUnreachable) {
			if (!followCreature || !hasFollowPath) {
				searchTarget(TARGETSEARCH_NEAREST);
			} else if (attackedCreature && isFleeing() && !canUseAttack(getPosition(), attackedCreature)) {
				searchTarget(TARGETSEARCH_DEFAULT);
			}
		}
	}

	onThinkTarget(EVENT_CREATURE_THINK_INTERVAL);

	safeCall([this] {
		onThinkYell(EVENT_CREATURE_THINK_INTERVAL);
		onThinkDefense(EVENT_CREATURE_THINK_INTERVAL);
		onThinkSound(EVENT_CREATURE_THINK_INTERVAL);
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

	bool updateLook = true;
	bool resetTicks = interval != 0;
	attackTicks += interval;

	const Position &myPos = getPosition();
	const Position &targetPos = attackedCreature->getPosition();

	for (const spellBlock_t &spellBlock : mType->info.attackSpells) {
		bool inRange = false;

		if (spellBlock.spell == nullptr || (spellBlock.isMelee && isFleeing())) {
			continue;
		}

		if (canUseSpell(myPos, targetPos, spellBlock, interval, inRange, resetTicks)) {
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

				spellBlock.spell->castSpell(getMonster(), attackedCreature);

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

	if (updateLook) {
		updateLookDirection();
	}

	if (resetTicks) {
		attackTicks = 0;
	}
}

bool Monster::hasExtraSwing() {
	return extraMeleeAttack;
}

bool Monster::canUseAttack(const Position &pos, const std::shared_ptr<Creature> &target) const {
	if (isHostile()) {
		const Position &targetPos = target->getPosition();
		uint32_t distance = std::max<uint32_t>(Position::getDistanceX(pos, targetPos), Position::getDistanceY(pos, targetPos));
		for (const spellBlock_t &spellBlock : mType->info.attackSpells) {
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
		if (mType->info.changeTargetSpeed != 0) {
			bool canChangeTarget = true;

			if (challengeFocusDuration > 0) {
				challengeFocusDuration -= interval;
				canChangeTarget = false;

				if (challengeFocusDuration <= 0) {
					challengeFocusDuration = 0;
				}
			}

			if (m_targetChangeCooldown > 0) {
				m_targetChangeCooldown -= interval;

				if (m_targetChangeCooldown <= 0) {
					m_targetChangeCooldown = 0;
					targetChangeTicks = mType->info.changeTargetSpeed;
				} else {
					canChangeTarget = false;
				}
			}

			if (canChangeTarget) {
				targetChangeTicks += interval;

				if (targetChangeTicks >= mType->info.changeTargetSpeed) {
					targetChangeTicks = 0;
					m_targetChangeCooldown = mType->info.changeTargetSpeed;

					if (challengeFocusDuration > 0) {
						challengeFocusDuration = 0;
					}

					if (mType->info.changeTargetChance >= uniform_random(1, 100)) {
						if (mType->info.targetDistance <= 1) {
							searchTarget(TARGETSEARCH_RANDOM);
						} else {
							searchTarget(TARGETSEARCH_NEAREST);
						}
					}
				}
			}
		}
	}
}

void Monster::onThinkDefense(uint32_t interval) {
	bool resetTicks = true;
	defenseTicks += interval;

	for (const spellBlock_t &spellBlock : mType->info.defenseSpells) {
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

	if (!isSummon() && m_summons.size() < mType->info.maxSummons && hasFollowPath) {
		for (const auto &[summonName, summonChance, summonSpeed, summonCount, summonForce] : mType->info.summons) {
			if (summonSpeed > defenseTicks) {
				resetTicks = false;
				continue;
			}

			if (m_summons.size() >= mType->info.maxSummons) {
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
			if (summon) {
				if (g_game().placeCreature(summon, getPosition(), false, summonForce)) {
					summon->setMaster(static_self_cast<Monster>(), true);
					g_game().addMagicEffect(getPosition(), CONST_ME_MAGIC_BLUE);
					g_game().addMagicEffect(summon->getPosition(), CONST_ME_TELEPORT);
					g_game().sendSingleSoundEffect(summon->getPosition(), SoundEffect_t::MONSTER_SPELL_SUMMON, getMonster());
				}
			}
		}
	}

	if (resetTicks) {
		defenseTicks = 0;
	}
}

void Monster::onThinkYell(uint32_t interval) {
	if (mType->info.yellSpeedTicks == 0) {
		return;
	}

	yellTicks += interval;
	if (yellTicks >= mType->info.yellSpeedTicks) {
		yellTicks = 0;

		if (!mType->info.voiceVector.empty() && (mType->info.yellChance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			const uint32_t index = uniform_random(0, mType->info.voiceVector.size() - 1);
			const auto &[text, yellText] = mType->info.voiceVector[index];

			if (yellText) {
				g_game().internalCreatureSay(static_self_cast<Monster>(), TALKTYPE_MONSTER_YELL, text, false);
			} else {
				g_game().internalCreatureSay(static_self_cast<Monster>(), TALKTYPE_MONSTER_SAY, text, false);
			}
		}
	}
}

void Monster::onThinkSound(uint32_t interval) {
	if (mType->info.soundSpeedTicks == 0) {
		return;
	}

	soundTicks += interval;
	if (soundTicks >= mType->info.soundSpeedTicks) {
		soundTicks = 0;

		if (!mType->info.soundVector.empty() && (mType->info.soundChance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			int64_t index = uniform_random(0, static_cast<int64_t>(mType->info.soundVector.size() - 1));
			g_game().sendSingleSoundEffect(static_self_cast<Monster>()->getPosition(), mType->info.soundVector[index], getMonster());
		}
	}
}

bool Monster::pushItem(const std::shared_ptr<Item> &item, const Direction &nextDirection) {
	const Position &centerPos = item->getPosition();
	for (const auto &[x, y] : getPushItemLocationOptions(nextDirection)) {
		Position tryPos(centerPos.x + x, centerPos.y + y, centerPos.z);
		std::shared_ptr<Tile> tile = g_game().map.getTile(tryPos);
		if (tile && g_game().canThrowObjectTo(centerPos, tryPos) && g_game().internalMoveItem(item->getParent(), tile, INDEX_WHEREEVER, item, item->getItemCount(), nullptr) == RETURNVALUE_NOERROR) {
			return true;
		}
	}
	return false;
}

void Monster::pushItems(const std::shared_ptr<Tile> &tile, const Direction &nextDirection) {
	// We can not use iterators here since we can push the item to another tile
	// which will invalidate the iterator.
	// start from the end to minimize the amount of traffic
	if (const auto &items = tile->getItemList()) {
		uint32_t moveCount = 0;
		uint32_t removeCount = 0;
		int32_t downItemSize = tile->getDownItemCount();
		for (int32_t i = downItemSize; --i >= 0;) {
			const auto &item = items->at(i);
			if (item && item->hasProperty(CONST_PROP_MOVABLE) && (item->hasProperty(CONST_PROP_BLOCKPATH) || item->hasProperty(CONST_PROP_BLOCKSOLID)) && item->canBeMoved()) {
				if (moveCount < 20 && pushItem(item, nextDirection)) {
					++moveCount;
				} else if (!item->isCorpse() && g_game().internalRemoveItem(item) == RETURNVALUE_NOERROR) {
					++removeCount;
				}
			}
		}
		if (removeCount > 0) {
			g_game().addMagicEffect(tile->getPosition(), CONST_ME_POFF);
		}
	}
}

bool Monster::pushCreature(const std::shared_ptr<Creature> &creature) {
	static std::vector<Direction> dirList {
		DIRECTION_NORTH,
		DIRECTION_WEST, DIRECTION_EAST,
		DIRECTION_SOUTH
	};
	std::ranges::shuffle(dirList, getRandomGenerator());

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
	// We can not use iterators here since we can push a creature to another tile
	// which will invalidate the iterator.
	if (const CreatureVector* creatures = tile->getCreatures()) {
		uint32_t removeCount = 0;
		std::shared_ptr<Monster> lastPushedMonster = nullptr;

		for (size_t i = 0; i < creatures->size();) {
			const auto &monster = creatures->at(i)->getMonster();
			if (monster && monster->isPushable()) {
				if (monster != lastPushedMonster && Monster::pushCreature(monster)) {
					lastPushedMonster = monster;
					continue;
				}

				monster->changeHealth(-monster->getHealth());
				monster->setDropLoot(true);
				removeCount++;
			}

			++i;
		}

		if (removeCount > 0) {
			g_game().addMagicEffect(tile->getPosition(), CONST_ME_BLOCKHIT);
		}
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

	if (result && (canPushItems() || canPushCreatures())) {
		const Position &pos = getNextPosition(nextDirection, getPosition());
		const auto &posTile = g_game().map.getTile(pos);
		if (posTile) {
			if (canPushItems()) {
				Monster::pushItems(posTile, nextDirection);
			}

			if (canPushCreatures()) {
				if (g_dispatcher().context().getGroup() == TaskGroup::Walk) {
					Monster::pushCreatures(posTile);
				} else {
					g_dispatcher().addWalkEvent([=] {
						Monster::pushCreatures(posTile);
					});
				}
			}
		}
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
			} else if (mType->info.staticAttackChance < static_cast<uint32_t>(uniform_random(1, 100))) {
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
	std::ranges::shuffle(dirList, getRandomGenerator());

	for (const Direction &dir : dirList) {
		if (canWalkTo(creaturePos, dir)) {
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
	auto tryAddDirection = [&](Direction direction, int_fast32_t newX, int_fast32_t newY) {
		uint32_t tmpDist = std::max<uint32_t>(std::abs(newX - centerPos.getX()), std::abs(newY - centerPos.getY()));
		if (tmpDist == centerToDist && canWalkTo(creaturePos, direction)) {
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
		std::ranges::shuffle(dirList, getRandomGenerator());
		moveDirection = dirList[uniform_random(0, dirList.size() - 1)];
		return true;
	}
	return false;
}

bool Monster::getDistanceStep(const Position &targetPos, Direction &moveDirection, bool flee /* = false */) {
	const Position &creaturePos = getPosition();

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
	return mType->info.raceid;
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

bool Monster::canWalkTo(Position pos, Direction moveDirection) {
	pos = getNextPosition(moveDirection, pos);
	if (isInSpawnRange(pos)) {
		const auto &tile = g_game().map.getTile(pos);
		if (tile && tile->getTopVisibleCreature(getMonster()) == nullptr && tile->queryAdd(0, getMonster(), 1, FLAG_PATHFINDING | FLAG_IGNOREFIELDDAMAGE) == RETURNVALUE_NOERROR) {
			return true;
		}
	}
	return false;
}

void Monster::death(const std::shared_ptr<Creature> &) {
	if (monsterForgeClassification > ForgeClassifications_t::FORGE_NORMAL_MONSTER) {
		g_game().removeForgeMonster(getID(), monsterForgeClassification, true);
	}
	setAttackedCreature(nullptr);

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

	if (mType) {
		g_game().sendSingleSoundEffect(static_self_cast<Monster>()->getPosition(), mType->info.deathSound, getMonster());
	}

	setDead(true);
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
	if (!spawnMonster) {
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
			g_callbacks().executeCallback(EventCallback_t::monsterOnDropLoot, &EventCallback::monsterOnDropLoot, getMonster(), corpse);
			g_callbacks().executeCallback(EventCallback_t::monsterPostDropLoot, &EventCallback::monsterPostDropLoot, getMonster(), corpse);
		}
	}
}

void Monster::setNormalCreatureLight() {
	internalLight = mType->info.light;
}

void Monster::drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) {
	Creature::drainHealth(attacker, damage);

	if (damage > 0 && randomStepping) {
		ignoreFieldDamage = true;
	}

	if (isInvisible()) {
		removeCondition(CONDITION_INVISIBLE);
	}
}

void Monster::changeHealth(int32_t healthChange, bool sendHealthChange /* = true*/) {
	if (mType && !mType->info.soundVector.empty() && mType->info.soundChance >= static_cast<uint32_t>(uniform_random(1, 100))) {
		auto index = uniform_random(0, mType->info.soundVector.size() - 1);
		g_game().sendSingleSoundEffect(static_self_cast<Monster>()->getPosition(), mType->info.soundVector[index], getMonster());
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
			player->wheel()->healIfBattleHealingActive();
		}
	}
	return result;
}

bool Monster::changeTargetDistance(int32_t distance, uint32_t duration /* = 12000*/) {
	if (isSummon()) {
		return false;
	}

	if (mType->info.isRewardBoss) {
		return false;
	}

	bool shouldUpdate = mType->info.targetDistance > distance ? true : false;
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
	auto creatureIcons = Creature::getIcons();
	if (!creatureIcons.empty()) {
		return creatureIcons;
	}

	using enum CreatureIconModifications_t;
	if (challengeMeleeDuration > 0 && mType->info.targetDistance > targetDistance) {
		return { CreatureIcon(TurnedMelee) };
	} else if (varBuffs[BUFF_DAMAGERECEIVED] > 100) {
		return { CreatureIcon(HigherDamageReceived) };
	} else if (varBuffs[BUFF_DAMAGEDEALT] < 100) {
		return { CreatureIcon(LowerDamageDealt) };
	}
	return {};
}

bool Monster::isImmune(ConditionType_t conditionType) const {
	return m_isImmune || mType->info.m_conditionImmunities[static_cast<size_t>(conditionType)];
}

bool Monster::isImmune(CombatType_t combatType) const {
	return m_isImmune || mType->info.m_damageImmunities[combatTypeToIndex(combatType)];
}

void Monster::setImmune(bool immune) {
	m_isImmune = immune;
}

bool Monster::isImmune() const {
	return m_isImmune;
}

float Monster::getAttackMultiplier() const {
	float multiplier = mType->getAttackMultiplier();
	if (auto stacks = getForgeStack(); stacks > 0) {
		multiplier *= (1.35 + (stacks - 1) * 0.1);
	}
	return multiplier;
}

float Monster::getDefenseMultiplier() const {
	float multiplier = mType->getDefenseMultiplier();
	if (auto stacks = getForgeStack(); stacks > 0) {
		multiplier *= (1 + (0.1 * stacks));
	}
	return multiplier;
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

void Monster::configureForgeSystem() {
	if (!canBeForgeMonster()) {
		return;
	}

	if (monsterForgeClassification == ForgeClassifications_t::FORGE_FIENDISH_MONSTER) {
		setForgeStack(15);
		setIcon("forge", CreatureIcon(CreatureIconModifications_t::Fiendish, 0 /* don't show stacks on fiends */));
		g_game().updateCreatureIcon(static_self_cast<Monster>());
	} else if (monsterForgeClassification == ForgeClassifications_t::FORGE_INFLUENCED_MONSTER) {
		auto stack = static_cast<uint16_t>(normal_random(1, 5));
		setForgeStack(stack);
		setIcon("forge", CreatureIcon(CreatureIconModifications_t::Influenced, stack));
		g_game().updateCreatureIcon(static_self_cast<Monster>());
	}

	// Change health based in stacks
	const auto percentToIncrement = 1 + (15 * forgeStack + 35) / 100.f;
	auto newHealth = static_cast<int32_t>(std::ceil(static_cast<float>(healthMax) * percentToIncrement));

	healthMax = newHealth;
	health = newHealth;

	// Event to give Dusts
	const std::string &Eventname = "ForgeSystemMonster";
	registerCreatureEvent(Eventname);

	g_game().sendUpdateCreature(static_self_cast<Monster>());
}

bool Monster::canBeForgeMonster() const {
	return getForgeStack() == 0 && !isSummon() && !isRewardBoss() && canDropLoot() && isForgeCreature() && getRaceId() > 0;
}

bool Monster::isForgeCreature() const {
	return mType->info.isForgeCreature;
}

void Monster::setForgeMonster(bool forge) const {
	mType->info.isForgeCreature = forge;
}

uint16_t Monster::getForgeStack() const {
	return forgeStack;
}

void Monster::setForgeStack(uint16_t stack) {
	forgeStack = stack;
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
	return mType;
}

void Monster::clearFiendishStatus() {
	timeToChangeFiendish = 0;
	forgeStack = 0;
	monsterForgeClassification = ForgeClassifications_t::FORGE_NORMAL_MONSTER;

	health = mType->info.health * mType->getHealthMultiplier();
	healthMax = mType->info.healthMax * mType->getHealthMultiplier();

	removeIcon("forge");
	g_game().updateCreatureIcon(static_self_cast<Monster>());
	g_game().sendUpdateCreature(static_self_cast<Monster>());
}

bool Monster::canDropLoot() const {
	return !mType->info.lootItems.empty();
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

	if (hasAsyncTaskFlag(OnThink)) {
		onThink_async();
	}
}
