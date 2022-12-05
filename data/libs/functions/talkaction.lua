local function accountTypeGod(player)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
end

function Player.setFiendish(self)
	if accountTypeGod(self) then
		return true
	end

	local position = self:getPosition()
	position:getNextPosition(self:getDirection())

	local tile = Tile(position)
	if not tile then
		self:sendCancelMessage("Monster not found.")
		return false
	end

	local thing = tile:getTopVisibleThing(self)
	if not thing then
		self:sendCancelMessage("Thing not found.")
		return false
	end

	local monster = thing:getMonster()
	if monster then
		monster:setFiendish(position, self)
	end
	return false
end
