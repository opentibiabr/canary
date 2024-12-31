local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)

local combatCast = Combat()

local barrelId = 23486
local bombArea = {
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 3, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
}

function onTargetCreature(creature, target)
	local min = -800
	local max = -1100

	if target:isPlayer() or (target:getMaster() and target:getMaster():isPlayer()) then
		doTargetCombatHealth(0, target, COMBAT_FIREDAMAGE, min, max, CONST_ME_NONE)
	end

	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local function createBarrel()
	local template = Game.createItem(barrelId, 1)

	template:setDuration(3)
	template:stopDecay()

	return template
end

createBarrel()

local function explodeBomb(position, creatureId)
	local var = {}

	var.instantName = "Cask Explode"
	var.runeName = ""
	var.type = 2 -- VARIANT_POSITION
	var.pos = position

	combat:execute(Creature(creatureId), var)
end

local function bombTimer(seconds, pos)
	local spectators = Game.getSpectators(pos, false, true, 11, 11, 9, 9)

	if #spectators > 0 then
		for i = 1, #spectators do
			spectators[i]:say(seconds, TALKTYPE_MONSTER_SAY, false, spectators[i], pos)
		end
	end
end

function onTargetCreature(creature, target)
	if not creature or not target then
		return false
	end

	local position = target:getPosition()
	local template = createBarrel()
	template:setOwner(creature:getId())

	local tile = Tile(position)
	local item = template:clone()
	tile:addItemEx(item)
	item:setDuration(3)
	item:decay()
	item:setActionId(IMMOVABLE_ACTION_ID)

	addEvent(explodeBomb, 3000, position, creature:getId())
	bombTimer(3, position)
	addEvent(bombTimer, 1000, 2, position, creature:getId())
	addEvent(bombTimer, 2000, 1, position, creature:getId())

	return true
end

combatCast:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not creature or not var then
		return false
	end

	var.instantName = "Exploding Cask Cast"
	return combatCast:execute(creature, var)
end

spell:name("exploding cask")
spell:words("###6049")
spell:range(6)
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
