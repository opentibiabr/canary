local actions_asura_fragrance = Action()

function actions_asura_fragrance.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Hmmmm, what an infatuating fragrance!")
	player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Asuras.Fragrance, os.time() + 10 * 60)
	item:remove(1)

	return true
end

actions_asura_fragrance:id(28495)
actions_asura_fragrance:register()
