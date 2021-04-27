local crystalDuration = 5 * 60 -- 5 minutes

local crystals = {
	-- Warzone IV
	[57350] = Storage.DangerousDepths.Crystals.WarzoneVI.MediumCrystal1,
	[57351] = Storage.DangerousDepths.Crystals.WarzoneVI.BigCrystal1,
	[57352] = Storage.DangerousDepths.Crystals.WarzoneVI.BigCrystal2,
	[57353] = Storage.DangerousDepths.Crystals.WarzoneVI.MediumCrystal2,
	[57354] = Storage.DangerousDepths.Crystals.WarzoneVI.SmallCrystal1,
	[57355] = Storage.DangerousDepths.Crystals.WarzoneVI.SmallCrystal2,

	-- Warzone V
	[57356] = Storage.DangerousDepths.Crystals.WarzoneV.BigCrystal1,
	[57357] = Storage.DangerousDepths.Crystals.WarzoneIV.MediumCrystal1,
	[57358] = Storage.DangerousDepths.Crystals.WarzoneV.BigCrystal2,
	[57359] = Storage.DangerousDepths.Crystals.WarzoneIV.MediumCrystal2,
	[57360] = Storage.DangerousDepths.Crystals.WarzoneV.SmallCrystal1,
	[57361] = Storage.DangerousDepths.Crystals.WarzoneV.SmallCrystal2,

	-- Warzone IV
	[57362] = Storage.DangerousDepths.Crystals.WarzoneIV.BigCrystal1,
	[57363] = Storage.DangerousDepths.Crystals.WarzoneIV.MediumCrystal1,
	[57364] = Storage.DangerousDepths.Crystals.WarzoneIV.BigCrystal2,
	[57365] = Storage.DangerousDepths.Crystals.WarzoneIV.MediumCrystal2,
	[57366] = Storage.DangerousDepths.Crystals.WarzoneIV.SmallCrystal1,
	[57367] = Storage.DangerousDepths.Crystals.WarzoneIV.SmallCrystal2,
}

local crystalsChance = {
	[30738] = 1, -- Large Crystal
	[30740] = 5, -- Medium Crystal
	[17017] = 5, -- Medium Crystal
	[32405] = 7, -- Small Crystal
}

local function createCrystal(crystalId, player)
	local crystalChance = crystalsChance[crystalId]
	if not crystalChance then
		return false
	end

	local chance = math.random(10)
	local itemId = chance <= crystalChance and 18554 or 31993

	local item = Game.createItem(itemId, 1)
	local ret = player:addItemEx(item)
	if ret ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage(Game.getReturnMessage(ret))
		return false
	end

	return true
end

local dangerousDepthWarzoneCrystals = Action()
function dangerousDepthWarzoneCrystals.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local crystalTimer = crystals[item:getActionId()]
	if not crystalTimer or crystalTimer > os.time() then
		return true
	end

	local itemId = item:getId()
	local crystal = createCrystal(itemId, player)
	if crystal then
		player:setStorageValue(crystalTimer, os.time() + crystalDuration)
	end

	return true
end

for value = 57350, 57367 do
	dangerousDepthWarzoneCrystals:aid(value)
end
dangerousDepthWarzoneCrystals:register()