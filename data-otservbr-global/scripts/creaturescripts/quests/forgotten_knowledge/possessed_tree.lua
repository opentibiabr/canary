local monsters = {"unbound blightwalker", "unbound demon", "unbound demon outcast", "unbound defiler"}
local possessedTree = CreatureEvent("PossessedTree")
function possessedTree.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster then
		return true
	end
	targetMonster:getPosition():sendMagicEffect(CONST_ME_SMALLPLANTS)
	local monster = Game.createMonster(monsters[math.random(#monsters)], targetMonster:getPosition(), true, true)
	if monster then
		monster:say("The destruction of the tree unleashes the " ..monster:getName():lower().."!", TALKTYPE_MONSTER_SAY)
	end
	addEvent(Game.createMonster, 60 * 1000, "possessed tree", targetMonster:getPosition(), true, true)
	return true
end
possessedTree:register()
