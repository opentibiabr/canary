local xogixath = CreatureEvent("XogixathKill")

function xogixath.onKill(cid, target, damage, flags, corpse)
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "xogixath") then
			for attackerUid, damage in pairs(target:getDamageMap()) do
				local player = Player(attackerUid)
				if player and player:getStorageValue(Storage.Kilmaresh.Twelve.Xogixath) == 1 then
					player:setStorageValue(Storage.Kilmaresh.Twelve.Xogixath, 2)
				end
			end
		end
	end
	return true
end

xogixath:register()
