local hirelingLogoutPlayer = CreatureEvent("HirelingLogoutPlayer")
function hirelingLogoutPlayer.onLogout(player)
	player:copyHirelingStorageToCache()
	return true
end
hirelingLogoutPlayer:register()
