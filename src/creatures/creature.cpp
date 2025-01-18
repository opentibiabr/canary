/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/creature.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/grouping/party.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/zones/zone.hpp"
#include "lib/metrics/metrics.hpp"
#include "lua/creature/creatureevent.hpp"
#include "map/spectators.hpp"
#include "creatures/players/player.hpp"
#include "server/network/protocol/protocolgame.hpp"

Creature::Creature() {
	Creature::onIdleStatus();
}

Creature::~Creature() {
	for (const auto &summon : m_summons) {
		summon->setAttackedCreature(nullptr);
		summon->removeMaster();
	}
}

bool Creature::canSee(const Position &myPos, const Position &pos, int32_t viewRangeX, int32_t viewRangeY) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (myPos.z <= MAP_INIT_SURFACE_LAYER) {
		// we are on ground level or above (7 -> 0)
		// view is from 7 -> 0
		if (pos.z > MAP_INIT_SURFACE_LAYER) {
			return false;
		}
	} else if (myPos.z >= MAP_INIT_SURFACE_LAYER + 1) {
		// we are underground (8 -> 15)
		// view is +/- 2 from the floor we stand on
		if (Position::getDistanceZ(myPos, pos) > MAP_LAYER_VIEW_LIMIT) {
			return false;
		}
	}

	const int_fast32_t offsetz = myPos.getZ() - pos.getZ();
	return (pos.getX() >= myPos.getX() - viewRangeX + offsetz) && (pos.getX() <= myPos.getX() + viewRangeX + offsetz)
		&& (pos.getY() >= myPos.getY() - viewRangeY + offsetz) && (pos.getY() <= myPos.getY() + viewRangeY + offsetz);
}

bool Creature::canSee(const Position &pos) {
	return canSee(getPosition(), pos, MAP_MAX_VIEW_PORT_X, MAP_MAX_VIEW_PORT_Y);
}

bool Creature::canSeeCreature(const std::shared_ptr<Creature> &creature) const {
	if (!canSeeInvisibility() && creature->isInvisible()) {
		return false;
	}
	return true;
}

void Creature::setSkull(Skulls_t newSkull) {
	skull = newSkull;
	g_game().updateCreatureSkull(static_self_cast<Creature>());
}

int64_t Creature::getTimeSinceLastMove() const {
	return lastStep ? OTSYS_TIME() - lastStep : std::numeric_limits<int64_t>::max();
}

int32_t Creature::getWalkDelay(Direction dir) {
	if (lastStep == 0) {
		return 0;
	}

	const int64_t ct = OTSYS_TIME();
	uint16_t stepDuration = getStepDuration(dir);
	if (dir == DIRECTION_NONE) {
		stepDuration *= lastStepCost;
	}

	return stepDuration - (ct - lastStep);
}

int32_t Creature::getWalkSize() {
	auto ret = std::distance(listWalkDir.begin(), listWalkDir.end());
	return static_cast<int32_t>(ret);
}

void Creature::onThink(uint32_t interval) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);

	const auto &followCreature = getFollowCreature();
	const auto &master = getMaster();
	if (followCreature && master != followCreature && !canSeeCreature(followCreature)) {
		onCreatureDisappear(followCreature, false);
	}

	const auto &attackedCreature = getAttackedCreature();
	if (attackedCreature && master != attackedCreature && !canSeeCreature(attackedCreature)) {
		onCreatureDisappear(attackedCreature, false);
	}

	blockTicks += interval;
	if (blockTicks >= 1000) {
		blockCount = std::min<uint32_t>(blockCount + 1, 2);
		blockTicks = 0;
	}

	if (followCreature) {
		walkUpdateTicks += interval;
		if (forceUpdateFollowPath || walkUpdateTicks >= 2000) {
			walkUpdateTicks = 0;
			forceUpdateFollowPath = false;
			isUpdatingPath = true;
		}
	}

	auto onThink = [self = getCreature(), interval] {
		// scripting event - onThink
		const auto &thinkEvents = self->getCreatureEvents(CREATURE_EVENT_THINK);
		for (const auto &creatureEventPtr : thinkEvents) {
			creatureEventPtr->executeOnThink(self->static_self_cast<Creature>(), interval);
		}
	};

	if (isUpdatingPath) {
		isUpdatingPath = false;
		goToFollowCreature_async(onThink);
		return;
	}

	onThink();
}

void Creature::checkCreatureAttack(bool now) {
	if (now) {
		if (isAlive()) {
			onAttacking(0);
		}
		return;
	}

	g_dispatcher().addEvent([self = std::weak_ptr<Creature>(getCreature())] {
		if (const auto &creature = self.lock()) {
			creature->checkCreatureAttack(true);
		} }, "Creature::checkCreatureAttack");
}

void Creature::onAttacking(uint32_t interval) {
	const auto &attackedCreature = getAttackedCreature();
	if (!attackedCreature) {
		return;
	}

	if (attackedCreature->getType() == CreatureType_t::CREATURETYPE_PLAYER) {
		const auto &player = attackedCreature->getPlayer();
		if (player && player->isDisconnected() && !player->isProtected()) {
			player->setProtection(true);
			player->setLoginProtection(30000);
		}
	}

	onAttacked();
	attackedCreature->onAttacked();

	if (g_game().isSightClear(getPosition(), attackedCreature->getPosition(), true)) {
		doAttacking(interval);
	}
}

void Creature::onIdleStatus() {
	if (getHealth() > 0) {
		damageMap.clear();
		lastHitCreatureId = 0;
	}
}

void Creature::onCreatureWalk() {
	if (checkingWalkCreature || isRemoved() || isDead()) {
		return;
	}

	checkingWalkCreature = true;

	metrics::method_latency measure(__METRICS_METHOD_NAME__);

	g_dispatcher().addWalkEvent([self = std::weak_ptr<Creature>(getCreature()), this] {
		if (!self.lock()) {
			return;
		}

		checkingWalkCreature = false;
		if (isRemoved()) {
			return;
		}

		if (getWalkDelay() <= 0) {
			Direction dir;
			uint32_t flags = FLAG_IGNOREFIELDDAMAGE;
			if (getNextStep(dir, flags)) {
				ReturnValue ret = g_game().internalMoveCreature(static_self_cast<Creature>(), dir, flags);
				if (ret != RETURNVALUE_NOERROR) {
					if (std::shared_ptr<Player> player = getPlayer()) {
						player->sendCancelMessage(ret);
						player->sendCancelWalk();
					}

					forceUpdateFollowPath = true;
				}
			} else {
				if (listWalkDir.empty()) {
					onWalkComplete();
				}

				stopEventWalk();
			}
		}

		if (cancelNextWalk) {
			listWalkDir.clear();
			onWalkAborted();
			cancelNextWalk = false;
		}

		if (eventWalk != 0) {
			eventWalk = 0;
			addEventWalk();
		}
	});
}

void Creature::onWalk(Direction &dir) {
	if (hasCondition(CONDITION_DRUNK)) {
		uint32_t r = uniform_random(0, 60);
		if (r <= DIRECTION_DIAGONAL_MASK) {
			if (r < DIRECTION_DIAGONAL_MASK) {
				dir = static_cast<Direction>(r);
			}
			g_game().internalCreatureSay(static_self_cast<Creature>(), TALKTYPE_MONSTER_SAY, "Hicks!", false);
		}
	}
}

bool Creature::getNextStep(Direction &dir, uint32_t &) {
	if (listWalkDir.empty()) {
		return false;
	}

	dir = listWalkDir.back();
	listWalkDir.pop_back();
	onWalk(dir);
	return true;
}

void Creature::startAutoWalk(const std::vector<Direction> &listDir, bool ignoreConditions /* = false*/) {
	listWalkDir.clear();

	if (!ignoreConditions && (hasCondition(CONDITION_ROOTED) || hasCondition(CONDITION_FEARED))) {
		return;
	}

	listWalkDir = { listDir.begin(), listDir.end() };

	if (listWalkDir.empty()) {
		return;
	}

	addEventWalk(listWalkDir.size() == 1);
}

void Creature::addEventWalk(bool firstStep) {
	cancelNextWalk = false;

	if (getStepSpeed() <= 0) {
		return;
	}

	if (eventWalk != 0) {
		return;
	}

	const int64_t ticks = getEventStepTicks(firstStep);
	if (ticks <= 0) {
		return;
	}

	safeCall([this, ticks]() {
		// Take first step right away, but still queue the next
		if (ticks == 1) {
			onCreatureWalk();
		}

		eventWalk = g_dispatcher().scheduleEvent(
			static_cast<uint32_t>(ticks), [self = std::weak_ptr<Creature>(getCreature())] {
				if (const auto &creature = self.lock()) {
					creature->onCreatureWalk();
				}
			},
			"Game::checkCreatureWalk"
		);
	});
}

void Creature::stopEventWalk() {
	if (eventWalk != 0) {
		g_dispatcher().stopEvent(eventWalk);
		eventWalk = 0;
	}
}

void Creature::onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (creature.get() == this) {
		if (isLogin) {
			setLastPosition(getPosition());
		}
	}
}

void Creature::onRemoveCreature(const std::shared_ptr<Creature> &creature, bool) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	onCreatureDisappear(creature, true);

	// Update player from monster target list (avoid memory usage after clean)
	if (const auto &monster = getMonster(); monster && monster->getAttackedCreature() == creature) {
		monster->setAttackedCreature(creature);
		monster->setFollowCreature(creature);
	}
}

void Creature::onCreatureDisappear(const std::shared_ptr<Creature> &creature, bool isLogout) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (getAttackedCreature() == creature) {
		setAttackedCreature(nullptr);
		onAttackedCreatureDisappear(isLogout);
	}

	if (getFollowCreature() == creature) {
		setFollowCreature(nullptr);
		onFollowCreatureDisappear(isLogout);
	}
}

void Creature::onChangeZone(ZoneType_t zone) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	const auto &attackedCreature = getAttackedCreature();
	if (attackedCreature && zone == ZONE_PROTECTION) {
		onCreatureDisappear(attackedCreature, false);
	}
}

void Creature::onAttackedCreatureChangeZone(ZoneType_t zone) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (zone == ZONE_PROTECTION) {
		const auto &attackedCreature = getAttackedCreature();
		if (attackedCreature) {
			onCreatureDisappear(attackedCreature, false);
		}
	}
}

void Creature::checkSummonMove(const Position &newPos, bool teleportSummon) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (hasSummons()) {
		std::vector<std::shared_ptr<Creature>> despawnMonsterList;
		for (const auto &summon : getSummons()) {
			if (!summon) {
				continue;
			}

			const auto &pos = summon->getPosition();
			const auto &monster = summon->getMonster();
			const auto &tile = getTile();
			bool protectionZoneCheck = tile ? tile->hasFlag(TILESTATE_PROTECTIONZONE) : false;
			// Check if any of our summons is out of range (+/- 0 floors or 15 tiles away)
			bool checkSummonDist = Position::getDistanceZ(newPos, pos) > 0 || (std::max<int32_t>(Position::getDistanceX(newPos, pos), Position::getDistanceY(newPos, pos)) > 15);
			// Check if any of our summons is out of range (+/- 2 floors or 30 tiles away)
			bool checkRemoveDist = Position::getDistanceZ(newPos, pos) > 2 || (std::max<int32_t>(Position::getDistanceX(newPos, pos), Position::getDistanceY(newPos, pos)) > 30);

			if ((monster && monster->isFamiliar() && checkSummonDist) || (teleportSummon && !protectionZoneCheck && checkSummonDist)) {
				const auto &creatureMaster = summon->getMaster();
				if (!creatureMaster) {
					continue;
				}

				if (const auto &masterTile = creatureMaster->getTile()) {
					if (masterTile->hasFlag(TILESTATE_TELEPORT)) {
						g_logger().warn("[{}] cannot teleport summon, position has teleport. {}", __FUNCTION__, creatureMaster->getPosition().toString());
					} else {
						g_game().internalTeleport(summon, creatureMaster->getPosition(), true);
						continue;
					}
				}
			}

			if (monster && monster->isSummon() && !monster->isFamiliar() && !teleportSummon && checkRemoveDist) {
				despawnMonsterList.push_back(summon);
			}
		}

		for (const auto &despawnCreature : despawnMonsterList) {
			if (!despawnMonsterList.empty()) {
				g_game().removeCreature(despawnCreature, true);
			}
		}
	}
}

void Creature::onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (creature.get() == this) {
		lastStep = OTSYS_TIME();
		lastStepCost = 1;

		if (!teleport) {
			if (oldPos.z != newPos.z) {
				lastStepCost = WALK_FLOOR_CHANGE_EXTRA_COST;
			} else if (Position::getDistanceX(newPos, oldPos) >= 1 && Position::getDistanceY(newPos, oldPos) >= 1) {
				lastStepCost = WALK_DIAGONAL_EXTRA_COST;
			}
		} else {
			stopEventWalk();
		}

		bool configTeleportSummons = g_configManager().getBoolean(TELEPORT_SUMMONS);
		checkSummonMove(newPos, configTeleportSummons);
		if (isLostSummon()) {
			handleLostSummon(configTeleportSummons);
		}

		if (const auto &player = creature->getPlayer()) {
			if (player->isExerciseTraining()) {
				player->setTraining(false);
			}
		}

		if (newTile->getZoneType() != oldTile->getZoneType()) {
			onChangeZone(getZoneType());
		}
	}

	const auto &followCreature = getFollowCreature();
	if (followCreature && (creature.get() == this || creature == followCreature)) {
		if (hasFollowPath) {
			isUpdatingPath = true;
			updateCreatureWalk();
		}

		if (newPos.z != oldPos.z || !canSee(followCreature->getPosition())) {
			onCreatureDisappear(followCreature, false);
		}
	}

	const auto &attackedCreature = getAttackedCreature();
	if (attackedCreature && (creature == attackedCreature || creature.get() == this)) {
		if (newPos.z != oldPos.z || !canSee(attackedCreature->getPosition())) {
			onCreatureDisappear(attackedCreature, false);
		} else {
			if (hasExtraSwing()) {
				// our target is moving lets see if we can get in hit
				checkCreatureAttack();
			}

			if (newTile->getZoneType() != oldTile->getZoneType()) {
				onAttackedCreatureChangeZone(attackedCreature->getZoneType());
			}
		}
	}
}

void Creature::onDeath() {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	bool lastHitUnjustified = false;
	bool mostDamageUnjustified = false;
	const auto &lastHitCreature = g_game().getCreatureByID(lastHitCreatureId);
	std::shared_ptr<Creature> lastHitCreatureMaster;
	if (lastHitCreature && getPlayer()) {
		/**
		 * @deprecated -- This is here to trigger the deprecated onKill events in lua
		 */
		lastHitCreature->deprecatedOnKilledCreature(getCreature(), true);
		lastHitUnjustified = lastHitCreature->onKilledPlayer(getPlayer(), true);
		lastHitCreatureMaster = lastHitCreature->getMaster();
	} else {
		lastHitCreatureMaster = nullptr;
	}

	std::shared_ptr<Creature> mostDamageCreature = nullptr;

	const int64_t timeNow = OTSYS_TIME();
	const uint32_t inFightTicks = g_configManager().getNumber(PZ_LOCKED);
	int32_t mostDamage = 0;
	std::map<std::shared_ptr<Creature>, uint64_t> experienceMap;
	std::unordered_set<std::shared_ptr<Player>> killers;
	for (const auto &[creatureId, damageInfo] : damageMap) {
		if (creatureId == 0) {
			continue;
		}

		if (auto attacker = g_game().getCreatureByID(creatureId)) {
			const auto &[total, ticks] = damageInfo;
			if (total == 0 || ticks == 0) {
				continue;
			}

			if (total > mostDamage && timeNow - ticks <= inFightTicks) {
				mostDamage = total;
				mostDamageCreature = attacker;
			}

			if (attacker != getCreature()) {
				const uint64_t gainExp = getGainedExperience(attacker);
				const auto &attackerMaster = attacker->getMaster() ? attacker->getMaster() : attacker;
				if (auto attackerPlayer = attackerMaster->getPlayer()) {
					attackerPlayer->removeAttacked(getPlayer());

					const auto &party = attackerPlayer->getParty();
					killers.insert(attackerPlayer);
					if (party && party->getLeader() && party->isSharedExperienceActive() && party->isSharedExperienceEnabled()) {
						attacker = party->getLeader();
						killers.insert(party->getLeader());
						mostDamageCreature = attacker;

						for (const auto &partyMember : party->getMembers()) {
							killers.insert(partyMember);
						}
					}
				}

				auto tmpIt = experienceMap.find(attacker);
				if (tmpIt == experienceMap.end()) {
					experienceMap[attacker] = gainExp;
				} else {
					tmpIt->second += gainExp;
				}
			}
		}
	}

	for (const auto &[creature, experience] : experienceMap) {
		creature->onGainExperience(experience, getCreature());
	}

	mostDamageCreature = mostDamageCreature && mostDamageCreature->getMaster() ? mostDamageCreature->getMaster() : mostDamageCreature;
	for (const auto &killer : killers) {
		if (const auto &monster = getMonster()) {
			killer->onKilledMonster(monster);
		} else if (const auto &player = getPlayer(); player && mostDamageCreature != killer) {
			killer->onKilledPlayer(player, false);
		}
	}

	/**
	 * @deprecated -- This is here to trigger the deprecated onKill events in lua
	 */
	const auto &mostDamageCreatureMaster = mostDamageCreature ? mostDamageCreature->getMaster() : nullptr;
	if (mostDamageCreature && (mostDamageCreature != lastHitCreature || getMonster()) && mostDamageCreature != lastHitCreatureMaster) {
		if (lastHitCreature != mostDamageCreatureMaster && (lastHitCreatureMaster == nullptr || mostDamageCreatureMaster != lastHitCreatureMaster)) {
			mostDamageUnjustified = mostDamageCreature->deprecatedOnKilledCreature(getCreature(), false);
		}
	}

	bool killedByPlayer = (mostDamageCreature && mostDamageCreature->getPlayer()) || (mostDamageCreatureMaster && mostDamageCreatureMaster->getPlayer());
	if (getPlayer()) {
		g_metrics().addCounter(
			"player_death",
			1,
			{
				{ "name", getNameDescription() },
				{ "level", std::to_string(getPlayer()->getLevel()) },
				{ "most_damage_creature", mostDamageCreature ? mostDamageCreature->getName() : "(none)" },
				{ "last_hit_creature", lastHitCreature ? lastHitCreature->getName() : "(none)" },
				{ "most_damage_dealt", std::to_string(mostDamage) },
				{ "most_damage_creature_master", mostDamageCreatureMaster ? mostDamageCreatureMaster->getName() : "(none)" },
				{ "most_damage_unjustified", std::to_string(mostDamageUnjustified) },
				{ "last_hit_unjustified", std::to_string(lastHitUnjustified) },
				{ "by_player", std::to_string(killedByPlayer) },
			}
		);
	} else {
		std::string killerName = mostDamageCreature ? mostDamageCreature->getName() : "(none)";
		if (mostDamageCreatureMaster) {
			killerName = mostDamageCreatureMaster->getName();
		}
		g_metrics().addCounter(
			"monster_death",
			1,
			{
				{ "name", getName() },
				{ "killer", killerName },
				{ "is_summon", std::to_string(getMaster() ? true : false) },
				{ "by_player", std::to_string(killedByPlayer) },
			}
		);
	}

	bool droppedCorpse = dropCorpse(lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
	death(lastHitCreature);

	if (droppedCorpse && !getPlayer()) {
		g_game().removeCreature(static_self_cast<Creature>(), false);
	}

	if (getMaster()) {
		removeMaster();
	}
}

bool Creature::dropCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (!lootDrop && getMonster()) {
		if (getMaster()) {
			// Scripting event onDeath
			const CreatureEventList &deathEvents = getCreatureEvents(CREATURE_EVENT_DEATH);
			for (const auto &deathEventPtr : deathEvents) {
				deathEventPtr->executeOnDeath(static_self_cast<Creature>(), nullptr, lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
			}
		}

		g_game().addMagicEffect(getPosition(), CONST_ME_POFF);
	} else {
		std::shared_ptr<Item> splash;
		switch (getRace()) {
			case RACE_VENOM:
				splash = Item::CreateItem(ITEM_FULLSPLASH, FLUID_SLIME);
				break;

			case RACE_BLOOD:
				splash = Item::CreateItem(ITEM_FULLSPLASH, FLUID_BLOOD);
				break;

			case RACE_INK:
				splash = Item::CreateItem(ITEM_FULLSPLASH, FLUID_INK);
				break;

			default:
				splash = nullptr;
				break;
		}

		const auto &tile = getTile();
		if (tile && splash) {
			g_game().internalAddItem(tile, splash, INDEX_WHEREEVER, FLAG_NOLIMIT);
			splash->startDecaying();
		}

		const auto &corpse = getCorpse(lastHitCreature, mostDamageCreature);
		if (tile && corpse) {
			g_game().internalAddItem(tile, corpse, INDEX_WHEREEVER, FLAG_NOLIMIT);
			dropLoot(corpse->getContainer(), lastHitCreature);
			corpse->startDecaying();
			const bool disallowedCorpses = corpse->isRewardCorpse() || (corpse->getID() == ITEM_MALE_CORPSE || corpse->getID() == ITEM_FEMALE_CORPSE);
			const auto &player = mostDamageCreature ? mostDamageCreature->getPlayer() : nullptr;
			const auto &corpseContainer = corpse->getContainer();
			if (corpseContainer && player && !disallowedCorpses) {
				const auto &monster = getMonster();
				if (monster && !monster->isRewardBoss()) {
					std::ostringstream lootMessage;
					auto collorMessage = player->getProtocolVersion() > 1200;
					lootMessage << "Loot of " << getNameDescription() << ": " << corpseContainer->getContentDescription(collorMessage) << ".";
					auto suffix = corpseContainer->getAttribute<std::string>(ItemAttribute_t::LOOTMESSAGE_SUFFIX);
					if (!suffix.empty()) {
						lootMessage << suffix;
					}
					player->sendLootMessage(lootMessage.str());
				}

				FindPathParams fpp;
				fpp.minTargetDist = 0;
				fpp.maxTargetDist = 1;
				fpp.fullPathSearch = true;
				fpp.clearSight = true;
				fpp.maxSearchDist = 0;

				std::vector<Direction> dirList;
				auto isReachable = g_game().map.getPathMatching(player->getPosition(), dirList, FrozenPathingConditionCall(corpse->getPosition()), fpp);

				if (player->checkAutoLoot(monster->isRewardBoss()) && isReachable) {
					g_dispatcher().addEvent([player, corpseContainer, corpsePosition = corpse->getPosition()] {
						g_game().playerQuickLootCorpse(player, corpseContainer, corpsePosition);
					},
					                        "Game::playerQuickLootCorpse");
				}
			}
		}

		// Scripting event onDeath
		for (const auto &deathEventPtr : getCreatureEvents(CREATURE_EVENT_DEATH)) {
			if (deathEventPtr) {
				deathEventPtr->executeOnDeath(static_self_cast<Creature>(), corpse, lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
			}
		}
	}

	return true;
}

bool Creature::hasBeenAttacked(uint32_t attackerId) {
	auto it = damageMap.find(attackerId);
	if (it == damageMap.end()) {
		return false;
	}
	return (OTSYS_TIME() - it->second.ticks) <= g_configManager().getNumber(PZ_LOCKED);
}

std::shared_ptr<Item> Creature::getCorpse(const std::shared_ptr<Creature> &, const std::shared_ptr<Creature> &) {
	if (getLookCorpse() != 0) {
		return Item::CreateItem(getLookCorpse());
	}
	return nullptr;
}

void Creature::changeHealth(int32_t healthChange, bool sendHealthChange /* = true*/) {
	if (isLifeless()) {
		return;
	}

	int32_t oldHealth = health;

	if (healthChange > 0) {
		health += std::min<int32_t>(healthChange, getMaxHealth() - health);
	} else {
		health = std::max<int32_t>(0, health + healthChange);
	}

	if (sendHealthChange && oldHealth != health) {
		g_game().addCreatureHealth(static_self_cast<Creature>());
	}
	if (health <= 0) {
		g_dispatcher().addEvent([self = std::weak_ptr<Creature>(getCreature())] {
			if (const auto &creature = self.lock()) {
				if (!creature->isRemoved()) {
					g_game().afterCreatureZoneChange(creature, creature->getZones(), {});
					creature->onDeath();
				}
			} }, "Game::executeDeath");
	}
}

void Creature::changeMana(int32_t manaChange) {
	if (manaChange > 0) {
		mana += std::min<int32_t>(manaChange, getMaxMana() - mana);
	} else {
		mana = std::max<int32_t>(0, mana + manaChange);
	}
}

void Creature::gainHealth(const std::shared_ptr<Creature> &healer, int32_t healthGain) {
	changeHealth(healthGain);
	if (healer) {
		healer->onTargetCreatureGainHealth(static_self_cast<Creature>(), healthGain);
	}
}

void Creature::drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) {
	changeHealth(-damage, false);

	if (attacker) {
		attacker->onAttackedCreatureDrainHealth(static_self_cast<Creature>(), damage);
	}
}

void Creature::drainMana(const std::shared_ptr<Creature> &attacker, int32_t manaLoss) {
	onAttacked();
	changeMana(-manaLoss);

	if (attacker) {
		addDamagePoints(attacker, manaLoss);
	}
}

// Wheel of destiny - mitigation system for creature
void Creature::mitigateDamage(const CombatType_t &combatType, BlockType_t &blockType, int32_t &damage) const {
	if (combatType != COMBAT_MANADRAIN && combatType != COMBAT_LIFEDRAIN && combatType != COMBAT_AGONYDAMAGE) { // Increase mitigate damage
		auto originalDamage = damage;
		damage -= (damage * getMitigation()) / 100.;
		g_logger().trace("[mitigation] creature: {}, original damage: {}, mitigation damage: {}", getName(), originalDamage, damage);

		if (damage <= 0) {
			damage = 0;
			blockType = BLOCK_ARMOR;
		}
	}
}

void Creature::applyAbsorbDamageModifications(const std::shared_ptr<Creature> &attacker, int32_t &damage, CombatType_t combatType) const {
	if (combatType != COMBAT_HEALING && damage != 0) {
		int32_t value = getAbsorbPercent(combatType);
		if (value != 0) {
			damage -= std::round(damage * value / 100.f);
		}
		value = getAbsorbFlat(combatType);
		if (value != 0) {
			damage = std::max(0, damage + value);
		}

		if (attacker) {
			value = attacker->getIncreasePercent(combatType);
			if (value != 0) {
				damage += std::round(damage * value / 100.f);
			}
		}
	}
}

BlockType_t Creature::blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense /* = false */, bool checkArmor /* = false */, bool /* field  = false */) {
	BlockType_t blockType = BLOCK_NONE;

	// Apply skills 12.72 absorbs damage
	applyAbsorbDamageModifications(attacker, damage, combatType);

	if (getMonster() && g_configManager().getBoolean(DISABLE_MONSTER_ARMOR)) {
		checkDefense = false;
		checkArmor = false;
	}

	if (isImmune(combatType)) {
		damage = 0;
		blockType = BLOCK_IMMUNITY;
	} else if (checkDefense || checkArmor) {
		bool hasDefense = false;

		if (blockCount > 0) {
			--blockCount;
			hasDefense = true;
		}

		if (checkDefense && hasDefense && canUseDefense) {
			int32_t defense = getDefense();
			damage -= uniform_random(defense / 2, defense);
			if (damage <= 0) {
				damage = 0;
				blockType = BLOCK_DEFENSE;
				checkArmor = false;
			}
		}

		if (checkArmor) {
			int32_t armor = getArmor();
			if (armor > 3) {
				damage -= uniform_random(armor / 2, armor - (armor % 2 + 1));
			} else if (armor > 0) {
				--damage;
			}

			if (damage <= 0) {
				damage = 0;
				blockType = BLOCK_ARMOR;
			}
		}

		if (hasDefense && blockType != BLOCK_NONE) {
			onBlockHit();
		}
	}

	if (attacker) {
		attacker->onAttackedCreature(static_self_cast<Creature>());
		attacker->onAttackedCreatureBlockHit(blockType);
	}

	if (damage != 0) {
		mitigateDamage(combatType, blockType, damage);
	}

	if (damage != 0) {
		onTakeDamage(attacker, damage);
	}
	onAttacked();
	return blockType;
}

bool Creature::setAttackedCreature(const std::shared_ptr<Creature> &creature) {
	if (creature) {
		const auto &monster = getMonster();
		const auto &tile = getTile();
		if (monster && monster->isFamiliar() && tile && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
			return false;
		}

		const Position &creaturePos = creature->getPosition();
		if (creaturePos.z != getPosition().z || !canSee(creaturePos)) {
			m_attackedCreature.reset();
			return false;
		}

		m_attackedCreature = creature;
		onAttackedCreature(creature);
		creature->onAttacked();
	} else {
		m_attackedCreature.reset();
	}

	for (const auto &summon : m_summons) {
		summon->setAttackedCreature(creature);
	}
	return true;
}

void Creature::getPathSearchParams(const std::shared_ptr<Creature> &, FindPathParams &fpp) {
	fpp.fullPathSearch = !hasFollowPath;
	fpp.clearSight = true;
	fpp.maxSearchDist = 12;
	fpp.minTargetDist = 1;
	fpp.maxTargetDist = 1;
}

void Creature::goToFollowCreature_async(std::function<void()> &&onComplete) {
	if (isDead()) {
		return;
	}

	if (!hasAsyncTaskFlag(Pathfinder) && onComplete) {
		g_dispatcher().addEvent(std::move(onComplete), "goToFollowCreature_async");
	}

	setAsyncTaskFlag(Pathfinder, true);
}

void Creature::goToFollowCreature() {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	const auto &followCreature = getFollowCreature();
	if (!followCreature) {
		return;
	}

	const auto &monster = getMonster();

	if (isSummon() && !monster->isFamiliar() && !canFollowMaster()) {
		listWalkDir.clear();
		return;
	}

	bool executeOnFollow = true;
	std::vector<Direction> listDir;
	listDir.reserve(128);

	FindPathParams fpp;
	getPathSearchParams(followCreature, fpp);

	if (monster && !monster->getMaster() && (monster->isFleeing() || fpp.maxTargetDist > 1)) {
		Direction dir = DIRECTION_NONE;

		if (monster->isFleeing()) {
			monster->getDistanceStep(followCreature->getPosition(), dir, true);
		} else if (!monster->getDistanceStep(followCreature->getPosition(), dir)) { // maxTargetDist > 1
			// if we can't get anything then let the A* calculate
			executeOnFollow = false;
		} else if (dir != DIRECTION_NONE) {
			listDir.push_back(dir);
			hasFollowPath = true;
		}
	}

	if (listDir.empty()) {
		hasFollowPath = getPathTo(followCreature->getPosition(), listDir, fpp);
	}

	startAutoWalk(listDir);

	if (executeOnFollow) {
		onFollowCreatureComplete(followCreature);
	}
}

bool Creature::canFollowMaster() const {
	const auto &master = getMaster();
	if (!master) {
		return false;
	}
	const auto &tile = master->getTile();
	return tile && !tile->hasFlag(TILESTATE_PROTECTIONZONE) && (canSeeInvisibility() || !master->isInvisible());
}

bool Creature::setFollowCreature(const std::shared_ptr<Creature> &creature) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (creature) {
		if (getFollowCreature() == creature) {
			return true;
		}

		if (hasCondition(CONDITION_FEARED)) {
			m_followCreature.reset();
			return false;
		}

		const Position &creaturePos = creature->getPosition();
		if (creaturePos.z != getPosition().z || !canSee(creaturePos)) {
			m_followCreature.reset();
			return false;
		}

		if (!listWalkDir.empty()) {
			listWalkDir.clear();
			onWalkAborted();
		}

		hasFollowPath = true;
		forceUpdateFollowPath = false;
		m_followCreature = creature;
		isUpdatingPath = true;
	} else {
		isUpdatingPath = false;
		m_followCreature.reset();
	}

	onFollowCreature(creature);
	return true;
}

double Creature::getDamageRatio(const std::shared_ptr<Creature> &attacker) const {
	uint32_t totalDamage = 0;
	uint32_t attackerDamage = 0;

	for (const auto &[attackerId, damageInfo] : damageMap) {
		const auto &[totalDamageValue, ticks] = damageInfo;
		if (attackerId == 0 || totalDamageValue == 0) {
			continue;
		}

		totalDamage += totalDamageValue;
		if (attackerId == attacker->getID()) {
			attackerDamage += totalDamageValue;
		}
	}

	if (totalDamage == 0) {
		return 0;
	}

	return (static_cast<double>(attackerDamage) / totalDamage);
}

uint64_t Creature::getGainedExperience(const std::shared_ptr<Creature> &attacker) const {
	return std::floor(getDamageRatio(attacker) * getLostExperience());
}

void Creature::addDamagePoints(const std::shared_ptr<Creature> &attacker, int32_t damagePoints) {
	if (damagePoints <= 0) {
		return;
	}

	uint32_t attackerId = attacker->id;

	auto it = damageMap.find(attackerId);
	if (it == damageMap.end()) {
		CountBlock_t cb {};
		cb.ticks = OTSYS_TIME();
		cb.total = damagePoints;
		damageMap[attackerId] = cb;
	} else {
		it->second.total += damagePoints;
		it->second.ticks = OTSYS_TIME();
	}

	lastHitCreatureId = attackerId;
}

void Creature::onAddCondition(ConditionType_t type) {
	if (type == CONDITION_PARALYZE && hasCondition(CONDITION_HASTE)) {
		removeCondition(CONDITION_HASTE);
	} else if (type == CONDITION_HASTE && hasCondition(CONDITION_PARALYZE)) {
		removeCondition(CONDITION_PARALYZE);
	}
}

void Creature::onAddCombatCondition(ConditionType_t) {
	//
}

void Creature::onEndCondition(ConditionType_t) {
	//
}

void Creature::onTickCondition(ConditionType_t type, bool &bRemove) {
	const auto &tile = getTile();
	const auto &field = tile ? tile->getFieldItem() : nullptr;
	if (!field) {
		return;
	}

	switch (type) {
		case CONDITION_FIRE:
			bRemove = (field->getCombatType() != COMBAT_FIREDAMAGE);
			break;
		case CONDITION_ENERGY:
			bRemove = (field->getCombatType() != COMBAT_ENERGYDAMAGE);
			break;
		case CONDITION_POISON:
			bRemove = (field->getCombatType() != COMBAT_EARTHDAMAGE);
			break;
		case CONDITION_FREEZING:
			bRemove = (field->getCombatType() != COMBAT_ICEDAMAGE);
			break;
		case CONDITION_DAZZLED:
			bRemove = (field->getCombatType() != COMBAT_HOLYDAMAGE);
			break;
		case CONDITION_CURSED:
			bRemove = (field->getCombatType() != COMBAT_DEATHDAMAGE);
			break;
		case CONDITION_DROWN:
			bRemove = (field->getCombatType() != COMBAT_DROWNDAMAGE);
			break;
		case CONDITION_BLEEDING:
			bRemove = (field->getCombatType() != COMBAT_PHYSICALDAMAGE);
			break;
		default:
			break;
	}
}

void Creature::onCombatRemoveCondition(const std::shared_ptr<Condition> &condition) {
	removeCondition(condition);
}

void Creature::onAttacked() {
	//
}

void Creature::onAttackedCreatureDrainHealth(const std::shared_ptr<Creature> &target, int32_t points) {
	target->addDamagePoints(static_self_cast<Creature>(), points);
}

void Creature::onAttackedCreatureKilled(const std::shared_ptr<Creature> &target) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (target != getCreature()) {
		uint64_t gainExp = target->getGainedExperience(static_self_cast<Creature>());
		onGainExperience(gainExp, target);
	}
}

bool Creature::deprecatedOnKilledCreature(const std::shared_ptr<Creature> &target, bool lastHit) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	const auto &master = getMaster();
	if (master) {
		master->deprecatedOnKilledCreature(target, lastHit);
	}

	// scripting event - onKill
	const CreatureEventList &killEvents = getCreatureEvents(CREATURE_EVENT_KILL);
	for (const auto &killEventPtr : killEvents) {
		killEventPtr->executeOnKill(static_self_cast<Creature>(), target, lastHit);
	}
	return false;
}

void Creature::onGainExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	const auto &master = getMaster();
	if (gainExp == 0 || !master) {
		return;
	}

	const auto &m = getMonster();
	if (!m->isFamiliar()) {
		gainExp /= 2;
	}

	master->onGainExperience(gainExp, target);

	if (!m->isFamiliar()) {
		auto spectators = Spectators().find<Player>(position);
		if (spectators.empty()) {
			return;
		}

		TextMessage message(MESSAGE_EXPERIENCE_OTHERS, fmt::format("{} gained {} experience point{}.", ucfirst(getNameDescription()), gainExp, (gainExp != 1 ? "s" : "")));
		message.position = position;
		message.primary.color = TEXTCOLOR_WHITE_EXP;
		message.primary.value = gainExp;

		for (const auto &spectator : spectators) {
			spectator->getPlayer()->sendTextMessage(message);
		}
	}
}

bool Creature::setMaster(const std::shared_ptr<Creature> &newMaster, bool reloadCreature /* = false*/) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	// Persists if this creature has ever been a summon
	this->summoned = true;
	const auto &oldMaster = getMaster();

	if (!newMaster && !oldMaster) {
		return false;
	}
	const auto &self = getCreature();

	// Reloading summon icon/knownCreature and reset informations (follow/dropLoot/skillLoss)
	if (reloadCreature) {
		setFollowCreature(nullptr);
		setDropLoot(false);
		setSkillLoss(false);
		g_game().reloadCreature(self);
	}
	if (newMaster) {
		newMaster->m_summons.emplace_back(self);
	}

	m_master = newMaster;

	if (oldMaster) {
		auto it = std::ranges::find(oldMaster->m_summons, self);
		if (it != oldMaster->m_summons.end()) {
			oldMaster->m_summons.erase(it);
		}
	}
	return true;
}

bool Creature::addCondition(const std::shared_ptr<Condition> &condition, bool attackerPlayer /* = false*/) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (condition == nullptr) {
		return false;
	}
	if (isSuppress(condition->getType(), attackerPlayer)) {
		return false;
	}
	const auto &prevCond = getCondition(condition->getType(), condition->getId(), condition->getSubId());
	if (prevCond) {
		prevCond->addCondition(getCreature(), condition);
		return true;
	}

	if (condition->startCondition(getCreature())) {
		conditions.emplace_back(condition);
		onAddCondition(condition->getType());
		return true;
	}

	return false;
}

bool Creature::addCombatCondition(const std::shared_ptr<Condition> &condition, bool attackerPlayer /* = false*/) {
	if (condition == nullptr) {
		return false;
	}

	ConditionType_t type = condition->getType();

	if (!addCondition(condition, attackerPlayer)) {
		return false;
	}

	onAddCombatCondition(type);
	return true;
}

void Creature::removeCondition(ConditionType_t type) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	auto it = conditions.begin(), end = conditions.end();
	while (it != end) {
		std::shared_ptr<Condition> condition = *it;
		if (condition->getType() != type) {
			++it;
			continue;
		}

		it = conditions.erase(it);

		condition->endCondition(getCreature());

		onEndCondition(type);
	}
}

void Creature::removeCondition(ConditionType_t conditionType, ConditionId_t conditionId, bool force /* = false*/) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	auto it = conditions.begin();
	const auto end = conditions.end();
	while (it != end) {
		auto condition = *it;
		if (condition->getType() != conditionType || condition->getId() != conditionId) {
			++it;
			continue;
		}

		if (!force && conditionType == CONDITION_PARALYZE) {
			int32_t walkDelay = getWalkDelay();
			if (walkDelay > 0) {
				g_dispatcher().scheduleEvent(
					walkDelay, [creatureId = getID(), conditionType, conditionId] { g_game().forceRemoveCondition(creatureId, conditionType, conditionId); }, "Game::forceRemoveCondition"
				);
				return;
			}
		}

		it = conditions.erase(it);

		condition->endCondition(getCreature());

		onEndCondition(conditionType);
	}
}

void Creature::removeCombatCondition(ConditionType_t type) {
	std::vector<std::shared_ptr<Condition>> removeConditions;
	for (const auto &condition : conditions) {
		if (condition->getType() == type) {
			removeConditions.emplace_back(condition);
		}
	}

	for (const auto &condition : removeConditions) {
		onCombatRemoveCondition(condition);
	}
}

void Creature::removeCondition(const std::shared_ptr<Condition> &condition) {
	const auto it = std::ranges::find(conditions, condition);
	if (it == conditions.end()) {
		return;
	}

	conditions.erase(it);

	condition->endCondition(getCreature());
	onEndCondition(condition->getType());
}

std::shared_ptr<Condition> Creature::getCondition(ConditionType_t type) const {
	for (const auto &condition : conditions) {
		if (condition->getType() == type) {
			return condition;
		}
	}
	return nullptr;
}

std::shared_ptr<Condition> Creature::getCondition(ConditionType_t type, ConditionId_t conditionId, uint32_t subId /* = 0*/) const {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	for (const auto &condition : conditions) {
		if (condition->getType() == type && condition->getId() == conditionId && condition->getSubId() == subId) {
			return condition;
		}
	}
	return nullptr;
}

std::vector<std::shared_ptr<Condition>> Creature::getConditionsByType(ConditionType_t type) const {
	std::vector<std::shared_ptr<Condition>> conditionsVec;
	for (const auto &condition : conditions) {
		if (condition->getType() == type) {
			conditionsVec.emplace_back(condition);
		}
	}
	return conditionsVec;
}

void Creature::executeConditions(uint32_t interval) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	auto it = conditions.begin(), end = conditions.end();
	while (it != end) {
		std::shared_ptr<Condition> condition = *it;
		if (!condition->executeCondition(getCreature(), interval)) {
			ConditionType_t type = condition->getType();

			it = conditions.erase(it);

			condition->endCondition(getCreature());

			onEndCondition(type);
		} else {
			++it;
		}
	}
}

bool Creature::hasCondition(ConditionType_t type, uint32_t subId /* = 0*/) const {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (isSuppress(type, false)) {
		return false;
	}

	int64_t timeNow = OTSYS_TIME();
	for (const auto &condition : conditions) {
		if (condition->getType() != type || condition->getSubId() != subId) {
			continue;
		}

		if (condition->getEndTime() >= timeNow || condition->getTicks() == -1) {
			return true;
		}
	}
	return false;
}

uint16_t Creature::getStepDuration(Direction dir) {
	if (isRemoved()) {
		return 0;
	}

	if (walk.needRecache()) {
		auto duration = std::floor(1000 * walk.groundSpeed / walk.calculatedStepSpeed);
		walk.duration = static_cast<uint16_t>(std::ceil(duration / SERVER_BEAT) * SERVER_BEAT);
	}

	auto duration = walk.duration;
	if ((dir & DIRECTION_DIAGONAL_MASK) != 0) {
		duration *= WALK_DIAGONAL_EXTRA_COST;
	} else if (const auto &monster = getMonster()) {
		if (monster->isTargetNearby() && !monster->isFleeing() && !monster->getMaster()) {
			duration *= WALK_TARGET_NEARBY_EXTRA_COST;
		}
	}

	return duration;
}

int64_t Creature::getEventStepTicks(bool onlyDelay) {
	int64_t ret = getWalkDelay();
	if (ret <= 0) {
		const uint16_t stepDuration = getStepDuration();
		ret = onlyDelay && stepDuration > 0 ? 1 : stepDuration * lastStepCost;
	}

	return ret;
}

LightInfo Creature::getCreatureLight() const {
	return internalLight;
}

uint16_t Creature::getSpeed() const {
	return std::clamp(baseSpeed + varSpeed, 0, static_cast<int>(std::numeric_limits<uint16_t>::max()));
}

void Creature::setSpeed(int32_t varSpeedDelta) {
	// Prevents creatures from not exceeding the maximum allowed speed
	if (getSpeed() >= PLAYER_MAX_SPEED) {
		return;
	}

	int32_t oldSpeed = getSpeed();
	varSpeed = varSpeedDelta;

	if (getSpeed() <= 0) {
		stopEventWalk();
		cancelNextWalk = true;
	} else if (oldSpeed <= 0 && !listWalkDir.empty()) {
		addEventWalk();
	}

	updateCalculatedStepSpeed();
}

void Creature::setCreatureLight(LightInfo lightInfo) {
	internalLight = lightInfo;
}

void Creature::setNormalCreatureLight() {
	internalLight = {};
}

bool Creature::registerCreatureEvent(const std::string &name) {
	const auto &event = g_creatureEvents().getEventByName(name);
	if (!event) {
		return false;
	}

	CreatureEventType_t type = event->getEventType();
	if (hasEventRegistered(type)) {
		for (const auto &creatureEventPtr : eventsList) {
			if (creatureEventPtr == event) {
				return false;
			}
		}
	} else {
		scriptEventsBitField |= static_cast<uint32_t>(1) << type;
	}

	eventsList.emplace_back(event);
	return true;
}

bool Creature::unregisterCreatureEvent(const std::string &name) {
	const auto &event = g_creatureEvents().getEventByName(name);
	if (!event) {
		return false;
	}

	CreatureEventType_t type = event->getEventType();
	if (!hasEventRegistered(type)) {
		return false;
	}

	bool resetTypeBit = true;

	auto it = eventsList.begin(), end = eventsList.end();
	while (it != end) {
		const auto curEvent = *it;
		if (curEvent == event) {
			it = eventsList.erase(it);
			continue;
		}

		if (curEvent->getEventType() == type) {
			resetTypeBit = false;
		}
		++it;
	}

	if (resetTypeBit) {
		scriptEventsBitField &= ~(static_cast<uint32_t>(1) << type);
	}
	return true;
}

std::shared_ptr<Cylinder> Creature::getParent() {
	return getTile();
}

void Creature::setParent(std::weak_ptr<Cylinder> cylinder) {
	const auto oldGroundSpeed = walk.groundSpeed;
	walk.groundSpeed = 150;

	if (const auto &lockedCylinder = cylinder.lock()) {
		const auto &newParent = lockedCylinder->getTile();
		position = newParent->getPosition();
		m_tile = newParent;

		if (newParent->getGround()) {
			const auto &it = Item::items[newParent->getGround()->getID()];
			if (it.speed > 0) {
				walk.groundSpeed = it.speed;
			}
		}
	}

	if (walk.groundSpeed != oldGroundSpeed) {
		walk.recache();
	}
}

// creature script events
bool Creature::hasEventRegistered(CreatureEventType_t event) const {
	return (0 != (scriptEventsBitField & (static_cast<uint32_t>(1) << event)));
}

CreatureEventList Creature::getCreatureEvents(CreatureEventType_t type) const {
	CreatureEventList tmpEventList;

	if (!hasEventRegistered(type)) {
		return tmpEventList;
	}

	for (const auto &creatureEventPtr : eventsList) {
		if (creatureEventPtr->getEventType() == type) {
			tmpEventList.emplace_back(creatureEventPtr);
		}
	}

	return tmpEventList;
}

bool FrozenPathingConditionCall::isInRange(const Position &startPos, const Position &testPos, const FindPathParams &fpp) const {
	if (fpp.fullPathSearch) {
		if (testPos.x > targetPos.x + fpp.maxTargetDist) {
			return false;
		}

		if (testPos.x < targetPos.x - fpp.maxTargetDist) {
			return false;
		}

		if (testPos.y > targetPos.y + fpp.maxTargetDist) {
			return false;
		}

		if (testPos.y < targetPos.y - fpp.maxTargetDist) {
			return false;
		}
	} else {
		int_fast32_t dx = Position::getOffsetX(startPos, targetPos);

		int32_t dxMax = (dx >= 0 ? fpp.maxTargetDist : 0);
		if (testPos.x > targetPos.x + dxMax) {
			return false;
		}

		int32_t dxMin = (dx <= 0 ? fpp.maxTargetDist : 0);
		if (testPos.x < targetPos.x - dxMin) {
			return false;
		}

		int_fast32_t dy = Position::getOffsetY(startPos, targetPos);

		int32_t dyMax = (dy >= 0 ? fpp.maxTargetDist : 0);
		if (testPos.y > targetPos.y + dyMax) {
			return false;
		}

		int32_t dyMin = (dy <= 0 ? fpp.maxTargetDist : 0);
		if (testPos.y < targetPos.y - dyMin) {
			return false;
		}
	}
	return true;
}
bool FrozenPathingConditionCall::operator()(const Position &startPos, const Position &testPos, const FindPathParams &fpp, int32_t &bestMatchDist) const {
	if (!isInRange(startPos, testPos, fpp)) {
		return false;
	}

	if (fpp.clearSight && !g_game().isSightClear(testPos, targetPos, true)) {
		return false;
	}

	int32_t testDist = std::max<int32_t>(Position::getDistanceX(targetPos, testPos), Position::getDistanceY(targetPos, testPos));
	if (fpp.maxTargetDist == 1) {
		if (testDist < fpp.minTargetDist || testDist > fpp.maxTargetDist) {
			return false;
		}
		return true;
	} else if (testDist <= fpp.maxTargetDist) {
		if (testDist < fpp.minTargetDist) {
			return false;
		}
		if (testDist == fpp.maxTargetDist) {
			bestMatchDist = 0;
			return true;
		} else if (testDist > bestMatchDist) { // not quite what we want, but the best so far
			bestMatchDist = testDist;
			return true;
		}
	}
	return false;
}

bool Creature::isInvisible() const {
	return std::ranges::find_if(conditions, [](const std::shared_ptr<Condition> &condition) {
			   return condition->getType() == CONDITION_INVISIBLE;
		   })
		!= conditions.end();
}

ZoneType_t Creature::getZoneType() {
	if (getTile()) {
		return getTile()->getZoneType();
	}

	return ZONE_NORMAL;
}

bool Creature::getPathTo(const Position &targetPos, std::vector<Direction> &dirList, const FindPathParams &fpp) {
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	if (fpp.maxSearchDist != 0 || fpp.keepDistance) {
		return g_game().map.getPathMatchingCond(getCreature(), targetPos, dirList, FrozenPathingConditionCall(targetPos), fpp);
	}
	return g_game().map.getPathMatching(getCreature(), targetPos, dirList, FrozenPathingConditionCall(targetPos), fpp);
}

bool Creature::getPathTo(const Position &targetPos, std::vector<Direction> &dirList, int32_t minTargetDist, int32_t maxTargetDist, bool fullPathSearch /*= true*/, bool clearSight /*= true*/, int32_t maxSearchDist /*= 7*/) {
	FindPathParams fpp;
	fpp.fullPathSearch = fullPathSearch;
	fpp.maxSearchDist = maxSearchDist;
	fpp.clearSight = clearSight;
	fpp.minTargetDist = minTargetDist;
	fpp.maxTargetDist = maxTargetDist;
	return getPathTo(targetPos, dirList, fpp);
}

void Creature::turnToCreature(const std::shared_ptr<Creature> &creature) {
	const Position &creaturePos = creature->getPosition();
	const auto dx = Position::getOffsetX(position, creaturePos);
	const auto dy = Position::getOffsetY(position, creaturePos);

	float tan;
	if (dx != 0) {
		tan = static_cast<float>(dy) / dx;
	} else {
		tan = 10;
	}

	Direction dir;
	if (std::abs(tan) < 1) {
		if (dx > 0) {
			dir = DIRECTION_WEST;
		} else {
			dir = DIRECTION_EAST;
		}
	} else {
		if (dy > 0) {
			dir = DIRECTION_NORTH;
		} else {
			dir = DIRECTION_SOUTH;
		}
	}
	g_game().internalCreatureTurn(static_self_cast<Creature>(), dir);
}

bool Creature::isLostSummon() {
	if (!isSummon()) {
		return false;
	}
	const Position &masterPosition = getMaster()->getPosition();
	return std::max<int32_t>(Position::getDistanceX(getPosition(), masterPosition), Position::getDistanceY(getPosition(), masterPosition)) > 30;
}

void Creature::handleLostSummon(bool teleportSummons) {
	if (teleportSummons) {
		g_game().internalTeleport(static_self_cast<Creature>(), getMaster()->getPosition(), true);
	} else {
		g_game().removeCreature(static_self_cast<Creature>(), true);
	}
	g_game().addMagicEffect(getPosition(), CONST_ME_POFF);
}

double_t Creature::getReflectPercent(CombatType_t combatType, bool useCharges /*= false*/) const {
	try {
		return reflectPercent.at(combatTypeToIndex(combatType));
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in getReflectPercent: {}", e.what());
	}
	return 0;
}

void Creature::setReflectPercent(CombatType_t combatType, int32_t value) {
	try {
		reflectPercent.at(combatTypeToIndex(combatType)) = std::max(0, reflectPercent.at(combatTypeToIndex(combatType)) + value);
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in setReflectPercent: {}", e.what());
	}
}

int32_t Creature::getReflectFlat(CombatType_t combatType, bool useCharges /* = false*/) const {
	try {
		return reflectFlat.at(combatTypeToIndex(combatType));
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in getReflectFlat: {}", e.what());
	}
	return 0;
}

void Creature::setReflectFlat(CombatType_t combatType, int32_t value) {
	try {
		reflectFlat.at(combatTypeToIndex(combatType)) = std::max(0, reflectFlat.at(combatTypeToIndex(combatType)) + value);
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in setReflectFlat: {}", e.what());
	}
}

int32_t Creature::getAbsorbFlat(CombatType_t combat) const {
	try {
		return absorbFlat.at(combatTypeToIndex(combat));
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in getAbsorbFlat: {}", e.what());
	}
	return 0;
}

void Creature::setAbsorbFlat(CombatType_t combat, int32_t value) {
	try {
		absorbFlat.at(combatTypeToIndex(combat)) += value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in setAbsorbFlat: {}", e.what());
	}
}

int32_t Creature::getAbsorbPercent(CombatType_t combat) const {
	try {
		return absorbPercent.at(combatTypeToIndex(combat));
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in getAbsorbPercent: {}", e.what());
	}
	return 0;
}

void Creature::setAbsorbPercent(CombatType_t combat, int32_t value) {
	try {
		absorbPercent.at(combatTypeToIndex(combat)) += value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in setAbsorbPercent: {}", e.what());
	}
}

int32_t Creature::getIncreasePercent(CombatType_t combat) const {
	try {
		return increasePercent.at(combatTypeToIndex(combat));
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in getIncreasePercent: {}", e.what());
	}
	return 0;
}

void Creature::setIncreasePercent(CombatType_t combat, int32_t value) {
	try {
		increasePercent.at(combatTypeToIndex(combat)) += value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index is out of range in setIncreasePercent: {}", e.what());
	}
}

std::unordered_set<std::shared_ptr<Zone>> Creature::getZones() {
	if (const auto &tile = getTile()) {
		return tile->getZones();
	}
	return {};
}

void Creature::iconChanged() {
	const auto &tile = getTile();
	if (!tile) {
		return;
	}

	for (const auto &spectator : Spectators().find<Player>(tile->getPosition(), true)) {
		spectator->getPlayer()->sendCreatureIcon(getCreature());
	}
}

void Creature::sendAsyncTasks() {
	if (hasAsyncTaskFlag(AsyncTaskRunning)) {
		return;
	}

	setAsyncTaskFlag(AsyncTaskRunning, true);
	g_dispatcher().asyncEvent([self = std::weak_ptr<Creature>(getCreature())] {
		if (const auto &creature = self.lock()) {
			if (!creature->isRemoved() && creature->isAlive()) {
				for (const auto &task : creature->asyncTasks) {
					task();
				}

				if (creature->hasAsyncTaskFlag(Pathfinder)) {
					creature->goToFollowCreature();
				}

				creature->onExecuteAsyncTasks();
			}

			creature->asyncTasks.clear();
			creature->m_flagAsyncTask = 0;
		}
	},
	                          TaskGroup::WalkParallel);
}

void Creature::safeCall(std::function<void(void)> &&action) const {
	if (g_dispatcher().context().isAsync()) {
		g_dispatcher().addEvent([weak_self = std::weak_ptr<const Creature>(static_self_cast<Creature>()), action = std::move(action)] {
			if (const auto self = weak_self.lock()) {
				if (!self->isInternalRemoved) {
					action();
				}
			}
		},
		                        g_dispatcher().context().getName());
	} else if (!isInternalRemoved) {
		action();
	}
}
