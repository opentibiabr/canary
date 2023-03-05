/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/creature.h"
#include "declarations.hpp"
#include "game/game.h"
#include "creatures/monsters/monster.h"
#include "game/scheduling/scheduler.h"

double Creature::speedA = 857.36;
double Creature::speedB = 261.29;
double Creature::speedC = -4795.01;

Creature::Creature() {
	onIdleStatus();
}

Creature::~Creature() {
	for (Creature* summon : summons) {
		summon->setAttackedCreature(nullptr);
		summon->removeMaster();
	}

	for (Condition* condition : conditions) {
		condition->endCondition(this);
		delete condition;
	}
}

bool Creature::canSee(const Position &myPos, const Position &pos, int32_t viewRangeX, int32_t viewRangeY) {
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

bool Creature::canSee(const Position &pos) const {
	return canSee(getPosition(), pos, Map::maxViewportX, Map::maxViewportY);
}

bool Creature::canSeeCreature(const Creature* creature) const {
	if (!canSeeInvisibility() && creature->isInvisible()) {
		return false;
	}
	return true;
}

void Creature::setSkull(Skulls_t newSkull) {
	skull = newSkull;
	g_game().updateCreatureSkull(this);
}

int64_t Creature::getTimeSinceLastMove() const {
	if (lastStep) {
		return OTSYS_TIME() - lastStep;
	}
	return std::numeric_limits<int64_t>::max();
}

int32_t Creature::getWalkDelay(Direction dir) const {
	if (lastStep == 0) {
		return 0;
	}

	int64_t ct = OTSYS_TIME();
	int64_t stepDuration = getStepDuration(dir);
	return stepDuration - (ct - lastStep);
}

int32_t Creature::getWalkDelay() const {
	// Used for auto-walking
	if (lastStep == 0) {
		return 0;
	}

	int64_t ct = OTSYS_TIME();
	int64_t stepDuration = getStepDuration() * lastStepCost;
	return stepDuration - (ct - lastStep);
}

void Creature::onThink(uint32_t interval) {
	if (!isMapLoaded && useCacheMap()) {
		isMapLoaded = true;
		updateMapCache();
	}

	if (followCreature && master != followCreature && !canSeeCreature(followCreature)) {
		onCreatureDisappear(followCreature, false);
	}

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

	if (isUpdatingPath) {
		isUpdatingPath = false;
		goToFollowCreature();
	}

	// scripting event - onThink
	const CreatureEventList &thinkEvents = getCreatureEvents(CREATURE_EVENT_THINK);
	for (CreatureEvent* thinkEvent : thinkEvents) {
		thinkEvent->executeOnThink(this, interval);
	}
}

void Creature::onAttacking(uint32_t interval) {
	if (!attackedCreature) {
		return;
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
	if (getWalkDelay() <= 0) {
		Direction dir;
		uint32_t flags = FLAG_IGNOREFIELDDAMAGE;
		if (getNextStep(dir, flags)) {
			ReturnValue ret = g_game().internalMoveCreature(this, dir, flags);
			if (ret != RETURNVALUE_NOERROR) {
				if (Player* player = getPlayer()) {
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
}

void Creature::onWalk(Direction &dir) {
	if (hasCondition(CONDITION_DRUNK)) {
		uint32_t r = uniform_random(0, 20);
		if (r <= DIRECTION_DIAGONAL_MASK) {
			if (r < DIRECTION_DIAGONAL_MASK) {
				dir = static_cast<Direction>(r);
			}
			g_game().internalCreatureSay(this, TALKTYPE_MONSTER_SAY, "Hicks!", false);
		}
	}
}

bool Creature::getNextStep(Direction &dir, uint32_t &) {
	if (listWalkDir.empty()) {
		return false;
	}

	dir = listWalkDir.front();
	listWalkDir.pop_front();
	onWalk(dir);
	return true;
}

void Creature::startAutoWalk(const std::forward_list<Direction> &listDir) {
	if (hasCondition(CONDITION_ROOTED)) {
		return;
	}

	listWalkDir = listDir;

	size_t size = 0;
	for (auto it = listDir.begin(); it != listDir.end() && size <= 1; ++it) {
		size++;
	}
	addEventWalk(size == 1);
}

void Creature::addEventWalk(bool firstStep) {
	cancelNextWalk = false;

	if (getStepSpeed() <= 0) {
		return;
	}

	if (eventWalk != 0) {
		return;
	}

	int64_t ticks = getEventStepTicks(firstStep);
	if (ticks <= 0) {
		return;
	}

	// Take first step right away, but still queue the next
	if (ticks == 1) {
		g_game().checkCreatureWalk(getID());
	}

	eventWalk = g_scheduler().addEvent(createSchedulerTask(static_cast<uint32_t>(ticks), std::bind(&Game::checkCreatureWalk, &g_game(), getID())));
}

void Creature::stopEventWalk() {
	if (eventWalk != 0) {
		g_scheduler().stopEvent(eventWalk);
		eventWalk = 0;
	}
}

void Creature::updateMapCache() {
	Tile* newTile;
	const Position &myPos = getPosition();
	Position pos(0, 0, myPos.z);

	for (int32_t y = -maxWalkCacheHeight; y <= maxWalkCacheHeight; ++y) {
		for (int32_t x = -maxWalkCacheWidth; x <= maxWalkCacheWidth; ++x) {
			pos.x = myPos.getX() + x;
			pos.y = myPos.getY() + y;
			newTile = g_game().map.getTile(pos);
			updateTileCache(newTile, pos);
		}
	}
}

void Creature::updateTileCache(const Tile* newTile, int32_t dx, int32_t dy) {
	if (std::abs(dx) <= maxWalkCacheWidth && std::abs(dy) <= maxWalkCacheHeight) {
		localMapCache[maxWalkCacheHeight + dy][maxWalkCacheWidth + dx] = newTile && newTile->queryAdd(0, *this, 1, FLAG_PATHFINDING | FLAG_IGNOREFIELDDAMAGE) == RETURNVALUE_NOERROR;
	}
}

void Creature::updateTileCache(const Tile* upTile, const Position &pos) {
	const Position &myPos = getPosition();
	if (pos.z == myPos.z) {
		int32_t dx = Position::getOffsetX(pos, myPos);
		int32_t dy = Position::getOffsetY(pos, myPos);
		updateTileCache(upTile, dx, dy);
	}
}

int32_t Creature::getWalkCache(const Position &pos) const {
	if (!useCacheMap()) {
		return 2;
	}

	const Position &myPos = getPosition();
	if (myPos.z != pos.z) {
		return 0;
	}

	if (pos == myPos) {
		return 1;
	}

	int32_t dx = Position::getOffsetX(pos, myPos);
	if (std::abs(dx) <= maxWalkCacheWidth) {
		int32_t dy = Position::getOffsetY(pos, myPos);
		if (std::abs(dy) <= maxWalkCacheHeight) {
			if (localMapCache[maxWalkCacheHeight + dy][maxWalkCacheWidth + dx]) {
				return 1;
			} else {
				return 0;
			}
		}
	}

	// out of range
	return 2;
}

void Creature::onAddTileItem(const Tile* tileItem, const Position &pos) {
	if (isMapLoaded && pos.z == getPosition().z) {
		updateTileCache(tileItem, pos);
	}
}

void Creature::onUpdateTileItem(const Tile* updateTile, const Position &pos, const Item*, const ItemType &oldType, const Item*, const ItemType &newType) {
	if (!isMapLoaded) {
		return;
	}

	if (oldType.blockSolid || oldType.blockPathFind || newType.blockPathFind || newType.blockSolid) {
		if (pos.z == getPosition().z) {
			updateTileCache(updateTile, pos);
		}
	}
}

void Creature::onRemoveTileItem(const Tile* updateTile, const Position &pos, const ItemType &iType, const Item*) {
	if (!isMapLoaded) {
		return;
	}

	if (iType.blockSolid || iType.blockPathFind || iType.isGroundTile()) {
		if (pos.z == getPosition().z) {
			updateTileCache(updateTile, pos);
		}
	}
}

void Creature::onCreatureAppear(Creature* creature, bool isLogin) {
	if (creature == this) {
		if (useCacheMap()) {
			isMapLoaded = true;
			updateMapCache();
		}

		if (isLogin) {
			setLastPosition(getPosition());
		}
	} else if (isMapLoaded) {
		if (creature->getPosition().z == getPosition().z) {
			updateTileCache(creature->getTile(), creature->getPosition());
		}
	}
}

void Creature::onRemoveCreature(Creature* creature, bool) {
	onCreatureDisappear(creature, true);
	if (creature != this && isMapLoaded) {
		if (creature->getPosition().z == getPosition().z) {
			updateTileCache(creature->getTile(), creature->getPosition());
		}
	}

	// Update player from monster target list (avoid memory usage after clean)
	if (auto monster = getMonster(); monster && monster->getAttackedCreature() == creature) {
		monster->setAttackedCreature(creature);
		monster->setFollowCreature(creature);
	}
}

void Creature::onCreatureDisappear(const Creature* creature, bool isLogout) {
	if (attackedCreature == creature) {
		setAttackedCreature(nullptr);
		onAttackedCreatureDisappear(isLogout);
	}

	if (followCreature == creature) {
		setFollowCreature(nullptr);
		onFollowCreatureDisappear(isLogout);
	}
}

void Creature::onChangeZone(ZoneType_t zone) {
	if (attackedCreature && zone == ZONE_PROTECTION) {
		onCreatureDisappear(attackedCreature, false);
	}
}

void Creature::onAttackedCreatureChangeZone(ZoneType_t zone) {
	if (zone == ZONE_PROTECTION) {
		onCreatureDisappear(attackedCreature, false);
	}
}

void Creature::checkSummonMove(const Position &newPos, bool teleportSummon) const {
	if (hasSummons()) {
		std::vector<Creature*> despawnMonsterList;
		for (Creature* creature : getSummons()) {
			if (!creature) {
				continue;
			}

			const Position &pos = creature->getPosition();
			const Monster* monster = creature->getMonster();
			bool protectionZoneCheck = this->getTile()->hasFlag(TILESTATE_PROTECTIONZONE);
			// Check if any of our summons is out of range (+/- 0 floors or 15 tiles away)
			bool checkSummonDist = Position::getDistanceZ(newPos, pos) > 0 || (std::max<int32_t>(Position::getDistanceX(newPos, pos), Position::getDistanceY(newPos, pos)) > 15);
			// Check if any of our summons is out of range (+/- 2 floors or 30 tiles away)
			bool checkRemoveDist = Position::getDistanceZ(newPos, pos) > 2 || (std::max<int32_t>(Position::getDistanceX(newPos, pos), Position::getDistanceY(newPos, pos)) > 30);

			if (monster->isFamiliar() && checkSummonDist || teleportSummon && !protectionZoneCheck && checkSummonDist) {
				g_game().internalTeleport(creature, creature->getMaster()->getPosition(), true);
				continue;
			}

			if (monster->isSummon() && !monster->isFamiliar() && !teleportSummon && checkRemoveDist) {
				despawnMonsterList.push_back(creature);
			}
		}

		for (Creature* despawnCreature : despawnMonsterList) {
			if (!despawnMonsterList.empty()) {
				g_game().removeCreature(despawnCreature, true);
			}
		}
	}
}

void Creature::onCreatureMove(Creature* creature, const Tile* newTile, const Position &newPos, const Tile* oldTile, const Position &oldPos, bool teleport) {
	if (creature == this) {
		lastStep = OTSYS_TIME();
		lastStepCost = 1;

		if (!teleport) {
			if (oldPos.z != newPos.z) {
				// floor change extra cost
				lastStepCost = 2;
			} else if (Position::getDistanceX(newPos, oldPos) >= 1 && Position::getDistanceY(newPos, oldPos) >= 1) {
				// diagonal extra cost
				lastStepCost = 3;
			}
		} else {
			stopEventWalk();
		}

		bool configTeleportSummons = g_configManager().getBoolean(TELEPORT_SUMMONS);
		checkSummonMove(newPos, configTeleportSummons);
		if (isLostSummon()) {
			handleLostSummon(configTeleportSummons);
		}

		if (Player* player = creature->getPlayer()) {
			if (player->isExerciseTraining()) {
				player->setTraining(false);
			}
		}

		if (newTile->getZone() != oldTile->getZone()) {
			onChangeZone(getZone());
		}

		// update map cache
		if (isMapLoaded) {
			if (teleport || oldPos.z != newPos.z) {
				updateMapCache();
			} else {
				const Position &myPos = getPosition();

				if (oldPos.y > newPos.y) { // north
					// shift y south
					for (int32_t y = mapWalkHeight - 1; --y >= 0;) {
						memcpy(localMapCache[y + 1], localMapCache[y], sizeof(localMapCache[y]));
					}

					// update 0
					for (int32_t x = -maxWalkCacheWidth; x <= maxWalkCacheWidth; ++x) {
						const Tile* cacheTile = g_game().map.getTile(static_cast<uint16_t>(myPos.getX() + x), static_cast<uint16_t>(myPos.getY() - maxWalkCacheHeight), myPos.z);
						updateTileCache(cacheTile, x, -maxWalkCacheHeight);
					}
				} else if (oldPos.y < newPos.y) { // south
					// shift y north
					for (int32_t y = 0; y <= mapWalkHeight - 2; ++y) {
						memcpy(localMapCache[y], localMapCache[y + 1], sizeof(localMapCache[y]));
					}

					// update mapWalkHeight - 1
					for (int32_t x = -maxWalkCacheWidth; x <= maxWalkCacheWidth; ++x) {
						const Tile* cacheTile = g_game().map.getTile(static_cast<uint16_t>(myPos.getX() + x), static_cast<uint16_t>(myPos.getY() + maxWalkCacheHeight), myPos.z);
						updateTileCache(cacheTile, x, maxWalkCacheHeight);
					}
				}

				if (oldPos.x < newPos.x) { // east
					// shift y west
					int32_t starty = 0;
					int32_t endy = mapWalkHeight - 1;
					int32_t dy = Position::getDistanceY(oldPos, newPos);

					if (dy < 0) {
						endy += dy;
					} else if (dy > 0) {
						starty = dy;
					}

					for (int32_t y = starty; y <= endy; ++y) {
						for (int32_t x = 0; x <= mapWalkWidth - 2; ++x) {
							localMapCache[y][x] = localMapCache[y][x + 1];
						}
					}

					// update mapWalkWidth - 1
					for (int32_t y = -maxWalkCacheHeight; y <= maxWalkCacheHeight; ++y) {
						const Tile* cacheTile = g_game().map.getTile(myPos.x + maxWalkCacheWidth, static_cast<uint16_t>(myPos.y + y), myPos.z);
						updateTileCache(cacheTile, maxWalkCacheWidth, y);
					}
				} else if (oldPos.x > newPos.x) { // west
					// shift y east
					int32_t starty = 0;
					int32_t endy = mapWalkHeight - 1;
					int32_t dy = Position::getDistanceY(oldPos, newPos);

					if (dy < 0) {
						endy += dy;
					} else if (dy > 0) {
						starty = dy;
					}

					for (int32_t y = starty; y <= endy; ++y) {
						for (int32_t x = mapWalkWidth - 1; --x >= 0;) {
							localMapCache[y][x + 1] = localMapCache[y][x];
						}
					}

					// update 0
					for (int32_t y = -maxWalkCacheHeight; y <= maxWalkCacheHeight; ++y) {
						const Tile* cacheTile = g_game().map.getTile(myPos.x - maxWalkCacheWidth, static_cast<uint16_t>(myPos.y + y), myPos.z);
						updateTileCache(cacheTile, -maxWalkCacheWidth, y);
					}
				}

				updateTileCache(oldTile, oldPos);
			}
		}
	} else {
		if (isMapLoaded) {
			const Position &myPos = getPosition();

			if (newPos.z == myPos.z) {
				updateTileCache(newTile, newPos);
			}

			if (oldPos.z == myPos.z) {
				updateTileCache(oldTile, oldPos);
			}
		}
	}

	if (followCreature && (creature == this || creature == followCreature)) {
		if (hasFollowPath) {
			isUpdatingPath = true;
			g_dispatcher().addTask(createTask(std::bind(&Game::updateCreatureWalk, &g_game(), getID())));
		}

		if (newPos.z != oldPos.z || !canSee(followCreature->getPosition())) {
			onCreatureDisappear(followCreature, false);
		}
	}

	if (creature == attackedCreature || (creature == this && attackedCreature)) {
		if (newPos.z != oldPos.z || !canSee(attackedCreature->getPosition())) {
			onCreatureDisappear(attackedCreature, false);
		} else {
			if (hasExtraSwing()) {
				// our target is moving lets see if we can get in hit
				g_dispatcher().addTask(createTask(std::bind(&Game::checkCreatureAttack, &g_game(), getID())));
			}

			if (newTile->getZone() != oldTile->getZone()) {
				onAttackedCreatureChangeZone(attackedCreature->getZone());
			}
		}
	}
}

void Creature::onDeath() {
	bool lastHitUnjustified = false;
	bool mostDamageUnjustified = false;
	Creature* lastHitCreature = g_game().getCreatureByID(lastHitCreatureId);
	Creature* lastHitCreatureMaster;
	if (lastHitCreature) {
		lastHitUnjustified = lastHitCreature->onKilledCreature(this, true);
		lastHitCreatureMaster = lastHitCreature->getMaster();
	} else {
		lastHitCreatureMaster = nullptr;
	}

	Creature* mostDamageCreature = nullptr;

	const int64_t timeNow = OTSYS_TIME();
	const uint32_t inFightTicks = g_configManager().getNumber(PZ_LOCKED);
	int32_t mostDamage = 0;
	std::map<Creature*, uint64_t> experienceMap;
	for (const auto &it : damageMap) {
		if (Creature* attacker = g_game().getCreatureByID(it.first)) {
			CountBlock_t cb = it.second;
			if ((cb.total > mostDamage && (timeNow - cb.ticks <= inFightTicks))) {
				mostDamage = cb.total;
				mostDamageCreature = attacker;
			}

			if (attacker != this) {
				uint64_t gainExp = getGainedExperience(attacker);
				if (Player* attackerPlayer = attacker->getPlayer()) {
					attackerPlayer->removeAttacked(getPlayer());

					Party* party = attackerPlayer->getParty();
					if (party && party->getLeader() && party->isSharedExperienceActive() && party->isSharedExperienceEnabled()) {
						attacker = party->getLeader();
						mostDamageCreature = attacker;
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

	for (const auto &it : experienceMap) {
		it.first->onGainExperience(it.second, this);
	}

	if (mostDamageCreature) {
		if (mostDamageCreature != lastHitCreature && mostDamageCreature != lastHitCreatureMaster) {
			Creature* mostDamageCreatureMaster = mostDamageCreature->getMaster();
			if (lastHitCreature != mostDamageCreatureMaster && (lastHitCreatureMaster == nullptr || mostDamageCreatureMaster != lastHitCreatureMaster)) {
				mostDamageUnjustified = mostDamageCreature->onKilledCreature(this, false);
			}
		}
	}

	bool droppedCorpse = dropCorpse(lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
	death(lastHitCreature);

	if (droppedCorpse && !getPlayer()) {
		g_game().removeCreature(this, false);
	}

	if (master) {
		removeMaster();
	}
}

bool Creature::dropCorpse(Creature* lastHitCreature, Creature* mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified) {
	if (!lootDrop && getMonster()) {
		if (master) {
			// Scripting event onDeath
			const CreatureEventList &deathEvents = getCreatureEvents(CREATURE_EVENT_DEATH);
			for (CreatureEvent* deathEvent : deathEvents) {
				deathEvent->executeOnDeath(this, nullptr, lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
			}
		}

		g_game().addMagicEffect(getPosition(), CONST_ME_POFF);
	} else {
		Item* splash;
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

		Tile* tile = getTile();
		if (tile && splash) {
			g_game().internalAddItem(tile, splash, INDEX_WHEREEVER, FLAG_NOLIMIT);
			splash->startDecaying();
		}

		Item* corpse = getCorpse(lastHitCreature, mostDamageCreature);
		if (tile && corpse) {
			g_game().internalAddItem(tile, corpse, INDEX_WHEREEVER, FLAG_NOLIMIT);
			dropLoot(corpse->getContainer(), lastHitCreature);
			corpse->startDecaying();
			bool corpses = corpse->isRewardCorpse() || (corpse->getID() == ITEM_MALE_CORPSE || corpse->getID() == ITEM_FEMALE_CORPSE);
			if (mostDamageCreature && mostDamageCreature->getPlayer() && !corpses) {
				Player* player = mostDamageCreature->getPlayer();
				if (g_configManager().getBoolean(AUTOBANK)) {
					if (!corpse->getContainer()) {
						return true;
					}

					int32_t money = 0;
					for (Item* item : corpse->getContainer()->getItems()) {
						if (uint32_t worth = item->getWorth(); worth > 0) {
							money += worth;
							g_game().internalRemoveItem(item);
						}
					}

					if (money > 0) {
						player->setBankBalance(player->getBankBalance() + money);
						std::ostringstream ss;
						ss << "Added " << money << " gold coins to your bank account.";
						player->sendTextMessage(MESSAGE_STATUS, ss.str());
					}
				}

				if (g_configManager().getBoolean(AUTOLOOT)) {
					int32_t pos = tile->getStackposOfItem(player, corpse);
					g_dispatcher().addTask(createTask(std::bind(&Game::playerQuickLoot, &g_game(), mostDamageCreature->getID(), this->getPosition(), corpse->getID(), pos - 1, nullptr, false, true)));
				}
			}
		}

		// Scripting event onDeath
		for (CreatureEvent* deathEvent : getCreatureEvents(CREATURE_EVENT_DEATH)) {
			if (deathEvent) {
				deathEvent->executeOnDeath(this, corpse, lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
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

Item* Creature::getCorpse(Creature*, Creature*) {
	return Item::CreateItem(getLookCorpse());
}

void Creature::changeHealth(int32_t healthChange, bool sendHealthChange /* = true*/) {
	int32_t oldHealth = health;

	if (healthChange > 0) {
		health += std::min<int32_t>(healthChange, getMaxHealth() - health);
	} else {
		health = std::max<int32_t>(0, health + healthChange);
	}

	if (sendHealthChange && oldHealth != health) {
		g_game().addCreatureHealth(this);
	}
	if (health <= 0) {
		g_dispatcher().addTask(createTask(std::bind(&Game::executeDeath, &g_game(), getID())));
	}
}

void Creature::changeMana(int32_t manaChange) {
	if (manaChange > 0) {
		mana += std::min<int32_t>(manaChange, getMaxMana() - mana);
	} else {
		mana = std::max<int32_t>(0, mana + manaChange);
	}
}

void Creature::gainHealth(Creature* healer, int32_t healthGain) {
	changeHealth(healthGain);
	if (healer) {
		healer->onTargetCreatureGainHealth(this, healthGain);
	}
}

void Creature::drainHealth(Creature* attacker, int32_t damage) {
	changeHealth(-damage, false);

	if (attacker) {
		attacker->onAttackedCreatureDrainHealth(this, damage);
	}
}

void Creature::drainMana(Creature* attacker, int32_t manaLoss) {
	onAttacked();
	changeMana(-manaLoss);

	if (attacker) {
		addDamagePoints(attacker, manaLoss);
	}
}

BlockType_t Creature::blockHit(Creature* attacker, CombatType_t combatType, int32_t &damage, bool checkDefense /* = false */, bool checkArmor /* = false */, bool /* field  = false */) {
	BlockType_t blockType = BLOCK_NONE;

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
		attacker->onAttackedCreature(this);
		attacker->onAttackedCreatureBlockHit(blockType);
	}

	// Mitigation system
	if (combatType != COMBAT_MANADRAIN && combatType != COMBAT_LIFEDRAIN) { // Add agony check if the server does have agony combat type
		damage -= (damage * getMitigation()) / 100.;

		if (damage <= 0) {
			damage = 0;
			blockType = BLOCK_ARMOR;
		}
	}

	onAttacked();
	return blockType;
}

bool Creature::setAttackedCreature(Creature* creature) {
	if (creature) {
		if (this->getMonster() && this->getMonster()->isFamiliar() && this->getTile() && this->getTile()->hasFlag(TILESTATE_PROTECTIONZONE)) {
			return false;
		}

		const Position &creaturePos = creature->getPosition();
		if (creaturePos.z != getPosition().z || !canSee(creaturePos)) {
			attackedCreature = nullptr;
			return false;
		}

		attackedCreature = creature;
		onAttackedCreature(attackedCreature);
		attackedCreature->onAttacked();
	} else {
		attackedCreature = nullptr;
	}

	for (Creature* summon : summons) {
		summon->setAttackedCreature(creature);
	}
	return true;
}

void Creature::getPathSearchParams(const Creature*, FindPathParams &fpp) const {
	fpp.fullPathSearch = !hasFollowPath;
	fpp.clearSight = true;
	fpp.maxSearchDist = 12;
	fpp.minTargetDist = 1;
	fpp.maxTargetDist = 1;
}

void Creature::goToFollowCreature() {
	if (followCreature) {
		if (isSummon() && !getMonster()->isFamiliar() && !canFollowMaster()) {
			hasFollowPath = false;
			return;
		}

		FindPathParams fpp;
		getPathSearchParams(followCreature, fpp);
		Monster* monster = getMonster();
		if (monster && !monster->getMaster() && (monster->isFleeing() || fpp.maxTargetDist > 1)) {
			Direction dir = DIRECTION_NONE;

			if (monster->isFleeing()) {
				monster->getDistanceStep(followCreature->getPosition(), dir, true);
			} else { // maxTargetDist > 1
				if (!monster->getDistanceStep(followCreature->getPosition(), dir)) {
					// if we can't get anything then let the A* calculate
					listWalkDir.clear();
					if (getPathTo(followCreature->getPosition(), listWalkDir, fpp)) {
						hasFollowPath = true;
						startAutoWalk(listWalkDir);
					} else {
						hasFollowPath = false;
					}
					return;
				}
			}

			if (dir != DIRECTION_NONE) {
				listWalkDir.clear();
				listWalkDir.push_front(dir);

				hasFollowPath = true;
				startAutoWalk(listWalkDir);
			}
		} else {
			listWalkDir.clear();
			if (getPathTo(followCreature->getPosition(), listWalkDir, fpp)) {
				hasFollowPath = true;
				startAutoWalk(listWalkDir);
			} else {
				hasFollowPath = false;
			}
		}
	}

	onFollowCreatureComplete(followCreature);
}

bool Creature::canFollowMaster() const {
	return !master->getTile()->hasFlag(TILESTATE_PROTECTIONZONE) && (canSeeInvisibility() || !master->isInvisible());
}

bool Creature::setFollowCreature(Creature* creature) {
	if (creature) {
		if (followCreature == creature) {
			return true;
		}

		const Position &creaturePos = creature->getPosition();
		if (creaturePos.z != getPosition().z || !canSee(creaturePos)) {
			followCreature = nullptr;
			return false;
		}

		if (!listWalkDir.empty()) {
			listWalkDir.clear();
			onWalkAborted();
		}

		hasFollowPath = false;
		forceUpdateFollowPath = false;
		followCreature = creature;
		isUpdatingPath = true;
	} else {
		isUpdatingPath = false;
		followCreature = nullptr;
	}

	onFollowCreature(creature);
	return true;
}

double Creature::getDamageRatio(Creature* attacker) const {
	uint32_t totalDamage = 0;
	uint32_t attackerDamage = 0;

	for (const auto &it : damageMap) {
		const CountBlock_t &cb = it.second;
		totalDamage += cb.total;
		if (it.first == attacker->getID()) {
			attackerDamage += cb.total;
		}
	}

	if (totalDamage == 0) {
		return 0;
	}

	return (static_cast<double>(attackerDamage) / totalDamage);
}

uint64_t Creature::getGainedExperience(Creature* attacker) const {
	return std::floor(getDamageRatio(attacker) * getLostExperience());
}

void Creature::addDamagePoints(Creature* attacker, int32_t damagePoints) {
	if (damagePoints <= 0) {
		return;
	}

	uint32_t attackerId = attacker->id;

	auto it = damageMap.find(attackerId);
	if (it == damageMap.end()) {
		CountBlock_t cb;
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
	const MagicField* field = getTile()->getFieldItem();
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

void Creature::onCombatRemoveCondition(Condition* condition) {
	removeCondition(condition);
}

void Creature::onAttacked() {
	//
}

void Creature::onAttackedCreatureDrainHealth(Creature* target, int32_t points) {
	target->addDamagePoints(this, points);
}

void Creature::onAttackedCreatureKilled(Creature* target) {
	if (target != this) {
		uint64_t gainExp = target->getGainedExperience(this);
		onGainExperience(gainExp, target);
	}
}

bool Creature::onKilledCreature(Creature* target, bool lastHit) {
	if (master) {
		master->onKilledCreature(target, lastHit);
	}

	// scripting event - onKill
	const CreatureEventList &killEvents = getCreatureEvents(CREATURE_EVENT_KILL);
	for (CreatureEvent* killEvent : killEvents) {
		killEvent->executeOnKill(this, target, lastHit);
	}
	return false;
}

void Creature::onGainExperience(uint64_t gainExp, Creature* target) {
	if (gainExp == 0 || !master) {
		return;
	}

	Monster* m = getMonster();
	if (!m->isFamiliar()) {
		gainExp /= 2;
	}

	master->onGainExperience(gainExp, target);

	if (!m->isFamiliar()) {
		SpectatorHashSet spectators;
		g_game().map.getSpectators(spectators, position, false, true);
		if (spectators.empty()) {
			return;
		}

		TextMessage message(MESSAGE_EXPERIENCE_OTHERS, fmt::format("{} gained {} experience point{}.", ucfirst(getNameDescription()), gainExp, (gainExp != 1 ? "s" : "")));
		message.position = position;
		message.primary.color = TEXTCOLOR_WHITE_EXP;
		message.primary.value = gainExp;

		for (Creature* spectator : spectators) {
			spectator->getPlayer()->sendTextMessage(message);
		}
	}
}

bool Creature::setMaster(Creature* newMaster, bool reloadCreature /* = false*/) {
	// Persists if this creature has ever been a summon
	this->summoned = true;

	if (!newMaster && !master) {
		return false;
	}

	// Reloading summon icon/knownCreature and reset informations (follow/dropLoot/skillLoss)
	if (reloadCreature) {
		setFollowCreature(nullptr);
		setDropLoot(false);
		setSkillLoss(false);
		g_game().reloadCreature(this);
	}
	if (newMaster) {
		incrementReferenceCounter();
		newMaster->summons.push_back(this);
	}

	Creature* oldMaster = master;
	master = newMaster;

	if (oldMaster) {
		auto summon = std::find(oldMaster->summons.begin(), oldMaster->summons.end(), this);
		if (summon != oldMaster->summons.end()) {
			oldMaster->summons.erase(summon);
			decrementReferenceCounter();
		}
	}
	return true;
}

bool Creature::addCondition(Condition* condition) {
	if (condition == nullptr) {
		return false;
	}

	Condition* prevCond = getCondition(condition->getType(), condition->getId(), condition->getSubId());
	if (prevCond) {
		prevCond->addCondition(this, condition);
		delete condition;
		return true;
	}

	if (condition->startCondition(this)) {
		conditions.push_back(condition);
		onAddCondition(condition->getType());
		return true;
	}

	delete condition;
	return false;
}

bool Creature::addCombatCondition(Condition* condition) {
	// Caution: condition variable could be deleted after the call to addCondition
	ConditionType_t type = condition->getType();

	if (!addCondition(condition)) {
		return false;
	}

	onAddCombatCondition(type);
	return true;
}

void Creature::removeCondition(ConditionType_t type) {
	auto it = conditions.begin(), end = conditions.end();
	while (it != end) {
		Condition* condition = *it;
		if (condition->getType() != type) {
			++it;
			continue;
		}

		it = conditions.erase(it);

		condition->endCondition(this);
		delete condition;

		onEndCondition(type);
	}
}

void Creature::removeCondition(ConditionType_t conditionType, ConditionId_t conditionId, bool force /* = false*/) {
	auto it = conditions.begin(), end = conditions.end();
	while (it != end) {
		Condition* condition = *it;
		if (condition->getType() != conditionType || condition->getId() != conditionId) {
			++it;
			continue;
		}

		if (!force && conditionType == CONDITION_PARALYZE) {
			int32_t walkDelay = getWalkDelay();
			if (walkDelay > 0) {
				g_scheduler().addEvent(createSchedulerTask(walkDelay, std::bind(&Game::forceRemoveCondition, &g_game(), getID(), conditionType, conditionId)));
				return;
			}
		}

		it = conditions.erase(it);

		condition->endCondition(this);
		delete condition;

		onEndCondition(conditionType);
	}
}

void Creature::removeCombatCondition(ConditionType_t type) {
	std::vector<Condition*> removeConditions;
	for (Condition* condition : conditions) {
		if (condition->getType() == type) {
			removeConditions.push_back(condition);
		}
	}

	for (Condition* condition : removeConditions) {
		onCombatRemoveCondition(condition);
	}
}

void Creature::removeCondition(Condition* condition) {
	auto it = std::find(conditions.begin(), conditions.end(), condition);
	if (it == conditions.end()) {
		return;
	}

	conditions.erase(it);

	condition->endCondition(this);
	onEndCondition(condition->getType());
	delete condition;
}

Condition* Creature::getCondition(ConditionType_t type) const {
	for (Condition* condition : conditions) {
		if (condition->getType() == type) {
			return condition;
		}
	}
	return nullptr;
}

Condition* Creature::getCondition(ConditionType_t type, ConditionId_t conditionId, uint32_t subId /* = 0*/) const {
	for (Condition* condition : conditions) {
		if (condition->getType() == type && condition->getId() == conditionId && condition->getSubId() == subId) {
			return condition;
		}
	}
	return nullptr;
}

std::vector<Condition*> Creature::getConditions(ConditionType_t type) {
	std::vector<Condition*> conditionsVec;
	for (Condition* condition : conditions) {
		if (condition->getType() == type) {
			conditionsVec.push_back(condition);
		}
	}
	return conditionsVec;
}

void Creature::executeConditions(uint32_t interval) {
	auto it = conditions.begin(), end = conditions.end();
	while (it != end) {
		Condition* condition = *it;
		if (!condition->executeCondition(this, interval)) {
			ConditionType_t type = condition->getType();

			it = conditions.erase(it);

			condition->endCondition(this);
			delete condition;

			onEndCondition(type);
		} else {
			++it;
		}
	}
}

bool Creature::hasCondition(ConditionType_t type, uint32_t subId /* = 0*/) const {
	if (isSuppress(type)) {
		return false;
	}

	int64_t timeNow = OTSYS_TIME();
	for (Condition* condition : conditions) {
		if (condition->getType() != type || condition->getSubId() != subId) {
			continue;
		}

		if (condition->getEndTime() >= timeNow || condition->getTicks() == -1) {
			return true;
		}
	}
	return false;
}

bool Creature::isImmune(CombatType_t type) const {
	return hasBitSet(static_cast<uint32_t>(type), getDamageImmunities());
}

bool Creature::isImmune(ConditionType_t type) const {
	return hasBitSet(static_cast<uint32_t>(type), getConditionImmunities());
}

bool Creature::isSuppress(ConditionType_t type) const {
	return hasBitSet(static_cast<uint32_t>(type), getConditionSuppressions());
}

int64_t Creature::getStepDuration(Direction dir) const {
	int64_t stepDuration = getStepDuration();
	if ((dir & DIRECTION_DIAGONAL_MASK) != 0) {
		stepDuration *= 3;
	}
	return stepDuration;
}

int64_t Creature::getStepDuration() const {
	if (isRemoved()) {
		return 0;
	}

	int32_t stepSpeed = getStepSpeed();
	uint32_t calculatedStepSpeed = std::max<uint32_t>(floor((Creature::speedA * log(stepSpeed + Creature::speedB) + Creature::speedC) + 0.5), 1);
	calculatedStepSpeed = (stepSpeed > -Creature::speedB) ? calculatedStepSpeed : 1;

	uint32_t groundSpeed = 150;
	if (tile && tile->getGround()) {
		Item* ground = tile->getGround();
		const ItemType &it = Item::items[ground->getID()];
		groundSpeed = it.speed > 0 ? it.speed : groundSpeed;
	}

	double duration = std::floor(1000 * groundSpeed / calculatedStepSpeed);
	int64_t stepDuration = std::ceil(duration / 50) * 50;

	const Monster* monster = getMonster();
	if (monster && monster->isTargetNearby() && !monster->isFleeing() && !monster->getMaster()) {
		stepDuration *= 2;
	}

	return stepDuration;
}

int64_t Creature::getEventStepTicks(bool onlyDelay) const {
	int64_t ret = getWalkDelay();
	if (ret <= 0) {
		int64_t stepDuration = getStepDuration();
		if (onlyDelay && stepDuration > 0) {
			ret = 1;
		} else {
			ret = stepDuration * lastStepCost;
		}
	}
	return ret;
}

LightInfo Creature::getCreatureLight() const {
	return internalLight;
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
}

void Creature::setCreatureLight(LightInfo lightInfo) {
	internalLight = std::move(lightInfo);
}

void Creature::setNormalCreatureLight() {
	internalLight = {};
}

bool Creature::registerCreatureEvent(const std::string &name) {
	CreatureEvent* event = g_creatureEvents().getEventByName(name);
	if (!event) {
		return false;
	}

	CreatureEventType_t type = event->getEventType();
	if (hasEventRegistered(type)) {
		for (CreatureEvent* creatureEvent : eventsList) {
			if (creatureEvent == event) {
				return false;
			}
		}
	} else {
		scriptEventsBitField |= static_cast<uint32_t>(1) << type;
	}

	eventsList.push_back(event);
	return true;
}

bool Creature::unregisterCreatureEvent(const std::string &name) {
	const CreatureEvent* event = g_creatureEvents().getEventByName(name);
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
		CreatureEvent* curEvent = *it;
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

CreatureEventList Creature::getCreatureEvents(CreatureEventType_t type) {
	CreatureEventList tmpEventList;

	if (!hasEventRegistered(type)) {
		return tmpEventList;
	}

	for (CreatureEvent* creatureEvent : eventsList) {
		if (creatureEvent->getEventType() == type) {
			tmpEventList.push_back(creatureEvent);
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
		} else if (testDist > bestMatchDist) {
			// not quite what we want, but the best so far
			bestMatchDist = testDist;
			return true;
		}
	}
	return false;
}

bool Creature::isInvisible() const {
	return std::find_if(conditions.begin(), conditions.end(), [](const Condition* condition) {
			   return condition->getType() == CONDITION_INVISIBLE;
		   })
		!= conditions.end();
}

bool Creature::getPathTo(const Position &targetPos, std::forward_list<Direction> &dirList, const FindPathParams &fpp) const {
	return g_game().map.getPathMatching(*this, dirList, FrozenPathingConditionCall(targetPos), fpp);
}

bool Creature::getPathTo(const Position &targetPos, std::forward_list<Direction> &dirList, int32_t minTargetDist, int32_t maxTargetDist, bool fullPathSearch /*= true*/, bool clearSight /*= true*/, int32_t maxSearchDist /*= 7*/) const {
	FindPathParams fpp;
	fpp.fullPathSearch = fullPathSearch;
	fpp.maxSearchDist = maxSearchDist;
	fpp.clearSight = clearSight;
	fpp.minTargetDist = minTargetDist;
	fpp.maxTargetDist = maxTargetDist;
	return getPathTo(targetPos, dirList, fpp);
}

void Creature::turnToCreature(Creature* creature) {
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
	g_game().internalCreatureTurn(this, dir);
}

bool Creature::isLostSummon() const {
	if (!isSummon()) {
		return false;
	}
	const Position &masterPosition = getMaster()->getPosition();
	return std::max<int32_t>(Position::getDistanceX(getPosition(), masterPosition), Position::getDistanceY(getPosition(), masterPosition)) > 30;
}

void Creature::handleLostSummon(bool teleportSummons) {
	if (teleportSummons) {
		g_game().internalTeleport(this, getMaster()->getPosition(), true);
	} else {
		g_game().removeCreature(this, true);
	}
	g_game().addMagicEffect(getPosition(), CONST_ME_POFF);
}
