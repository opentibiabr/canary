local function getItemsInContainer(container, sep)
	local text = ""
	local tsep = ""
	local count
	for i = 1, sep do
		tsep = tsep .. "-"
	end
	tsep = tsep .. ">"
	for slot = 0, container:getSize() - 1 do
		local item = container:getItem(slot)
		if not item:isContainer() then
			if item.type > 0 then
				count = "(" .. item.type .. "x)"
			else
				count = ""
			end
			text = text .. "\n" .. tsep .. ItemType(item.itemid):getName() .. " " .. count
		else
			if item:getSize() > 0 then
				text = text .. "\n" .. tsep .. ItemType(item.itemd):getName()
				text = text .. getItemsInContainer(item, sep + 2)
			else
				text = text .. "\n" .. tsep .. ItemType(item.itemid):getName()
			end
		end
	end
	return text
end

local spy = TalkAction("/spy")

function spy.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Write the name of the character to be spyed.")
		return true
	end

	local target = Player(param)

	if target and target:isPlayer() then
		local slotName = { "Helmet", "Amulet", "Backpack", "Armor", "Right Hand", "Left Hand", "Legs", "Boots", "Ring", "Arrow" }
		local text = "Equipments of " .. target:getName()
		for i = 1, 10 do
			text = text .. "\n\n"
			local item = target:getSlotItem(i)
			if item and item.itemid > 0 then
				if item:isContainer() then
					text = text .. slotName[i] .. ": " .. ItemType(item.itemid):getName() .. getItemsInContainer(item, 1)
				else
					local count
					if item.type > 0 then
						count = "(" .. item.type .. "x)"
					else
						count = ""
					end
					text = text .. slotName[i] .. ": " .. ItemType(item.itemid):getName() .. " " .. count
				end
			else
				text = text .. slotName[i] .. ": Empty"
			end
		end
		player:showTextDialog(6528, text)
	else
		player:sendCancelMessage("This player is offline or doesn't exist.")
	end
	return true
end

spy:separator(" ")
spy:groupType("gamemaster")
spy:register()
