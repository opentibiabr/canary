local bosses = {
	["fury of the emperor"] = {
		position = Position(33048, 31085, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Fury,
	},
	["wrath of the emperor"] = {
		position = Position(33094, 31087, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Wrath,
	},
	["scorn of the emperor"] = {
		position = Position(33095, 31110, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Scorn,
	},
	["spite of the emperor"] = {
		position = Position(33048, 31111, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Spite,
	},
}

local bossesKill = CreatureEvent("WrathOfTheEmperorBossDeath")
function bossesKill.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	Game.setStorageValue(bossConfig.storage, 0)
	local tile = Tile(bossConfig.position)
	if tile then
		local thing = tile:getItemById(10797)
		if thing then
			thing:transform(11427)
		end
	end
	return true
end

bossesKill:register()
