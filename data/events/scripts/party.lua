function Party:onJoin(player)
	local ec = EventCallback.onJoin
	if ec then
		return ec(self, player)
	end
	return true
end

function Party:onLeave(player)
	local ec = EventCallback.onLeave
	if ec then
		return ec(self, player)
	end
	return true
end

function Party:onDisband()
	local ec = EventCallback.onDisband
	if ec then
		return ec(self)
	end
	return true
end

function Party:onShareExperience(exp)
	local ec = EventCallback.onShareExperience
	if ec then
		return ec(self, exp, exp)
	end
	return exp
end
