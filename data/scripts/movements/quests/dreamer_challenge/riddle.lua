local riddle = MoveEvent()

function riddle.onStepIn(creature, item, position, fromPosition)
	item:transform(425)

	if item.actionid == 2245 then
		local new_position = Position(0, position.y, position.z)
		for i = 5, 0, -1 do
			new_position.x = position.x + 2 + i
			local tile = new_position:getTile()
			if i == 5 then
				new_position.x = position.x + 2
			else
				new_position.x = new_position.x + 1
			end

			local itemCount = tile:getDownItemCount()
			if itemCount > 0 then
				tile:getThing(tile:getTopItemCount() + tile:getCreatureCount() + itemCount):moveTo(new_position)
			end
		end
	elseif item.actionid == 2246 then
		local new_position = Position(position.x, 0, position.z)
		for i = 5, 0, -1 do
			new_position.y = position.y + 2 + i
			local tile = new_position:getTile()
			if i == 5 then
				new_position.y = position.y + 2
			else
				new_position.y = new_position.y + 1
			end

			local itemCount = tile:getDownItemCount()
			if itemCount > 0 then
				tile:getThing(tile:getTopItemCount() + tile:getCreatureCount() + itemCount):moveTo(new_position)
			end
		end
	end
	return true
end

riddle:type("stepin")
riddle:aid(2245, 2246)
riddle:register()

riddle = MoveEvent()

function riddle.onStepOut(creature, item, position, fromPosition)
	item:transform(426)
	return true
end

riddle:type("stepout")
riddle:aid(2245, 2246)
riddle:register()
