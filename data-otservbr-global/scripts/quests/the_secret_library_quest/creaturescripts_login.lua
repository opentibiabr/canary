local creaturescripts_library_login = CreatureEvent("loginLibrary")

function creaturescripts_library_login.onLogin(player)
	player:registerEvent("killingLibrary")
	return true
end

creaturescripts_library_login:register()
