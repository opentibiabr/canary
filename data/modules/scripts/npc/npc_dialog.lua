NpcDialog = NpcDialog or {}
NpcDialog._stateByPlayerId = NpcDialog._stateByPlayerId or {}
NpcDialog.ValidProfessions = NpcDialog.ValidProfessions or {
	normal = true,
	sailor = true,
	banker = true,
	king = true,
	queen = true,
	trader = true,
	hireling = true,
}

local BUTTON = {
	Trade = 0,
	TradePotion = 1,
	TradeEquipment = 2,
	Sail = 3,
	DepositAll = 4,
	Withdraw = 5,
	Balance = 6,
	Yes = 7,
	No = 8,
	Bye = 9,
}

local function addAction(actions, buttonId, keyword)
	actions[#actions + 1] = {
		buttonId = buttonId,
		keyword = keyword,
	}
end

local function hasNpcId(list, npcId)
	for _, id in ipairs(list) do
		if id == npcId then
			return true
		end
	end
	return false
end

function NpcDialog._getList(player)
	local playerId = player and player:getId()
	if not playerId then
		return nil
	end

	local list = NpcDialog._stateByPlayerId[playerId]
	if not list then
		list = {}
		NpcDialog._stateByPlayerId[playerId] = list
	end

	return list
end

function NpcDialog.add(player, npcId)
	if not player or not npcId or npcId == 0 then
		return
	end

	local list = NpcDialog._getList(player)
	if not list or hasNpcId(list, npcId) then
		return
	end

	list[#list + 1] = npcId
end

function NpcDialog.remove(player, npcId)
	if not player or not npcId or npcId == 0 then
		return
	end

	local list = NpcDialog._getList(player)
	if not list or #list == 0 then
		return
	end

	for i = #list, 1, -1 do
		if list[i] == npcId then
			table.remove(list, i)
		end
	end
end

function NpcDialog.clear(player)
	if not player then
		return
	end

	local playerId = player:getId()
	if not playerId then
		return
	end

	NpcDialog._stateByPlayerId[playerId] = {}
end

function NpcDialog.buildActions(player, npc)
	local actions = {}
	if not player or not npc then
		return actions
	end

	addAction(actions, BUTTON.Yes, "yes")
	addAction(actions, BUTTON.No, "no")
	addAction(actions, BUTTON.Bye, "bye")

	if npc:isMerchant() then
		addAction(actions, BUTTON.Trade, "trade")
	end

	local profession = "normal"
	if NpcDialogProfessionByName then
		profession = NpcDialogProfessionByName[npc:getName():lower()] or profession
	end

	if profession == "sailor" then
		addAction(actions, BUTTON.Sail, "sail")
	end

	if profession == "banker" then
		addAction(actions, BUTTON.DepositAll, "deposit all")
		addAction(actions, BUTTON.Withdraw, "withdraw")
		addAction(actions, BUTTON.Balance, "balance")
	end

	if profession == "hireling" or npc:getSpeechBubble() == SPEECHBUBBLE_HIRELING then
		local skills = player:kv():scoped("hireling-skills")
		if skills:get("banker") then
			addAction(actions, BUTTON.DepositAll, "deposit all")
			addAction(actions, BUTTON.Withdraw, "withdraw")
			addAction(actions, BUTTON.Balance, "balance")
		end
		if skills:get("trader") then
			addAction(actions, BUTTON.TradePotion, "potions")
			addAction(actions, BUTTON.TradeEquipment, "equipment")
		end
	end

	return actions
end

function NpcDialog.sendWindow(player)
	if not player then
		return
	end

	local npcIds = NpcDialog._getList(player) or {}

	local msg = NetworkMessage()
	msg:addByte(0x1C)
	msg:addByte(#npcIds > 0 and 0x00 or 0x01)

	if #npcIds <= 0 then
		msg:sendToPlayer(player)
		return
	end

	msg:addByte(#npcIds)
	for _, npcId in ipairs(npcIds) do
		msg:addU32(npcId)
	end

	local actions = {}
	local lastNpc = Npc(npcIds[#npcIds])
	if not lastNpc then
		NpcDialog.clear(player)
		msg = NetworkMessage()
		msg:addByte(0x1C)
		msg:addByte(0x01)
		msg:sendToPlayer(player)
		return
	end

	actions = NpcDialog.buildActions(player, lastNpc)

	msg:addByte(#actions)
	for _, action in ipairs(actions) do
		msg:addByte(action.buttonId)
		msg:addString(action.keyword)
	end

	msg:sendToPlayer(player)
end
