local setting = {
	[50510] = {position = Position(33459, 31715, 9), message = 'Slrrp!', premium = false}, --entrance
	[50511] = {position = Position(33668, 31887, 5), message = 'Slrrp!', premium = false}, --exit

	[50512] = {position = Position(31254, 32604, 9), message = 'Slrrp!', premium = false}, --minos entrance
	[50513] = {position = Position(31061, 32605, 9), message = 'Slrrp!', premium = false}, --golens entrance

	[50514] = {position = Position(33668, 31887, 5), message = 'Slrrp!', premium = false}, --minos exit
	[50515] = {position = Position(33668, 31887, 5), message = 'Slrrp!', premium = false}, --golens exit

	[50624] = {position = Position(33668, 31887, 5), message = 'Slrrp!', premium = false}, --minos exit
	[50625] = {position = Position(33668, 31887, 5), message = 'Slrrp!', premium = false}, --golens exit
}

local oramondTeleports = MoveEvent()

function oramondTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[item.uid]
	if teleport then
		if not player:isPremium() and teleport.premium then
			player:teleportTo(fromPosition)
			player:sendCancelMessage("You need a premium account to access this area.")
			fromPosition:sendMagicEffect(CONST_ME_POFF)
			return true
		end

		player:teleportTo(teleport.position)
		item:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
		player:say(teleport.message, TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

oramondTeleports:type("stepin")

for index, value in pairs(setting) do
	oramondTeleports:uid(index)
end

oramondTeleports:register()
