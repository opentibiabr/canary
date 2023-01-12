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
	[1] = "Gulp.", -- water
	[2] = "Aah...", -- wine
	[3] = "Aah...", -- beer
	[4] = "Gulp.", -- mud
	[5] = "Gulp.", -- blood
	[6] = "Urgh!", -- slime
	[7] = "Gulp.", -- oil
	[8] = "Urgh!", -- urine
	[9] = "Gulp.", -- milk
	[10] = "Aaaah...", -- manafluid
	[11] = "Aaaah...", -- lifefluid
	[12] = "Mmmh.", -- lemonade
	[13] = "Aah...", -- rum
	[14] = "Mmmh.", -- fruit juice
	[15] = "Mmmh.", -- coconut milk
	[16] = "Aah...", -- mead
	[17] = "Gulp.", -- tea
	[18] = "Urgh!" -- ink
}

local fluid = Action()

function fluid.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItemType = ItemType(target.itemid)
	if targetItemType and targetItemType:isFluidContainer() then
		if target.type == 0 and item.type ~= 0 then
			target:transform(target:getId(), item.type)
			item:transform(item:getId(), 0)
			return true
		elseif target.type ~= 0 and item.type == 0 then
			target:transform(target:getId(), 0)
			item:transform(item:getId(), target.type)
			return true
		end
	end

	if target.itemid == 1 then
		if item.type == 0 then
			player:sendTextMessage(MESSAGE_FAILURE, "It is empty.")
		elseif target.uid == player.uid then
			if table.contains({3, 15, 43}, item.type) then
				player:addCondition(drunk)
			elseif item.type == 4 then
				player:addCondition(poison)
			elseif item.type == 7 then
				player:addMana(math.random(50, 150))
				fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			elseif item.type == 10 then
				player:addHealth(60)
				fromPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			player:say(fluidMessage[item.type] or "Gulp.", TALKTYPE_MONSTER_SAY)
			item:transform(item:getId(), 0)
		else
			Game.createItem(2886, item.type, toPosition):decay()
			item:transform(item:getId(), 0)
		end
	else
		local fluidSource = targetItemType and targetItemType:getFluidSource() or 0
		if fluidSource ~= 0 then
			item:transform(item:getId(), fluidSource)
		elseif item.type == 0 then
			player:sendTextMessage(MESSAGE_FAILURE, "It is empty.")
		else
			if toPosition.x == CONTAINER_POSITION then
				toPosition = player:getPosition()
			end
			Game.createItem(2886, item.type, toPosition):decay()
			item:transform(item:getId(), 0)
		end
	end
	return true
end

fluid:id(2524, 2873, 2874, 2875, 2876, 2877, 2879, 2880, 2881, 2882, 2883, 2884, 2885, 2893, 2901, 2902, 2903, 2904, 3477, 3478, 3479, 3480)
fluid:register()
