local cityWarEventLogin = CreatureEvent("cityWarEventLogin")

function cityWarEventLogin.onLogin(player)
	if player:getStorageValue(team_battle.stor_team) > -1 then
		player:setStorageValue(team_battle.stor_team, -1)
	end
    local v = team_battle.team_a[player:getName()]
	if v and (#v > 0) then
		player:addItem(v[1], v[2])
		team_battle.broadcast(team_battle.msg_bonus:format(team_battle.reward[2], ItemType(team_battle.reward[1]):getName()), TALKTYPE_BROADCAST)
		team_battle.team_a[player:getName()] = nil
	end
	v = team_battle.team_b[player:getName()]
	if v and (#v > 0) then
		player:addItem(v[1], v[2])
		team_battle.broadcast(team_battle.msg_bonus:format(team_battle.reward[2], ItemType(team_battle.reward[1]):getName()), TALKTYPE_BROADCAST)
		team_battle.team_b[player:getName()] = nil
	end
	return true
end

cityWarEventLogin:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

local cityWarEventHealthChange = CreatureEvent("cityWarEventHealthChange")

function cityWarEventHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

    if getGlobalStorageValue(team_battle.status) == 0 or getGlobalStorageValue(team_battle.status) == 1 then
        if creature:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) or
        creature:getPosition():isInRange(team_battle.arena.from, team_battle.arena.to) then
			if creature == attacker then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
            if not team_battle.isEnemy(creature, attacker) then
				attacker:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You can't attack your team.")
				attacker:getPosition():sendMagicEffect(CONST_ME_POFF)
                return false
            end
        end
    end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

cityWarEventHealthChange:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

local cityWarEventPrepareDeath = CreatureEvent("cityWarEventPrepareDeath")

function cityWarEventPrepareDeath.onPrepareDeath(creature, killer, realDamage)

    local loseTeam = team_battle.getData(creature, "team")
	if killer and killer:isPlayer() and getGlobalStorageValue(team_battle.status) > -1 then
		local winTeam = (team_battle.getData(killer, "team") == 1) and team_battle.team_a_frags or team_battle.team_b_frags
		killer:setTarget(0)
		setGlobalStorageValue(winTeam, getGlobalStorageValue(winTeam) + 1)
		team_battle.broadcast(team_battle.msg_kill:format(killer:getName(), creature:getName(), getGlobalStorageValue(team_battle.team_a_frags), getGlobalStorageValue(team_battle.team_b_frags)), TALKTYPE_BROADCAST)
		creature:sendPrivateMessage(creature, team_battle.msg_defeat:format(killer:getName() .. " just killed you"), TALKTYPE_BROADCAST)
	else
        --if died for monster/not player, then teleport to team temple
        -- add teleport function
		creature:sendPrivateMessage(creature, team_battle.msg_defeat:format("You just died"), TALKTYPE_BROADCAST)
	end
	team_battle.onEnd(creature)
	if #team_battle.getTeamPlayers(loseTeam) == 0 then
		team_battle.finish()
	end

	return true
end

cityWarEventPrepareDeath:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

local teamBattle = TalkAction("!teambattle")
function teamBattle.onSay(player, words, param)

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
		player:sendCancelMessage("Cannot perform action.")
		return true
	end

    if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
    elseif param == "start" then
        if getGlobalStorageValue(team_battle.status) > -1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Team Battle is already running.")
            return true
        else
            setGlobalStorageValue(team_battle.status, 0)
            for n = 0, team_battle.start_time-1 do
                addEvent(broadcastMessage, n*60*1000, team_battle.msg_call:format(team_battle.start_time-n .. " minute" .. (team_battle.start_time-n > 1 and "s" or "")), MESSAGE_EVENT_ADVANCE)
            end
            addEvent(team_battle.start, team_battle.start_time*60*1000)
        end
    elseif param == "cancel" then
        if getGlobalStorageValue(team_battle.status) == -1 then
			player:sendCancelMessage("Team Battle is not currently running.")
			return true
		elseif getGlobalStorageValue(team_battle.status) == 0 then
			team_battle.cancel()
			return true
		else
			stopEvent(team_battle.event)
			setGlobalStorageValue(team_battle.status, -1)
			for _, player in ipairs(Game.getPlayers()) do
				if player:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) or
					player:getPosition():isInRange(team_battle.arena.from, team_battle.arena.to) then
					team_battle.unregister(player)
					team_battle.heal(player)
					player:removeCondition(CONDITION_OUTFIT)
					player:teleportTo(player:getTown():getTemplePosition())
				end
			end
		end
	end
end
teamBattle:groupType("god")
teamBattle:separator(" ")
teamBattle:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

local cityWarJoin = TalkAction("!citywar")
function cityWarJoin.onSay(player, words, param)

    if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
    elseif param == "join" then
        if getGlobalStorageValue(team_battle.status) == 1 then
			player:sendCancelMessage("Team Battle has already started.")
			return false
		elseif getGlobalStorageValue(team_battle.status) == -1 then
			player:sendCancelMessage("Team Battle is not currently running.")
			return false
		else
			if not getTileInfo(player:getPosition()).protection then
				player:sendCancelMessage("You may only join the event while being on protection zone.")
				return false
			end

			if player:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) then
				player:sendCancelMessage("You are already in the Team Battle.")
				return false
			end

			if player:getLevel() < team_battle.player_level then
				player:sendCancelMessage("You need to be at least of level " .. team_battle.player_level .. " to join the Team Battle.")
				return false
			end

			if team_battle.ip_check and team_battle.hasDuplicateIP(player) then
				player:sendCancelMessage("You cannot join the Team Battle with someone else having your same IP.")
				return false
			end

            local count = 0
            for i, counted in ipairs(Game.getPlayers()) do
                if counted:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) then
                    count = count + 1
                end
            end

            if count >= team_battle.max_players then
                player:sendCancelMessage("The Team Battle Event is already full.")
                return false
            end

			player:openChannel(team_battle.channel)
			team_battle.teleport(player, team_battle.wait_room.from, team_battle.wait_room.to)
			team_battle.broadcast(team_battle.msg_join:format(player:getName()), 8)
		end
	end
end
cityWarJoin:groupType("normal")
cityWarJoin:separator(" ")
cityWarJoin:register()

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
