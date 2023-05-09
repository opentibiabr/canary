local yielothaxKill = CreatureEvent("YielothaxKill")
function yielothaxKill.onKill(cid, target, damage, flags)
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "yielothax") then
			 setGlobalStorageValue(673003, getGlobalStorageValue(673003) + 1)
		end
	end
	return true
end

yielothaxKill:register()
