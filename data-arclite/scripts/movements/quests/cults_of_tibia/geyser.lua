local function bossTransformBack(creatureid, itemid)
	local creature = Creature(creatureid)
	if not creature then
		return false
	end

	local position = creature:getPosition()
	if Tile(position):getItemCountById(itemid) > 0 then
		addEvent(bossTransformBack, 4*1000, creature:getId(), itemid)
		return false
	end

	local bossTransformBack = Game.createMonster("the sinister hermit dirty", position, true, true)
	local currentLife = creature:getHealth()
	if bossTransformBack then
		bossTransformBack:registerEvent("SpawnBoss")
		creature:remove()
		local subtract = bossTransformBack:getHealth() - currentLife
		bossTransformBack:addHealth(-subtract)
	end
	return true
end

local geyser = MoveEvent()

function geyser.onStepIn(creature, item, position, fromPosition)
	if not creature or not creature:isMonster() then
		return true
	end

	local monsterType = creature:getType()
	if monsterType and monsterType:getTypeName():lower() == "the sinister hermit dirty" and creature:getOutfit().lookBody == 97 then
		local currentLife = creature:getHealth()
		local bossTransform = Game.createMonster("the sinister hermit", creature:getPosition(), true, true)
		if bossTransform then
			creature:remove()
			item:remove()
			local subtract = bossTransform:getHealth() - currentLife
			bossTransform:addHealth(-subtract)
			bossTransform:registerEvent("SpawnBoss")
			addEvent(bossTransformBack, 4*1000, bossTransform:getId(), item:getId())
			return true
		end
	end
	return false
end

geyser:type("stepin")
geyser:id(25510)
geyser:register()
