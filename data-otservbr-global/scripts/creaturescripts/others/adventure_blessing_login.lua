dofile(CORE_DIRECTORY .. "/modules/scripts/blessings/blessings.lua")

local adventurerBlessingLogin = CreatureEvent("AdventurerBlessingLogin")
function adventurerBlessingLogin.onLogin(player)
	return Blessings.doAdventurerBlessing(player)
end

adventurerBlessingLogin:register()
