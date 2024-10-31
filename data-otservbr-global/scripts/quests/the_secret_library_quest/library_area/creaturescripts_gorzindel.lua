local knowledges = {
	"stolen knowledge of armor",
	"stolen knowledge of summoning",
	"stolen knowledge of lifesteal",
	"stolen knowledge of spells",
	"stolen knowledge of healing",
}

local middlePosition = Position(32687, 32719, 10)

local creaturescripts_gorzindel = CreatureEvent("gorzindelDeath")

function creaturescripts_gorzindel.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local cPos = creature:getPosition()

	if isInArray(knowledges, creature:getName():lower()) then
		addEvent(function()
			local spectators = Game.getSpectators(middlePosition, false, false, 12, 12, 12, 12)
			local hasKnowledges = false
			for _, c in pairs(spectators) do
				if c and isInArray(knowledges, c:getName():lower()) then
					hasKnowledges = true
				end
			end
			if not hasKnowledges then
				for _, c in pairs(spectators) do
					if c then
						if c:getName():lower() == "mean minion" then
							c:getPosition():sendMagicEffect(CONST_ME_POFF)
							c:remove()
						elseif c:getName():lower() == "gorzindel" then
							c:unregisterEvent("gorzindelHealth")
						end
					end
				end
			end
		end, 1 * 1000)
	elseif creature:getName():lower() == "stolen tome of portals" then
		local portal = Game.createItem(1949, 1, cPos)
		if portal then
			portal:setActionId(4952)
			addEvent(function()
				Game.createMonster("stolen tome of portals", cPos, true, true)
				local sqm = Tile(cPos):getItemById(1949)
				if sqm then
					sqm:remove(1)
				end
			end, 10 * 1000)
		end
	end
end

creaturescripts_gorzindel:register()

local creaturescripts_gorzindel = CreatureEvent("gorzindelHealth")

function creaturescripts_gorzindel.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	primaryDamage = 0
	secondaryDamage = 0
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creaturescripts_gorzindel:register()
