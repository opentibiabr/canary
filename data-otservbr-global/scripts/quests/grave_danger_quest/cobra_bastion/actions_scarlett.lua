local armorId = 31482
local metalWallId = 31449

local config = {
	boss = {
		name = "Scarlett Etzel",
		createFunction = function()
			return GraveDanger.start("Scarlett Etzel", Position(33396, 32643, 6))
		end,
	},
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeat = 10 * 60,
	playerPositions = {
		{ pos = Position(33395, 32661, 6), teleport = Position(33396, 32651, 6) },
		{ pos = Position(33394, 32662, 6), teleport = Position(33396, 32651, 6) },
		{ pos = Position(33396, 32662, 6), teleport = Position(33396, 32651, 6) },
		{ pos = Position(33395, 32662, 6), teleport = Position(33396, 32651, 6) },
		{ pos = Position(33395, 32663, 6), teleport = Position(33396, 32651, 6) },
	},
	specPos = {
		from = Position(33385, 32638, 6),
		to = Position(33406, 32660, 6),
	},
	exit = Position(33395, 32665, 6),
}

local lever = BossLever(config)
lever:position(Position(33395, 32660, 6))
lever:register()

local transformTo = {
	[31474] = 31475,
	[31475] = 31476,
	[31476] = 31477,
	[31477] = 31474,
}

local graveScarlettAid = Action()

function graveScarlettAid.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_20.GraveDanger.GaffirKilled) ~= 1 or player:getStorageValue(Storage.Quest.U12_20.GraveDanger.CustodianKilled) ~= 1 or player:getStorageValue(Storage.Quest.U12_20.GraveDanger.QuaidKilled) ~= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not allowed to use this yet.")
		return true
	end

	if transformTo[item.itemid] then
		local pilar = transformTo[item.itemid]
		if pilar then
			item:transform(pilar)
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.itemid == armorId then
		return GraveDanger.scarlettArmor(player, item)
	elseif item.itemid == metalWallId then
		if player:getPosition().y == 32666 then
			player:teleportTo(Position(33395, 32668, 6))
		else
			player:teleportTo(Position(33395, 32666, 6))
		end
	end

	return true
end

graveScarlettAid:aid(40003)
graveScarlettAid:register()
