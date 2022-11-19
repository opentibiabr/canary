local monster = {
	['burning gladiator'] = Storage.Kilmaresh.Thirteen.Fafnar,
	['priestess of the wild sun'] = Storage.Kilmaresh.Thirteen.Fafnar
}

local fafnar = CreatureEvent("FafnarKill")

function fafnar.onKill(creature, target)
	local storage = monster[target:getName():lower()]
	if target:isPlayer() or target:getMaster() or not storage then
		return false
	end

	local kills = creature:getStorageValue(storage)
	if kills == 300 and creature:getStorageValue(storage) == 1 then
		creature:say('You slayed ' .. target:getName() .. '.', TALKTYPE_MONSTER_SAY)
	else
		kills = kills + 1
		creature:say('You have slayed ' .. target:getName() .. ' '.. kills ..' times!', TALKTYPE_MONSTER_SAY)
		creature:setStorageValue(storage, kills)
	end
	return true
end

fafnar:register()
