local totems = {
	{ toPosition = Position(32945, 32292, 8), targetId = 28531, toId = 28532, itemId = 28535, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FirstTotem },
	{ toPosition = Position(32947, 32292, 8), targetId = 28527, toId = 28528, itemId = 28537, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.SecondTotem },
	{ toPosition = Position(32949, 32292, 8), targetId = 28533, toId = 28534, itemId = 28538, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.ThirdTotem },
	{ toPosition = Position(32951, 32292, 8), targetId = 28529, toId = 28530, itemId = 28536, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FourthTotem },
}

local function isQuestComplete(cid)
	local player = Player(cid)
	if player then
		for _, s in pairs(totems) do
			if player:getStorageValue(s.storage) ~= 1 then
				return false
			end
		end
	end
	return true
end

local function revert(old, new, position)
	local totem = Tile(position):getItemById(new)
	if totem then
		totem:transform(old)
	end
end

local actions_desert_totems = Action()

function actions_desert_totems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline) == 6 then
		for _, k in pairs(totems) do
			if toPosition == k.toPosition and item.itemid == k.itemId and target.itemid == k.targetId then
				if player:getStorageValue(k.storage) < 1 then
					toPosition:sendMagicEffect(CONST_ME_HITAREA)
					target:transform(k.toId)
					item:remove(1)
					player:setStorageValue(k.storage, 1)
					addEvent(revert, 15 * 1000, k.targetId, k.toId, toPosition)
				end
			end
			if isQuestComplete(player:getId()) then
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, 7)
				player:say("Access granted!", TALKTYPE_MONSTER_SAY)
			end
		end
	end
	return true
end

for _, totem in pairs(totems) do
	actions_desert_totems:id(totem.itemId)
end

actions_desert_totems:register()
