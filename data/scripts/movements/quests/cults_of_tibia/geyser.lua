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
	if not creature:isMonster() then
		return true
	end

	if creature:getType():getName():lower() == "the sinister hermit" and creature:getOutfit().lookBody == 63 then
		local currentLife = creature:getHealth()
		local bossTransform = Game.createMonster("the sinister hermit dirty", creature:getPosition(), true, true)
		if bossTransform then
			creature:remove()
			item:remove()
			local subtract = bossTransform:getHealth() - currentLife
			bossTransform:addHealth(-subtract)
			bossTransform:registerEvent("spawnBoss")
			addEvent(bossTransformBack, 4*1000, bossTransform:getId(), item:getId())
			return false
		end
	end
	return true
end

geyser:type("stepin")
geyser:id(28869)
geyser:register()
