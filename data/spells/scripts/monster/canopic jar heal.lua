local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DRAWBLOOD)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

arr = {
	{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
	}

local area = createCombatArea(arr)
combat:setArea(area)

function onTargetCreature(creature, target)
	local hp = (creature:getHealth()/creature:getMaxHealth())*100
	local min = 4000
	local max = 5000

	local master = target:getMaster()
	if target:isPlayer() and not master
			or master and master:isPlayer() then
		return true
	end
	if hp > 75 then
		doTargetCombatHealth(0, target, COMBAT_HEALING, min, max, CONST_ME_NONE)
	elseif hp < 75 and hp > 50 then
		doTargetCombatHealth(0, target, COMBAT_HEALING, min*0.5, max*0.5, CONST_ME_NONE)
	elseif hp < 50 and hp > 25 then
		doTargetCombatHealth(0, target, COMBAT_HEALING, min*0.25, max*0.25, CONST_ME_NONE)
	elseif hp < 25 then
		doTargetCombatHealth(0, target, COMBAT_HEALING, min*0.10, max*0.10, CONST_ME_NONE)
	end

	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
