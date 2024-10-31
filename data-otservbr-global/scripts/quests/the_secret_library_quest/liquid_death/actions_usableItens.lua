local config = {
	statues = {
		[1] = { position = Position(33598, 31398, 14), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue1 },
		[2] = { position = Position(33602, 31439, 13), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue2 },
		[3] = { position = Position(33587, 31461, 14), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue3 },
		[4] = { position = Position(33588, 31461, 14), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue4 },
		[5] = { position = Position(33549, 31459, 14), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue5 },
		[6] = { position = Position(33577, 31475, 15), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue6 },
		[7] = { position = Position(33612, 31465, 15), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue7 },
		[8] = { position = Position(33565, 31423, 13), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue8 },
		[9] = { position = Position(33574, 31441, 15), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Statue9 },
	},
	bookInfo = {
		id = 14072,
		position = Position(32881, 32435, 8),
		storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline,
		value = 2,
		message = "The descriptions in this book look like plans detailing the launch of a large-scale assault.",
	},
	statueEffect = CONST_ME_THUNDER,
	statueMessage = "The Njey will appreciate your help.",
	statueMessage_ = "You recently fixed that idol.",
	statueId = { 15895, 15896 },
	fixedId = { 15894, 15897 },
	countStatues = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.StatueCount,
	maxValue = 9,
}

local function doRevert(position, id, newId)
	local item = Tile(position):getItemById(newId)
	if item then
		item:transform(id)
	end
end

local function fixStatue(position, id)
	local item = Tile(position):getItemById(id)
	local newId = 0

	if id == config.statueId[1] then
		newId = config.fixedId[1]
	else
		newId = config.fixedId[2]
	end

	if item then
		item:transform(newId)
		position:sendMagicEffect(config.statueEffect)
	end

	addEvent(doRevert, 10 * 1000, position, id, newId)
end

local actions_liquid_usableItens = Action()

function actions_liquid_usableItens.onUse(player, item, position, fromPosition, pos, target, toPosition)
	local b = config.bookInfo

	if item:getId() == b.id and item:getPosition() == b.position then
		if player:getStorageValue(b.storage) == b.value then
			player:setStorageValue(b.storage, player:getStorageValue(b.storage) + 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, b.message)
		end
	else
		local statueId = config.statueId
		if item.itemid == statueId[1] or item.itemid == statueId[2] then
			for _, k in pairs(config.statues) do
				if position == k.position then
					if player:getStorageValue(k.storage) < 1 then
						player:setStorageValue(k.storage, 1)
						player:setStorageValue(config.countStatues, math.max(player:getStorageValue(config.countStatues), 0) + 1)
						if player:getStorageValue(config.countStatues) == config.maxValue then
							player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) + 1)
						end
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.statueMessage)
						fixStatue(position, item.itemid)
					else
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.statueMessage_)
					end
				end
			end
		end
	end

	return true
end

actions_liquid_usableItens:aid(4900)
actions_liquid_usableItens:register()
