local ferumbrasAscendantBoneFlute = Action()
function ferumbrasAscendantBoneFlute.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target:isItem() then
		return false
	end
	if player:getStorageValue(Storage.FerumbrasAscension.BoneFlute) >= 1 then
		return false
	end
	if not isInRange(target:getPosition(), Position(33477, 32775, 11), Position(33493, 32781, 11)) then
		return false
	end
	if target:getName():lower() == 'snake' or target:getName():lower() == 'lion' or target:getName():lower() == 'bear' or target:getName():lower() == 'seagull' or target:getName():lower() == 'pig'  then
		local rand = math.random(100)
		if rand <= 5 then
			player:say('Finally this one reveal your spirit animal.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.FerumbrasAscension.BoneFlute, 1)
			item:remove()
			return true
		elseif rand > 5 and rand <= 50 then
			player:say('This one has shaken its head. This probably means it\'s not your spirit animal.', TALKTYPE_MONSTER_SAY)
			return true
		elseif rand > 50 then
			player:say('This one\'s still unwilling reveal whether it\'s your spirit animal.', TALKTYPE_MONSTER_SAY)
			return true
		end
	end
	return true
end

ferumbrasAscendantBoneFlute:id(24910)
ferumbrasAscendantBoneFlute:register()