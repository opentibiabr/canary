/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef SRC_CREATURES_NPCS_XML_NPC_HPP_
#define SRC_CREATURES_NPCS_XML_NPC_HPP_

#include "creatures/creature.h"
#include "lua/scripts/luascript.h"

#include <set>

class NpcOld;
class Player;

class NpcsOld
{
	public:
		static void reload();
};

class NpcScriptInterface final : public LuaScriptInterface
{
	public:
		NpcScriptInterface();

		bool loadNpcLib(const std::string& file);

		// Check if is loaded: if (isLoaded()) or if (!isLoaded())
		bool isLoaded() const {
			return libLoaded;
		}
		// Set to loaded: setLoaded(true or false)
		bool setLoaded(bool setLoaded) {
			return libLoaded = setLoaded;
		}

	private:
		void loadFunctions() {
			lua_register(luaState, "selfSay", NpcScriptInterface::luaActionSay);
			lua_register(luaState, "selfMove", NpcScriptInterface::luaActionMove);
			lua_register(luaState, "selfMoveTo", NpcScriptInterface::luaActionMoveTo);
			lua_register(luaState, "selfTurn", NpcScriptInterface::luaActionTurn);
			lua_register(luaState, "selfFollow", NpcScriptInterface::luaActionFollow);
			lua_register(luaState, "getDistanceTo", NpcScriptInterface::luagetDistanceTo);
			lua_register(luaState, "doNpcSetCreatureFocus", NpcScriptInterface::luaSetNpcFocus);
			lua_register(luaState, "getNpcCid", NpcScriptInterface::luaGetNpcCid);
			lua_register(luaState, "getNpcParameter", NpcScriptInterface::luaGetNpcParameter);
			lua_register(luaState, "openShopWindow", NpcScriptInterface::luaOpenShopWindow);
			lua_register(luaState, "closeShopWindow", NpcScriptInterface::luaCloseShopWindow);
			lua_register(luaState, "doSellItem", NpcScriptInterface::luaDoSellItem);
		}

		// XML npcs init exclusive functions
		static int luaActionSay(lua_State* L);
		static int luaActionMove(lua_State* L);
		static int luaActionMoveTo(lua_State* L);
		static int luaActionTurn(lua_State* L);
		static int luaActionFollow(lua_State* L);
		static int luagetDistanceTo(lua_State* L);
		static int luaSetNpcFocus(lua_State* L);
		static int luaGetNpcCid(lua_State* L);
		static int luaGetNpcParameter(lua_State* L);
		static int luaOpenShopWindow(lua_State* L);
		static int luaCloseShopWindow(lua_State* L);
		static int luaDoSellItem(lua_State* L);

		bool initState() override;
		bool closeState() override;
		bool libLoaded;
};

class NpcEventsHandler
{
	public:
		NpcEventsHandler(const std::string& file, NpcOld* npcOld);

		void onCreatureAppear(Creature* creature);
		void onCreatureDisappear(Creature* creature);
		void onCreatureMove(Creature* creature, const Position& oldPos, const Position& newPos);
		void onCreatureSay(Creature* creature, SpeakClasses, const std::string& text);
		void onPlayerTrade(Player* player, int32_t callback, uint16_t itemId, uint8_t count, uint8_t amount, bool ignore = false, bool inBackpacks = false);
		void onPlayerCloseChannel(Player* player);
		void onPlayerEndTrade(Player* player);
		void onThink();

		// Check if is loaded: if (isLoaded()) or if (!isLoaded())
		bool isLoaded() const {
			return loaded;
		}

	private:
		NpcOld* npcOld;
		NpcScriptInterface* scriptInterface;

		int32_t creatureAppearEvent = -1;
		int32_t creatureDisappearEvent = -1;
		int32_t creatureMoveEvent = -1;
		int32_t creatureSayEvent = -1;
		int32_t playerCloseChannelEvent = -1;
		int32_t playerEndTradeEvent = -1;
		int32_t thinkEvent = -1;
		bool loaded = false;
};

class NpcOld final : public Creature
{
	public:
		~NpcOld();

		// non-copyable
		NpcOld(const NpcOld&) = delete;
		NpcOld& operator=(const NpcOld&) = delete;

		NpcOld* getNpcOld() override {
			return this;
		}
		const NpcOld* getNpcOld() const override {
			return this;
		}

		// Check if is loaded: if (isLoaded()) or if (!isLoaded())
		bool isLoaded() const {
			return loaded;
		}
		// Set to loaded: setLoaded(true or false)
		bool setLoaded(bool setLoaded) {
			return loaded = setLoaded;
		}

		bool isPushable() const override {
			return pushable && walkTicks != 0;
		}

		void setID() override {
			if (id == 0) {
				id = npcOldAutoID++;
			}
		}

		void removeList() override;
		void addList() override;

		static NpcOld* createNpc(const std::string& name);

		bool canSee(const Position& pos) const override;

		bool load();
		void reload();

		const std::string& getName() const override {
			return name;
		}
		const std::string& getNameDescription() const override {
			return name;
		}
		const std::string setName(std::string newName) {
			return name = newName;
		}
		CreatureType_t getType() const override {
			return CREATURETYPE_NPC;
		}

		uint8_t getSpeechBubble() const override {
			return speechBubble;
		}
		void setSpeechBubble(const uint8_t bubble) {
			speechBubble = bubble;
		}

		uint16_t getCurrencyTrading() const {
			return currencyClientId;
		}

		uint16_t getCurrency() const {
			return currencyServerId;
		}

		void doSay(const std::string& text);
		void doSayToPlayer(Player* player, const std::string& text);

		void doMoveTo(const Position& pos);

		int32_t getMasterRadius() const {
			return masterRadius;
		}
		const Position& getMasterPos() const {
			return masterPos;
		}
		void setMasterPos(Position pos, int32_t radius = 1) {
			masterPos = pos;
			if (masterRadius == -1) {
				masterRadius = radius;
			}
		}

		void onPlayerCloseChannel(Player* player);
		void onPlayerTrade(Player* player, int32_t callback, uint16_t itemId, uint8_t count,
		                   uint8_t amount, bool ignore = false, bool inBackpacks = false);
		void onPlayerEndTrade(Player* player, int32_t buyCallback, int32_t sellCallback);

		void turnToCreature(Creature* creature);
		void setCreatureFocus(Creature* creature);

		NpcScriptInterface* getScriptInterface();

		static uint32_t npcOldAutoID;

	private:
		explicit NpcOld(const std::string& name);

		void onCreatureAppear(Creature* creature, bool isLogin) override;
		void onRemoveCreature(Creature* creature, bool isLogout) override;
		void onCreatureMove(Creature* creature, const Tile* newTile, const Position& newPos,
		                            const Tile* oldTile, const Position& oldPos, bool teleport) override;

		void onCreatureSay(Creature* creature, SpeakClasses type, const std::string& text) override;
		void onThink(uint32_t interval) override;
		std::string getDescription(int32_t lookDistance) const override;

		bool isImmune(CombatType_t) const override {
			return !attackable;
		}
		bool isImmune(ConditionType_t) const override {
			return !attackable;
		}
		bool isAttackable() const override {
			return attackable;
		}
		bool getNextStep(Direction& dir, uint32_t& flags) override;

		void setIdle(bool idle);
		void updateIdleStatus();

		bool canWalkTo(const Position& fromPos, Direction dir) const;
		bool getRandomStep(Direction& dir) const;

		void reset();
		bool loadFromXml();

		void addShopPlayer(Player* player);
		void removeShopPlayer(Player* player);
		void closeAllShopWindows();

		std::map<std::string, std::string> parameters;

		std::set<Player*> oldShopPlayerSet;
		std::set<Player*> spectators;

		std::string name;
		std::string filename;

		NpcEventsHandler* npcEventHandler;

		Position masterPos;

		uint32_t walkTicks;
		int32_t focusCreature;
		int32_t masterRadius;

		uint8_t speechBubble;

		uint16_t currencyServerId;
		uint16_t currencyClientId;

		bool floorChange;
		bool attackable;
		bool ignoreHeight;
		bool loaded;
		bool isIdle;
		bool pushable;

		static NpcScriptInterface* scriptInterface;

		friend class NpcsOld;
		friend class NpcScriptInterface;
		friend class NpcOldFunctions;
};

#endif // SRC_CREATURES_NPCS_XML_NPC_HPP_
