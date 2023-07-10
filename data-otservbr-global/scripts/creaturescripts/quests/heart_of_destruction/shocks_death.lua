local shocksDeath = CreatureEvent("ShocksDeath")
function shocksDeath.onDeath(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	local name = creature:getName():lower()
	if name == "foreshock" and realityQuakeStage == 0 then
		if realityQuakeStage == 0 then
			local monster = Game.createMonster("aftershock", {x = 32208, y = 31248, z = 14}, false, true)
			monster:addHealth(-monster:getHealth() + aftershockHealth, COMBAT_PHYSICALDAMAGE)
			Game.createMonster("spark of destruction", {x = 32203, y = 31246, z = 14}, false, true)
			Game.createMonster("spark of destruction", {x = 32205, y = 31251, z = 14}, false, true)
			Game.createMonster("spark of destruction", {x = 32210, y = 31251, z = 14}, false, true)
			Game.createMonster("spark of destruction", {x = 32212, y = 31246, z = 14}, false, true)
		end
	elseif name == "aftershock" and realityQuakeStage == 0 then
		local monster = Game.createMonster("foreshock", {x = 32208, y = 31248, z = 14}, false, true)
		monster:addHealth(-monster:getHealth() + aftershockHealth, COMBAT_PHYSICALDAMAGE)
		Game.createMonster("spark of destruction", {x = 32203, y = 31246, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32205, y = 31251, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32210, y = 31251, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32212, y = 31246, z = 14}, false, true)
	end
	realityQuakeStage = realityQuakeStage + 1

	if realityQuakeStage == 2 then
		local pos = creature:getPosition()
		local monster = Game.createMonster("realityquake", pos, false, true)
		Game.createMonster("spark of destruction", {x = 32203, y = 31246, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32205, y = 31251, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32210, y = 31251, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32212, y = 31246, z = 14}, false, true)
	end

	return true
end

shocksDeath:register()
