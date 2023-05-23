local bragrumol = CreatureEvent("BragrumolKill")

function bragrumol.onKill(cid, target, damage, flags, corpse)
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "bragrumol") then
			for attackerUid, damage in pairs(target:getDamageMap()) do
				local player = Player(attackerUid)
				if player and player:getStorageValue(Storage.Kilmaresh.Twelve.Bragrumol) == 1 then
					player:setStorageValue(Storage.Kilmaresh.Twelve.Bragrumol, 2)
				end
			end
		end
	end
	return true
end

bragrumol:register()
