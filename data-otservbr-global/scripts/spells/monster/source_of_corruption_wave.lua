local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

combat:setArea(createCombatArea({
{0, 0, 0, 0, 0},
{0, 1, 3, 1, 0},
{0, 0, 0, 0, 0}
}))

function spellCallback(param)
	local tile = Tile(Position(param.pos))
	if tile then
		if tile:getTopCreature() and tile:getTopCreature():isPlayer() then
			tile:getTopCreature():addHealth( - math.random(0, 600))
		elseif tile:getTopCreature() and tile:getTopCreature():isMonster() then
			if tile:getTopCreature():getName():lower() == "stolen soul" then
				tile:getTopCreature():addHealth( - math.random(700, 1500))
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

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

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