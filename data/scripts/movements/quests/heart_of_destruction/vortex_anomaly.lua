local vortexAnomaly = MoveEvent()

function vortexAnomaly.onStepIn(creature, item, position, fromPosition)
	if item.itemid == 25550 then
		if creature:isMonster() then
			if creature:getName():lower() == "charged anomaly" then
				creature:addHealth(-6000, COMBAT_DROWNDAMAGE)
			end
		elseif isPlayer(creature) then
			creature:addHealth(-100, COMBAT_ENERGYDAMAGE)
		end
	end
	return true
end

vortexAnomaly:type("stepin")
vortexAnomaly:id(25550)
vortexAnomaly:register()
