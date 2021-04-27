local feroxaTransform = CreatureEvent("FeroxaTransform")
function feroxaTransform.onThink(creature)
	if creature:getName():lower() ~= 'feroxa' then
		return true
	end
	if creature:getMaxHealth() == 100000 then
		if creature:getHealth() <= 50000 then
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
			Game.createMonster('feroxa2', creature:getPosition(), true, true)
			creature:remove()
		end
	end
	if creature:getMaxHealth() == 50000 then
		if creature:getHealth() <= 25000 then
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
			local feroxas = {
				[1] = {name = 'feroxa3'},
				[2] = {name = 'feroxa4'}
			}
			Game.createMonster(feroxas[math.random(#feroxas)].name, creature:getPosition(), true, true)
			creature:remove()
		end
	end
end

feroxaTransform:register()

local feroxaDeath = CreatureEvent("FeroxaDeath")
function feroxaDeath.onDeath(creature, corpse, deathList)
	local pool = Tile(creature:getPosition()):getItemById(2016)
	if pool then
		pool:remove()
	end
	Game.createMonster("Feroxa5", creature:getPosition(), true, true)
end

feroxaDeath:register()
