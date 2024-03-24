local function sortSpellsByLevel(spellList, levelKey)
	table.sort(spellList, function(a, b)
		return a[levelKey] < b[levelKey]
	end)
end

local function appendSpellsInfo(spellList, header, levelKey, manaKey)
	local text = ""
	local prevLevel = -1

	for i, spell in ipairs(spellList) do
		local line = ""
		if prevLevel ~= spell[levelKey] then
			line = (i == 1 and "" or "\n") .. header .. spell[levelKey] .. "\n"
			prevLevel = spell[levelKey]
		end

		text = text .. line .. "  " .. spell.words .. " - " .. spell.name .. " : " .. spell[manaKey] .. "\n"
	end
	return text
end

local spellbook = Action()

function spellbook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spellsForLevel = {}
	local spellsForMagicLevel = {}

	for _, spell in ipairs(player:getInstantSpells()) do
		if (spell.level > 0 or spell.mlevel > 0) and spell.level + spell.mlevel > 0 then
			if spell.manapercent > 0 then
				spell.mana = spell.manapercent .. "%"
			end

			if spell.level > 0 then
				spellsForLevel[#spellsForLevel + 1] = spell
			else
				spellsForMagicLevel[#spellsForMagicLevel + 1] = spell
			end
		end
	end

	sortSpellsByLevel(spellsForLevel, "level")
	sortSpellsByLevel(spellsForMagicLevel, "mlevel")

	local spellsText = appendSpellsInfo(spellsForLevel, "Spells for Level ", "level", "mana")
	spellsText = spellsText .. "\n"
	spellsText = spellsText .. appendSpellsInfo(spellsForMagicLevel, "Spells for Magic Level ", "mlevel", "mana")

	player:showTextDialog(item:getId(), spellsText)
	return true
end

spellbook:id(3059, 6120, 8072, 8073, 8074, 8075, 8076, 8090, 11691, 14769, 16107, 20088, 21400, 22755, 25699, 29431, 20089, 20090, 34153)
spellbook:register()
