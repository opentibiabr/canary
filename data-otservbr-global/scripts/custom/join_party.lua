local ptInvite = TalkAction("!invite")
function ptInvite.onSay(player, words, param)
    local party = player:getParty()
	local inAParty = Player(param):getParty()
    if party and not inAParty then
        if party:getLeader():getId() == player:getId() then
            party:addInvite(Player(param))
            Player(param):sendTextMessage(MESSAGE_INFO_DESCR, "".. player:getName() .." has invited you to join his party, say !join ".. player:getName() .."")
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Party invitation has been sent to ".. Player(param):getName() .."")
        else
            player:sendCancelMessage("You need to be party leader to invite others")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
	else
		if not inAParty then
			local party = Party(player)
			 party:addInvite(Player(param))
			 Player(param):sendTextMessage(MESSAGE_INFO_DESCR, "".. player:getName() .." has invited you to join his party, say !join ".. player:getName() .."")
			 player:sendTextMessage(MESSAGE_INFO_DESCR, "Party invitation has been sent to ".. Player(param):getName() .."")
		else
			player:sendCancelMessage("Player already in a party.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
    end
    return false
end

ptInvite:groupType("normal")
ptInvite:separator(" ")
ptInvite:register()



local ptJoin = TalkAction("!join")
function ptJoin.onSay(player, words, param)
	local party = Player(param):getParty()
    if party then
        local invited = party:getInvitees()
        local flag = 0
        for i = 1, #invited do
            if invited[i]:getId() == player:getId() then
                flag = 1
            end
        end
        if flag > 0 then
            --party:removeInvite(player)
            party:addMember(player)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have joined ".. Player(param):getName() .." party.")
            Player(param):sendTextMessage(MESSAGE_INFO_DESCR, "".. player:getName() .." has joined the party.")
			party:removeInvite(player)
        else
            player:sendCancelMessage("You are not invited in this party.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
    else
        player:sendCancelMessage(""..Player(param):getName().." is not a party member.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end
end

ptJoin:groupType("normal")
ptJoin:separator(" ")
ptJoin:register()