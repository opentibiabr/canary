local config = {
	{ name="Grand Master Oberon", position = Position(33293, 31287, 9) },
	{ name="Timira The Many-Headed", position = Position(33807, 32699, 8) },
	{ name="KingZelos", position = Position(33489, 31546, 13) },
	{ name="Scarlett Etzel", position = Position(33395, 32662, 6) },
	{ name="The Brainstealer", position = Position(32536, 31120, 15) },
	{ name="The Monster", position = Position(33806, 32583, 12) },
	{ name="Ratmiral", position = Position(33894, 31390, 15) },
	{ name="Tentugly", position = Position(33796, 31386, 6) },
	{ name="Ferumbras Ascendant Bosses", position = Position(33309, 32377, 13) },
	{ name="Ascending Ferumbras", position = Position(33269, 31474, 14) },
	{ name="The Primal Menace", position = Position(33553, 32752, 14) },
	{ name="Magma Bubble", position = Position(33669, 32931, 15) },
	{ name="Drume", position = Position(32458, 32507, 6) },
	{ name="Urmahlullu", position = Position(33920, 31623, 8) },
	{ name="Dream Courts", position = Position(32208, 32036, 13) },
	{ name="Nighmare Beast", position = Position(32208, 32036, 13) },
	{ name="Unwelcome", position = Position(33741, 31537, 14) },
	{ name="Fear Feaster", position = Position(33739, 31471, 14) },
	{ name="Pale Worm", position = Position(33776, 31504, 14) },
	{ name="Faceless Bane", position = Position(33642, 32560, 13) },
	{ name="Leiden", position = Position(33136, 31954, 15) },
	{ name="Jaul", position = Position(33540, 31262, 11) },
	{ name="Goshnar Malice", position = Position(33684, 31599, 14) },
	{ name="Goshnar Hatred", position = Position(33778, 31601, 14) },
	{ name="Goshnar Spite", position = Position(33779, 31634, 14) },
	{ name="Goshnar Cruelty", position = Position(33859, 31854, 6) },
	{ name="Goshnar Greed", position = Position(33781, 31665, 14) },
	{ name="Goshnar Megalomania", position = Position(33681, 31634, 14) },
	{ name="Lady Tenebris", position = Position(32902, 31628, 14) },
	{ name="Lloyd", position = Position(32759, 32873, 14) },
	{ name="Thorn Knight", position = Position(32657, 32882, 14) },
	{ name="Dragonking Zyrtarch", position = Position(33391, 31183, 10) },
	{ name="Frozen Horror", position = Position(32302, 31093, 14) },
	{ name="Time Guardian", position = Position(33010, 31665, 14) },
	{ name="Last Lore Keeper", position = Position(32019, 32849, 14) },
	{ name="Brain Head", position = Position(31973, 32325, 10) },
	{ name="Unaz the Mean", position = Position(33566, 31477, 8) },
	{ name="Irgix the Flimsy", position = Position(33492, 31400, 8) },
	{ name="Vok the Freakish", position = Position(33509, 31452, 9) },
	{ name="Dread Maiden", position = Position(33744, 31506, 14) },
	{ name="Lion Sanctum", position = Position(33123, 32236, 12) },
	{ name="Shadowpelt", position = Position(33403, 32097, 9) },
	{ name="Black Vixen", position = Position(33442, 32052, 9) },
	{ name="Sharpclaw", position = Position(33128, 31972, 9) },
	{ name="Darkfang", position = Position(33055, 31911, 9) },
	{ name="Bloodback", position = Position(33167, 31978, 8) },
	{ name="Kroazur", position = Position(33619, 32305, 9) },
	{ name="Count Vlarkorth", position = Position(33456, 31408, 13) },
	{ name="Lord Azaram", position = Position(33423, 31497, 13) },
	{ name="Earl Osam", position = Position(33517, 31440, 13) },
	{ name="Sir Baeloc-Nictros", position = Position(33426, 31408, 13) },
	{ name="Duke Krule", position = Position(33456, 31497, 13) },
	{ name="Gaffir", position = Position(33393, 32674, 4) },
	{ name="Custodian", position = Position(33378, 32825, 8) },
	{ name="Guard Captain Quaid", position = Position(33397, 32658, 3) },
   }

local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	local window = ModalWindow {
		title = "Teleport Bosses",
		message = "Boss"
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
teleportBoss:type("stepin")
teleportBoss:aid(33313)
teleportBoss:register()
