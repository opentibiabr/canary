local config = {
	{ chanceFrom = 0, chanceTo = 38 }, -- nothing
	{ chanceFrom = 39, chanceTo = 2132, itemId = 3035, count = 2 }, -- platinum coin
	{ chanceFrom = 2133, chanceTo = 4187, itemId = 14084, count = 10 }, -- larvae
	{ chanceFrom = 4188, chanceTo = 6040, itemId = 3027, count = 2 }, -- black pearl
	{ chanceFrom = 6041, chanceTo = 7951, itemId = 239, count = 2 }, -- great health potion
	{ chanceFrom = 7952, chanceTo = 9843, itemId = 238, count = 2 }, -- great mana potion
	{ chanceFrom = 9844, chanceTo = 9941, itemId = 9058 }, -- gold ingot
	{ chanceFrom = 9942, chanceTo = 9987, itemId = 14143 }, -- four-leaf clover
	{ chanceFrom = 9988, chanceTo = 10000, itemId = 14089 }, -- hive scythe
}

local gooeyMass = Action()

function gooeyMass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randomChance = math.random(0, 10000)
	for _, rewardItem in ipairs(config) do
		if randomChance >= rewardItem.chanceFrom and randomChance <= rewardItem.chanceTo then
			if rewardItem.itemId then
				local count = rewardItem.count or 1
				player:addItem(rewardItem.itemId, count)
			end

			break
		end
	end

	item:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
	item:remove(1)
	return true
end

gooeyMass:id(14172)
gooeyMass:register()
