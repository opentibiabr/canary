local SPELL_BASE_POWER = 52
local DEBUFF_DURATION = 10 * 1000

local function getShieldDefense(player)
	for _, slot in ipairs({ CONST_SLOT_LEFT, CONST_SLOT_RIGHT }) do
		local item = player:getSlotItem(slot)
		if item then
			local itemType = ItemType(item:getId())
			if itemType:getType() == ITEM_TYPE_SHIELD and itemType:getWeaponType() == WEAPON_SHIELD then
				return itemType:getDefense()
			end
		end
	end

	return nil
end

local debuff = Condition(CONDITION_ATTRIBUTES)
debuff:setParameter(CONDITION_PARAM_TICKS, DEBUFF_DURATION)
debuff:setParameter(CONDITION_PARAM_SUBID, AttrSubId_ShieldAttackDebuff)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BASH)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setArea(createCombatArea(AREA_SQUARE1X1))
combat:addCondition(debuff)

function onGetFormulaValues(player, skill, attack, factor)
	local shieldDefense = getShieldDefense(player)
	if not shieldDefense then
		return 0, 0
	end

	local shielding = player:getEffectiveSkillLevel(SKILL_SHIELD)
	local damage = SPELL_BASE_POWER * (shielding / 100) * (shieldDefense / 10) + player:calculateFlatDamageHealing()
	return damage * 0.9, damage * 1.1
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not getShieldDefense(creature) then
		creature:sendCancelMessage("You need to equip a shield to cast this spell.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(316)
spell:name("Shield Slam")
spell:words("exori scu")
spell:level(30)
spell:mana(110)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("knight;true", "elite knight;true")
spell:register()
