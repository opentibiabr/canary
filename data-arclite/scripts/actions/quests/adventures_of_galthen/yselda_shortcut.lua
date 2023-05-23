local config = {
	{position = {x = 32419, y = 32458, z = 7}, destination = {x = 32528, y = 32489, z = 11}},
	{position = {x = 32528, y = 32488, z = 11}, destination = {x = 32418, y = 32458, z = 7}}
}

local entranceYselda = Action()
function entranceYselda.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(Storage.Quest.U12_70.AdventuresOfGalthen.MegasylvanYseldaTimer) < 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This root seems to thicken and wreathe the moment you try to grab it.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == item:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for value in pairs(config) do
	entranceYselda:position(config[value].position)
end
entranceYselda:register()