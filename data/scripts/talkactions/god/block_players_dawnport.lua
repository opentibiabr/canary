local config = {
	barrierId = 15467,
	positions = {
		Position(32074, 31899, 6),
		Position(32074, 31900, 6),
		Position(32074, 31901, 6),
		Position(32074, 31902, 6),
	},
}

local dawnportBarrier = TalkAction("/barrier")

function dawnportBarrier.onSay(player, words, param)
	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid parameter. Usage: /barrier <on|off>")
		return true
	end

	-- create log
	logCommand(player, words, param)

	local action = param:trim():lower()
	if action == "on" then
		-- create barriers
		for i, position in pairs(config.positions) do
			Game.createItem(config.barrierId, 1, position)
		end
	elseif action == "off" then
		for i, pos in pairs(config.positions) do
			local tile = Tile(pos)
			if tile then
				local items = tile:getItems()
				if items then
					local barrier = tile:getItemById(config.barrierId)
					if barrier then
						barrier:remove()
					end
				end
			end
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Command invalid!")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Barrier were " .. (action == "on" and "added" or "removed") .. " on dawnport!")
	return true
end

dawnportBarrier:separator(" ")
dawnportBarrier:groupType("god")
dawnportBarrier:register()
