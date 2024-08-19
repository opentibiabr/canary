local vortexAnomaly = MoveEvent()

vortexAnomaly:type("stepin")

function vortexAnomaly.onStepIn(creature, item, position, fromPosition)
	if not creature then
		return true
	end

	if item.itemid == 22894 then
		if creature:isMonster() then
			if creature:getName():lower() == "charged anomaly" then
				creature:addHealth(-6000, COMBAT_DROWNDAMAGE)
			end
		elseif creature:isPlayer() then
			creature:addHealth(-100, COMBAT_ENERGYDAMAGE)
		end
	end
	return true
end

vortexAnomaly:id(22894)
vortexAnomaly:register()
