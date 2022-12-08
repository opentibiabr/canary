/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_GAME_FUNCTIONS_GAME_RELOAD_HPP_
#define SRC_GAME_FUNCTIONS_GAME_RELOAD_HPP_

#include "game/game.h"

class Game;

enum class Reload_t : uint8_t {
	RELOAD_TYPE_NONE,
	RELOAD_TYPE_ALL,
	RELOAD_TYPE_CHAT,
	RELOAD_TYPE_CONFIG,
	RELOAD_TYPE_EVENTS,
	RELOAD_TYPE_CORE,
	RELOAD_TYPE_IMBUEMENTS,
	RELOAD_TYPE_ITEMS,
	RELOAD_TYPE_MODULES,
	RELOAD_TYPE_MONSTERS,
	RELOAD_TYPE_MOUNTS,
	RELOAD_TYPE_NPCS,
	RELOAD_TYPE_RAIDS,
	RELOAD_TYPE_SCRIPTS,
	RELOAD_TYPE_TALKACTION,
	RELOAD_TYPE_LAST
};

class GameReload : public Game
{
public:
	GameReload();
	~GameReload();

	// non-copyable
	GameReload(const GameReload&) = delete;
	GameReload &operator = (const GameReload&) = delete;

	bool init(Reload_t reloadType) const;
	uint8_t getReloadNumber(Reload_t reloadTypes) const;

private:
	bool reloadAll() const;
	bool reloadChat() const;
	bool reloadConfig() const;
	bool reloadEvents() const;
	bool reloadCore() const;
	bool reloadImbuements() const;
	bool reloadItems() const;
	bool reloadModules() const;
	bool reloadMonsters() const;
	bool reloadMounts() const;
	bool reloadNpcs() const;
	bool reloadRaids() const;
	bool reloadScripts() const;
	bool reloadTalkaction() const;
};

const inline GameReload g_gameReload;

#endif  // SRC_GAME_FUNCTIONS_GAME_RELOAD_HPP_
