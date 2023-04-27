local bosses = {
	["brain head"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.BrainHead.Killed},
	["the pale worm"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.ThePaleWorm.Killed},
	["irgix the flimsy"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.IrgixTheFlimsy.Killed},
	["vok the freakish"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.VokTheFreakish.Killed},
	["the unwelcome"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.TheUnwelcome.Killed},
	["the fear feaster"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.TheFearFeaster.Killed},
	["the dread maiden"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.TheDreadMaiden.Killed},
	["unaz the mean"] = {storage = Storage.Quest.FeasterOfSouls.Bosses.UnazTheMean.Killed},
}

local feasterBossKill = CreatureEvent("feasterBossKill")
function feasterBossKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	for key, value in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(key)
		if attackerPlayer then
			if bossConfig.storage then
				attackerPlayer:setStorageValue(bossConfig.storage, 1)
			end
			if attackerPlayer:getStorageValue(Storage.Quest.PoltergeistOutfits.Outfit) == -1 then
				local all = true
				for _, sto in pairs(bosses) do
					if attackerPlayer:getStorageValue(sto.storage) ~= 1 then
						all = false
						break
					end
				end
				if all then
					attackerPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations, you received the Poltergeist Outfit!")
					attackerPlayer:addOutfit(1270)
					attackerPlayer:addOutfit(1271)
					attackerPlayer:setStorageValue(Storage.Quest.PoltergeistOutfits.Outfit, 1)
				end
			end
		end
	end
	return true
end
feasterBossKill:register()
