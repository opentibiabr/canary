registerCharm = {}
setmetatable(registerCharm, {
	__call = function(self, charm, mask)
		for _, parse in pairs(self) do
			parse(charm, mask)
		end
	end,
})

Charm.register = function(self, mask)
	return registerCharm(self, mask)
end

registerCharm.name = function(charm, mask)
	if mask.name then
		charm:name(mask.name)
	end
end

registerCharm.description = function(charm, mask)
	if mask.description then
		charm:description(mask.description)
	end
end

registerCharm.sounds = function(charm, mask)
	if mask.sounds then
		if mask.sounds.castSound then
			charm:castSound(mask.sounds.castSound)
		end
		if mask.sounds.impactSound then
			charm:impactSound(mask.sounds.impactSound)
		end
	end
end

registerCharm.category = function(charm, mask)
	if mask.type then
		charm:category(mask.category)
	end
end

registerCharm.type = function(charm, mask)
	if mask.type then
		charm:type(mask.type)
	end
end

registerCharm.damageType = function(charm, mask)
	if mask.damageType then
		charm:damageType(mask.damageType)
	end
end

registerCharm.percent = function(charm, mask)
	if mask.percent then
		charm:percentage(mask.percent)
	end
end

registerCharm.chance = function(charm, mask)
	if mask.chance then
		charm:chance(mask.chance)
	end
end

registerCharm.messageCancel = function(charm, mask)
	if mask.messageCancel then
		charm:messageCancel(mask.messageCancel)
	end
end

registerCharm.messageServerLog = function(charm, mask)
	if mask.messageServerLog then
		charm:messageServerLog(mask.messageServerLog)
	end
end

registerCharm.effect = function(charm, mask)
	if mask.effect then
		charm:effect(mask.effect)
	end
end

registerCharm.points = function(charm, mask)
	if mask.points then
		charm:points(mask.points)
	end
end
