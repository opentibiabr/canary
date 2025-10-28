local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_REGENERATION)
condition:setParameter(CONDITION_PARAM_SUBID, 3)
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
condition:setParameter(CONDITION_PARAM_TICKS, 5 * 60 * 1000)
condition:setParameter(CONDITION_PARAM_MANAGAIN, 5)
condition:setParameter(CONDITION_PARAM_MANATICKS, 2000)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local position = creature:getPosition()
	local party = creature:getParty()

	if not party then
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local members = party:getMembers()
	table.insert(members, party:getLeader())

	local affected = {}
	for _, member in ipairs(members) do
		if member:getPosition():getDistance(position) <= 36 then
			table.insert(affected, member)
		end
	end

	if #affected <= 1 then
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not combat:execute(creature, var) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	for _, member in ipairs(affected) do
		member:addCondition(condition)
		member:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end

	return true
end

spell:group("support")
spell:id(278)
spell:name("Enlighten Party")
spell:words("utevo mas sio")
spell:level(32)
spell:mana(75)
spell:isPremium(false)
spell:needLearn(false)
spell:cooldown(5 * 60 * 1000)
spell:groupCooldown(1 * 1000)
spell:isSelfTarget(true)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
