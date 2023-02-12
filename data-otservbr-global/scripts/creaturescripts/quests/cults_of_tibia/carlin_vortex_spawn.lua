local vortexCarlin = CreatureEvent("VortexCarlin")
function vortexCarlin.onKill(creature, target, item)
	if not creature or not creature:isPlayer() then
		return true
	end

	if not target or not target:isMonster() then
		return true
	end

	if isInArray({'cult enforcer', 'cult believer', 'cult scholar'}, target:getName():lower()) then
		local corpsePosition = target:getPosition()
		local rand = math.random(32414, 32415)
		Game.createItem(rand, 1, corpsePosition):setActionId(5580)
		addEvent(function()
			local teleport1 = Tile(corpsePosition):getItemById(rand)
			if teleport1 then
				teleport1:remove(1)
			end
		end, (1*60*1000), rand, 1, corpsePosition)
	end
	return true
end

vortexCarlin:register()
