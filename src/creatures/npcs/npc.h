/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_CREATURES_NPCS_NPC_H_
#define SRC_CREATURES_NPCS_NPC_H_

#include "creatures/npcs/npcs.h"
#include "declarations.hpp"
#include "items/tile.h"

class Creature;
class Game;
class SpawnNpc;

class Npc final : public Creature {
	public:
		static Npc* createNpc(const std::string &name);
		static int32_t despawnRange;
		static int32_t despawnRadius;

		explicit Npc(NpcType* npcType);
		Npc() = default;
		~Npc();

		// Singleton - ensures we don't accidentally copy it
		Npc(const Npc &) = delete;
		void operator=(const Npc &) = delete;

		static Npc &getInstance() {
			// Guaranteed to be destroyed
			static Npc instance;
			// Instantiated on first use
			return instance;
		}

		Npc* getNpc() override {
			return this;
		}
		const Npc* getNpc() const override {
			return this;
		}

		void setID() override {
			if (id == 0) {
				id = npcAutoID++;
			}
		}

		void removeList() override;
		void addList() override;

		const std::string &getName() const override {
			return npcType->name;
		}
		// Real npc name, set on npc creation "createNpcType(typeName)"
		const std::string &getTypeName() const override {
			return npcType->typeName;
		}
		const std::string &getNameDescription() const override {
			return npcType->nameDescription;
		}
		std::string getDescription(int32_t) const override {
			return strDescription + '.';
		}

		void setName(std::string newName) {
			npcType->name = newName;
		}

		CreatureType_t getType() const override {
			return CREATURETYPE_NPC;
		}

		const Position &getMasterPos() const {
			return masterPos;
		}
		void setMasterPos(Position pos) {
			masterPos = pos;
		}

		uint8_t getSpeechBubble() const override {
			return npcType->info.speechBubble;
		}
		void setSpeechBubble(const uint8_t bubble) {
			npcType->info.speechBubble = bubble;
		}

		uint16_t getCurrency() const {
			return npcType->info.currencyId;
		}
		void setCurrency(uint16_t currency) {
			npcType->info.currencyId = currency;
		}

		std::vector<ShopBlock> getShopItemVector() {
			return npcType->info.shopItemVector;
		}

		bool isPushable() const override {
			return npcType->info.pushable;
		}

		bool isAttackable() const override {
			return false;
		}

		bool canInteract(const Position &pos) const;
		bool canSeeInvisibility() const override {
			return true;
		}
		RespawnType getRespawnType() const {
			return npcType->info.respawnType;
		}
		void setSpawnNpc(SpawnNpc* newSpawn) {
			this->spawnNpc = newSpawn;
		}

		void setPlayerInteraction(uint32_t playerId, uint16_t topicId = 0);
		void removePlayerInteraction(Player* player);
		void resetPlayerInteractions();

		bool isInteractingWithPlayer(uint32_t playerId) {
			if (playerInteractions.find(playerId) == playerInteractions.end()) {
				return false;
			}
			return true;
		}

		bool isPlayerInteractingOnTopic(uint32_t playerId, uint16_t topicId) {
			auto it = playerInteractions.find(playerId);
			if (it == playerInteractions.end()) {
				return false;
			}
			return it->second == topicId;
		}

		void onCreatureAppear(Creature* creature, bool isLogin) override;
		void onRemoveCreature(Creature* creature, bool isLogout) override;
		void onCreatureMove(Creature* creature, const Tile* newTile, const Position &newPos, const Tile* oldTile, const Position &oldPos, bool teleport) override;
		void onCreatureSay(Creature* creature, SpeakClasses type, const std::string &text) override;
		void onThink(uint32_t interval) override;
		void onPlayerBuyItem(Player* player, uint16_t itemid, uint8_t count, uint16_t amount, bool ignore, bool inBackpacks);
		void onPlayerSellItem(Player* player, uint16_t itemid, uint8_t count, uint16_t amount, bool ignore);
		void onPlayerCheckItem(Player* player, uint16_t itemid, uint8_t count);
		void onPlayerCloseChannel(Creature* creature);
		void onPlacedCreature() override;

		bool canWalkTo(const Position &fromPos, Direction dir) const;
		bool getNextStep(Direction &nextDirection, uint32_t &flags) override;
		bool getRandomStep(Direction &moveDirection) const;

		void setNormalCreatureLight() override {
			internalLight = npcType->info.light;
		}

		void addShopPlayer(Player* player);
		void removeShopPlayer(Player* player);
		void closeAllShopWindows();

		static uint32_t npcAutoID;

		void onCreatureWalk() override;

	private:
		void onThinkYell(uint32_t interval);
		void onThinkWalk(uint32_t interval);
		void onThinkSound(uint32_t interval);

		bool isInSpawnRange(const Position &pos) const;

		std::string strDescription;

		std::map<uint32_t, uint16_t> playerInteractions;

		std::set<Player*> shopPlayerSet;

		NpcType* npcType;
		SpawnNpc* spawnNpc = nullptr;

		uint8_t speechBubble;

		uint32_t yellTicks = 0;
		uint32_t walkTicks = 0;
		uint32_t soundTicks = 0;

		bool ignoreHeight;

		SpectatorHashSet playerSpectators;
		Position masterPos;

		friend class LuaScriptInterface;
		friend class Map;

		void onPlayerAppear(Player* player);
		void onPlayerDisappear(Player* player);
		void manageIdle();
		void handlePlayerMove(Player* player, const Position &newPos);
		void loadPlayerSpectators();
};

constexpr auto g_npc = &Npc::getInstance;

#endif // SRC_CREATURES_NPCS_NPC_H_
