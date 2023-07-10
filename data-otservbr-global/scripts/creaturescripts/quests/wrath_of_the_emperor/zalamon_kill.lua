local bossForms = {
	['snake god essence'] = {
		text = 'IT\'S NOT THAT EASY MORTALS! FEEL THE POWER OF THE GOD!',
		newForm = 'snake thing'
	},
	['snake thing'] = {
		text = 'NOOO! NOW YOU HERETICS WILL FACE MY GODLY WRATH!',
		newForm = 'lizard abomination'
	},
	['lizard abomination'] = {
		text = 'YOU ... WILL ... PAY WITH ETERNITY ... OF AGONY!',
		newForm = 'mutated zalamon'
	}
}

local zalamonKill = CreatureEvent("ZalamonKill")
function zalamonKill.onKill(player, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() == 'mutated zalamon' then
		Game.setStorageValue(Storage.WrathoftheEmperor.Mission11, -1)
		return true
	end

	local name = targetMonster:getName():lower()
	local bossConfig = bossForms[name]
	if not bossConfig then
		return true
	end

	local found = false
	for k, v in ipairs(Game.getSpectators(targetMonster:getPosition())) do
		if v:getName():lower() == bossConfig.newForm then
			found = true
			break
		end
	end

	if not found then
		Game.createMonster(bossConfig.newForm, targetMonster:getPosition(), false, true)
		player:say(bossConfig.text, TALKTYPE_MONSTER_SAY)
	end
	return true
end

zalamonKill:register()
