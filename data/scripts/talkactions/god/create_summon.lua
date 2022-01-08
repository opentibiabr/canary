local createSummon = TalkAction("/s")

function createSummon.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local position = player:getPosition()
	local summon = Game.createMonster(param, position, true, false, player)
	if not summon then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if summon:getOutfit().lookType == 0 then
		summon:setOutfit({lookType = player:getFamiliarLooktype()})
	end
	return false
end

createSummon:separator(" ")
createSummon:register()
