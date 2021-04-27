function onCastSpell(player, variant)
	local monsterName = variant:getString()
	local monsterType = MonsterType(monsterName)

	if not monsterType then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not getPlayerFlagValue(player, PlayerFlag_CanSummonAll) then
		if not monsterType:isSummonable() then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		if #player:getSummons() >= 2 then
			player:sendCancelMessage("You cannot summon more players.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	local manaCost = monsterType:getManaCost()
	if player:getMana() < manaCost and not getPlayerFlagValue(player, PlayerFlag_HasInfiniteMana) then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local position = player:getPosition()
	local summon = Game.createMonster(monsterName, position, true, false)
	if not summon then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	player:addMana(-manaCost)
	player:addManaSpent(manaCost)
	player:addSummon(summon)
	summon:reload()
	position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	summon:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end
