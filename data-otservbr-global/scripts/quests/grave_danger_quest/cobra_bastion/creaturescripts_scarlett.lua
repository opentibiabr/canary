local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
local arr = {
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 3, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
}

combat:setArea(createCombatArea(arr))
function onTargetCreature(creature, target)
	local min = -7500
	local max = -7500
	doTargetCombatHealth(0, target, COMBAT_AGONYDAMAGE, min, max, CONST_ME_NONE)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local storage = Storage.Quest.U12_20.GraveDanger.CobraBastion.Questline
local rooms = {
	[1] = { fromPos = Position(33390, 32642, 6), toPos = Position(33394, 32646, 6) },
	[2] = { fromPos = Position(33390, 32646, 6), toPos = Position(33394, 32650, 6) },
	[3] = { fromPos = Position(33390, 32650, 6), toPos = Position(33394, 32654, 6) },
	[4] = { fromPos = Position(33394, 32642, 6), toPos = Position(33398, 32646, 6) },
	[5] = { fromPos = Position(33394, 32646, 6), toPos = Position(33398, 32650, 6) },
	[6] = { fromPos = Position(33394, 32650, 6), toPos = Position(33398, 32654, 6) },
	[7] = { fromPos = Position(33398, 32642, 6), toPos = Position(33402, 32646, 6) },
	[8] = { fromPos = Position(33398, 32646, 6), toPos = Position(33402, 32650, 6) },
	[9] = { fromPos = Position(33398, 32650, 6), toPos = Position(33402, 32654, 6) },
}

local function isMirrorsCorrect(fromPosition, toPosition)
	local Pillar1 = Tile(fromPosition):getItemById(31474)
	local Pillar2 = Tile(Position(fromPosition.x + 4, fromPosition.y, fromPosition.z)):getItemById(31475)
	local Pillar3 = Tile(Position(toPosition.x - 4, toPosition.y, toPosition.z)):getItemById(31477)
	local Pillar4 = Tile(toPosition):getItemById(31476)

	if Pillar1 and Pillar2 and Pillar3 and Pillar4 then
		return true
	end

	return false
end

local eventDoDamage = function(creatureid, attackerid, type)
	local creature = Creature(creatureid)
	local attacker = Creature(attackerid)
	if not creature or not attacker then
		return
	end

	local damage = creature:getMaxHealth() / 4
	creature:say("AHHHHHHHHHHH!", TALKTYPE_MONSTER_SAY)
	doTargetCombatHealth(attackerid, creature, type, -damage, -damage, CONST_ME_POFF, ORIGIN_NONE)

	combat:execute(creature, Variant(creature:getPosition()))

	creature:setMoveLocked(false)
end

local eventRemoveFreeze = function(creatureid, evented)
	local creature = Creature(creatureid)
	if not creature then
		return
	end

	if creature:isMoveLocked() then
		creature:setMoveLocked(false)
		if evented then
			SCARLETT_MAY_DIE = 0
		end
	end
end

local function changeScarlett(creatureid)
	local creature = Creature(creatureid)
	if not creature then
		return
	end

	creature:say("Galthen... is that you?", TALKTYPE_MONSTER_SAY)
	SCARLETT_MAY_DIE = 1
	SCARLETT_MAY_TRANSFORM = 0
	creature:setMoveLocked(true)
	addEvent(eventRemoveFreeze, 4 * 1000, creature:getId(), true)
end

local scarlettThink = CreatureEvent("scarlettThink")
function scarlettThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end

	if SCARLETT_MAY_TRANSFORM ~= 1 then
		return true
	end

	local mirrorsCount = 0
	for _, p in pairs(rooms) do
		if creature:getPosition():isInRange(p.fromPos, p.toPos) then
			if isMirrorsCorrect(p.fromPos, p.toPos) then
				addEvent(changeScarlett, 50, creature:getId())
				return true
			end
		end
	end
	return true
end

scarlettThink:register()

local scarlettHealth = CreatureEvent("scarlettHealth")
function scarlettHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getStorageValue(storage) ~= 1 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if not creature:isMoveLocked() then
		return primaryDamage * 0.01, primaryType, secondaryDamage * 0.01, secondaryType
	end

	addEvent(eventDoDamage, 200, creature:getId(), attacker:getId(), primaryType)
	SCARLETT_MAY_DIE = 0
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

scarlettHealth:register()
