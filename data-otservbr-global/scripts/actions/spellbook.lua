local spellbook = Action()

function spellbook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = ""
	local tlvl = {}
	local tml = {}

	for _, spell in ipairs(player:getInstantSpells()) do
		if spell.level ~= 0 or spell.mlevel ~= 0 then
			if spell.manapercent > 0 then
				spell.mana = spell.manapercent .. "%"
			end
			if spell.level > 0 then
				tlvl[#tlvl+1] = spell
			elseif spell.mlevel > 0 then
				tml[#tml+1] = spell
			end
		end
	end

	table.sort(tlvl, function(a, b) return a.level < b.level end)
	local prevLevel = -1
	for i, spell in ipairs(tlvl) do
		local line = ""
		if prevLevel ~= spell.level then
			if i ~= 1 then
				line = "\n"
			end
			line = line .. "Spells for Level " .. spell.level .. "\n"
			prevLevel = spell.level
		end
		text = text .. line .. "  " .. spell.words .. " - " .. spell.name .. " : " .. spell.mana .. "\n"
	end
	text = text.."\n"
	table.sort(tml, function(a, b) return a.mlevel < b.mlevel end)
	local prevmLevel = -1
	for i, spell in ipairs(tml) do
		local line = ""
		if prevLevel ~= spell.mlevel then
			if i ~= 1 then
				line = "\n"
			end
			line = line .. "Spells for Magic Level " .. spell.mlevel .. "\n"
			prevmLevel = spell.mlevel
		end
		text = text .. line .. "  " .. spell.words .. " - " .. spell.name .. " : " .. spell.mana .. "\n"
	end


	player:showTextDialog(item:getId(), text)
	return true
end


spellbook:id(3059, 6120, 8072, 8073, 8074, 8075, 8076, 8090, 11691, 14769, 16107, 20088, 21400, 22755, 25699, 29431, 20089, 20090, 34153)
spellbook:register()
