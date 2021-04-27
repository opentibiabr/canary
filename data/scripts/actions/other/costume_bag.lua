local setting = {
	-- Common
	[653] = {
		"orc warrior",
		"pirate cutthroat",
		"dworc voodoomaster",
		"dwarf guard",
		"minotaur mage"
	},
	-- Uncommon
	[654] = {
		"quara hydromancer",
		"diabolic imp",
		"banshee",
		"frost giant",
		"lich"
	},
	-- Deluxe
	[655] = {
		"serpent spawn",
		"demon",
		"juggernaut",
		"behemoth",
		"ashmunrah"
	},
}

local costumeBag = Action()

function costumeBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local creatures = setting[item.itemid]
	if not creatures then
		return true
	end
	player:setMonsterOutfit(creatures[math.random(#creatures)], 5 * 60 * 10 * 1000)
	item:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	item:remove()
	return true
end

for index, value in pairs(setting) do
	costumeBag:id(index)
end

costumeBag:register()
