/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/game.hpp"

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
	RELOAD_TYPE_OUTFITS,
	RELOAD_TYPE_NPCS,
	RELOAD_TYPE_RAIDS,
	RELOAD_TYPE_SCRIPTS,
	RELOAD_TYPE_GROUPS,
	RELOAD_TYPE_FAMILIARS,
	RELOAD_TYPE_VOCATIONS,

	// Every is last
	RELOAD_TYPE_LAST
};

class GameReload : public Game {
public:
	GameReload();
	~GameReload();

	// non-copyable
	GameReload(const GameReload &) = delete;
	GameReload &operator=(const GameReload &) = delete;

	static GameReload &getInstance() {
		return inject<GameReload>();
	}

	bool init(Reload_t reloadType) const;
	static uint8_t getReloadNumber(Reload_t reloadTypes);

private:
	bool reloadAll() const;
	static bool reloadChat();
	static bool reloadConfig();
	static bool reloadEvents();
	static bool reloadCore();
	static bool reloadImbuements();
	static bool reloadItems();
	static bool reloadModules();
	static bool reloadMonsters();
	static bool reloadMounts();
	static bool reloadNpcs();
	static bool reloadRaids();
	static bool reloadScripts();
	static bool reloadGroups();
	static bool reloadFamiliars();
	static bool reloadOutfits();
	bool reloadVocations() const;
};

constexpr auto g_gameReload = GameReload::getInstance;
