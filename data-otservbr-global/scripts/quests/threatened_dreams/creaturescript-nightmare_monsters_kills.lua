local nightmareMonsters = {
	"enfeebled silencer",
	"weakened frazzlemaw",
	"kroazur"
}
local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

local threatenedDreamsNightmareMonstersKills = CreatureEvent("ThreatenedDreamsNightmareMonstersKills")
function threatenedDreamsNightmareMonstersKills.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	if not isInArray(nightmareMonsters, target:getName():lower()) then
		return true
	end

	local enfeebledKills = player:getStorageValue(ThreatenedDreams.Mission02.EnfeebledCount)
	local frazzlemawsKills = player:getStorageValue(ThreatenedDreams.Mission02.FrazzlemawsCount)
	if player:getStorageValue(ThreatenedDreams.Mission02[1]) == 1 then
		player:setStorageValue(ThreatenedDreams.Mission02[1], 1)
		if target:getName():lower() == nightmareMonsters[1] then
			player:setStorageValue(ThreatenedDreams.Mission02.EnfeebledCount, enfeebledKills + 1)
		elseif target:getName():lower() == nightmareMonsters[2] then
			player:setStorageValue(ThreatenedDreams.Mission02.FrazzlemawsCount, frazzlemawsKills + 1)
		elseif target:getName():lower() == nightmareMonsters[3] then
			player:setStorageValue(ThreatenedDreams.Mission02.KroazurKill, 1)
		end
	end
	return true
end

threatenedDreamsNightmareMonstersKills:register()
