local goldenOutfitDisplay = Action()

function goldenOutfitDisplay.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		
	if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) == 3 then
		if (item:getId() == 31509) then --direita
			item:transform(31500)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31500) then
			item:transform(31505)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31505) then
			item:transform(31513)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31513) then
			item:transform(31509)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31510) then --baixo
			item:transform(31502)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31502) then
			item:transform(31506)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31506) then
			item:transform(31514)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31514) then
			item:transform(31510)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31511) then --esquerda
			item:transform(31503)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31503) then
			item:transform(31507)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31507) then
			item:transform(31515)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31515) then
			item:transform(31511)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31512) then --cima
			item:transform(31504)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31504) then
			item:transform(31508)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31508) then
			item:transform(31516)
			item:getPosition():sendMagicEffect(171)
		elseif (item:getId() == 31516) then
			item:transform(31512)
			item:getPosition():sendMagicEffect(171)
		end
	else 
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need Full Golden Outfit to use it.")
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

goldenOutfitDisplay:id(31500, 31502, 31503, 31504, 31505, 31506, 31507, 31508, 31509, 31510, 31511, 31512, 31513, 31514, 31515, 31516)
goldenOutfitDisplay:register()
