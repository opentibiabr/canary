local forge = TalkAction("/fiendish")

function forge.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local monster = Monster(ForgeMonster:pickFiendish())
	player:teleportTo(monster:getPosition())
	return false
end

forge:register()
