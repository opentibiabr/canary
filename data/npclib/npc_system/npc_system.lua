-- Advanced NPC System by Jiddo
npcs_loaded_travel = {}

if NpcSystem == nil then
	-- Loads the underlying classes of the npcsystem.
	dofile('data/npclib/npc_system/keyword_handler.lua')
	dofile('data/npclib/npc_system/npc_handler.lua')
	dofile('data/npclib/npc_system/modules.lua')

	-- Global npc constants:

	-- Greeting and unGreeting keywords. For more information look at the top of modules.lua
	FOCUS_GREETWORDS = {'hi', 'hello'}
	FOCUS_FAREWELLWORDS = {'bye', 'farewell'}

	-- The word for requesting trade window. For more information look at the top of modules.lua
	SHOP_TRADEREQUEST = {'trade'}

	-- The word for accepting/declining an offer. CAN ONLY CONTAIN ONE FIELD! For more information look at the top of modules.lua
	SHOP_YESWORD = {'yes'}
	SHOP_NOWORD = {'no'}

	-- Talkdelay behavior. For more information, look at the top of npchandler.lua.
	NPCHANDLER_TALKDELAY = TALKDELAY_ONTHINK

	-- Constant strings defining the keywords to replace in the default messages.
	--	For more information, look at the top of npchandler.lua...
	TAG_PLAYERNAME = '|PLAYERNAME|'
	TAG_ITEMCOUNT = '|ITEMCOUNT|'
	TAG_TOTALCOST = '|TOTALCOST|'
	TAG_ITEMNAME = '|ITEMNAME|'
	TAG_TIME = '|TIME|'
	TAG_BLESSCOST = '|BLESSCOST|'
	TAG_PVPBLESSCOST = '|PVPBLESSCOST|'
	TAG_TRAVELCOST = '|TRAVELCOST|'

	NpcSystem = {}
end
