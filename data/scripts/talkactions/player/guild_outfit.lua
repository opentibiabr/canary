local outfit = TalkAction("!guild outfit")

local function applyOutfitToMember(member, leaderOutfit)
    if canPlayerWearOutfit(member, leaderOutfit.lookType, 0) then
        member:setOutfit({
            lookType = leaderOutfit.lookType,
            lookFeet = leaderOutfit.lookFeet,
            lookBody = leaderOutfit.lookBody,
            lookLegs = leaderOutfit.lookLegs,
            lookHead = leaderOutfit.lookHead,
            lookAddons = leaderOutfit.lookAddons or 0,
        })
    else
        -- Apply partial outfit if the full outfit cannot be worn
        member:setOutfit({
            lookType = member:getOutfit().lookType,
            lookFeet = leaderOutfit.lookFeet,
            lookBody = leaderOutfit.lookBody,
            lookLegs = leaderOutfit.lookLegs,
            lookHead = leaderOutfit.lookHead,
            lookAddons = 0,
        })
    end
    member:getPosition():sendMagicEffect(CONST_ME_BATS)
end

function outfit.onSay(player, words, param)
    if not player or player:getGuildLevel() < 3 then
        player:sendCancelMessage("You need to be a leader of your guild to use this command.")
        return false
    end

    local guild = player:getGuild()
    if not guild then
        player:sendCancelMessage("You are not part of a guild.")
        return false
    end

    local leaderOutfit = player:getOutfit()
    for _, member in ipairs(guild:getMembersOnline() or {}) do
        if member then
            applyOutfitToMember(member, leaderOutfit)
        end
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Your guild members have been updated with your outfit.")
    return true
end

outfit:groupType("normal")
outfit:register()