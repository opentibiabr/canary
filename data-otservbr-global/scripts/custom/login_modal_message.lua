local config = {
	enabled = false,
	storage = Storage.Custom.loginModal
}

local messageLogin = CreatureEvent("messageLogin")

function messageLogin.onLogin(player)
	--local version = "0.1.0"
	--local pathTitle = "EnaraOT Launch Scheduled!"
	local text = [[
Date: April 25, 2025

Greetings, adventurers! This patch brings a host of exciting changes, including new content, balance adjustments, and bug fixes. Dive in and explore!

** New Content: **

New Zone: The Whispering Caves:
Explore a mysterious underground network filled with new monsters, treasures, and lore. Access it through the northern part of the Sunken Marshes.

New Character: The Geomancer:
A powerful new class specializing in earth-based magic. Unleash the power of the ground beneath your feet! You can create a new Geomancer character or purchase a class change token from the in-game store.

** New Items: **

The Obsidian Hammer (Legendary Weapon)
The Earthshaker Gauntlets (Epic Armor)
The Amulet of Stability (Rare Accessory)
The Ring of Elemental Mastery (Legendary Accessory)

** New Questline: **

The Earth's Fury: Embark on a series of quests related to the Geomancer and the disturbances in the Whispering Caves. Start the questline by speaking to Elder Stonebeard in Oakhaven.

** Balance Adjustments: **

* Warrior Class:
	* Increased the base damage of the "Cleave" skill by 10%.
	* Reduced the cooldown of the "Shield Bash" skill by 1 second.

* Mage Class:
	* Slightly reduced the mana cost of the "Arcane Bolt" spell.
	* Increased the cast time of the "Meteor Shower" spell by 0.5 seconds.

* Monster Adjustments:
	* Increased the health of the Swamp Lurker by 5%.
	* Reduced the attack speed of the Cave Spider by 10%.

** Bug Fixes: **

* Fixed an issue where players could fall through the world in the Sunken Marshes.
* Corrected a visual bug with the Ranger's "Arrow Rain" skill.
* Resolved a problem that prevented some players from completing the "Lost Artifact" quest.
* Addressed several minor UI issues.

** Known Issues: **

* Some players may experience minor graphical glitches in the Whispering Caves. We are working on a fix for the next patch.

Thank you for your continued support! We hope you enjoy the latest update.

EnaraOT Development Team
					]]

					-- [[
					-- This is a comment block for future reference
					-- local menu = ModalWindow{
					-- 	title = "[Patch Note] V. ".. version .." - " .. pathTitle,
					-- 	message = text
					-- }
					-- menu:addButton("Close")
					-- menu:addButton("Read Online")
					-- menu:setDefaultEnterButton(1)
					-- menu:setDefaultEscapeButton(0)
					-- menu:sendToPlayer(player)
					--]]

	if config.enabled then
		if player:getStorageValue(config.storage) <= 0 then
			player:popupFYI(text)
			player:setStorageValue(config.storage, 1)
		else
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "[Patch Notes]: You have already seen the patch notes. For more information, please check the official website or forums. Happy Hunting!")
		end
		return true
	end


	return true
end

messageLogin:register()
----------------------------------------------------------------------------------------

local updateMessageOnStart = GlobalEvent("updateMessageOnStart")
function updateMessageOnStart.onStartup()
		local exec = db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", 0, config.storage))
		if exec then
			logger.info("[Login Patch Notes] - Players Storage cleaned succesfully.")
		else
			logger.error("[Login Patch Notes] - Players Storage problem to be cleaned. Check data-otservbr-global/scripts/custom/login_modal_message.lua")
		end
	return true
end

updateMessageOnStart:register()
----------------------------------------------------------------------------------------
