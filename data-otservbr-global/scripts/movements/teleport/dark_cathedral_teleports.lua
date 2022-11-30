local config = {
	{leverpos = Position(32645, 32465, 9)},
	{leverpos = Position(32647, 32483, 9)},
	{leverpos = Position(32619, 32523, 9)},
	{leverpos = Position(32610, 32523, 9)},
	{leverpos = Position(32583, 32482, 9)},
	{leverpos = Position(32584, 32465, 9)}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(2773)
	if leverItem then
		leverItem:transform(2772)
	end
end

local lever = Action()
function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2773 then
		player:say("It doesn't move.", TALKTYPE_MONSTER_SAY)
		return true
	end
	addEvent(revertLever, 10 * 60 * 1000, toPosition)
	return item:transform(2773)
end

lever:aid(30004)
lever:register()

local teleport = MoveEvent()
function teleport.onStepIn(player, item, position, fromPosition)
	if not player then
		return true
	end
	for i = 1, #config do
		local table = config[i]
		if item.uid == 35022 then
			player:teleportTo(Position(32615, 32482, 9))
			position:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		elseif Tile(table.leverpos):getItemById(2772) then
			player:teleportTo(fromPosition)
			position:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		elseif i == #config and item.uid == 35021 then
			player:teleportTo(Position(32615, 32485, 10))
			position:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

teleport:type("stepin")
teleport:uid(35021, 35022)
teleport:register()
