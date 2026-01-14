/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

// uncomment these to selectively disable protocolgame send methods
// this can be used to perform manual tests when updating the server to higher protocol
// and to troubleshoot client crash on login

/*
// otc-only packets
#define PROTOCOL_OTC_DISABLE_FEATURES
#define PROTOCOL_OTC_DISABLE_ATTACHED_EFFECTS
#define PROTOCOL_OTC_DISABLE_SHADERS
#define PROTOCOL_OTC_DISABLE_TYPING_ICON

// core systems
#define PROTOCOL_DISABLE_PENDING_STATE
#define PROTOCOL_DISABLE_ENTER_WORLD
#define PROTOCOL_DISABLE_GAME_SCREEN
#define PROTOCOL_DISABLE_UPDATE_TILE
#define PROTOCOL_DISABLE_MOVE_CREATURE

// connection
#define PROTOCOL_DISABLE_PING_CHECKS

// effects (packet 0x83)
#define PROTOCOL_DISABLE_MAGIC_EFFECTS
#define PROTOCOL_DISABLE_MISSILES
#define PROTOCOL_DISABLE_SOUND

// ui
#define PROTOCOL_DISABLE_SEND_STATS
#define PROTOCOL_DISABLE_SEND_SKILLS
#define PROTOCOL_DISABLE_SEND_BASIC_DATA
#define PROTOCOL_DISABLE_OUTFIT_WINDOW
#define PROTOCOL_DISABLE_DEATH_SCREEN
#define PROTOCOL_DISABLE_BLESSINGS
#define PROTOCOL_DISABLE_UNJUST_PANEL
#define PROTOCOL_DISABLE_NPC_TRADE
#define PROTOCOL_DISABLE_PLAYER_TRADE
#define PROTOCOL_DISABLE_PLAYER_INVENTORY
#define PROTOCOL_DISABLE_TEXT_EDIT
#define PROTOCOL_DISABLE_TEXT_EDIT_HOUSE
#define PROTOCOL_DISABLE_VIP_LIST
#define PROTOCOL_DISABLE_MODAL_WINDOW
#define PROTOCOL_DISABLE_MILESTONES

// action bar
#define PROTOCOL_DISABLE_ACTION_BAR
#define PROTOCOL_DISABLE_SPELL_COOLDOWNS
#define PROTOCOL_DISABLE_USE_ITEM_COOLDOWN

// large systems
#define PROTOCOL_DISABLE_MARKET
#define PROTOCOL_DISABLE_STASH
#define PROTOCOL_DISABLE_STASH_MARKET_STATUS
#define PROTOCOL_DISABLE_EXALTATION_FORGE
#define PROTOCOL_DISABLE_PREY
#define PROTOCOL_DISABLE_HUNTING_TASKS
#define PROTOCOL_DISABLE_IMBUEMENTS
#define PROTOCOL_DISABLE_WHEEL_OF_DESTINY

// backpacks, quick loot
#define PROTOCOL_DISABLE_CONTAINERS
#define PROTOCOL_DISABLE_CONTAINER_SEARCH
#define PROTOCOL_DISABLE_LOOT_SETTINGS

// creature updates
#define PROTOCOL_DISABLE_UPDATE_HEALTH
#define PROTOCOL_DISABLE_UPDATE_OUTFIT
#define PROTOCOL_DISABLE_UPDATE_LIGHT
#define PROTOCOL_DISABLE_UPDATE_ICONS
#define PROTOCOL_DISABLE_UPDATE_WALKTHROUGH
#define PROTOCOL_DISABLE_UPDATE_GUILD
#define PROTOCOL_DISABLE_UPDATE_TYPE
#define PROTOCOL_DISABLE_UPDATE_CONDITIONS
#define PROTOCOL_DISABLE_UPDATE_SPEED
#define PROTOCOL_DISABLE_UPDATE_RESTING_AREA
#define PROTOCOL_DISABLE_UPDATE_VOCATION
#define PROTOCOL_DISABLE_UPDATE_FIGHT_MODES
#define PROTOCOL_DISABLE_UPDATE_CREATURE
#define PROTOCOL_DISABLE_MONK_STATES

// party / skulls
#define PROTOCOL_DISABLE_UPDATE_PARTY
#define PROTOCOL_DISABLE_UPDATE_PARTY_UI
#define PROTOCOL_DISABLE_UPDATE_SKULL

// square on creature (pvp frame, attack frame, etc)
#define PROTOCOL_DISABLE_UPDATE_FRAMES

// walking
#define PROTOCOL_DISABLE_UPDATE_DIRECTION
#define PROTOCOL_DISABLE_CANCEL_WALK

// chat
#define PROTOCOL_DISABLE_CHAT_CHANNELS
#define PROTOCOL_DISABLE_TEXT_MESSAGES

// cyclopedia related
#define PROTOCOL_DISABLE_INSPECT_ITEM
#define PROTOCOL_DISABLE_BESTIARY
#define PROTOCOL_DISABLE_BOSSTIARY
#define PROTOCOL_DISABLE_RESOURCE_BALANCE
#define PROTOCOL_DISABLE_CHARACTER_INFO
#define PROTOCOL_DISABLE_CYCLOPEDIA_HOUSES

// analyzers
#define PROTOCOL_DISABLE_ANALYZERS

// misc systems
#define PROTOCOL_DISABLE_HIGHSCORES
#define PROTOCOL_DISABLE_TEAM_FINDER
#define PROTOCOL_DISABLE_FRIEND_SYSTEM
#define PROTOCOL_DISABLE_TUTORIAL_POPUPS
#define PROTOCOL_DISABLE_MAP_MARKS
#define PROTOCOL_DISABLE_FYI_BOX
#define PROTOCOL_DISABLE_INFO_BOX
#define PROTOCOL_DISABLE_BUG_REPORTING
#define PROTOCOL_DISABLE_ITEM_PRICES

// world updates
#define PROTOCOL_DISABLE_WORLD_LIGHT_TIME

// trivial
#define PROTOCOL_DISABLE_PREMIUM_TRIGGER
#define PROTOCOL_DISABLE_CLIENT_CHECK
#define PROTOCOL_DISABLE_GAME_NEWS
#define PROTOCOL_OLD_DISABLE_HELPERS
*/

#ifndef __FUNCTION__
	#define __FUNCTION__ __func__
#endif

#define __METRICS_METHOD_NAME__ std::source_location::current().function_name()

#ifndef _CRT_SECURE_NO_WARNINGS
	#define _CRT_SECURE_NO_WARNINGS
#endif

#ifndef _USE_MATH_DEFINES
	#define _USE_MATH_DEFINES
#endif

#ifdef _WIN32
	#ifndef NOMINMAX
		#define NOMINMAX
	#endif

	#if defined(_WIN32) || defined(WIN32) || defined(__CYGWIN__) || defined(__MINGW32__) || defined(__BORLANDC__)
		#define OS_WINDOWS
	#endif

	#ifdef _MSC_VER
		#ifdef NDEBUG
			#define _SECURE_SCL 0
			#define HAS_ITERATOR_DEBUGGING 0
		#endif

		#pragma warning(disable : 4127) // conditional expression is constant
		#pragma warning(disable : 4244) // 'argument' : conversion from 'type1' to 'type2', possible loss of data
		#pragma warning(disable : 4250) // 'class1' : inherits 'class2::member' via dominance
		#pragma warning(disable : 4267) // 'var' : conversion from 'size_t' to 'type', possible loss of data
		#pragma warning(disable : 4319) // '~': zero extending 'unsigned int' to 'lua_Number' of greater size
		#pragma warning(disable : 4458) // declaration hides class member
		#pragma warning(disable : 4101) // local variable not referenced
		#pragma warning(disable : 4996) // declaration std::fpos<_Mbstatet>::seekpos
	#endif

	#define strcasecmp _stricmp
	#define strncasecmp _strnicmp

	#ifndef _WIN32_WINNT
		// 0x0602: Windows 7
		#define _WIN32_WINNT 0x0602
	#endif
#endif

#ifndef M_PI
	#define M_PI 3.14159265358979323846
#endif
