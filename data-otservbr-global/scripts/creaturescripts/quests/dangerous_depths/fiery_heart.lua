local function transformFieryHeart(creature)
	local monster = Creature(creature)
	if monster then
		if monster:getName():lower() ~= "fiery blood" then
			local oldHeartHealth = monster:getHealth()
			monster:setType("Fiery Blood")
			monster:addHealth(-(monster:getHealth() - oldHeartHealth))
		end
	end
end

local fieryHeartThink = CreatureEvent("FieryHeartThink")
function fieryHeartThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end
	local contadorHearts = 0
	local bossId
	if creature:getName():lower() == "the fire empowered duke" then
		bossId = Creature(creature:getId())
		local spectators = Game.getSpectators(creature:getPosition(), false, false, 20, 20, 20, 20)
		for _, spectator in pairs(spectators) do
			if spectator:getName():lower() == "fiery heart" then
				contadorHearts = contadorHearts + 1
			end
		end
		if contadorHearts < 1 then
			if bossId then
				local oldBossHealth = bossId:getHealth()
				bossId:setType("The Duke of The Depths")
				bossId:addHealth(-(bossId:getHealth() - oldBossHealth))
			end
		end
	end
	
	if creature:getName():lower() == "fiery heart" then
		if creature then
			addEvent(transformFieryHeart, 20*1000, creature:getId())
		end
	end

	return true
end

fieryHeartThink:register()
