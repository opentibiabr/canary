local dangerousDepthWooden = Action()
function dangerousDepthWooden.onUse(creature, item)
	if not creature or not creature:isPlayer() then
		return true
	end
	local r = math.random(1, 100)
	local stgValueP = creature:getStorageValue(Storage.DangerousDepths.Dwarves.Prisoners)

	if creature:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 1 and stgValueP < 3 then
		if r <= 25 then
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You started an escort, get your prisoner to the dwarf outpost!")
			local prisoner = Game.createMonster("Captured Dwarf", item:getPosition())
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
			item:remove()
			addEvent(function(pid)
				local prisoner = Monster(pid)
				if prisoner then
					prisoner:getPosition():sendMagicEffect(CONST_ME_POFF)
					prisoner:remove()
				end
			end,  5 * 60 * 1000, creatureid)
		else
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You find nothing of interest beneath the rubble.")
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
		item:remove()
		end
	end
	return true
end

dangerousDepthWooden:aid(57233)
dangerousDepthWooden:register()