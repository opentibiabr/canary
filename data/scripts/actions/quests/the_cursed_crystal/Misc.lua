local theCursedMiscItem = Action()
function theCursedMiscItem.onUse(cid, item, frompos, item2, topos)
	local user1 = Player(cid)
	if (item.itemid == 5902) then
		if ((item2.itemid == 1786) or (item2.itemid == 1788) or (item2.itemid == 1790) or (item2.itemid == 1792)) then
			item:remove(1)
			doPlayerAddItem(cid,10025,1)
		end
		return
	elseif (item.itemid == 23923) then
		if (((user1:getPosition().x - TCC_VORTEX_POSITION.x) < 4) and ((user1:getPosition().x - TCC_VORTEX_POSITION.x) > -4)) and
		(((user1:getPosition().y - TCC_VORTEX_POSITION.y) < 4) and ((user1:getPosition().y - TCC_VORTEX_POSITION.y) > -4)) then
			Game.createItem(8632, 1, TCC_VORTEX_POSITION)
			Tile(TCC_VORTEX_POSITION):getItemById(8632):setActionId(35001)
			doSendMagicEffect(user1:getPosition(), CONST_ME_SOUND_WHITE)
			user1:sendTextMessage(MESSAGE_EVENT_ADVANCE, "As you use the small bell an unearthly sound rings out sweetly. At the same moment, the lake's waters begin to whirl.")
				addEvent(function() 
					Tile(TCC_VORTEX_POSITION):getItemById(8632):remove() 
				end, 10000)		
		end
	end
end

theCursedMiscItem:id(5902,23923,23941)
theCursedMiscItem:register()

local theCursedMiscAction = Action()
function theCursedMiscAction.onUse(cid, item, frompos, item2, topos)
	if (item.actionid == 40001) and (item:getPosition() == TCC_SKELETON_PAPER_POS) then -- 40028
		if (user1:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 1) then
			user1:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a sheet of paper.")
			local paperCursedCrystal = doPlayerAddItem(cid, 1954, 1)
			Item(paperCursedCrystal):setAttribute(ITEM_ATTRIBUTE_TEXT, "I did it! I reached the crystal gardens! What beauty and splendor I have seen down there. Even more: I discovered a small subterranean lake - but Harry was there before me. And he did something strange: He ringed a small, transparent looking bell and immediatly a big whirl appeared in the water. I suppose this is the mysterious way deeper into the caves we sought after for so long. But Harry, the coward, didn't dare to dive into the water. Instead he left the caverns and heeded back to the surface. I have to go after him tomorrow. I must have this bell!")
		else
			user1:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pile of bones empty.")
		end
		return
	elseif (item.actionid == 40001) and (item:getPosition() == TCC_SKELETON_BELL_POS) then -- 40029
		if (user1:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 1) then
			user1:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a small crystal bell.")
			doPlayerAddItem(cid, 23923, 1)
			user1:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe, 1)
		else
			user1:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pile of bones empty.")
		end
		return
	elseif (item.actionid == 40002) and (item.itemid == 23941) then
		if (user1:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) > 0) then
			if (user1:getStorageValue(Storage.TibiaTales.TheCursedCrystal.MedusaOil) < os.time()) then
				user1:setStorageValue(Storage.TibiaTales.TheCursedCrystal.MedusaOil, os.time() + 72000)
				doPlayerAddItem(cid, 23873, 1)
				doSendMagicEffect(item:getPosition(), CONST_ME_MAGIC_RED)
				user1:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take some blood out of the hollow crystal. Hopefully that it is actually a medusa's blood.")
			end
			return
		end
	end
end

theCursedMiscAction:id(40001, 40002)
theCursedMiscAction:register()