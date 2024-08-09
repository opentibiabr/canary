local bossForms = {
	["snake god essence"] = {
		text = "IT'S NOT THAT EASY MORTALS! FEEL THE POWER OF THE GOD!",
		newForm = "snake thing",
	},
	["snake thing"] = {
		text = "NOOO! NOW YOU HERETICS WILL FACE MY GODLY WRATH!",
		newForm = "lizard abomination",
	},
	["lizard abomination"] = {
		text = "YOU ... WILL ... PAY WITH ETERNITY ... OF AGONY!",
		newForm = "mutated zalamon",
	},
}

local zalamonKill = CreatureEvent("ZalamonDeath")
function zalamonKill.onDeath(creature)
	if creature:getName():lower() == "mutated zalamon" then
		Game.setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission11, -1)
		return true
	end

	local name = creature:getName():lower()
	local bossConfig = bossForms[name]
	if not bossConfig then
		return true
	end

	local found = false
	for k, v in ipairs(Game.getSpectators(creature:getPosition())) do
		if v:getName():lower() == bossConfig.newForm then
			found = true
			break
		end
	end

	if not found then
		local monster = Game.createMonster(bossConfig.newForm, creature:getPosition(), false, true)
		if monster then
			monster:say(bossConfig.text, TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

zalamonKill:register()
