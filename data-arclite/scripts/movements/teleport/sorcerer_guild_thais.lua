local sorcererGuildThais = MoveEvent()

function sorcererGuildThais.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:isSorcerer() then
		return true
	end

	player:teleportTo(Position(32308, 32267, 7))
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return true
end

sorcererGuildThais:type("stepin")
sorcererGuildThais:aid(5555)
sorcererGuildThais:register()
