local drunk = Condition(CONDITION_DRUNK)
drunk:setParameter(CONDITION_PARAM_TICKS, 60000)

local poison = Condition(CONDITION_POISON)
poison:setParameter(CONDITION_PARAM_DELAYED, true)
poison:setParameter(CONDITION_PARAM_MINVALUE, -50)
poison:setParameter(CONDITION_PARAM_MAXVALUE, -120)
poison:setParameter(CONDITION_PARAM_STARTVALUE, -5)
poison:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
poison:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local fluidMessage = {
	[3] = 'Aah...',
	[4] = 'Urgh!',
	[5] = 'Mmmh.',
	[7] = 'Aaaah...',
	[10] = 'Aaaah...',
	[11] = 'Urgh!',
	[13] = 'Urgh!',
	[15] = 'Aah...',
	[19] = 'Urgh!',
	[43] = 'Aaaah...'
}

local function graveStoneTeleport(cid, fromPosition, toPosition)
	local player = Player(cid)
	if not player then
		return true
	end

	player:teleportTo(toPosition)
	player:say('Muahahahaha..', TALKTYPE_MONSTER_SAY, false, player)
	fromPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
	toPosition:sendMagicEffect(CONST_ME_MORTAREA)
end

-- Special poison condition used on dawnport residents
-- Doesnt allow poison yourself when health is <= 10 or your health go low than 10 due poison
function dawnportPoisonCondition(player)
	local health = player:getHealth();
	local minHealth = 10
	-- Default poison values (not possible read condition parameters)
	local startValue = 5
	local minPoisonDamage = 50
	local maxPoisonDamage = 120

	-- Special poison
	if health > minHealth and health < (minHealth + maxPoisonDamage) then
		local maxValue = health - minHealth
		local minValue = minPoisonDamage
		local value = startValue
		local minRoundsDamage = (startValue * (startValue + 1) / 2)

		if maxValue < minPoisonDamage then
			minValue = maxValue
		end

		if maxValue < minRoundsDamage then
			value = math.floor( math.sqrt(maxValue) )
		end

		local poisonMod = Condition(CONDITION_POISON)
		poisonMod:setParameter(CONDITION_PARAM_DELAYED, true)
		poisonMod:setParameter(CONDITION_PARAM_MINVALUE, -minValue)
		poisonMod:setParameter(CONDITION_PARAM_MAXVALUE, -maxValue)
		poisonMod:setParameter(CONDITION_PARAM_STARTVALUE, -value)
		poisonMod:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
		poisonMod:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

		player:addCondition(poisonMod)
	-- Common poison
	elseif health >= (minHealth + maxPoisonDamage) then
		player:addCondition(poison)
	end
	-- Otherwise no poison
end

local fluid = Action()

function fluid.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetType = ItemType(target.itemid)
	if targetType:isFluidContainer() then
		if target.type == 0 and item.type ~= 0 then
			target:transform(target.itemid, item.type)
			item:transform(item.itemid, 0)
			return true
		elseif target.type ~= 0 and item.type == 0 then
			target:transform(target.itemid, 0)
			item:transform(item.itemid, target.type)
			return true
		end
	end
	if target.itemid == 29312 then
		if item.type == 0 then
			player:sendTextMessage(MESSAGE_FAILURE, 'It is empty.')
		
		elseif item.type == 1 then
			toPosition:sendMagicEffect(CONST_ME_WATER_SPLASH)
			target:transform(target.itemid + 1)
			item:transform(item.itemid, 0)
		else
			player:sendTextMessage(MESSAGE_FAILURE, 'You need water.')
		end
		return true
	end
			
	if target.itemid == 1 then
		if item.type == 0 then
			player:sendTextMessage(MESSAGE_FAILURE, 'It is empty.')

		elseif target.uid == player.uid then
			if isInArray({3, 15, 43}, item.type) then
				player:addCondition(drunk)

			elseif item.type == 4 then
				local town = player:getTown()
				if town and town:getId() == TOWNS_LIST.DAWNPORT then
					dawnportPoisonCondition(player)
				else
					player:addCondition(poison)
				end
			elseif item.type == 7 then
				player:addMana(math.random(50, 150))
				fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			elseif item.type == 10 then
				player:addHealth(60)
				fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end

			player:say(fluidMessage[item.type] or 'Gulp.', TALKTYPE_MONSTER_SAY)
			item:transform(item.itemid, 0)
		else
			local pool = Game.createItem(2016, item.type, toPosition)
			if pool then
				pool:decay()
				if item.type == 1 then
					checkWallArito(pool, toPosition)
				end
			end
			item:transform(item.itemid, 0)
		end

	else

		local fluidSource = targetType:getFluidSource()
		if fluidSource ~= 0 then
			item:transform(item.itemid, fluidSource)

		elseif item.type == 0 then
			player:sendTextMessage(MESSAGE_FAILURE, 'It is empty.')

		else
			if item.type == 2 and target.actionid == 2023 then
				toPosition.y = toPosition.y + 1
				local creatures, destination = Tile(toPosition):getCreatures(), Position(32791, 32332, 10)
				if #creatures == 0 then
					graveStoneTeleport(player.uid, fromPosition, destination)
				else
					local creature
					for i = 1, #creatures do
						creature = creatures[i]
						if creature and creature:isPlayer() then
							graveStoneTeleport(creature.uid, toPosition, destination)
						end
					end
				end

			else
				if toPosition.x == CONTAINER_POSITION then
					toPosition = player:getPosition()
				end

				local pool = Game.createItem(2016, item.type, toPosition)
				if pool then
					pool:decay()
    				if item.type == 1 then
    					checkWallArito(pool, toPosition)
    				end
				end
			end
			item:transform(item.itemid, 0)
		end
	end

	return true
end

fluid:id(1775, 2005, 2006, 2007, 2008, 2009, 2011, 2012, 2013, 2014, 2015, 2023, 2031, 2032, 2033, 2034, 2562, 2574, 2575, 2576, 2577)
fluid:register()

