local spellCombat = Combat()
spellCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
spellCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ORANGETELEPORT)

spellCombat:setArea(createCombatArea(AREA_CIRCLE6X6))

local damage = 0
local crit = false

local function paralyze(player)
	if not player then
		return true
	end

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 500)
	condition:setFormula(-0.94, 0, -0.97, 0)
	player:addCondition(condition)
	return true
end

local spell = Spell("instant")
function onTargetCreature(creature, target)
	if not target then
		return true
	end
	local master = target:getMaster()
	if not target:isPlayer() and not (master or master:isPlayer()) then
		return true
	end

	local distance = math.floor(creature:getPosition():getDistance(target:getPosition()))
	local actualDamage = damage / (2 ^ distance)
	doTargetCombatHealth(0, target, COMBAT_EARTHDAMAGE, actualDamage, actualDamage, CONST_ME_NONE)
	if crit then
		target:getPosition():sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
	end
	return true
end

spellCombat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function spell.onCastSpell(creature, var)
	local target = Creature(var:getNumber())
	if not target then
		return false
	end
	local targetPos = target:getPosition()
	target:say("You are being targeted by Doctor Marrow's explosion!", TALKTYPE_MONSTER_SAY, false, target)
	creature:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)
	targetPos:sendMagicEffect(CONST_ME_ORANGETELEPORT)

	local totalDelay = 4000

	for i = 0, totalDelay / 100 do
		addEvent(function(pos)
			local spectators = Game.getSpectators(pos, false, true, 6, 6, 6, 6)
			for _, spectator in ipairs(spectators) do
				if spectator:isPlayer() then
					paralyze(spectator)
				end
			end
		end, i * 100, targetPos)
	end

	addEvent(function(cid, pos)
		local creature = Creature(cid)
		if creature then
			creature:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)
			pos:sendMagicEffect(CONST_ME_ORANGETELEPORT)
		end
	end, 2000, creature:getId(), targetPos)

	addEvent(function(cid, pos)
		local creature = Creature(cid)
		if creature then
			damage = -math.random(3500, 7000)
			if math.random(1, 100) <= 10 then
				crit = true
				damage = damage * 1.5
			else
				crit = false
			end
			spellCombat:execute(creature, Variant(pos))
		end
	end, totalDelay, creature:getId(), targetPos)
	return true
end

spell:name("doctor marrow explosion")
spell:words("###6044")
spell:needLearn(true)
spell:needTarget(true)
spell:cooldown(10000)
spell:register()
