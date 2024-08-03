local magicWallIds = {
	ITEM_MAGICWALL_SAFE,
	ITEM_MAGICWALL,
	ITEM_WILDGROWTH_SAFE,
	ITEM_WILDGROWTH,
}

local spell = Spell("instant")
function spell.onCastSpell(creature, var)
	-- check tiles around the caster
	local position = creature:getPosition()
	for x = -2, 2 do
		for y = -2, 2 do
			local tile = Tile(position.x + x, position.y + y, position.z)
			if tile then
				local item = tile:getTopVisibleThing()
				if item and table.contains(magicWallIds, item:getId()) then
					item:remove()
					position:sendMagicEffect(CONST_ME_POFF)
					return true -- only one magic wall per cast
				end
			end
		end
	end
	return true
end

spell:name("destroy magic walls")
spell:words("###6045")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
