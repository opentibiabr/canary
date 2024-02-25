local config = {
	[8894] = { -- heavily rusted armor
		[1] = { id = 3358, chance = 6994 }, -- chain armor
		[2] = { id = 3377, chance = 3952 }, -- scale armor
		[3] = { id = 3359, chance = 1502 }, -- brass armor
		[4] = { id = 3357, chance = 197 }, -- plate armor
	},
	[8895] = { -- rusted armor
		[1] = { id = 3358, chance = 6437 }, -- scale armor
		[2] = { id = 3358, chance = 4606 }, -- chain armor
		[3] = { id = 3359, chance = 3029 }, -- brass armor
		[4] = { id = 3357, chance = 1559 }, -- plate armor
		[5] = { id = 3370, chance = 595 }, -- knight armor
		[6] = { id = 8063, chance = 283 }, -- paladin armor
		[7] = { id = 3381, chance = 49 }, -- crown armor
	},
	[8896] = { -- slightly rusted armor
		[1] = { id = 3359, chance = 6681 }, -- brass armor
		[2] = { id = 3357, chance = 3767 }, -- plate armor
		[3] = { id = 3370, chance = 1832 }, -- knight armor
		[4] = { id = 3381, chance = 177 }, -- crown armor
		[5] = { id = 8063, chance = 31 }, -- paladin armor
		[6] = { id = 3360, chance = 10 }, -- golden armor
	},
	[8897] = { -- heavily rusted legs
		[1] = { id = 3558, chance = 6949 }, -- chain legs
		[2] = { id = 3362, chance = 3692 }, -- studded legs
		[3] = { id = 3372, chance = 1307 }, -- brass legs
		[4] = { id = 3557, chance = 133 }, -- plate legs
	},
	[8898] = { -- rusted legs
		[1] = { id = 3362, chance = 5962 }, -- studded legs
		[2] = { id = 3558, chance = 4037 }, -- chain legs
		[3] = { id = 3372, chance = 2174 }, -- brass legs
		[4] = { id = 3557, chance = 1242 }, -- plate legs
		[5] = { id = 3371, chance = 186 }, -- knight legs
	},
	[8899] = { -- slightly rusted legs
		[1] = { id = 3372, chance = 6500 }, -- brass legs
		[2] = { id = 3557, chance = 3800 }, -- plate legs
		[3] = { id = 3371, chance = 200 }, -- knight legs
		[4] = { id = 3382, chance = 52 }, -- crown legs
		[5] = { id = 3364, chance = 30 }, -- golden legs
	},
	[8902] = { -- slightly rusted shield
		[1] = { id = 3410, chance = 3137 }, -- plate shield
		[2] = { id = 3432, chance = 2887 }, -- ancient shield
		[3] = { id = 7460, chance = 929 }, -- norse shield
		[4] = { id = 3419, chance = 23 }, -- crown shield
		[5] = { id = 3434, chance = 10 }, -- vampire shield
	},
	[8907] = { -- rusted helmet
		[1] = { id = 3354, chance = 2200 }, -- brass helmet
		[2] = { id = 3376, chance = 1870 }, -- studded helmet
		[3] = { id = 3353, chance = 1490 }, -- iron helmet
		[4] = { id = 3351, chance = 1010 }, -- steel helmet
		[5] = { id = 3385, chance = 190 }, -- crown helmet
		[6] = { id = 3391, chance = 10 }, -- crusader helmet
	},
	[8908] = { -- slightly rusted helmet
		[1] = { id = 3353, chance = 3156 }, -- iron helmet
		[2] = { id = 3351, chance = 2976 }, -- steel helmet
		[3] = { id = 3385, chance = 963 }, -- crown helmet
		[4] = { id = 3391, chance = 210 }, -- crusader helmet
		[5] = { id = 3392, chance = 7 }, -- royal helmet
	},
}

local rustRemover = Action()

function rustRemover.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return true
	end

	local randomChance = math.random(10000)
	local index = false

	if targetItem[1].chance >= randomChance then
		while not index do
			local randomIndex = math.random(#targetItem)
			if targetItem[randomIndex].chance >= randomChance then
				index = randomIndex
			end
		end
	end

	if not index then
		local msg = nil
		if table.contains({ 8894, 8895, 8896 }, target.itemid) then
			msg = "The armor was already damaged so badly that it broke when you tried to clean it."
		elseif table.contains({ 8897, 8898, 8899 }, target.itemid) then
			msg = "The legs were already damaged so badly that they broke when you tried to clean them."
		elseif table.contains({ 8902 }, target.itemid) then
			msg = "The shield was already damaged so badly that it broke when you tried to clean it."
		elseif table.contains({ 8907, 8908 }, target.itemid) then
			msg = "The helmet was already damaged so badly that it broke when you tried to clean it."
		end

		player:say(msg, TALKTYPE_MONSTER_SAY)
		target:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		target:remove()
	else
		target:transform(targetItem[index].id)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:addAchievementProgress("Polisher", 1000)
	end

	item:remove(1)
	return true
end

rustRemover:id(9016)
rustRemover:register()
