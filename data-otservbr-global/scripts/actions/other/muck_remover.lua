local config = {
	{from = 1, to = 1644, itemId = 16100},
	{from = 1645, to = 3189, itemId = 3041},
	{from = 3190, to = 4725, itemId = 16097},
	{from = 4726, to = 6225, itemId = 16120, count = 5},
	{from = 6226, to = 7672, itemId = 16124, count = 10},
	{from = 7673, to = 9083, itemId = 16119, count = 10},
	{from = 9084, to = 9577, itemId = 3333},
	{from = 9578, to = 9873, itemId = 8050},
	{from = 9874, to = 9999, itemId = 16160}
}

local muckRemover = Action()

function muckRemover.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 16102 then
		return false
	end

	local chance, randomItem = math.random(9999)
	for i = 1, #config do
		randomItem = config[i]
		if chance >= randomItem.from and chance <= randomItem.to then
			if toPosition.x == CONTAINER_POSITION then
				target:getParent():addItem(randomItem.itemId, randomItem.count or 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
			else
				Game.createItem(randomItem.itemId, randomItem.count or 1, toPosition)
			end

			target:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
			target:remove(1)

			item:remove(1)
			break
		end
	end
	return true
end

muckRemover:id(16101)
muckRemover:register()
