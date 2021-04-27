-- Utils functions for NPC System
local travelDiscounts = {
	['postman'] = {price = 10, storage = Storage.Postman.Rank, value = 3},
	['new frontier'] = {price = 50, storage = Storage.TheNewFrontier.Mission03, value = 1}
}

function buildTravelMessage(baseMessage, place, cost)
	baseMessage = baseMessage or "Do you want to travel to %s for %s gold coins?"
	return string.format(baseMessage, place, cost > 0 and cost or "free")
end

function Player:calculateTravelPrice(basePrice, discount)
	return basePrice - self:getTravelDiscount(discount)
end

function getDiscount(player, discount)
	if discount and player:getStorageValue(discount.storage) >= discount.value then
		return discount.price
	end
	return 0
end

function Player:getTravelDiscount(discounts)
	local discountPrice, discount = 0
	if type(discounts) == 'string' then
		return getDiscount(self, travelDiscounts[discounts])
	end

	for i = 1, #discounts do
		discountPrice = discountPrice + getDiscount(self, travelDiscounts[discounts[i]])
	end

	return discountPrice
end

function Player:getTotalMoney()
	return self:getMoney() + self:getBankBalance()
end

function Player:removeMoneyIncludingBalance(amount)
	if type(amount) == 'string' then
		amount = tonumber(amount)
	end

	local moneyCount = self:getMoney()
	local bankCount = self:getBankBalance()

	-- The player have all the money with him
	if amount <= moneyCount then
		-- Removes player inventory money
		self:removeMoney(amount)

		self:sendTextMessage(MESSAGE_TRADE, ("Paid %d gold from inventory."):format(amount))
		return true

	-- The player doens't have all the money with him
	elseif amount <= (moneyCount + bankCount) then

		-- Check if the player has some money
		if moneyCount ~= 0 then
			-- Removes player inventory money
			self:removeMoney(moneyCount)
			local remains = amount - moneyCount

			-- Removes player bank money
			self:setBankBalance(bankCount - remains)

			self:sendTextMessage(MESSAGE_TRADE, ("Paid %d from inventory and %d gold from bank account. Your account balance is now %d gold."):format(moneyCount, amount - moneyCount, self:getBankBalance()))
			return true

		else
			self:setBankBalance(bankCount - amount)
			self:sendTextMessage(MESSAGE_TRADE, ("Paid %d gold from bank account. Your account balance is now %d gold."):format(amount, self:getBankBalance()))
			return true
		end
	end

	return false
end

function Npc:chargePlayer(player, cost, message)
    if not player:removeMoneyIncludingBalance(cost) then
        self:talk(player, message or "You do not have enough money!")
        return false
    end
    return true
end
