Features = {
	AutoLoot = "autoloot",
}

local function validateFeature(feature)
	local found = false
	for _, v in pairs(Features) do
		if v == feature then
			found = true
		end
	end
	if not found then
		error("Invalid feature: " .. feature)
	end
end

function Player:hasFeature(feature)
	validateFeature(feature)
	local kv = self:kv():scoped("features")
	if kv:get(feature) then
		return true
	end
	return false
end

function Player:getFeature(feature)
	validateFeature(feature)
	local kv = self:kv():scoped("features")
	return kv:get(feature)
end

function Player:setFeature(feature, value)
	validateFeature(feature)
	local kv = self:kv():scoped("features")
	kv:set(feature, value)
end
