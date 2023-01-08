local config = {
	{
		fromPosition = Position(32677, 32089, 8),
		toPosition = Position(32671, 32071, 8),
		sacrificePosition = Position(32679, 32089, 8),
		sacrificeId = 3059,
		vocationId = VOCATION.BASE_ID.SORCERER
	},
	{
		fromPosition = Position(32669, 32089, 8),
		toPosition = Position(32673, 32071, 8),
		sacrificePosition = Position(32667, 32089, 8),
		sacrificeId = 3585,
		vocationId = VOCATION.BASE_ID.DRUID
	},
	{
		fromPosition = Position(32673, 32085, 8),
		toPosition = Position(32670, 32071, 8),
		sacrificePosition = Position(32673, 32083, 8),
		sacrificeId = 3349,
		vocationId = VOCATION.BASE_ID.PALADIN
	},
	{
		fromPosition = Position(32673, 32093, 8),
		toPosition = Position(32672, 32071, 8),
		sacrificePosition = Position(32673, 32094, 8),
		sacrificeId = 3264,
		vocationId = VOCATION.BASE_ID.KNIGHT
	}
}

local othersDesert = Action()
function othersDesert.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 2772 and 2773 or 2772)

	if item.itemid ~= 2772 then
		return true
	end

	local position = player:getPosition()

	local players = {}
	for i = 1, #config do
		local creature = Tile(config[i].fromPosition):getTopCreature()
		if not creature or not creature:isPlayer() then
			player:sendCancelMessage('You need one player of each vocation for this quest.')
			position:sendMagicEffect(CONST_ME_POFF)
			return true
		end

		local vocationId = creature:getVocation():getBaseId()
		if vocationId ~= config[i].vocationId then
			player:sendCancelMessage('You need one player of each vocation for this quest.')
			position:sendMagicEffect(CONST_ME_POFF)
			return true
		end

		local sacrificeItem = Tile(config[i].sacrificePosition):getItemById(config[i].sacrificeId)
		if not sacrificeItem then
			player:sendCancelMessage(creature:getName() .. ' is missing ' .. (creature:getSex() == PLAYERSEX_FEMALE and 'her' or 'his') .. ' sacrifice on the altar.')
			position:sendMagicEffect(CONST_ME_POFF)
			return true
		end

		players[#players + 1] = creature
	end

	for i = 1, #players do
		local sacrificeItem = Tile(config[i].sacrificePosition):getItemById(config[i].sacrificeId)
		if sacrificeItem then
			sacrificeItem:remove()
		end

		players[i]:getPosition():sendMagicEffect(CONST_ME_POFF)
		players[i]:teleportTo(config[i].toPosition)
		config[i].toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

othersDesert:uid(1912)
othersDesert:register()