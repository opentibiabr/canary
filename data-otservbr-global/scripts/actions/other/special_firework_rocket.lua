local CONST_FIREWORK_TYPE_INSTANT, CONST_FIREWORK_TYPE_RANDOM, CONST_FIREWORK_TYPE_IMPLOSION = 1, 2, 3
CONST_FIREWORK_ITEMID_DISASSEMBLE, CONST_FIREWORK_ITEMID_NOT_DISASSEMBLE = 30329, 30330
local maxCooldown = 5

local fireworks = {
	-- Explosive Fireworks
	[37448] = {
		area = AREA_CIRCLE5X5V2,
		effect = CONST_ME_EXPLOSIONAREA,
		type = CONST_FIREWORK_TYPE_RANDOM,
		disassemble = true,
	},

	-- Splashing Fireworks
	[37453] = {
		area = AREA_CIRCLE5X5V2,
		effect = CONST_ME_WATERSPLASH,
		type = CONST_FIREWORK_TYPE_IMPLOSION,
		disassemble = true,
	},

	-- Snapping Fireworks
	[37450] = {
		area = AREA_CIRCLE5X5V2,
		effect = CONST_ME_GHOSTLY_BITE,
		type = CONST_FIREWORK_TYPE_IMPLOSION,
		disassemble = true,
	},

	--Dazzling Fireworks
	[37459] = {
		area = AREA_CIRCLE5X5V2,
		effect = CONST_ME_DAZZLING,
		type = CONST_FIREWORK_TYPE_RANDOM,
		disassemble = true,
	},

	-- Godly Fireworks
	[37456] = {
		area = AREA_CIRCLE5X5V2,
		effect = CONST_ME_THUNDER,
		type = CONST_FIREWORK_TYPE_RANDOM,
		disassemble = true,
	},

	-- Electric Fireworks
	[37452] = {
		area = AREA_CIRCLE6X6,
		effect = CONST_ME_YELLOW_ENERGY_SPARK,
		type = CONST_FIREWORK_TYPE_IMPLOSION,
		disassemble = true,
	},

	-- Lovely Fireworks
	[37454] = {
		area = {
			{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
			{ 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0 },
			{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
			{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
			{ 0, 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0, 0 },
			{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
			{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
			{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
			{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		},
		effect = CONST_ME_HEARTS,
		type = CONST_FIREWORK_TYPE_INSTANT,
		disassemble = true,
	},

	-- Sparkling Fireworks
	[37458] = {
		area = AREA_CIRCLE5X5V2,
		effect = CONST_ME_SPARKLING,
		type = CONST_FIREWORK_TYPE_RANDOM,
		disassemble = true,
	},

	-- Ghostly Fireworks
	[37455] = {
		area = AREA_CIRCLE3X3,
		effect = CONST_ME_GHOST_SMOKE,
		type = CONST_FIREWORK_TYPE_IMPLOSION,
		disassemble = true,
	},

	-- Fiery Fireworks
	[37460] = {
		area = AREA_CIRCLE6X6,
		effect = CONST_ME_FIREATTACK,
		type = CONST_FIREWORK_TYPE_RANDOM,
		disassemble = true,
	},

	-- Magical Fireworks
	[37451] = {
		area = AREA_CIRCLE6X6,
		effect = CONST_ME_PIXIE_EXPLOSION,
		type = CONST_FIREWORK_TYPE_RANDOM,
		disassemble = true,
	},
}

local function cleanMatrix(matrix)
	for i = 1, #matrix do
		for j = 1, #matrix[i] do
			if matrix[i][j] ~= 0 then
				matrix[i][j] = 1
			end
		end
	end
	return matrix
end

local function drawMatrix(matrix, x, y, size, value)
	local halfSize = math.floor(size / 2)
	for i = y - halfSize, y + halfSize do
		for j = x - halfSize, x + halfSize do
			if matrix[i][j] ~= 0 then
				if matrix[i][j] == 1 or matrix[i][j] == -1 then
					if i >= 1 and i <= #matrix and j >= 1 and j <= #matrix[i] then
						matrix[i][j] = value == -1 and math.random(maxCooldown) or value
					end
				end
			end
		end
	end
end

local fireworksRocket = Action()
function fireworksRocket.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemID = item:getId()
	local firework = fireworks[itemID]
	if not firework then
		return false
	end
	if item:getParent():isContainer() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can't use this item in a container.")
		return false
	end
	local event = addEvent(function()
		item:remove()
		local matrix = cleanMatrix(firework.area)
		local centerArea = { #matrix / 2, #matrix[1] / 2 }
		matrix[math.ceil(centerArea[1])][math.ceil(centerArea[2])] = -1
		local cdMatrix = 1
		for step = 1, centerArea[1] + 1 do
			if firework.type == CONST_FIREWORK_TYPE_IMPLOSION then
				cdMatrix = step + 1
			elseif firework.type == CONST_FIREWORK_TYPE_RANDOM then
				cdMatrix = -1
			end
			drawMatrix(matrix, math.floor(centerArea[2]) + 1, math.floor(centerArea[1]) + 1, step * 2 - 1, cdMatrix)
		end
		for iY, y in ipairs(matrix) do
			for iX, x in ipairs(y) do
				if x ~= 0 then
					addEvent(function(effect, position)
						position:sendMagicEffect(effect)
					end, x * 100, firework.effect, Position(fromPosition.x + iX - centerArea[2], fromPosition.y + iY - centerArea[1], fromPosition.z))
				end
			end
		end
	end, 10 * 1000)
	if firework.disassemble then
		item:transform(CONST_FIREWORK_ITEMID_DISASSEMBLE)
		item:setCustomAttribute("id", itemID)
		item:setCustomAttribute("event", event)
	else
		item:transform(CONST_FIREWORK_ITEMID_NOT_DISASSEMBLE)
	end
	return true
end

for i, _ in pairs(fireworks) do
	fireworksRocket:id(i)
end
fireworksRocket:register()
