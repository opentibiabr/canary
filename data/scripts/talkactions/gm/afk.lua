local afk = TalkAction("/afk")

playersAFKs = {}

local function checkIsAFK(id)
	for index, item in pairs(playersAFKs) do
		if id == item.id then
			return { afk = true, index = index }
		end
	end
	return { afk = false }
end

function afk.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("You need to specify on/off param.")
		return true
	end

	local id, position = player:getId(), player:getPosition()
	local isAfk = checkIsAFK(id)
	if param == "on" then
		if isAfk.afk then
			player:sendCancelMessage("You are already AFK!")
			return true
		end

		table.insert(playersAFKs, { id = id, position = position })
		if player:isInGhostMode() then
			player:setGhostMode(false)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are now AFK!")
		position:sendMagicEffect(CONST_ME_REDSMOKE)
		local spectators = Game.getSpectators(position, false, true, 8, 8, 8, 8)
		if #spectators > 0 then
			for _, spectator in ipairs(spectators) do
				spectator:say("AFK !", TALKTYPE_MONSTER_SAY, false, spectator, position)
			end
		end
	elseif param == "off" then
		if isAfk.afk then
			table.remove(playersAFKs, isAfk.index)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are no longer AFK!")
		position:sendMagicEffect(CONST_ME_REDSMOKE)
	end

	return true
end

afk:separator(" ")
afk:groupType("gamemaster")
afk:register()

------------------ AFK Effect Message ------------------
local afkEffect = GlobalEvent("GodAfkEffect")
function afkEffect.onThink(interval)
	for _, player in ipairs(playersAFKs) do
		local spectators = Game.getSpectators(player.position, false, true, 8, 8, 8, 8)
		if #spectators > 0 then
			for _, spectator in ipairs(spectators) do
				spectator:say("AFK !", TALKTYPE_MONSTER_SAY, false, spectator, player.position)
			end
		end
	end
	return true
end

afkEffect:interval(5000)
afkEffect:register()

------------------ Stop AFK Message when moves ------------------
local callback = EventCallback()
function callback.playerOnWalk(player, creature, creaturePos, toPos)
	local isAfk = checkIsAFK(player:getId())
	if isAfk.afk then
		table.remove(playersAFKs, isAfk.index)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are no longer AFK!")
	end
	return true
end

callback:register()
