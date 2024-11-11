local inboxCommand = TalkAction("/inbox")

function inboxCommand.onSay(player, words, param)
	param = param:split(",")
	player:getPosition():sendMagicEffect(CONST_ME_TUTORIALSQUARE)
	local target = Creature(param[1])
	if target then
		local inbox = target:getStoreInbox()
		local inboxSize = inbox:getSize()
		if inbox and inboxSize > 0 then
			if param[2] == "remove" then
				for i = 0, inboxSize do
					local item = inbox:getItem(i)
					if item and item:getId() == tonumber(param[3]) then
						local itemToDelete = Item(item.uid)
						if itemToDelete then
							itemToDelete:remove()
							player:say(item:getId() .. " removed")
						end
					end
				end
			elseif param[2] == "add" then
				target:addItemStoreInbox(tonumber(param[3]), 1, true, false)
				player:say(tonumber(param[3]) .. " added")
			end
		end
	else
		player:sendCancelMessage("Creature not found.")
	end

	return true
end

inboxCommand:separator(" ")
inboxCommand:setDescription("[Usage]: /inbox {PlayerName},{add|remove},{itemId}")
inboxCommand:groupType("god")
inboxCommand:register()
