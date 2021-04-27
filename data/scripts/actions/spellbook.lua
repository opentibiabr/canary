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


spellbook:id(2175, 6120, 8900, 8901, 8902, 8903, 8904, 8918, 12647, 16112, 18401, 22422, 23771)
spellbook:register()
