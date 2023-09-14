local config = {
	{ name="Hellgorge", position = Position(32047, 31043, 8) },
	{ name="Sea Serpent Area", position = Position(31953, 31237, 10) },
	{ name="Warzone 7,8,9", position = Position(32656, 31820, 10) },
	{ name="Wyrm(Drefia)", position = Position(33069, 32430, 14) },
	{ name="Undead Gladiator(Krailos)", position = Position(33581, 31587, 8) },
	{ name="Buster Spectre", position = Position(33090, 32389, 8) },
	{ name="gazer spectre", position = Position(32640, 32637, 8 ) },
	{ name="The Hive", position = Position(33461, 31303, 6) },
	{ name="Oramond Catacombs", position = Position(33526, 32025, 10) },
	{ name="Cobra Bastion", position = Position(33385, 32627, 7) },
	{ name="Mintwallin", position = Position(32465, 32103, 15) },
	{ name="The Extension Site", position = Position(33246, 32110, 8) },
	{ name="Mino Cult", position = Position(31931, 32504, 8) },
	{ name="Grimvale", position = Position(33400, 31614, 10) },
	{ name="ChyllFrost", position = Position(32007, 31178, 11) },
	{ name="exotic cave", position = Position(33917, 31471, 8) },
	{ name="glooth factory", position = Position(33560, 31987, 9) },
	{ name="draken castle", position = Position(33082, 31218, 8) },
	{ name="nightstalker", position = Position(32844, 32397, 12) },
	{ name="ancient scarab", position = Position(33370, 32619, 12 ) },
	{ name="Lizzard e Cult", position = Position(33312, 32682, 8 ) },
	{ name="water elemental", position = Position(32551, 32860, 9 ) },
   }

local teleportHunts = MoveEvent()
function teleportHunts.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	local window = ModalWindow {
		title = "Teleport Hunts",
		message = "Hunts"
	}
	for i, info in pairs(config) do
		window:addChoice(string.format("%s", info.name), function (player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end)
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
	return true
end
teleportHunts:type("stepin")
teleportHunts:aid(33314)
teleportHunts:register()
