local boneCapsule = CreatureEvent("BoneCapsule")
function boneCapsule.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local position = creature:getPosition()
	position:sendMagicEffect(CONST_ME_POFF)
	if creature:getName():lower() ~= "bone capsule" then
		return true
	end

	local monster = Game.createMonster("bone capsule", Position(33485, 32333, 14), true, true)
	if not monster then
		return true
	end

	local ragiaz = Tile(Position(33487, 32333, 14)):getTopCreature()
	ragiaz:teleportTo(position)
	ragiaz:addHealth(math.random(25000, 35000), true, true)
	return true
end

boneCapsule:register()
