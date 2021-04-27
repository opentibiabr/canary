local setting = {
	[57531] = {
		vocationId = VOCATION.CLIENT_ID.SORCERER,
		toPosition = {x = 33829, y = 31635, z = 9}
	},
	[57532] = {
		vocationId = VOCATION.CLIENT_ID.DRUID,
		toPosition = {x = 33831, y = 31635, z = 9}
	},
	[57533] = {
		vocationId = VOCATION.CLIENT_ID.PALADIN,
		toPosition = {x = 33833, y = 31635, z = 9}
	},
	[57534] = {
		vocationId = VOCATION.CLIENT_ID.KNIGHT,
		toPosition = {x = 33835, y = 31635, z = 9}
	}
}

local tpvoc = MoveEvent()

function tpvoc.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local vocation = setting[item.actionid]
	if not vocation then
		return true
	end

	if player:getVocation():getClientId() == vocation.vocationId then
		player:teleportTo(vocacoes.toPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo({x = 33822, y = 31645, z = 9})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

for key = 57531, 57534 do
	tpvoc:aid(key)
end

tpvoc:register()
