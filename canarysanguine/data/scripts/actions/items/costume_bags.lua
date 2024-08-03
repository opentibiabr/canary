local config = {
	[653] = { "orc warrior", "pirate cutthroat", "dworc voodoomaster", "dwarf guard", "minotaur mage", "ogre shaman", "ogre brute", "rat" },
	[654] = { "quara hydromancer", "diabolic imp", "banshee", "frost giant", "lich", "vexclaw", "grimeleech", "hellflayer", "ogre shaman", "ogre brute", "pig" },
	[655] = { "serpent spawn", "demon", "juggernaut", "behemoth", "ashmunrah", "vexclaw", "grimeleech", "hellflayer", "black sheep" },
	[24949] = { "old beholder", "old bug", "old wolf", "old giant spider" },
}

local costumeBags = Action()

function costumeBags.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local creatures = config[item.itemid]
	if not creatures then
		return true
	end

	player:setMonsterOutfit(creatures[math.random(#creatures)], 5 * 60 * 10 * 1000)
	player:addAchievementProgress("Masquerader", 100)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	item:remove()
	return true
end

for k, v in pairs(config) do
	costumeBags:id(k)
end

costumeBags:register()
