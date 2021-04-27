local carpetItems = {
	[25393] = 25392, --rift carpet
	[25392] = 25393, --rift carpet
	[26193] = 26192, --void carpet
	[26192] = 26193, --void carpet
	[26087] = 26109, --yalahahari carpet
	[26109] = 26087, --yalahahari carpet
	[26088] = 26110, --white fur carpet
	[26110] = 26088, --white fur carpet
	[26089] = 26111, --bamboo mat carpet
	[26111] = 26089, --bamboo matr carpet
	[26371] = 26363, --crimson carpet
	[26363] = 26371, --crimson carpet
	[26366] = 26372, --azure carpet
	[26372] = 26366, --azure carpet
	[26367] = 26373, --emerald carpet
	[26373] = 26367, --emerald carpet
	[26368] = 26374, --light parquet carpet
	[26374] = 26368, --light parquet carpet
	[26369] = 26375, --dark parquet carpet
	[26375] = 26369, --dark parquet carpet
	[26370] = 26376, --mable floor
	[26376] = 26370, --marble floor
	[27084] = 27092, --flowery carpet
	[27092] = 27084, --flowery carpet
	[27085] = 27093, --Colourful Carpet
	[27093] = 27085, --Colourful Carpet
	[27086] = 27094, --striped carpet
	[27094] = 27086, --striped carpet
	[27087] = 27095, --fur carpet
	[27095] = 27087, --fur carpet
	[27088] = 27096, --diamond carpet
	[27096] = 27088, --diamond carpet
	[27089] = 27097, --patterned carpet
	[27097] = 27089, --patterned carpet
	[27090] = 27098, --night sky carpet
	[27098] = 27090, --night sky carpet
	[27091] = 27099, --star carpet
	[27099] = 27091, --star carpet
	[29350] = 29351, --verdant carpet
	[29351] = 29350, --verdant carpet
	[29352] = 29353, --shaggy carpet
	[29353] = 29352, --shaggy carpet
	[29355] = 29354, --mystic carpet
	[29354] = 29355, --mystic carpet
	[29356] = 29357, --stone tile
	[29357] = 29356, --stone tile
	[29359] = 29358, --wooden plank
	[29358] = 29359, --wooden plank
	[29386] = 29387, --wheat carpet
	[29387] = 29386, --wheat carpet
	[29388] = 29389, --crested carpet
	[29389] = 29388, --crested carpet
	[29390] = 29391, --decorated carpet
	[29391] = 29390, --decorated carpet
	[36301] = 36303, --tournament carpet
	[36303] = 36301, --tournament carpet
	[36302] = 36304, --sublime tournament carpet
	[36304] = 36302, --sublime tournament carpet
	[40776] = 40777, --grandiose carpet
	[40777] = 40776, --grandiose carpet
}

local carpets = Action()

function carpets.onUse(player, item, fp, target, toPosition, isHotkey)
	local carpet = carpetItems[item.itemid]
	if not carpet then
		return false
	end

	local fromPosition = item:getPosition()
	local tile = Tile(fromPosition)
	if not fromPosition:getTile():getHouse() then
		player:sendTextMessage(MESSAGE_FAILURE, "You may use this only inside a house.")
	elseif tile:getItemCountById(item.itemid) == 1 then
		for k,v in pairs(carpetItems) do
			if tile:getItemCountById(k) > 0 and k ~= item.itemid then
				player:sendCancelMessage(Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
				return true
			end
		end
		item:transform(carpet)
	end
	return true
end

for index, value in pairs(carpetItems) do
	carpets:id(index)
end

carpets:register()
