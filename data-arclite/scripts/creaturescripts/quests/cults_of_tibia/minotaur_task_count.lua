local minotaurTask = CreatureEvent("MinotaurTask")
function minotaurTask.onKill(creature, target)
	if not creature or not creature:isPlayer() then
		return true
	end

	if not target or not target:isMonster() then
		return true
	end

	local storage = creature:getStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask)
	if(isInArray({'minotaur cult follower', 'minotaur cult zealot', 'minotaur cult prophet'}, target:getName():lower()) and storage >= 0 and storage < 50)then
		creature:setStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask, storage + 1)
	end
	return true
end

minotaurTask:register()
