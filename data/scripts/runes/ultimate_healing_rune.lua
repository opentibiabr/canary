local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 7.3) + 42
	local max = (level / 5) + (maglevel * 12.4) + 90
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	local player = Player(creature)
	if not player then
		return false
	end

	local vocation = player:getVocation():getName():lower()
	if vocation == "exalted monk" then
		player:sendCancelMessage("Your vocation cannot use this rune.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if Monster(var:getNumber(1073762188)) then
		player:sendCancelMessage("Sorry, not possible.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return combat:execute(player, var)
end

rune:id(5)
rune:group("healing")
rune:name("ultimate healing rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_ULTIMATE_HEALING_RUNE)
rune:runeId(3160)
rune:allowFarUse(true)
rune:charges(1)
rune:level(24)
rune:magicLevel(4)
rune:cooldown(1 * 1000)
rune:groupCooldown(1 * 1000)
rune:isAggressive(false)
rune:needTarget(true)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()
