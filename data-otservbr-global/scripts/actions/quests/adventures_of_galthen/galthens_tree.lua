local galthensTree = Action()
function galthensTree.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local hasExhaustion, message = player:kv():get("galthens-satchel") or 0, "Empty."
	if hasExhaustion < os.time() then
		local container = player:addItem(36813)
		container:addItem(36810, 1)
		player:kv():set("galthens-satchel", os.time() + 30 * 24 * 60 * 60)
		message = "You have found a galthens satchel."
	end

	player:teleportTo(Position(32396, 32520, 7))
	player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)

	return true
end

galthensTree:position(Position(32366, 32542, 8))
galthensTree:register()
