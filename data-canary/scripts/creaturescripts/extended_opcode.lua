local OPCODE_LANGUAGE = 1

local extendedOpcode = CreatureEvent("ExtendedOpcode")

function extendedOpcode.onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE_LANGUAGE then
		-- otclient language
		if buffer == "en" or buffer == "pt" then
			-- example, setting player language, because otclient is multi-language...
			-- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
		end
		-- other opcodes can be ignored, and the server will just work fine...
	else
	end
end

extendedOpcode:register()
