local config = {
	{ position = Position(32396, 31806, 8), itemId = 1295 },
}

local cultsOfTibiaTouch = Action()

function cultsOfTibiaTouch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wallItem

	if Game.getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Humans.WallDecaying) >= os.time() then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	else
		for i = 1, #config do
			wallItem = Tile(config[i].position):getItemById(config[i].itemId)
			if wallItem then
				Position(32396, 31806, 8):sendMagicEffect(CONST_ME_POFF)
				wallItem:remove()
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You hear a loud grinding sound not very far from you. something very heavy seems to have moved.")
				Game.setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Humans.WallDecaying, os.time() + 306)
				addEvent(Game.createItem, 300000, 1295, 1, Position(32396, 31806, 8))
			end
		end
	end

	return true
end

cultsOfTibiaTouch:aid(5524)
cultsOfTibiaTouch:register()
