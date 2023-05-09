local foods = {
	3577, -- meat
	3582, -- ham
	3592, -- grape
	3585, -- apple
	3600, -- bread
	3601, -- roll
	3607  -- cheese
}

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	if math.random(0, 1) == 1 then
		creature:addItem(foods[math.random(#foods)])
	end

	creature:addItem(foods[math.random(#foods)])
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

spell:name("Food")
spell:words("exevo pan")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_FOOD)
spell:id(42)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(14)
spell:mana(120)
spell:soul(1)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
