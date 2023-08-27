local combat = Combat()
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_DIVINE_DAZZLE)

function canChain(creature, target)
	if target:isMonster() then
		if target:getType():isRewardBoss() then
			return false
		elseif target:getMaster() == nil and target:getType():getTargetDistance() > 1 then
			return true
		end
	end
	return false
end

combat:setCallback(CALLBACK_PARAM_CHAINPICKER, "canChain")

function getChainValue(creature)
	local targets = 3
	local player = creature:getPlayer()
	if creature and player then
		targets = targets + player:getWheelSpellAdditionalTarget("Divine Dazzle")
	end
	return targets, 6, false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")

function onChain(creature, target)
	local duration = 12000
	local player = creature:getPlayer()
	if creature and player then
		duration = duration + (player:getWheelSpellAdditionalDuration("Divine Dazzle") * 1000)
	end
	if target and target:isMonster() then
		target:changeTargetDistance(1, duration)
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onChain")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local spectators = Game.getSpectators(creature:getPosition(), false, false)
	for _, spectator in pairs(spectators) do
		if spectator:isMonster() then
			if spectator:getType():isRewardBoss() then
				creature:sendCancelMessage("You can't use this spell if there's a boss.")
				creature:getPosition():sendMagicEffect(CONST_ME_POFF)
				return false
			end
		end
	end

	if not combat:execute(creature, variant) then
		creature:sendCancelMessage("There are no ranged monsters.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	return true
end

spell:group("support")
spell:id(238)
spell:name("Divine Dazzle")
spell:words("exana amp res")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_DIVINE_DAZZLE)
spell:level(250)
spell:mana(80)
spell:isAggressive(false)
spell:isPremium(true)
spell:cooldown(16 * 1000)
spell:groupCooldown(2 * 1000)
spell:vocation("paladin;true", "royal paladin;true")
spell:needLearn(false)
spell:register()
