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

	local split = param:split(",")
	local monsterName = split[1]
	local monsterForge = nil
	if split[2] then
		split[2] = split[2]:gsub("^%s*(.-)$", "%1") --Trim left
		monsterForge = split[2]
	end
	-- Check dust level
	local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(monsterForge, player)

	local position = player:getPosition()
	local monster = Game.createMonster(monsterName, position)
	if monster then
		if not monster:isForgeable() then
			player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
			return false
		end
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)

		local monsterType = monster:getType()
		if canSetFiendish then
			SetFiendish(monsterType, position, player, monster)
		end
		if canSetInfluenced then
			SetInfluenced(monsterType, monster, player, influencedLevel)
		end
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end

createMonster:separator(" ")
createMonster:register()
