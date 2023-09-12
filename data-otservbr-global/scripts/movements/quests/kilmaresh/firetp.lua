-- (Eduardo) TODO: Refactor this script
local firstTp = {
	itemActionId = 57539, -- action id teleport
	posFireOne = { x = 33830, y = 31628, z = 9 }, -- local do fire um
	posFireTwo = { x = 33832, y = 31628, z = 9 }, -- local do fire dois
	posFireTree = { x = 33834, y = 31628, z = 9 }, -- local do fire tres
	fireIdOn = 171, -- id do fire on
	fireIdOff = 2114, -- id do fire off
}

local secondTp = {
	itemActionId = 57540, -- action id teleport
	posFireOne = { x = 33830, y = 31628, z = 9 }, -- local do fire um
	posFireTwo = { x = 33832, y = 31628, z = 9 }, -- local do fire dois
	posFireTree = { x = 33834, y = 31628, z = 9 }, -- local do fire tres
	fireIdOn = 171, -- id do fire on
	fireIdOff = 2114, -- id do fire off
}

local thirdTp = {
	itemActionId = 57541, -- action id teleport
	posFireOne = { x = 33830, y = 31628, z = 9 }, -- local do fire um
	posFireTwo = { x = 33832, y = 31628, z = 9 }, -- local do fire dois
	posFireTree = { x = 33834, y = 31628, z = 9 }, -- local do fire tres
	fireIdOn = 171, -- id do fire on
	fireIdOff = 2114, -- id do fire off
}

local fourthTp = {
	itemActionId = 57542, -- action id teleport
	posFireOne = { x = 33830, y = 31628, z = 9 }, -- local do fire um
	posFireTwo = { x = 33832, y = 31628, z = 9 }, -- local do fire dois
	posFireTree = { x = 33834, y = 31628, z = 9 }, -- local do fire tres
	fireIdOn = 171, -- id do fire on
	fireIdOff = 2114, -- id do fire off
}

local backPosition = { x = 33822, y = 31645, z = 9 } -- errou
local finalPosition = { x = 33826, y = 31620, z = 9 } -- deu certo

local firetp = MoveEvent()

function firetp.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local firstStepFireOne = Tile(firstTp.posFireOne):getItemById(firstTp.fireIdOff)
	local firstfasefiredois = Tile(firstTp.posFireTwo):getItemById(firstTp.fireIdOff)
	local firstStepFireTree = Tile(firstTp.posFireTree):getItemById(firstTp.fireIdOff)
	if item.actionid == firstTp.itemActionId then
		if firstStepFireOne and firstfasefiredois and firstStepFireTree then
			player:teleportTo(finalPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(backPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	local secondStepFireOne = Tile(secondTp.posFireOne):getItemById(secondTp.fireIdOn)
	local secondStepFireTwo = Tile(secondTp.posFireTwo):getItemById(secondTp.fireIdOff)
	local secondStepFireTree = Tile(secondTp.posFireTree):getItemById(secondTp.fireIdOff)
	if item.actionid == secondTp.itemActionId then
		if secondStepFireOne and secondStepFireTwo and secondStepFireTree then
			player:teleportTo(finalPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(backPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	local thirdStepFireOne = Tile(thirdTp.posFireOne):getItemById(thirdTp.fireIdOn)
	local thirdStepFireTwo = Tile(thirdTp.posFireTwo):getItemById(thirdTp.fireIdOn)
	local thirdStepFireTree = Tile(thirdTp.posFireTree):getItemById(thirdTp.fireIdOff)
	if item.actionid == thirdTp.itemActionId then
		if thirdStepFireOne and thirdStepFireTwo and thirdStepFireTree then
			player:teleportTo(finalPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(backPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	local fourthStepFireOne = Tile(fourthTp.posFireOne):getItemById(fourthTp.fireIdOn)
	local fourthStepFireTwo = Tile(fourthTp.posFireTwo):getItemById(fourthTp.fireIdOn)
	local fourthStepFireTree = Tile(fourthTp.posFireTree):getItemById(fourthTp.fireIdOn)
	if item.actionid == fourthTp.itemActionId then
		if fourthStepFireOne and fourthStepFireTwo and fourthStepFireTree then
			player:teleportTo(finalPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(backPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return true
end

firetp:aid(57539, 57540, 57541, 57542)
firetp:register()
