local ItemsCursed = {
	[12422] = {usedID = 23873, finalID = 23874}, -- Flask with oil and blood
	[23873] = {usedID = 12422, finalID = 23874}, -- Flask with oil and blood
	[23874] = {usedID = 23876, finalID = 23875}, -- Medusa's oilment
	[23876] = {usedID = 23874, finalID = 23875} -- Medusa's oilment
}

local theCursedMedusa = Action()
function theCursedMedusa.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (item.itemid == 23875) and (item2.itemid == 11337) then
		if(player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) == 2)then
			if not(((Player(player):getPosition().x - TCC_PILLARPETRIFIED.x) < 5) and ((Player(player):getPosition().x - TCC_PILLARPETRIFIED.x) > -5) and 
			((Player(player):getPosition().y - TCC_PILLARPETRIFIED.y) < 5) and ((Player(player):getPosition().y - TCC_PILLARPETRIFIED.y) > -5) and (Player(player):getPosition().z == TCC_PILLARPETRIFIED.z)) then
				return
			end
			player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe, 3)
			item:remove(1)
			item2:remove(1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You unpetrify a banshee's scream near the evil crystal, your ears protected by wax. Thus the baleful artefact is destroyed.")
			local stone = Tile(TCC_PILLARPETRIFIED):getItemById(11753)
			doSendMagicEffect(stone:getPosition(), CONST_ME_POFF)
			stone:transform(11826)
				addEvent(function() 
				stone:transform(11753)
				end,5000)
		end
		return
	elseif(item.itemid == 10025)then
		if not(Tile(topos)) or not(Tile(topos):getTopCreature()) or not(Tile(topos):getTopCreature():isPlayer()) then
			return
		end
		if (Player(player) == Player(Tile(topos):getTopCreature())) and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 2) then
			if not(((Player(player):getPosition().x - TCC_PILLARPETRIFIED.x) < 5) and ((Player(player):getPosition().x - TCC_PILLARPETRIFIED.x) > -5) and 
			((Player(player):getPosition().y - TCC_PILLARPETRIFIED.y) < 5) and ((Player(player):getPosition().y - TCC_PILLARPETRIFIED.y) > -5) and (Player(player):getPosition().z == TCC_PILLARPETRIFIED.z)) then
				return
			end
			player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You use the molten wax to plug your ears.")
			doSendMagicEffect(player:getPosition(), CONST_ME_YELLOWSMOKE)
			item:remove(1)
		end
		return
	end
	for index, value in pairs(ItemsCursed) do
		if item2.itemid == index and item.itemid == value.usedID then
			if(value.finalID == 23874)then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You mixed the first ingredients to create a special ointment. But it isn't complete yet.")
			elseif(value.finalID == 23875)then
				if(player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline) < 2)then
					player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline, 2)
				end
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You mixed the proper ingredients to create a special ointment. With this salve you may unpetrify a petrified object.")
			end
			local topParent = item2:getTopParent()
			if topParent.isItem and (not topParent:isItem() or topParent.itemid ~= 460) then
				local parent = item2:getParent()
				if not parent:isTile() and (parent:addItem(value.finalID, 1) or topParent:addItem(value.finalID, 1)) then
					item2:remove(1)
					item:remove(1)
					Game.createItem(value.finalID, 1, item2:getPosition())
					return true
				else
					Game.createItem(value.finalID, 1, item2:getPosition())
				end
			else
				Game.createItem(value.finalID, 1, item2:getPosition())
			end
			item2:remove(1)
			item:remove(1)
			return
		end
	end
	player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
end

theCursedMedusa:id(10025,12422,23873,23874,23876)
theCursedMedusa:register()