local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local center, center2 = { x = 33529, y = 32334, z = 12, stackpos = 255 }, { x = 33528, y = 32334, z = 12, stackpos = 255 }
	creature:say("GET OVER HERE!", TALKTYPE_MONSTER_YELL, false, 0, center2)
	for x = 33519, 33538 do
		for y = 32327, 32342 do
			local tile = Tile(Position({ x = x, y = y, z = 12 }))
			if tile then
				local creatureTile = tile:getTopCreature()
				if creatureTile and creatureTile:isMonster() and creature:getName():lower() ~= "prince drazzak" or creatureTile:isPlayer() then
					creatureTile:teleportTo(center, true)
					creature:teleportTo(center2, true)
				end
			end
		end
	end
	return true
end

spell:name("prince drazzak tp")
spell:words("###353")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
