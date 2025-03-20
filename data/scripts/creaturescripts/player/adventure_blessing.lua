dofile(CORE_DIRECTORY .. "/libs/systems/blessing.lua")

local adventurerBlessingLogin = CreatureEvent("AdventurerBlessingLogin")

function adventurerBlessingLogin.onLogin(player)
	return Blessings.doAdventurerBlessing(player)
end

adventurerBlessingLogin:register()
