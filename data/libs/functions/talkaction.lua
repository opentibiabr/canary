function Player.setFiendish(self)
	local position = self:getPosition()
	position:getNextPosition(self:getDirection())

	local tile = Tile(position)
	local thing = tile:getTopVisibleThing(self)
	if not tile or thing and not thing:isMonster() then
		self:sendCancelMessage("Monster not found.")
		return false
	end

	local monster = thing:getMonster()
	if monster then
		monster:setFiendish(position, self)
	end
	return false
end
