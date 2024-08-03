local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	local position = player:getPosition()
	local monsterName = variant:getString()
	local monsterType = MonsterType(monsterName)

	if not monsterType then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not player:hasFlag(PlayerFlag_CanSummonAll) then
		if not monsterType:isSummonable() then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			position:sendMagicEffect(CONST_ME_POFF)
			return false
		end

		if #player:getSummons() >= 2 then
			player:sendCancelMessage("You cannot summon more creatures.")
			position:sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	local manaCost = monsterType:getManaCost()
	if player:getMana() < manaCost and not player:hasFlag(PlayerFlag_HasInfiniteMana) then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local summon = Game.createMonster(monsterName, position, true, false, player)
	if not summon then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	player:addMana(-manaCost)
	player:addManaSpent(manaCost)
	position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	summon:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

spell:group("support")
spell:id(9)
spell:name("Summon Creature")
spell:words("utevo res")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_CREATURE)
spell:level(25)
spell:hasParams(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "sorcerer;true", "elder druid;true", "master sorcerer;true")
spell:register()
