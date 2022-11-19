local checkTile = CreatureEvent("CheckTile")
function checkTile.onThink(creature, interval)
	if creature:getName():lower() == 'the corruptor of souls' then
		if Game.getStorageValue('CheckTile') < os.time() then
			local pos = creature:getPosition()
			Game.setStorageValue('healthSoul', creature:getHealth())
			creature:remove()
			Game.createMonster('the remorseless corruptor', pos)
		end
	end
	return true
end

checkTile:register()
