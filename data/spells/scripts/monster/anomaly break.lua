local function anomalyBreak(pos)
	local upConer = {x = pos.x - 1, y = pos.y - 1, z = pos.z}       -- upLeftCorner
	local downConer = {x = pos.x + 1, y = pos.y + 1, z = pos.z}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					if tile:getItemById(1499) then
						tile:getItemById(1499):remove()
						Position(room):sendMagicEffect(3)
					elseif tile:getItemById(1497) then
						tile:getItemById(1497):remove()
						Position(room):sendMagicEffect(3)
					end
				end
			end
		end
	end
end

function onCastSpell(creature, var)
	local pos = creature:getPosition()
	anomalyBreak(pos)
end
