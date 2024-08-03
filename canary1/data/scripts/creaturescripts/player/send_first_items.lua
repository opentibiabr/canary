local config = {
	[VOCATION.ID.NONE] = {
		container = {
			{ 3003, 1 }, -- rope
			{ 3457, 1 }, -- shovel
		},
	},

	[VOCATION.ID.SORCERER] = {
		items = {
			{ 3059, 1 }, -- spellbook
			{ 3074, 1 }, -- wand of vortex
			{ 7991, 1 }, -- magician's robe
			{ 7992, 1 }, -- mage hat
			{ 3362, 1 }, -- studded legs
			{ 3552, 1 }, -- leather boots
			{ 3572, 1 }, -- scarf
		},

		container = {
			{ 3003, 1 }, -- rope
			{ 5710, 1 }, -- light shovel
			{ 268, 10 }, -- mana potion
		},
	},

	[VOCATION.ID.DRUID] = {
		items = {
			{ 3059, 1 }, -- spellbook
			{ 3066, 1 }, -- snakebite rod
			{ 7991, 1 }, -- magician's robe
			{ 7992, 1 }, -- mage hat
			{ 3362, 1 }, -- studded legs
			{ 3552, 1 }, -- leather boots
			{ 3572, 1 }, -- scarf
		},

		container = {
			{ 3003, 1 }, -- rope
			{ 5710, 1 }, -- light shovel
			{ 268, 10 }, -- mana potion
		},
	},

	[VOCATION.ID.PALADIN] = {
		items = {
			{ 3425, 1 }, -- dwarven shield
			{ 3277, 1 }, -- spear
			{ 3571, 1 }, -- ranger's cloak
			{ 8095, 1 }, -- ranger legs
			{ 3552, 1 }, -- leather boots
			{ 3572, 1 }, -- scarf
			{ 3374, 1 }, -- legion helmet
		},

		container = {
			{ 3003, 1 }, -- rope
			{ 5710, 1 }, -- light shovel
			{ 266, 10 }, -- health potion
			{ 3350, 1 }, -- bow
			{ 3447, 50 }, -- 50 arrows
		},
	},

	[VOCATION.ID.KNIGHT] = {
		items = {
			{ 3425, 1 }, -- dwarven shield
			{ 7773, 1 }, -- steel axe
			{ 3359, 1 }, -- brass armor
			{ 3354, 1 }, -- brass helmet
			{ 3372, 1 }, -- brass legs
			{ 3552, 1 }, -- leather boots
			{ 3572, 1 }, -- scarf
		},

		container = {
			{ 7774, 1 }, -- jagged sword
			{ 3327, 1 }, -- daramanian mace
			{ 3003, 1 }, -- rope
			{ 5710, 1 }, -- light shovel
			{ 266, 10 }, -- health potion
		},
	},
}

local sendFirstItems = CreatureEvent("SendFirstItems")

function sendFirstItems.onLogin(player)
	local targetVocation = config[player:getVocation():getId()]
	if not targetVocation or player:getLastLoginSaved() ~= 0 then
		return true
	end

	if targetVocation.items then
		for i = 1, #targetVocation.items do
			player:addItem(targetVocation.items[i][1], targetVocation.items[i][2])
		end
	end

	local backpack = player:addItem(2854)
	if not backpack then
		return true
	end

	if targetVocation.container then
		for i = 1, #targetVocation.container do
			backpack:addItem(targetVocation.container[i][1], targetVocation.container[i][2])
		end
	end
	return true
end

sendFirstItems:register()
