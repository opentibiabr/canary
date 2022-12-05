local createMonster = TalkAction("/m")

function createMonster.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Usage: "/m monstername, fiendish" for create a fiendish monster (/m rat, fiendish)
	-- Usage: "/m monstername, [1-5]" for create a influenced monster with specific level (/m rat, 2)
	if param == "" then
		player:sendCancelMessage("Monster name param required.")
		Spdlog.error("[createMonster.onSay] - Monster name param not found.")
		return false
	end

	local split = param:split(", ")
	local monsterName = split[1]
	local monsterForge = nil
	if split[2] then
		monsterForge = split[2]
	end
	-- Check dust level
	local setFiendish = false
	local setInfluenced
	if type(monsterForge) == "string" and monsterForge == "fiendish" then
		setFiendish = true
	end
	local influencedLevel
	if not setFiendish then
		influencedLevel = tonumber(monsterForge)
	end
	if influencedLevel and influencedLevel > 0 then
		if influencedLevel > 5 then
			player:sendCancelMessage("Invalid influenced level.")
			return false
		end
		setInfluenced = true
	end

	local position = player:getPosition()
	local monster = Game.createMonster(monsterName, position)
	if monster then
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
		if setFiendish then
			monster:setFiendish(position, player)
		end
		if setInfluenced then
			Game.addInfluencedMonster(monster)
			monster:setForgeStack(influencedLevel)
		end
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end

createMonster:separator(" ")
createMonster:register()
