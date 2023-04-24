-- Credits: https://otland.net/threads/tfs-1-5-send-squarecolour-when-equiped-a-set.284711/

local squareInterval = 1 -- seconds
local squareColour = TEXTCOLOR_SKYBLUE
local equipments = {
	[CONST_SLOT_HEAD] = 3387,
	[CONST_SLOT_ARMOR] = 3388,
	[CONST_SLOT_LEGS] = 3389,
	[CONST_SLOT_FEET] = 3554
}

function EventCallback.onInventoryUpdate(player, item, slot, equip)
	local equipamentId = equipments[slot]
	if not equipamentId then
		return
	end

	if not equip then
		if item:getId() == equipamentId then
			player:unregisterEvent("SquareColour")
		end
		return
	end

	for s, id in pairs(equipments) do
		if s ~= slot then
			local sItem = player:getSlotItem(s)
			if not sItem or sItem:getId() ~= id then
				player:unregisterEvent("SquareColour")
				return
			end
		end
	end

	player:registerEvent("SquareColour")
end

local intervals = {}

local squareEvent = CreatureEvent("SquareColour")

function squareEvent.onThink(player)
	local playerId = player:getId()
	local timeNow = os.time()
	if not intervals[playerId] then
		intervals[playerId] = timeNow
	end

	if timeNow - intervals[playerId] >= squareInterval then
		intervals[playerId] = timeNow + squareInterval
		for _, specPlayer in pairs(Game.getSpectators(player:getPosition(), false, true)) do
			if specPlayer then
				specPlayer:getPosition():sendMagicEffect(CONST_ME_FIREAREA)
			end
		end
	end
	return true
end

squareEvent:register()
