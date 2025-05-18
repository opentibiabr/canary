local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLESMOKE)

combat:setArea(createCombatArea({
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1, 1, 1 },
	{ 1, 1, 1, 3, 1, 1, 1 },
	{ 1, 1, 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
}))

function onTargetTile(creature, pos)
	local tile = Tile(pos)
	if tile then
		if tile:getTopCreature() and tile:getTopCreature():isMonster() then
			if tile:getTopCreature():getName():lower() == "leiden" then
				tile:getTopCreature():registerEvent("SpawnBoss")
				tile:getTopCreature():addHealth(-math.random(3000, 6000))
			elseif tile:getTopCreature():getName():lower() == "ravenous hunger" then
				tile:getTopCreature():addHealth(math.random(3000, 6000))
			end
			return
		end
	end
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local evaporate = CreatureEvent("Evaporate")
function evaporate.onThink(creature)
	local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
	if hp < 60.0 then
		addEvent(function(cid)
			local creature = Creature(cid)
			if not creature then
				return
			end
			creature:say("The liquor spirit evaporates!", TALKTYPE_MONSTER_YELL)
			local var = { type = 1, number = creature:getId() }
			combat:execute(creature, var)
			creature:remove(1)
			return true
		end, 100, creature:getId())
	end
end

evaporate:register()
