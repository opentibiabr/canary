local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_STONES)
combat:setArea(createCombatArea(AREA_CIRCLE6X6))

function spellCallback(param)
	local tile = Tile(Position(param.pos))
	if tile then
		if tile:getTopCreature() then
			tile:getTopCreature():addHealth( - math.random(1000, 1500))
		end
	end
end

function onTargetTile(cid, pos)
	local param = {}
	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallback(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local gnomeAvalanche = MoveEvent()

function gnomeAvalanche.onStepIn(creature, position, fromPosition, toPosition)
	if not creature or not creature:isMonster() then
		return true
	end

	local monsterName = creature:getName():lower()
	local var = {type = 1, number = creature:getId()}
	local r = math.random(1, 100)

	if monsterName == "lost gnome" then
		if r <= 25 then
			combat:execute(creature, var)
		end
	end
	return true
end

gnomeAvalanche:type("stepin")
gnomeAvalanche:aid(57240)
gnomeAvalanche:register()
