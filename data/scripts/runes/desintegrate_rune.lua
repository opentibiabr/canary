local rune = Spell("rune")

local corpseIds = {4240, 4241, 4242, 4243, 4246, 4247, 4248}
local removalLimit = 500

function rune.onCastSpell(creature, variant, isHotkey)
	local position = variant:getPosition()
	local tile = Tile(position)
	if tile then
		local items = tile:getItems()
		if items then
			for i, item in ipairs(items) do
				if item:getType():isMovable() and item:getUniqueId() > 65535 and item:getActionId() == 0 and not table.contains(corpseIds, item:getId()) then
					item:remove()
				end

				if i == removalLimit then
					break
				end
			end
		end
	end

	creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	position:sendMagicEffect(CONST_ME_POFF)
	return true
end

rune:group("support")
rune:name("desintegrate rune")
rune:runeId(3197)
rune:allowFarUse(false)
rune:charges(3)
rune:level(21)
rune:magicLevel(4)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:range(1)
rune:register()