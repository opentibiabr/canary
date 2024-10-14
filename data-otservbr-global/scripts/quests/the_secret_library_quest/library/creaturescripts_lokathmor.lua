local paper = 28488

local creaturescripts_library_lokathmor = CreatureEvent("lokathmorDeath")

function creaturescripts_library_lokathmor.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local cPos = creature:getPosition()
	if creature:getName():lower() == "dark knowledge" then
		local item = Game.createItem(paper, 1, cPos)
	end
end

creaturescripts_library_lokathmor:register()
