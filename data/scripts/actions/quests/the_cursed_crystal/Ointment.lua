local theCursedOintment = Action()
function theCursedOintment.onUse(player, item, frompos, item2, topos)
		-- The Cursed Crystal quest:
	if (item.itemid == 23875) and (item2.itemid == 11337) then
		if(player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) == 2)then
			if not(((Player(player):getPosition().x - TCC_PILLARPETRIFIED.x) < 5) and ((Player(player):getPosition().x - TCC_PILLARPETRIFIED.x) > -5) and 
			((Player(player):getPosition().y - TCC_PILLARPETRIFIED.y) < 5) and ((Player(player):getPosition().y - TCC_PILLARPETRIFIED.y) > -5) and (Player(player):getPosition().z == TCC_PILLARPETRIFIED.z)) then
				return
			end
			if (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline) < 3)then
				player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline, 3)
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
		-- The dream courts quest: not ready
		-- elseif
	end
end

theCursedOintment:id(23875)
theCursedOintment:register()