@REM NOTE(fusion): This building script is meant to be used along with vcpkg:
@REM	vcpkg install --triple=x64-windows-static --x-manisfest-root="CANARY_ROOT_DIR"

@SETLOCAL

pushd %~dp0
del /q .\build\*
mkdir .\build
pushd .\build

@REM TODO(fusion): Unity builds would speed this up by more than 10x but would require the code to be sanitized beforehand.

@REM TODO(fusion): Remove all these sub directories.

@REM NOTE(fusion): Don't mess with the %INCLUDE% variable as the visual studio cmd prompt will already setup paths to the stdlib and windows sdk libraries. If we set it to something else, we'll have problems with including any standard header file.

@SET INCL=-I"../src" -I"../vcpkg_installed/x64-windows-static/include"

@SET LIBS="advapi32.lib" "crypt32.lib" "secur32.lib" "shlwapi.lib" "user32.lib" "ws2_32.lib"^
	"../vcpkg_installed/x64-windows-static/lib/boost_filesystem-vc140-mt.lib"^
	"../vcpkg_installed/x64-windows-static/lib/boost_iostreams-vc140-mt.lib"^
	"../vcpkg_installed/x64-windows-static/lib/boost_system-vc140-mt.lib"^
	"../vcpkg_installed/x64-windows-static/lib/bz2.lib"^
	"../vcpkg_installed/x64-windows-static/lib/fmt.lib"^
	"../vcpkg_installed/x64-windows-static/lib/jsoncpp.lib"^
	"../vcpkg_installed/x64-windows-static/lib/libcurl.lib"^
	"../vcpkg_installed/x64-windows-static/lib/libprotobuf.lib"^
	"../vcpkg_installed/x64-windows-static/lib/libzippp_static.lib"^
	"../vcpkg_installed/x64-windows-static/lib/lua51.lib"^
	"../vcpkg_installed/x64-windows-static/lib/mariadbclient.lib"^
	"../vcpkg_installed/x64-windows-static/lib/mpir.lib"^
	"../vcpkg_installed/x64-windows-static/lib/pugixml.lib"^
	"../vcpkg_installed/x64-windows-static/lib/spdlog.lib"^
	"../vcpkg_installed/x64-windows-static/lib/zip.lib"^
	"../vcpkg_installed/x64-windows-static/lib/zlib.lib"

@SET DEFS=-D_CRT_SECURE_NO_WARNINGS=1
@SET SRC="../src/otserv.cpp"^
	"../src/config/configmanager.cpp"^
	"../src/creatures/creature.cpp"^
	"../src/creatures/appearance/mounts/mounts.cpp"^
	"../src/creatures/appearance/outfit/outfit.cpp"^
	"../src/creatures/combat/combat.cpp"^
	"../src/creatures/combat/condition.cpp"^
	"../src/creatures/combat/spells.cpp"^
	"../src/creatures/interactions/chat.cpp"^
	"../src/creatures/monsters/monster.cpp"^
	"../src/creatures/monsters/monsters.cpp"^
	"../src/creatures/monsters/spawns/spawn_monster.cpp"^
	"../src/creatures/npcs/npc.cpp"^
	"../src/creatures/npcs/npcs.cpp"^
	"../src/creatures/npcs/spawns/spawn_npc.cpp"^
	"../src/creatures/players/player.cpp"^
	"../src/creatures/players/account/account.cpp"^
	"../src/creatures/players/grouping/familiars.cpp"^
	"../src/creatures/players/grouping/groups.cpp"^
	"../src/creatures/players/grouping/guild.cpp"^
	"../src/creatures/players/grouping/party.cpp"^
	"../src/creatures/players/imbuements/imbuements.cpp"^
	"../src/creatures/players/management/ban.cpp"^
	"../src/creatures/players/management/waitlist.cpp"^
	"../src/creatures/players/vocations/vocation.cpp"^
	"../src/database/database.cpp"^
	"../src/database/databasemanager.cpp"^
	"../src/database/databasetasks.cpp"^
	"../src/game/game.cpp"^
	"../src/game/gamestore.cpp"^
	"../src/game/movement/position.cpp"^
	"../src/game/movement/teleport.cpp"^
	"../src/game/scheduling/events_scheduler.cpp"^
	"../src/game/scheduling/scheduler.cpp"^
	"../src/game/scheduling/tasks.cpp"^
	"../src/io/fileloader.cpp"^
	"../src/io/iobestiary.cpp"^
	"../src/io/ioguild.cpp"^
	"../src/io/iologindata.cpp"^
	"../src/io/iomap.cpp"^
	"../src/io/iomapserialize.cpp"^
	"../src/io/iomarket.cpp"^
	"../src/io/ioprey.cpp"^
	"../src/items/bed.cpp"^
	"../src/items/cylinder.cpp"^
	"../src/items/item.cpp"^
	"../src/items/items.cpp"^
	"../src/items/thing.cpp"^
	"../src/items/tile.cpp"^
	"../src/items/trashholder.cpp"^
	"../src/items/containers/container.cpp"^
	"../src/items/containers/depot/depotchest.cpp"^
	"../src/items/containers/depot/depotlocker.cpp"^
	"../src/items/containers/inbox/inbox.cpp"^
	"../src/items/containers/mailbox/mailbox.cpp"^
	"../src/items/containers/rewards/reward.cpp"^
	"../src/items/containers/rewards/rewardchest.cpp"^
	"../src/items/decay/decay.cpp"^
	"../src/items/functions/item_parse.cpp"^
	"../src/items/weapons/weapons.cpp"^
	"../src/lua/callbacks/creaturecallback.cpp"^
	"../src/lua/creature/actions.cpp"^
	"../src/lua/creature/creatureevent.cpp"^
	"../src/lua/creature/events.cpp"^
	"../src/lua/creature/movement.cpp"^
	"../src/lua/creature/raids.cpp"^
	"../src/lua/creature/talkaction.cpp"^
	"../src/lua/functions/lua_functions_loader.cpp"^
	"../src/lua/functions/core/game/config_functions.cpp"^
	"../src/lua/functions/core/game/game_functions.cpp"^
	"../src/lua/functions/core/game/global_functions.cpp"^
	"../src/lua/functions/core/game/modal_window_functions.cpp"^
	"../src/lua/functions/core/libs/bit_functions.cpp"^
	"../src/lua/functions/core/libs/db_functions.cpp"^
	"../src/lua/functions/core/libs/result_functions.cpp"^
	"../src/lua/functions/core/libs/spdlog_functions.cpp"^
	"../src/lua/functions/core/network/network_message_functions.cpp"^
	"../src/lua/functions/core/network/webhook_functions.cpp"^
	"../src/lua/functions/creatures/creature_functions.cpp"^
	"../src/lua/functions/creatures/combat/combat_functions.cpp"^
	"../src/lua/functions/creatures/combat/condition_functions.cpp"^
	"../src/lua/functions/creatures/combat/spell_functions.cpp"^
	"../src/lua/functions/creatures/combat/variant_functions.cpp"^
	"../src/lua/functions/creatures/monster/charm_functions.cpp"^
	"../src/lua/functions/creatures/monster/loot_functions.cpp"^
	"../src/lua/functions/creatures/monster/monster_functions.cpp"^
	"../src/lua/functions/creatures/monster/monster_spell_functions.cpp"^
	"../src/lua/functions/creatures/monster/monster_type_functions.cpp"^
	"../src/lua/functions/creatures/npc/npc_functions.cpp"^
	"../src/lua/functions/creatures/npc/npc_type_functions.cpp"^
	"../src/lua/functions/creatures/npc/shop_functions.cpp"^
	"../src/lua/functions/creatures/player/group_functions.cpp"^
	"../src/lua/functions/creatures/player/guild_functions.cpp"^
	"../src/lua/functions/creatures/player/mount_functions.cpp"^
	"../src/lua/functions/creatures/player/party_functions.cpp"^
	"../src/lua/functions/creatures/player/player_functions.cpp"^
	"../src/lua/functions/creatures/player/vocation_functions.cpp"^
	"../src/lua/functions/events/action_functions.cpp"^
	"../src/lua/functions/events/creature_event_functions.cpp"^
	"../src/lua/functions/events/events_scheduler_functions.cpp"^
	"../src/lua/functions/events/global_event_functions.cpp"^
	"../src/lua/functions/events/move_event_functions.cpp"^
	"../src/lua/functions/events/talk_action_functions.cpp"^
	"../src/lua/functions/items/container_functions.cpp"^
	"../src/lua/functions/items/imbuement_functions.cpp"^
	"../src/lua/functions/items/item_classification_functions.cpp"^
	"../src/lua/functions/items/item_functions.cpp"^
	"../src/lua/functions/items/item_type_functions.cpp"^
	"../src/lua/functions/items/weapon_functions.cpp"^
	"../src/lua/functions/map/house_functions.cpp"^
	"../src/lua/functions/map/position_functions.cpp"^
	"../src/lua/functions/map/teleport_functions.cpp"^
	"../src/lua/functions/map/tile_functions.cpp"^
	"../src/lua/functions/map/town_functions.cpp"^
	"../src/lua/global/baseevents.cpp"^
	"../src/lua/global/globalevent.cpp"^
	"../src/lua/modules/modules.cpp"^
	"../src/lua/scripts/lua_environment.cpp"^
	"../src/lua/scripts/luascript.cpp"^
	"../src/lua/scripts/script_environment.cpp"^
	"../src/lua/scripts/scripts.cpp"^
	"../src/map/map.cpp"^
	"../src/map/house/house.cpp"^
	"../src/map/house/housetile.cpp"^
	"../src/security/rsa.cpp"^
	"../src/server/server.cpp"^
	"../src/server/signals.cpp"^
	"../src/server/network/connection/connection.cpp"^
	"../src/server/network/message/networkmessage.cpp"^
	"../src/server/network/message/outputmessage.cpp"^
	"../src/server/network/protocol/protocol.cpp"^
	"../src/server/network/protocol/protocolgame.cpp"^
	"../src/server/network/protocol/protocollogin.cpp"^
	"../src/server/network/protocol/protocolstatus.cpp"^
	"../src/server/network/webhook/webhook.cpp"^
	"../src/utils/tools.cpp"^
	"../src/utils/wildcardtree.cpp"

@REM TODO(fusion): Warnings that I disabled but should eventually get fixed (?):
@REM	- C4250				inheritance by dominance warning triggered mostly by the cylinder class
@REM	- C4251				protobuf library files
@REM	- C4244, C4267		protobuf generated files.

@SET OUTPUTEXE="canary.exe"
@SET OUTPUTPDB="canary.pdb"
@SET OUTPUTPCH="canary.pch"
@SET INSTALLDIR="../bin/"

@SET COMMONFLAGS=-Zi -MT -W3 -WX -wd4250 -wd4251 -wd4244 -wd4267 -std:c++17 -EHsc -MP -Gm- %DEFS% %INCL%

@REM NOTE(fusion): Generate PCH separately.
cl.exe %COMMONFLAGS% -c -Fd%OUTPUTPDB% -Fp%OUTPUTPCH% -Yc"otpch.h" "../src/otpch.cpp"

@REM NOTE(fusion): Compile protobuf files separately because they don't include the pre compiled header and for some reason if you use the -Yu option, all source files must have it included.
cl.exe %COMMONFLAGS% -c -Fd%OUTPUTPDB% "../src/protobuf/appearances.pb.cc"

@REM NOTE(fusion): Build the project using the PCH.
cl.exe %COMMONFLAGS% -Fe%OUTPUTEXE% -Fd%OUTPUTPDB% -Fp%OUTPUTPCH% -Yu"otpch.h" %SRC% "./otpch.obj" "./appearances.pb.obj" /link -stack:0x400000,0x100000 -subsystem:console -incremental:no -opt:ref -dynamicbase %LIBS%

IF EXIST %OUTPUTEXE% copy /Y %OUTPUTEXE% %INSTALLDIR%
IF EXIST %OUTPUTPDB% copy /Y %OUTPUTPDB% %INSTALLDIR%

popd
popd

@ENDLOCAL
