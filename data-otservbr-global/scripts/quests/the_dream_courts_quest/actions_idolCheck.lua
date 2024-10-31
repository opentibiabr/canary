local altars = {
	[1] = { position = Position(32591, 32629, 9) },
	[2] = { position = Position(32591, 32621, 9) },
	[3] = { position = Position(32602, 32629, 9) },
	[4] = { position = Position(32602, 32621, 9) },
}

local blockedItem = 29300

local function cleanIdols()
	for _, altar in pairs(altars) do
		local checkTile = Tile(altar.position):getItemById(blockedItem)

		if checkTile then
			checkTile:remove(1)
		end
	end
end

local actions_idolCheck = Action()

function actions_idolCheck.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local count = 0

	for _, altar in pairs(altars) do
		local checkTile = Tile(altar.position):getItemById(blockedItem)

		if checkTile then
			count = count + 1
		end
	end

	if count == 4 then
		addEvent(cleanIdols, 1*60*1000)

		local spectators = Game.getSpectators(item:getPosition(), false, true, 12, 12, 12, 12)

		for _, spectator in pairs(spectators) do
			local p = Player(spectator:getId())
			p:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple, 1)
			if p:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Tomb) == 1 and p:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar) == 1 and p:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple) == 1 then
				p:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, 2)
			end
		end

		player:say('REPLACING THE IDOLS FEEDS THE PORTAL BUT DOES NOT FREE ONE FROM THE SACRILEGE OF TAKING THEM AWAY FROM TUKH!', TALKTYPE_MONSTER_SAY)
	end

	return true
end

actions_idolCheck:aid(23107)
actions_idolCheck:register()
