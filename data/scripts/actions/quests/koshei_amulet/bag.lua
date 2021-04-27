local documentContent = [[
PAGE 2
Lord Koshei the Curious
-_-_-_-_-_-_-_-_-_-_-_-
Date of birth: unknown
Age: unknown
Hometown: unknown
Date of death: unknown
There are not many things known about this man. He appeared out of nowhere and lived here for nearly ten years. Even though he was communicative, he never told anything about his profession or what he did for a living. First he lived in Darashia 2, Flat 11 for about two years. During that time he was roaming around, travelling the lands of Darama and often visiting the Bath of Dreams and the minotaur pyramid in the North.
Then it was discovered that he had built a tower south of the mountains. It is unexplained how he managed to do that because no one has been seen to help him. Anyway, the remains of his tower are still there. ...]]

local kosheiBag = Action()
function kosheiBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (player:getStorageValue(483293) == -1) then
		local bag = player:addItem(1987, 1)
		if (bag) then
			local document = bag:addItem(1968, 1)
			if (document) then
				document:setAttribute(ITEM_ATTRIBUTE_NAME, "Famous Inhabitants of Darashia, Page 2")
				document:setAttribute(ITEM_ATTRIBUTE_TEXT, documentContent)
			end
		end
		player:setStorageValue(483293)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a bag.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The bookcase is empty.")
	end
	return true
end

kosheiBag:aid(40532)
kosheiBag:register()