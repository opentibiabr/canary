local juliusmap = Action()
local STORAGE_MAPMARKS = Storage.Quest.U8_4.BloodBrothers.MapMarks
local STORAGE_CASTLE_ENTRANCE = Storage.Quest.U8_4.BloodBrothers.MapMarks_CastleEntrance
local STORAGE_MARK_BLACKGAP = Storage.Quest.U8_4.BloodBrothers.MapMarks_BlackGap
local STORAGE_MARK_BONETOTEMS = Storage.Quest.U8_4.BloodBrothers.MapMarks_BoneTotems
local STORAGE_MARK_HAUNTED = Storage.Quest.U8_4.BloodBrothers.MapMarks_HauntedRuins
local STORAGE_MARK_LONELYGRAVE = Storage.Quest.U8_4.BloodBrothers.MapMarks_LonelyGrave
local STORAGE_MARK_BURNINGTREES = Storage.Quest.U8_4.BloodBrothers.MapMarks_BurningTrees
local STORAGE_MARK_OLDSHRINE = Storage.Quest.U8_4.BloodBrothers.MapMarks_OldShrine
local STORAGE_MARK_CASTLEGARDEN = Storage.Quest.U8_4.BloodBrothers.MapMarks_CastleGarden

local locations = {
	{
		name = "Black Gap",
		from = Position(32943, 31517, 7),
		to = Position(32951, 31524, 7),
		markStorage = STORAGE_MARK_BLACKGAP,
	},
	{
		name = "Bone Totems",
		from = Position(32940, 31492, 7),
		to = Position(32944, 31496, 7),
		markStorage = STORAGE_MARK_BONETOTEMS,
	},
	{
		name = "Haunted Ruins",
		from = Position(32911, 31487, 7),
		to = Position(32916, 31492, 7),
		markStorage = STORAGE_MARK_HAUNTED,
	},
	{
		name = "Lonely Grave",
		from = Position(32902, 31468, 7),
		to = Position(32906, 31470, 7),
		markStorage = STORAGE_MARK_LONELYGRAVE,
	},
	{
		name = "Burning Trees",
		from = Position(32880, 31497, 7),
		to = Position(32884, 31502, 7),
		markStorage = STORAGE_MARK_BURNINGTREES,
	},
	{
		name = "Old Shrine",
		from = Position(32932, 31561, 4),
		to = Position(32934, 31563, 4),
		markStorage = STORAGE_MARK_OLDSHRINE,
	},
	{
		name = "Castle Garden",
		from = Position(32963, 31495, 6),
		to = Position(32966, 31498, 6),
		markStorage = STORAGE_MARK_CASTLEGARDEN,
	},
	{
		name = "Castle Entrance",
		from = Position(32951, 31486, 6),
		to = Position(32955, 31488, 6),
		markStorage = STORAGE_CASTLE_ENTRANCE,
	},
}

local function isInsideZone(pos, from, to)
	return pos.x >= from.x and pos.x <= to.x and pos.y >= from.y and pos.y <= to.y and pos.z == from.z
end

local function getLocationForPlayer(playerPos)
	for _, loc in ipairs(locations) do
		if isInsideZone(playerPos, loc.from, loc.to) then
			return loc
		end
	end
	return nil
end

function juliusmap.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.VengothAccess) ~= 1 then
		return true
	end
	local playerPos = player:getPosition()
	local loc = getLocationForPlayer(playerPos)
	if not loc then
		return true
	end
	if player:getStorageValue(loc.markStorage) == 1 then
		player:say("You have already marked this location on the map.", TALKTYPE_MONSTER_SAY)
		return true
	end
	player:setStorageValue(loc.markStorage, 1)
	player:setStorageValue(STORAGE_MAPMARKS, (player:getStorageValue(STORAGE_MAPMARKS) or 0) + 1)
	player:say("You marked the " .. loc.name .. ".", TALKTYPE_MONSTER_SAY)
	return true
end

juliusmap:id(8200)
juliusmap:register()
