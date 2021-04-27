local goldenOutfitDisplay = Action()

function goldenOutfitDisplay.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		
	if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) == 3 then
		if (item:getId() == 36344) then --direita
			item:transform(36336)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36336) then
			item:transform(36340)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36340) then
			item:transform(36348)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36348) then
			item:transform(36344)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36345) then --baixo
			item:transform(36337)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36337) then
			item:transform(36341)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36341) then
			item:transform(36349)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36349) then
			item:transform(36345)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36346) then --esquerda
			item:transform(36338)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36338) then
			item:transform(36342)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36342) then
			item:transform(36350)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36350) then
			item:transform(36346)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36347) then --cima
			item:transform(36339)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36339) then
			item:transform(36343)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36343) then
			item:transform(36351)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 36351) then
			item:transform(36347)
			item:getPosition():sendMagicEffect(171)
		end
	else 
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need Full Golden Outfit to use it.")
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

goldenOutfitDisplay:id(36336, 36337, 36338, 36339, 36340, 36341, 36342, 36343, 36344, 36345, 36346, 36347, 36348, 36349, 36350, 36351)
goldenOutfitDisplay:register()
