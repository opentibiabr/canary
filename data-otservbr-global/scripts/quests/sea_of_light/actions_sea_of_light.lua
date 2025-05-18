-- Rare crystal
local rareCrystal = Action()

function rareCrystal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) ~= 7 then
		return false
	end

	if toPosition == Position(32011, 31709, 7) then
		player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) + 1)
		player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission3, player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission3) + 1)
		player:teleportTo({ x = 32017, y = 31730, z = 8 })
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		item:remove()
		return true
	end
	return false
end

rareCrystal:id(9697)
rareCrystal:register()

-- Collector corpse
local collectorCorpse = Action()

function collectorCorpse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 9695 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) ~= 8 then
		return false
	end

	player:say("You carefully put the mirror crystal into the astronomers's device.", TALKTYPE_MONSTER_SAY)
	player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 9)
	player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission3, 3)
	item:transform(9699)
end

collectorCorpse:id(9698)
collectorCorpse:register()
