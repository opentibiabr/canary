local familiar = {
	[VOCATION.BASE_ID.SORCERER] = {id = 994, name = "Sorcerer familiar"},
	[VOCATION.BASE_ID.DRUID] = {id = 993, name = "Druid familiar"},
	[VOCATION.BASE_ID.PALADIN] = {id = 992, name = "Paladin familiar"},
	[VOCATION.BASE_ID.KNIGHT] = {id = 991, name = "Knight familiar"}
}

local timer = {
	[1] = {storage=Storage.PetSummonEvent10, countdown=10, message = "10 seconds"},
	[2] = {storage=Storage.PetSummonEvent60, countdown=60, message = "one minute"}
}

local function SendMessageFunction(pid, message)
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

local familiarStorage = Storage.PetSummon

local familiarLogin = CreatureEvent("FamiliarLogin")

function familiarLogin.onLogin(player)
	if not player then
		return false
	end

	local vocation = familiar[player:getVocation():getBaseId()]

	local familiarName
	local petTimeLeft = player:getStorageValue(familiarStorage) - player:getLastLogout()

	if vocation then
		if (not isPremium(player) and player:hasFamiliar(vocation.id)) or player:getLevel() < 200 then
			player:removeFamiliar(vocation.id)
		elseif isPremium(player) and player:getLevel() >= 200 then
			if petTimeLeft > 0 then
				familiarName = vocation.name
			end
			if player:getFamiliarLooktype() == 0 then
				player:setFamiliarLooktype(vocation.id)
			end
			if not player:hasFamiliar(vocation.id) then
				player:addFamiliar(vocation.id)
			end
		end
	end

	if familiarName then
		local position = player:getPosition()
		local familiarMonster = Game.createMonster(familiarName, position, true, false, player)
		if familiarMonster then

			familiarMonster:setOutfit({lookType = player:getFamiliarLooktype()})
			familiarMonster:registerEvent("FamiliarDeath")
			position:sendMagicEffect(CONST_ME_MAGIC_BLUE)

			local deltaSpeed = math.max(player:getSpeed() - familiarMonster:getSpeed(), 0)
			familiarMonster:changeSpeed(deltaSpeed)

			player:setStorageValue(familiarStorage, os.time() + petTimeLeft)
			addEvent(removePet, petTimeLeft*1000, familiarMonster:getId(), player:getId())

			for sendMessage = 1, #timer do
				if player:getStorageValue(timer[sendMessage].storage) == -1 and petTimeLeft >= timer[sendMessage].countdown then
					player:setStorageValue(timer[sendMessage].storage, addEvent(SendMessageFunction, (petTimeLeft-timer[sendMessage].countdown)*1000, player:getId(), timer[sendMessage].message))
				end
			end
		end
	end
	return true
end

familiarLogin:register()

local advanceFamiliar = CreatureEvent("AdvanceFamiliar")

function advanceFamiliar.onAdvance(player, skill, oldLevel, newLevel)
	local vocation = familiar[player:getVocation():getBaseId()]
	if vocation and newLevel >= 200 and isPremium(player) then
		if player:getFamiliarLooktype() == 0 then
				player:setFamiliarLooktype(vocation.id)
		end
		if not player:hasFamiliar(vocation.id) then
			player:addFamiliar(vocation.id)
		end
	end
	return true
end

advanceFamiliar:register()

local familiarDeath = CreatureEvent("FamiliarDeath")

function familiarDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local player = creature:getMaster()
	if not player then
		return false
	end

	local vocation = familiar[player:getVocation():getBaseId()]
	if table.contains(vocation, creature:getName()) then
		player:setStorageValue(familiarStorage, os.time())
		for sendMessage = 1, #timer do
			stopEvent(player:getStorageValue(timer[sendMessage].storage))
			player:setStorageValue(timer[sendMessage].storage, -1)
		end
	end
	return true
end

familiarDeath:register()
