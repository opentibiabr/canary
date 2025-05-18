local crystals = {
	[1] = { fromPosition = Position(33389, 31467, 14), toPosition = Position(33391, 31469, 14), crystalPosition = Position(33390, 31468, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal1 },
	[2] = { fromPosition = Position(33393, 31467, 14), toPosition = Position(33395, 31469, 14), crystalPosition = Position(33394, 31468, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal2 },
	[3] = { fromPosition = Position(33396, 31470, 14), toPosition = Position(33398, 31472, 14), crystalPosition = Position(33397, 31471, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal3 },
	[4] = { fromPosition = Position(33396, 31474, 14), toPosition = Position(33398, 31476, 14), crystalPosition = Position(33397, 31475, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal4 },
	[5] = { fromPosition = Position(33393, 31477, 14), toPosition = Position(33395, 31479, 14), crystalPosition = Position(33394, 31478, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal5 },
	[6] = { fromPosition = Position(33389, 31477, 14), toPosition = Position(33391, 31479, 14), crystalPosition = Position(33390, 31478, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal6 },
	[7] = { fromPosition = Position(33386, 31474, 14), toPosition = Position(33388, 31476, 14), crystalPosition = Position(33387, 31475, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal7 },
	[8] = { fromPosition = Position(33386, 31470, 14), toPosition = Position(33388, 31472, 14), crystalPosition = Position(33387, 31471, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal8 },
}

local config = AscendingFerumbrasConfig

local riftInvaderDeath = CreatureEvent("RiftInvaderDeath")
function riftInvaderDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local pos = Position(33392 + math.random(-10, 10), 31473 + math.random(-10, 10), 14)
	local name = creature:getName():lower()
	if name ~= "rift invader" then
		return true
	end
	Game.createMonster(name, pos)

	for i = 1, #crystals do
		local crystal = crystals[i]
		if creature:getPosition():isInRange(crystal.fromPosition, crystal.toPosition) then
			if player:getStorageValue(crystal.globalStorage) > 8 then
				local item = Tile(crystal.crystalPosition):getItemById(14955)
				if not item then
					return true
				end
				item:transform(14961)
				player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals, player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals) + 1)
			end
			if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals) == 8 then
				local creature = Tile(config.bossPos):getTopCreature()
				creature:say("NOOOOOOOOOOO!", TALKTYPE_MONSTER_YELL)
				creature:say("FERUMBRAS BURSTS INTO SOUL SPLINTERS!", TALKTYPE_MONSTER_YELL, nil, nil, Position(33392, 31475, 14))
				creature:remove()
				for a = 1, #crystals do
					local crystalEffect = crystals[i]
					crystalEffect.crystalPosition:sendMagicEffect(CONST_ME_FERUMBRAS)
					Game.createMonster("Ferumbras Soul Splinter", Position(33392, 31473, 14), false, true)
				end
			end
			player:setStorageValue(crystal.globalStorage, player:getStorageValue(crystal.globalStorage) + 1)
			lasthitkiller:say("The negative energy of the rift creature is absorbed by the crystal!", TALKTYPE_MONSTER_SAY, nil, nil, crystal.crystalPosition)
			lasthitkiller:say("ARGH!", TALKTYPE_MONSTER_SAY, nil, nil, Position(33392, 31473, 14))
		end
	end

	local pool = Tile(creature:getPosition()):getItemById(2886)
	if pool then
		pool:remove()
	end

	local vortex = Game.createItem(config.vortex, 1, creature:getPosition())
	if vortex then
		addEvent(function(creaturePos)
			local tile = Tile(creaturePos)
			if tile then
				local vortexItem = tile:getItemById(config.vortex)
				if vortexItem then
					vortexItem:remove(1)
				end
			end
		end, 10 * 1000, creature:getPosition())
	end
	return true
end

riftInvaderDeath:register()
