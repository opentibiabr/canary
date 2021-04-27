local setting = {
	[26138] = {
		storage = Storage.CultsOfTibia.Humans.Decaying,
		max = 10,
		id = 26138,
		text = "You absorb the energetic remains of this decaying soul. Its power is very fragile and fleeting"
	},
	[26140] = {
		storage = Storage.CultsOfTibia.Humans.Vaporized,
		max = 10,
		id = 26140,
		text = "You absorb the energetic remains of this whitering soul. Its power is very fragile and fleeting."
	}
}

local taskTeleport = MoveEvent()

function taskTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.CultsOfTibia.Questline) < 1 then
		player:setStorageValue(Storage.CultsOfTibia.Questline, 1)
	end
	if player:getStorageValue(Storage.CultsOfTibia.Humans.Mission) < 1 then
		player:setStorageValue(Storage.CultsOfTibia.Humans.Mission, 1)
	end

	for index, value in pairs(setting) do
		local teleport = Tile(position):getItemById(index)
		if teleport then
			local storage = (player:getStorageValue(value.storage) < 0 and 0 or player:getStorageValue(value.storage))
			local attribute = teleport:getSpecialAttribute("task") or ''
			if attribute:find(player:getName()) or storage >= value.max then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"The power of these souls is now within you. You cannot absorb any more souls.")
				return false
			end
			attribute = string.format("%s, %s", attribute, player:getName())
			teleport:setSpecialAttribute("task", attribute)
			player:setStorageValue(value.storage, storage + 1)
			player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			teleport:remove()
			player:say(value.text, TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

taskTeleport:type("stepin")
taskTeleport:aid(5580)
taskTeleport:register()
