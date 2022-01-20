local familiar = {
	[VOCATION.BASE_ID.DRUID] = {name = "Druid familiar"}
}

local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	local playerPosition = player:getPosition()
	if not player or not player:isPremium() then
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
	player:setStorageValue(Storage.FamiliarSummon, os.time() + 15*60) -- 15 minutes from now
	addEvent(removeFamiliar, 15*60*1000, myFamiliar:getId(), player:getId())
	for sendMessage = 1, #FAMILIAR_TIMER do
		player:setStorageValue(FAMILIAR_TIMER[sendMessage].storage,addEvent(sendMessageFunction, (15*60-FAMILIAR_TIMER[sendMessage].countdown)*1000, player:getId(),FAMILIAR_TIMER[sendMessage].message))
	end
	return true
end

spell:group("support")
spell:id(197)
spell:name("Druid familiar")
spell:words("utevo gran res dru")
spell:level(200)
spell:mana(3000)
spell:cooldown(30 * 60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true")
spell:register()
