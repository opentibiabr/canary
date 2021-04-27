--dofile('tests/lua/luainit.lua')
lu = require('tests.lua.luaunit')
TestWithFailures = {}

-- Load lib files
dofile('tests/lua/lib/asserts.lua')
dofile('tests/lua/lib/utils.lua')

-- Load mock files
dofile('tests/lua/mock/fake_npc.lua')
dofile('tests/lua/mock/fake_player.lua')

-- Load testable files
dofile('data/lib/npc/npc_interaction/load.lua')

dofile('data/lib/player_processor/load.lua')

-- Load test files
dofile('tests/lua/test_npc_interaction.lua')
dofile('tests/lua/test_npc_messages.lua')
dofile('tests/lua/test_npc_topic.lua')
dofile('tests/lua/test_player_processing_configs.lua')
dofile('tests/lua/test_player_updater.lua')
dofile('tests/lua/test_player_validator.lua')

os.exit( lu.LuaUnit.run() )