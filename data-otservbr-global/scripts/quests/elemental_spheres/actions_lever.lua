local config = {
	{
		position = Position(33268, 31833, 10),
		itemid = 946,
		toPosition = Position(33268, 31833, 12),
		vocationId = VOCATION.BASE_ID.SORCERER,
	},
	{
		position = Position(33268, 31838, 10),
		itemid = 947,
		toPosition = Position(33267, 31838, 12),
		vocationId = VOCATION.BASE_ID.DRUID,
	},
	{
		position = Position(33266, 31835, 10),
		itemid = 948,
		toPosition = Position(33265, 31835, 12),
		vocationId = VOCATION.BASE_ID.KNIGHT,
	},
	{
		position = Position(33270, 31835, 10),
		itemid = 942,
		toPosition = Position(33270, 31835, 12),
		vocationId = VOCATION.BASE_ID.PALADIN,
	},
}

local elementalSpheresLever = Action()
function elementalSpheresLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 2772 then
		item:transform(2772)
		return true
	end

	if player:getPosition() ~= Position(33270, 31835, 10) then
		return false
	end

	local spectators = Game.getSpectators(Position(33268, 31836, 12), false, true, 30, 30, 30, 30)
	if #spectators > 0 or Game.getStorageValue(Storage.Quest.U8_2.ElementalSpheres.BossRoom) > 0 then
		player:say("Wait for the current team to exit.", TALKTYPE_MONSTER_SAY, false, 0, Position(33268, 31835, 10))
		return true
	end

	local players = {}
	for i = 1, #config do
		local creature = Tile(config[i].position):getTopCreature()
		if not creature or not creature:isPlayer() then
			player:say("You need one player of each vocation having completed the Elemental Spheres quest and also carrying the elemental rare item.", TALKTYPE_MONSTER_SAY, false, 0, Position(33268, 31835, 10))
			return true
		end

		local vocationId = creature:getVocation():getBaseId()
		if vocationId ~= config[i].vocationId or creature:getItemCount(config[i].itemid) < 1 or creature:getStorageValue(Storage.Quest.U8_2.ElementalSpheres.QuestLine) < 1 then
			player:say("You need one player of each vocation having completed the Elemental Spheres quest and also carrying the elemental rare item.", TALKTYPE_MONSTER_SAY, false, 0, Position(33268, 31835, 10))
			return true
		end

		players[#players + 1] = creature
	end

	for i = 1, #players do
		players[i]:teleportTo(config[i].toPosition)
		config[i].position:sendMagicEffect(CONST_ME_TELEPORT)
		config[i].toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	item:transform(item.itemid + 1)
	return true
end

elementalSpheresLever:uid(1010)
elementalSpheresLever:register()
