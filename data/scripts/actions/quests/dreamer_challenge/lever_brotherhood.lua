local config = {
	[1] = {uid = 3045, position = Position(32784, 32222, 14), itemId = 7844, storageOutfit = 2},
	[2] = {uid = 3046, position = Position(32785, 32230, 14), itemId = 7846, storageOutfit = 3},
	[3] = {uid = 3047, position = Position(32781, 32226, 14), itemId = 7845, storageOutfit = 4}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

local dreamerBrotherhoodLever = Action()
function dreamerBrotherhoodLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return true
	end
	if item.uid == config[1].uid then
		local diamondItem = Tile(config[1].position):getItemById(2145)
		if player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) >= config[1].storageOutfit then
			if diamondItem and player:getStorageValue(Storage.DreamersChallenge.LeverBrotherhood1) < 1 then
				diamondItem:remove(1)
				player:setStorageValue(Storage.DreamersChallenge.LeverBrotherhood1, 1)
				config[1].position:sendMagicEffect(CONST_ME_TELEPORT)
				Game.createItem(config[1].itemId, 1, config[1].position)
				item:transform(1946)
				addEvent(revertLever, 4 * 1000, toPosition)
			elseif not diamondItem and player:getStorageValue(Storage.DreamersChallenge.LeverBrotherhood1) < 1 then
				player:sendCancelMessage('You need to offer a small diamond.')
			else
				player:sendCancelMessage('You have already used this lever!')
			end
		else
			player:sendCancelMessage('You still don\'t have permission.')
		end
	elseif item.uid == config[2].uid then
		if player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) >= config[2].storageOutfit then
			local diamondItem = Tile(config[2].position):getItemById(2145)
			if diamondItem and player:getStorageValue(Storage.DreamersChallenge.LeverBrotherhood2) < 1 then
				diamondItem:remove(1)
				player:setStorageValue(Storage.DreamersChallenge.LeverBrotherhood2, 1)
				config[2].position:sendMagicEffect(CONST_ME_TELEPORT)
				Game.createItem(config[2].itemId, 1, config[2].position)
				item:transform(1946)
				addEvent(revertLever, 4 * 1000, toPosition)
			elseif not diamondItem and player:getStorageValue(Storage.DreamersChallenge.LeverBrotherhood2) < 1 then
				player:sendCancelMessage('You need to offer a small diamond.')
			else
				player:sendCancelMessage('You have already used this lever!')
			end
		else
			player:sendCancelMessage('You still don\'t have permission.')
		end
	elseif item.uid == config[3].uid then
		if player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) >= config[3].storageOutfit then
			local diamondItem = Tile(config[3].position):getItemById(2145)
			if diamondItem and player:getStorageValue(Storage.DreamersChallenge.LeverBrotherhood3) < 1 then
				diamondItem:remove(1)
				player:setStorageValue(Storage.DreamersChallenge.LeverBrotherhood3, 1)
				config[3].position:sendMagicEffect(CONST_ME_TELEPORT)
				Game.createItem(config[3].itemId, 1, config[3].position)
				item:transform(1946)
				addEvent(revertLever, 4 * 1000, toPosition)
			elseif not diamondItem and player:getStorageValue(Storage.DreamersChallenge.LeverBrotherhood3) < 1 then
				player:sendCancelMessage('You need to offer a small diamond.')
			else
				player:sendCancelMessage('You have already used this lever!')
			end
		else
			player:sendCancelMessage('You still don\'t have permission.')
		end
	end
end

dreamerBrotherhoodLever:uid(3045,3046,3047)
dreamerBrotherhoodLever:register()