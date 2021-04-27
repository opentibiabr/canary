local function DestruirRaio1(fromPos, toPos, id, dir)
	if dir == 1 then
		for _x = fromPos.x, toPos.x, 1 do
			local tile = Tile(Position(_x, fromPos.y, fromPos.z))
			if tile and tile:getItemCountById(id) > 0 then
				tile:getItemById(id):remove()
			end
		end
	elseif dir == 2 then
		for _y = fromPos.y, toPos.y, 1 do
			local tile = Tile(Position(fromPos.x, _y, fromPos.z))
			if tile and tile:getItemCountById(id) > 0 then
				tile:getItemById(id):remove()
			end
		end
	end
end

local machineDeath = CreatureEvent("MachineDeath")
function machineDeath.onDeath(creature, attacker)
	if not creature:isMonster() then
		return true
	end

	local name = creature:getName():lower()
	local creaturePosition = creature:getPosition()
	if name == "containment machine" then
		-- destruindo os raios
		DestruirRaio1(Position(33134, 31856, 15), Position(33139, 31856, 15), 29087, 1)
		DestruirRaio1(Position(33134, 31863, 15), Position(33139, 31863, 15), 29087, 1)
		DestruirRaio1(Position(33140, 31857, 15), Position(33140, 31862, 15), 29087, 2)
		DestruirRaio1(Position(33133, 31857, 15), Position(33133, 31862, 15), 29087, 2)
		local itensToMonster = {--8633
			Position(33133, 31856, 15),
			Position(33140, 31856, 15),
			Position(33140, 31863, 15),
			Position(33133, 31863, 15)
		}
		for _, position in pairs(itensToMonster) do
			local tile = Tile(position)
			if tile then
				if tile:getItemCountById(8633) > 0 then
					tile:getItemById(8633):remove()
				end
				local crystal = Game.createMonster("Containment Crystal", position)
				crystal:registerEvent("machineHealth")
				crystal:registerEvent("machineDeath")
			end
		end
	elseif name == "containment crystal" then
		Game.createItem(8637,1, creaturePosition)
	elseif name == "the armored voidborn" then
		Game.createMonster("The Unarmored Voidborn", creaturePosition):registerEvent("bossesMission")
	end

	return true
end

machineDeath:register()

local machineHealth = CreatureEvent("MachineHealth")
function machineHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local frompos = Position(33123, 31846, 15) -- Checagem
	local topos = Position(33149, 31871, 15) -- Checagem

	if creature:getName():lower() == "containment crystal" then
		local bossid = 0
		for _x= frompos.x, topos.x, 1 do
			for _y= frompos.y, topos.y, 1 do
				for _z= frompos.z, topos.z, 1 do
					local tile = Tile(Position(_x, _y, _z))
					if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() and tile:getTopCreature():getName():lower() == "the armored voidborn" then
						bossid = tile:getTopCreature():getId()
					end
				end
			end
		end
		local boss = Monster(bossid)
		if not boss or primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
		local hasdano = false
		local maxheal = creature:getMaxHealth()
		if creature:getHealth() > (maxheal*60)/100 and creature:getHealth() < (maxheal*65)/100 then
			boss:addHealth(-7000)
			hasdano = true
		end
		for _x= frompos.x, topos.x, 1 do
			for _y= frompos.y, topos.y, 1 do
				for _z= frompos.z, topos.z, 1 do
					local tile = Tile(Position(_x, _y, _z))
					if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() and tile:getTopCreature():getName():lower() == "voidshard" then
						hasdano = false
					end
				end
			end
		end
		if hasdano then
			Game.createMonster("Voidshard", boss:getPosition() )
			Game.createMonster("Voidshard", boss:getPosition() )
		end

	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

machineHealth:register()
