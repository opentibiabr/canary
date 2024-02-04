local galthensTree = Action()
function galthensTree.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local hasExhaustion = player:kv():get("galthens-satchel") or 0
	if hasExhaustion < os.time() then
		local container = player:addItem(36813)
		container:addItem(36810, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a galthens satchel.")
		player:teleportTo(Position(32396, 32520, 7))
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		player:kv():set("galthens-satchel", os.time() + 30 * 24 * 60 * 60)
	else
		player:teleportTo(Position(32396, 32520, 7))
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
	end
end

galthensTree:uid(14044)
galthensTree:register()
