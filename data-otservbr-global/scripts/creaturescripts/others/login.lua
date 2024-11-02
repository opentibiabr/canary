local playerLogin = CreatureEvent("PlayerLogin")

function playerLogin.onLogin(player)
	-- Premium Ends Teleport to Temple, change addon (citizen) houseless
	local defaultTown = "Thais" -- default town where player is teleported if his home town is in premium area
	local freeTowns = { "Ab'Dendriel", "Carlin", "Kazordoon", "Thais", "Venore", "Rookgaard", "Dawnport", "Dawnport Tutorial", "Island of Destiny" } -- towns in free account area

	if not player:isPremium() and not table.contains(freeTowns, player:getTown():getName()) then
		local town = player:getTown()
		local sex = player:getSex()
		local home = getHouseByPlayerGUID(getPlayerGUID(player))
		town = table.contains(freeTowns, town:getName()) and town or Town(defaultTown)
		player:teleportTo(town:getTemplePosition())
		player:setTown(town)
		player:sendTextMessage(MESSAGE_FAILURE, "Your premium time has expired!")

		if sex == 1 then
			player:setOutfit({ lookType = 128, lookHead = 114, lookBody = 120, lookLegs = 132, lookFeet = 115, lookAddons = 0 })
		elseif sex == 0 then
			player:setOutfit({ lookType = 136, lookHead = 114, lookBody = 120, lookLegs = 132, lookFeet = 115, lookAddons = 0 })
		end

		if home and not player:isPremium() then
			setHouseOwner(home, 0)
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "You have lost your house because you are no longer a premium account.")
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Your items from the house have been sent to your inbox.")
		end
	end

	-- Open channels
	if table.contains({ TOWNS_LIST.DAWNPORT, TOWNS_LIST.DAWNPORT_TUTORIAL }, player:getTown():getId()) then
		player:openChannel(3) -- World chat
	else
		player:openChannel(3) -- World chat
		player:openChannel(5) -- Advertsing main
		if player:getGuild() then
			player:openChannel(0x00) -- guild
		end
	end
	return true
end

playerLogin:register()
