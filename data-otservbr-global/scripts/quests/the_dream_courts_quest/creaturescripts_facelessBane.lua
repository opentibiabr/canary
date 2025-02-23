local summons = { "Burster Spectre", "Gazer Spectre", "Ripper Spectre" }
local storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.FacelessLifes

local creaturescripts_facelessBane = CreatureEvent("facelessThink")

function creaturescripts_facelessBane.onThink(creature, interval)
	if not creature:isMonster() then
		return true
	end

	local lifes = creature:getStorageValue(storage)
	local percentageHealth = (creature:getHealth() / creature:getMaxHealth()) * 100

	if lifes <= 3 then
		if lifes < 0 then
			creature:setStorageValue(storage, 0)
		end
		if percentageHealth <= 20 then
			creature:addHealth(creature:getMaxHealth())
			creature:registerEvent("facelessHealth")

			for i = 1, #summons do
				Game.createMonster(summons[i], creature:getPosition(), true, true)
			end

			creature:setStorageValue(storage, lifes + 1)
			Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.FacelessLifes, 0)
		end
	end

	return true
end

creaturescripts_facelessBane:register()

local creaturescripts_facelessBane = CreatureEvent("facelessHealth")

function creaturescripts_facelessBane.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getName():lower() == "maxxenius" then
		if primaryType == COMBAT_ENERGYDAMAGE then
			creature:addHealth(primaryDamage)
			primaryDamage = 0
		end
	elseif creature:getName():lower() == "alptramun" then
		if primaryType == COMBAT_DEATHDAMAGE then
			creature:addHealth(primaryDamage)
			primaryDamage = 0
		end
	elseif creature:getName():lower() == "faceless bane" then
		primaryDamage = 0
	elseif creature:getName():lower() == "plagueroot" then
		if primaryType == COMBAT_EARTHDAMAGE then
			creature:addHealth(primaryDamage)
			primaryDamage = 0
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creaturescripts_facelessBane:register()
