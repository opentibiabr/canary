local transformations = {
	[31509] = 31500,
	[31500] = 31505,
	[31505] = 31513,
	[31513] = 31509,
	[31510] = 31502,
	[31502] = 31506,
	[31506] = 31514,
	[31514] = 31510,
	[31511] = 31503,
	[31503] = 31507,
	[31507] = 31515,
	[31515] = 31511,
	[31512] = 31504,
	[31504] = 31508,
	[31508] = 31516,
	[31516] = 31512,
}

local goldenOutfitDisplay = Action()

function goldenOutfitDisplay.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local newItemID = transformations[item:getId()]
	if not newItemID then
		return true
	end

	if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) == 3 then
		item:transform(newItemID)
		item:getPosition():sendMagicEffect(CONST_ME_EARLY_THUNDER)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need Full Golden Outfit to use it.")
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

for index, value in pairs(transformations) do
	goldenOutfitDisplay:id(index)
end

goldenOutfitDisplay:register()
