local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

combat:setArea(createCombatArea({
	{ 0, 0, 0, 0, 0 },
	{ 0, 1, 3, 1, 0 },
	{ 0, 0, 0, 0, 0 },
}))

function spellCallback(param)
	local tile = Tile(Position(param.pos))
	if tile then
		local creatureTop = tile:getTopCreature()
		if creatureTop then
			if creatureTop:isPlayer() then
				creatureTop:addHealth(-math.random(0, 600))
			elseif creatureTop:isMonster() and creatureTop:getName():lower() == "stolen soul" then
				creatureTop:addHealth(-math.random(700, 1500))
			end
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

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Source of Corruption Wave")
spell:words("#####461")
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
