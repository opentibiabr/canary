
function Player.getRewardChest(self, autocreate)
	return self:getDepotChest(99, autocreate)
end

function Player.inBossFight(self)
	if not next(GlobalBosses) then
		return false
	end

	local playerGuid = self:getGuid()
	for _, info in pairs(GlobalBosses) do
		local stats = info[playerGuid]
		if stats and stats.active then
			return stats
		end
	end
	return false
end
