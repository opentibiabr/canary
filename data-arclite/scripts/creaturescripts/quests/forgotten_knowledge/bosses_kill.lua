local bosses = {
	-- bosses
	["lady tenebris"] = {storage = Storage.ForgottenKnowledge.LadyTenebrisKilled},
	["the enraged thorn knight"] = {storage = Storage.ForgottenKnowledge.ThornKnightKilled},
	["lloyd"] = {storage = Storage.ForgottenKnowledge.LloydKilled},
	["soul of dragonking zyrtarch"] = {storage = Storage.ForgottenKnowledge.DragonkingKilled},
	["melting frozen horror"] = {storage = Storage.ForgottenKnowledge.HorrorKilled},
	["the time guardian"] = {storage = Storage.ForgottenKnowledge.TimeGuardianKilled},
	["the blazing time guardian"] = {storage = Storage.ForgottenKnowledge.TimeGuardianKilled},
	["the freezing time guardian"] = {storage = Storage.ForgottenKnowledge.TimeGuardianKilled},
	["the last lore keeper"] = {storage = Storage.ForgottenKnowledge.LastLoreKilled},
	-- IA interactions
	["an astral glyph"] = {}
}

local bossesForgottenKill = CreatureEvent("BossesForgottenKill")
function bossesForgottenKill.onKill(creature, target)
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
				attackerPlayer:setStorageValue(bossConfig.storage, os.time() + 20 * 3600)
			elseif targetMonster:getName():lower() == "the enraged thorn knight" then
				attackerPlayer:setStorageValue(Storage.ForgottenKnowledge.PlantCounter, 0)
				attackerPlayer:setStorageValue(Storage.ForgottenKnowledge.BirdCounter, 0)
			elseif targetMonster:getName():lower() == "melting frozen horror" then
				local egg = Tile(Position(32269, 31084, 14)):getTopCreature()
				if egg then
					local pos = egg:getPosition()
					egg:remove()
					Game.createMonster("baby dragon", pos, true, true)
				end
				local horror = Tile(Position(32267, 31071, 14)):getTopCreature()
				if horror then
					horror:remove()
				end
			end
		end
	end
	return true
end
bossesForgottenKill:register()
