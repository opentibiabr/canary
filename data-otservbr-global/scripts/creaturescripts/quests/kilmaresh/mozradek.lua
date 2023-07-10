local mozradek = CreatureEvent("MozradekKill")

function mozradek.onKill(cid, target, damage, flags, corpse)
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "mozradek") then
			for attackerUid, damage in pairs(target:getDamageMap()) do
				local player = Player(attackerUid)
				if player and player:getStorageValue(Storage.Kilmaresh.Twelve.Mozradek) == 1 then
					player:setStorageValue(Storage.Kilmaresh.Twelve.Mozradek, 2)
				end
			end
		end
	end
	return true
end

mozradek:register()
