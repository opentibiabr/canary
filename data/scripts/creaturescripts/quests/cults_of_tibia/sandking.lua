local function spawnSandBoss(name, frompos, topos)
	local spawn = true
	for _x= frompos.x, topos.x, 1 do
		for _y= frompos.y, topos.y, 1 do
			for _z= frompos.z, topos.z, 1 do
				local tile = Tile(Position(_x, _y, _z))
				if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() and tile:getTopCreature():getName():lower() == "sand brood" then
					spawn = false
					break
				end
			end
		end
	end
	if not spawn then
		addEvent(spawnSandBoss, 5000, name, frompos, topos)
		return true
	end
	for _x= frompos.x, topos.x, 1 do
		for _y= frompos.y, topos.y, 1 do
			for _z= frompos.z, topos.z, 1 do
				local tile = Tile(Position(_x, _y, _z))
				if tile and tile:getTopCreature() and tile:getTopCreature():getName():lower() == "sand vortex" then
					tile:getTopCreature():remove()
				end
			end
		end
	end

	local str = Game.getStorageValue("sandking")
	local boss = Game.createMonster("the sandking fake", Position( 33099, 31859, 15))
	if str < 4 then
		boss:registerEvent("sandking think")
	end
	Game.setStorageValue("sandking", str + 1)
	boss:say("THE BROOD RETREATS AND THE SANDKING REMERGES TO PROTECT HIS OFFSPRING!",TALKTYPE_MONSTER_SAY)
	return true
end
local function spawnSandMonster(name, _time)
	if _time == 0 then
		addEvent(spawnSandBoss, 5000, "the sandking fake", Position(33087, 31848, 15), Position(33109, 31871, 15))
		return true
	end
	local randomarea = {x = math.random(33092, 33105), y = math.random(31853, 31865), z = 15}
	Game.createMonster(name, randomarea):registerEvent("sandking death")
	_time = _time - 1
	addEvent(spawnSandMonster, 5000, name, _time)
	return true
end

local sandkingThink = CreatureEvent("SandkingThink")
function sandkingThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end
	if creature:getName():lower() ~= "the sandking" then
		return true
	end
	local maxhealth = creature:getMaxHealth()
	local str = Game.getStorageValue("sandking")
	if str <= 3 then
		if ((maxhealth*0.95) > creature:getHealth() ) then
			creature:say("THE SANDKING VANISHES INTO THE SAND AND HIS BROOD EMERGES!",TALKTYPE_MONSTER_SAY)
			creature:remove()
			local positions = {
				Position(33095, 31854, 15),
				Position(33102, 31854, 15),
				Position(33095, 31864, 15),
				Position(33102, 31864, 15),
			}

			for _, pos in pairs(positions) do
				Game.createMonster("sand vortex",pos):registerEvent("sand health")
			end
			spawnSandMonster("Sand Brood", 10)
		end
	elseif str == 4 then
		local tm = os.time()
		if ((maxhealth*0.50) > creature:getHealth() ) then
			creature:say("THE SANDKING VANISHES INTO THE SAND AND HIS BROOD EMERGES!",TALKTYPE_MONSTER_SAY)
			creature:remove()
			local ps = {
				Position(33097, 31857, 15),
				Position(33099, 31856, 15),
				Position(33102, 31857, 15),
			}
			local pass = 0
			for _, pos in pairs(ps) do
				local monster = Game.createMonster("the sandking fake", pos)
				monster:setHealth(monster:getMaxHealth()/2)
				if pass == 0 then
					monster:registerEvent("sandking death")
					pass = 1
				end
				monster:beginSharedLife(tm)
				monster:registerEvent("shared life")
			end
		end
	end
	return true
end
sandkingThink:register()

local sandkingDeath = CreatureEvent("SandkingDeath")
function sandkingDeath.onDeath(creature, attacker, corpse)
	if not creature:isMonster() then
		return true
	end
	if creature:getName():lower() == "sand brood" then
		addEvent(
		function(position, corpseid)
			local tile = Tile(position)
			if tile then
				local corpoCount = tile:getItemCountById(corpseid)
				if corpoCount > 0 then
					tile:getItemById(corpseid):setActionId(5595)
				end
			end
		end, 200, creature:getPosition(), MonsterType(creature:getName()):getCorpseId()
		)
		return true
	end
	local stg = Game.getStorageValue("sandking")
	if stg == 4 then
		local monster = Game.createMonster("the sandking", Position( 33099, 31859, 15))
		monster:setHealth(monster:getMaxHealth()/2)
		addEvent(Game.setStorageValue, 2000, "sandking", 5)
	end
	return true
end
sandkingDeath:register()


local sandHealth = CreatureEvent("SandHealth")
function sandHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getName():lower() == "sand vortex" then
		if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
		if attacker and attacker:isPlayer() then
			if primaryDamage > 0 then
				attacker:addHealth(-primaryDamage)
			end
			if secondaryDamage > 0 then
				attacker:addHealth(-secondaryDamage)
			end
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
sandHealth:register()
