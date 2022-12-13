local sirNictrosThink = CreatureEvent("SirNictrosThink")
function sirNictrosThink.onThink(creature)
	local maxhealth = creature:getMaxHealth()
	if maxhealth * 0.65 > creature:getHealth() then
		creature:say("Now it's your chance for entertainment, dear brother!",TALKTYPE_MONSTER_SAY)
		creature:teleportTo(Position({x = 33427, y = 31428, z = 13}))
		local boss = Tile(Position({x = 33422, y = 31428, z = 13})):getTopCreature()
		if boss and boss:isMonster() then
			boss:teleportTo(Position({x = 33423, y = 31437, z = 13}))
		end
		creature:unregisterEvent("SirNictrosThink")
	end
	return true
end
sirNictrosThink:register()

local sirBaelocThink = CreatureEvent("SirBaelocThink")
function sirBaelocThink.onThink(creature)
	local maxhealth = creature:getMaxHealth()
	if maxhealth * 0.65 > creature:getHealth() then
		creature:say("Join me in battle, my brother. Let's share the fun!",TALKTYPE_MONSTER_SAY)
		Tile(Position({x = 33427, y = 31428, z = 13})):getTopCreature():teleportTo(Position({x = 33424, y = 31437, z = 13}))
		creature:unregisterEvent("SirBaelocThink")
	end
	return true
end
sirBaelocThink:register()
