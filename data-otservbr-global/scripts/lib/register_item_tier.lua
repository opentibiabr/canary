registerItemClassification = {}
setmetatable(registerItemClassification, {
	__call = function(self, itemClass, mask)
		for _, parse in pairs(self) do
			parse(itemClass, mask)
		end
	end,
})

ItemClassification.register = function(self, mask)
	return registerItemClassification(self, mask)
end

registerItemClassification.Upgrades = function(itemClassification, mask)
	if mask.Upgrades then
		for _, value in ipairs(mask.Upgrades) do
			if value.TierId then
				logger.debug("Registering tier {}, core {}, regular price {}, fusion price {}, transfer price {}", value.TierId, value.Core, value.RegularPrice, value.ConvergenceFustionPrice, value.ConvergenceTransferPrice)
				itemClassification:addTier(value.TierId, value.Core, value.RegularPrice, value.ConvergenceFustionPrice, value.ConvergenceTransferPrice)
			else
				logger.warn("[registerItemClassification.Upgrades] - Item classification failed on adquire TierID or Price attribute.")
			end
		end
	end
end
