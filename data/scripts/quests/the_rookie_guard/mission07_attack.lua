-- The Rookie Guard Quest - Mission 07: Attack!

local missionTiles = {
	[50337] = {
		message = "Go down the stairs to reach the vault. It smells like fire down there. Make sure you are healthy!",
		arrowPosition = {x = 32089, y = 32154, z = 9}
	},
	[50338] = {
		message = "The vault is on fire! There is almost no air in here. You don't have much time to find the book. Hurry!"
	},
	[50340] = {
		message = "This must be the chest with the book - but it's covered in flames!",
		arrowPosition = {x = 32083,  y = 32141, z = 10}
	},
	[50341] = {
		message = "Right-click on the grey rune on the table and then left-click on the fire! You can't take the rune, but it works.",
		arrowPosition = {x = 32082, y = 32143, z = 10}
	}
}

-- Mission tutorial tiles

local missionGuide = MoveEvent()

function missionGuide.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	-- Skip if not was started or finished
	if missionState == -1 or missionState == 2 then
		return true
	end
	local missionTile = missionTiles[item.actionid]
	local libraryChestState = player:getStorageValue(Storage.TheRookieGuard.LibraryChest)
	-- Check if the tile is active
	if missionState == 1 and libraryChestState == -1 then
		-- Check delayed notifications (message/arrow)
		if not isTutorialNotificationDelayed(player) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, missionTile.message)
			if missionTile.arrowPosition then
				Position(missionTile.arrowPosition):sendMagicEffect(CONST_ME_TUTORIALARROW)
			end
		end
	end
	return true
end

for index, value in pairs(missionTiles) do
	missionGuide:aid(index)
end
missionGuide:register()

-- Cough inside library vault

local libraryVaultSteps = MoveEvent()

function libraryVaultSteps.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	-- Skip if not was started or finished
	if missionState == -1 or missionState == 2 then
		return true
	end
	if math.random(100) <= 20 then
		player:say("<cough>", TALKTYPE_MONSTER_SAY, false, player, position)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:addHealth(-1, COMBAT_PHYSICALDAMAGE)
		local health, maxHealth = player:getHealth(), player:getMaxHealth()
		local coughTolerance = (health / maxHealth) * 100
		if health <= (maxHealth / 3) or math.random(100) <= (100 - coughTolerance) then
			player:teleportTo({x = 32089, y = 32152, z = 9})
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You're coughing so badly that you had to return upstairs. Take a few deep breaths and try again.")
			player:addHealth((maxHealth - health), COMBAT_HEALING)
		end
	end
	return true
end

libraryVaultSteps:aid(50339)
libraryVaultSteps:register()

-- Fire fields (walk back on big fire fields)

local fireFields = MoveEvent()

function fireFields.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item.itemid == 13882 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This fire is much too hot to walk through it. Use the destroy field rune on the fire to weaken the flames!")
		player:teleportTo(fromPosition, true)
	end
	return true
end

fireFields:aid(40011)
fireFields:register()

-- Destroy field rune (destroy fire fields)

local function restoreFirefield(position)
	local tile = Tile(position)
	if tile then
		local item = tile:getItemById(13883)
		if item then
			item:transform(13882, 1)
		end
	end
end

local destroyFieldRune = Action()

function destroyFieldRune.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	if missionState == 1 and item2.itemid == 13882 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Fire in this stadium can be crossed without taking damage. Open the chest and get out of here!")
		item2:getPosition():sendMagicEffect(CONST_ME_POFF)
		item2:transform(13883, 1)
		addEvent(restoreFirefield, 25000, item2:getPosition())
	end
	return true
end

destroyFieldRune:uid(40046)
destroyFieldRune:register()

-- Treasure chest (gather orc language book)

local treasureChest = Action()

function treasureChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState == 1 then
		local libraryChestState = player:getStorageValue(Storage.TheRookieGuard.LibraryChest)
		if libraryChestState == -1 then
			local reward = Game.createItem(13831, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. reward:getArticle() .. " " .. reward:getName() .. ".")
			player:setStorageValue(Storage.TheRookieGuard.LibraryChest, 1)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

treasureChest:uid(40047)
treasureChest:register()
