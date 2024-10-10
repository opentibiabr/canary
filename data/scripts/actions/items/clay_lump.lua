local config = {
	{ chance = { 0.0, 1.1 }, transformId = 10425, description = "This little figurine of Brog, the raging Titan, was skillfully made by |PLAYERNAME|.", achievement = true },
	{ chance = { 1.1, 10.52 }, transformId = 10424, description = "It was made by |PLAYERNAME| and is clearly a little figurine of.. hm, one does not recognise that yet." },
	{ chance = { 10.52, 35.38 }, transformId = 10423, description = "It was made by |PLAYERNAME|, whose potter skills could use some serious improvement." },
	{ chance = { 35.38, 100.0 }, remove = true, sound = "Aw man. That did not work out too well." },
}

local clayLump = Action()

function clayLump.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randomChance = math.random() * 100
	for _, itemConfig in ipairs(config) do
		if randomChance >= itemConfig.chance[1] and randomChance < itemConfig.chance[2] then
			item:getPosition():sendMagicEffect(CONST_ME_POFF)

			if itemConfig.remove then
				item:remove()
			else
				item:transform(itemConfig.transformId)
			end

			if itemConfig.sound then
				player:say(itemConfig.sound, TALKTYPE_MONSTER_SAY, false, player)
			end

			if itemConfig.description then
				item:setDescription(itemConfig.description:gsub("|PLAYERNAME|", player:getName()))
			end

			if itemConfig.achievement then
				player:addAchievement("Clay Fighter")
				player:addAchievementProgress("Clay to Fame", 5)
			end
			break
		end
	end
	return true
end

clayLump:id(10422)
clayLump:register()
