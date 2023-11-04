local loginEvents = CreatureEvent("LoginEvents")
function loginEvents.onLogin(player)
	local events = {
		--Others
		"AdvanceSave",
		"BossParticipation",
		"DropLoot",
		"PlayerDeath",
		"RookgaardAdvance",
		"FamiliarLogin",
		"FamiliarAdvance",
		--Quests
		--Cults Of Tibia Quest
		"LeidenHeal",
		"HealthPillar",
		"YalahariHealth",
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end
	return true
end

loginEvents:register()
