function Player:sendMountWindow(mounts)
	local function buttonCallback(player, button, choice)
		local mountName = string.lower(mounts[choice.id].name) -- Converts the mount name to lowercase
	-- Modal window functionallity
		if button.name == "Confirm" then
		-- Start Checks
			-- Check if player already has the mount if true send error message and reopen window
			if self:hasMount(mounts[choice.id].ID) == true then
				self:sendMountWindow_owned(mounts)
				return false
			end
 
			-- Check if player has mount doll in backpack.
			if self:getItemCount(mounts.dollID) == 0 then
				self:sendMountWindow_noDoll(mounts)
				return false
			end
		end
		-- End Checks
 
		-- Add mount to play, remove mount doll, send confirmation message and send super special sparkles. 
		self:addMount(mounts[choice.id].ID)
		self:removeItem(mounts.dollID, 1)
		self:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can now use the " ..mountName.. " mount!")
	end
 
-- Modal window design
	local window = ModalWindow {
		title = mounts.mainTitle, -- Title of the modal window
		message = mounts.mainMsg, -- The message to be displayed on the modal window
	}
 
	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Confirm", buttonCallback)
	window:addButton("Cancel")
 
	-- Set what button is pressed when the player presses enter or escape
	window:setDefaultEnterButton("Confirm")
	window:setDefaultEscapeButton("Cancel")
 
	-- Add choices from the action script
	for i = 1, #mounts do
	local o = mounts[i].name
 
		-- Checks what mounts player has/doesnt
		if not self:hasMount(mounts[i].ID) then
			-- Add choice if player does not have mount
			window:addChoice(o)
		else
			-- Add "[Owned]" to the choice if player already has it.
			window:addChoice(o.." [Owned]")
		end
    end
 
	-- Send the window to player
	window:sendToPlayer(self)
end
 
 
--- The modal window that is played if player already has the addon.
function Player:sendMountWindow_owned(mounts)
	local function buttonCallback(player, button, choice)
 
		if button.name == "Back" then
			self:sendMountWindow(mounts)
		end
	end
-- Modal window design
	local window = ModalWindow {
		title = mounts.ownedTitle, -- Title of the modal window
		message = mounts.ownedMsg, -- The message to be displayed on the modal window
	}
 
	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Back", buttonCallback)
 
	-- Set what button is pressed when the player presses enter or escape
	window:setDefaultEnterButton("Back")
	window:setDefaultEscapeButton("Back")
 
	-- Send the window to player
	window:sendToPlayer(self)
end
 
--- The modal window that is displayed if the player doesnt have the doll in his BP
function Player:sendMountWindow_noDoll(mounts)
	local function buttonCallback(player, button, choice)
 
		if button.name == "Back" then
			self:sendMountWindow(mounts)
		end	
	end
-- Modal window design
	local window = ModalWindow {
		title = mounts.dollTitle, -- Title of the modal window
		message = mounts.dollMsg, -- The message to be displayed on the modal window
	}
 
	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Back", buttonCallback)
 
	-- Set what button is pressed when the player presses enter or escape
	window:setDefaultEnterButton("Back")
	window:setDefaultEscapeButton("Back")
 
	-- Send the window to player
	window:sendToPlayer(self)
end