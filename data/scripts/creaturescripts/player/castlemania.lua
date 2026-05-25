local Castlemania = CreatureEvent("Castlemania")

function Castlemania.onLogin(player)
	if not player or not player:isPlayer() then
		return true
	end

	if player:hasAchievement("Castlemania") then
		return true
	end

	local BB = Storage.Quest.U8_4.BloodBrothers
	local VH = Storage.Quest.U8_2.VampireHunterQuest

	if player:getStorageValue(BB.Mission10) < 2 then
		return true
	end

	if player:getStorageValue(BB.DiarySTG) < 6 then
		return true
	end

	local mapMarks = {
		BB.MapMarks_BlackGap,
		BB.MapMarks_BoneTotems,
		BB.MapMarks_HauntedRuins,
		BB.MapMarks_LonelyGrave,
		BB.MapMarks_BurningTrees,
		BB.MapMarks_OldShrine,
		BB.MapMarks_CastleGarden,
		BB.MapMarks_CastleEntrance,
	}

	for _, mark in pairs(mapMarks) do
		if player:getStorageValue(mark) ~= 1 then
			return true
		end
	end

	if player:getStorageValue(BB.BloodGoblet) ~= 1 then
		return true
	end

	if player:getStorageValue(VH.BloodSkull) ~= 1 then
		return true
	end

	player:addAchievement("Castlemania")

	return true
end

Castlemania:register()
