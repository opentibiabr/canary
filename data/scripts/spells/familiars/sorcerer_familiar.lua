local spell = Spell("instant")

local familiar = {
	[VOCATION.BASE_ID.SORCERER] = {name = "Sorcerer familiar"}
}

local timer = {
	[1] = {storage=Storage.PetSummonEvent10, countdown=10, message = "10 seconds"},
	[2] = {storage=Storage.PetSummonEvent60, countdown=60, message = "one minute"}
}

local function sendMessageFunction(pid, message)
	if Player(pid) then
		Player(pid):sendTextMessage(MESSAGE_LOOT, "Your summon will disappear in less than " .. message)
	end
end

local function removePet(creatureId, playerId)
	local creature = Creature(creatureId)
	local player = Player(playerId)
	if not creature or not player then
		return true
	end
	creature:remove()
	for sendMessage = 1, #timer do
		player:setStorageValue(timer[sendMessage].storage, -1)
	end
end

function spell.onCastSpell(player, variant)
	local playerPosition = player:getPosition()
	if not player or not isPremium(player) then
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("You need a premium account.")
	return false
	end

	if #player:getSummons() >= 1 then
		player:sendCancelMessage("You can't have other summons.")
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local vocation = familiar[player:getVocation():getBaseId()]
	local familiarName

	if vocation then
		familiarName = vocation.name
	end

	if not familiarName then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local myFamiliar = Game.createMonster(familiarName, playerPosition, true, false, player)
	if not myFamiliar then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	myFamiliar:setOutfit({lookType = player:getFamiliarLooktype()})
	myFamiliar:registerEvent("FamiliarDeath")
	local deltaSpeed = math.max(player:getSpeed() - myFamiliar:getBaseSpeed(), 0)
	myFamiliar:changeSpeed(deltaSpeed)
	playerPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	myFamiliar:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:setStorageValue(Storage.PetSummon, os.time() + 15*60) -- 15 minutes from now
	addEvent(removePet, 15*60*1000, myFamiliar:getId(), player:getId())
	for sendMessage = 1, #timer do
		player:setStorageValue(timer[sendMessage].storage,addEvent(sendMessageFunction, (15*60-timer[sendMessage].countdown)*1000, player:getId(),timer[sendMessage].message))
	end
	return true
end

spell:group("support")
spell:id(196)
spell:name("Sorcerer familiar")
spell:words("utevo gran res ven")
spell:level(200)
spell:mana(3000)
spell:cooldown(30 * 60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()