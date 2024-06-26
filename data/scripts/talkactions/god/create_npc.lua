-- To summon a temporary npc use /n npcname
-- To summon a permanent npc use /n npcname,true

local createNpc = TalkAction("/n")

function createNpc.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	local name = split[1]
	local permanentStr = split[2]

	local position = player:getPosition()
	local npc = Game.createNpc(name, position)
	if npc then
		npc:setMasterPos(position)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)

		if permanentStr and permanentStr == "true" then
			local mapName = configManager.getString(configKeys.MAP_NAME)
			local mapNpcsPath = mapName .. "-npc.xml"
			local filePath = string.format("%s/world/%s", DATA_DIRECTORY, mapNpcsPath)
			local npcsFile = io.open(filePath, "r")
			if not npcsFile then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when trying to add permanent NPC. NPC File not found.")
				return true
			end
			local fileContent = npcsFile:read("*all")
			npcsFile:close()
			local endTag = "</npcs>"
			if not fileContent:find(endTag, 1, true) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when trying to add permanent NPC. The NPC file format is incorrect. Missing end tag " .. endTag .. ".")
				return true
			end
			local textToAdd = string.format('\t<npc centerx="%i" centery="%i" centerz="%i" radius="1">\n\t\t<npc name="%s" x="0" y="0" z="%i" spawntime="60" />\n\t</npc>', position.x, position.y, position.z, name, position.z)
			local newFileContent = fileContent:gsub(endTag, textToAdd .. "\n" .. endTag)
			npcsFile = io.open(filePath, "w")
			if not npcsFile then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when trying to write to the NPC file.")
				return true
			end
			npcsFile:write(newFileContent)
			npcsFile:close()

			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Permanent NPC added successfully.")
		end
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

createNpc:separator(" ")
createNpc:groupType("god")
createNpc:register()
