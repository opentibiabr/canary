    --Clebin, OTBR
        --(Feito com auxilio de IA https://deepwiki.com/opentibiabr/canary & Gemini 2.5 Pro (preview), fica a recomendacao pois qualquer iniciante consegue se virar com essas ferramentas)
        
-- Enhanced skill map with all available skills
local skillMap = {
    club = SKILL_CLUB,
    sword = SKILL_SWORD,
    axe = SKILL_AXE,
    dist = SKILL_DISTANCE,
    distance = SKILL_DISTANCE,
    shield = SKILL_SHIELD,
    shielding = SKILL_SHIELD,
    fish = SKILL_FISHING,
    fishing = SKILL_FISHING,
    fist = SKILL_FIST
}

-- Function to get skill ID from skill name
local function getSkillId(skillName)
    return skillMap[skillName:lower()]
end

-- Function to handle additive skill increase
local function addSkillLevels(player, skillId, levelsToAdd)
    local vocation = player:getVocation()
    local currentLevel = player:getSkillLevel(skillId)
    local currentTries = player:getSkillTries(skillId)
    local requiredTriesForCurrentNextLevel = vocation:getRequiredSkillTries(skillId, currentLevel + 1)

    local percent = 0
    if requiredTriesForCurrentNextLevel > 0 then
        percent = currentTries / requiredTriesForCurrentNextLevel
    end

    local newLevel = currentLevel + levelsToAdd
    local requiredTriesForNewNextLevel = vocation:getRequiredSkillTries(skillId, newLevel + 1)
    local newTries = math.floor(requiredTriesForNewNextLevel * percent)

    player:setSkillLevel(skillId, newLevel, newTries)
    return newLevel
end

-- Function to handle additive magic level increase
local function addMagicLevels(player, levelsToAdd)
    local vocation = player:getVocation()
    local currentLevel = player:getBaseMagicLevel()
    local currentManaSpent = player:getManaSpent()
    local requiredManaForCurrentNextLevel = vocation:getRequiredManaSpent(currentLevel + 1)

    local percent = 0
    if requiredManaForCurrentNextLevel > 0 then
        percent = currentManaSpent / requiredManaForCurrentNextLevel
    end

    local newLevel = currentLevel + levelsToAdd
    local requiredManaForNewNextLevel = vocation:getRequiredManaSpent(newLevel + 1)
    local newManaSpent = math.floor(requiredManaForNewNextLevel * percent)

    player:setMagicLevel(newLevel, newManaSpent)
    return player:getBaseMagicLevel()
end

local addSkill = TalkAction("/addskill")

function addSkill.onSay(player, words, param)
    -- Create log for admin actions
    logCommand(player, words, param)

    if param == "" then
        player:sendCancelMessage("Command param required.")
        player:sendCancelMessage("Usage: /addskill <playername>, <skill or 'level'/'magic'>, <amount>")
        return true
    end

    local split = param:split(",")
    if #split < 3 then
        player:sendCancelMessage("Usage: /addskill <playername>, <skill or 'level'/'magic'>, <amount>")
        return true
    end

    -- Parse parameters
    local targetPlayerName = split[1]:trim()
    local targetPlayer = Player(targetPlayerName)

    if not targetPlayer then
        player:sendCancelMessage("Player not found.")
        return true
    end

    local skillParam = split[2]:trim():lower()
    local skillAmount = tonumber(split[3]:trim())

    if not skillAmount or skillAmount <= 0 then
        player:sendCancelMessage("Invalid amount. Must be a positive number.")
        return true
    end

    local skillPrefix = skillParam:sub(1, 1)

    -- Handle player level advancement
    if skillPrefix == "l" then
        local currentLevel = targetPlayer:getLevel()
        local newLevel = currentLevel + skillAmount
        local expForNewLevel = Game.getExperienceForLevel(newLevel)
        local expToAdd = expForNewLevel - targetPlayer:getExperience()
        if expToAdd > 0 then
            targetPlayer:addExperience(expToAdd, false)
        end
        local levelText = (skillAmount > 1) and "levels" or "level"
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillAmount, levelText))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillAmount, levelText, targetPlayer:getName()))

    -- Handle magic level advancement
    elseif skillPrefix == "m" then
        addMagicLevels(targetPlayer, skillAmount)
        local magicText = (skillAmount > 1) and "magic levels" or "magic level"
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillAmount, magicText))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillAmount, magicText, targetPlayer:getName()))

    -- Handle regular skill advancement
    else
        local skillId = getSkillId(skillParam)
        if not skillId then
            player:sendCancelMessage("Invalid skill name.")
            return true
        end
        addSkillLevels(targetPlayer, skillId, skillAmount)
        local skillText = (skillAmount > 1) and "skill levels" or "skill level"
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s %s to you.", player:getName(), skillAmount, skillParam, skillText))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s %s to player %s.", skillAmount, skillParam, skillText, targetPlayer:getName()))
    end

    return true
end

addSkill:separator(" ")
addSkill:groupType("god")
addSkill:register()

-- SETSKILL COMMAND
local setSkill = TalkAction("/setskill")

function setSkill.onSay(player, words, param)
    -- Create log for admin actions
    logCommand(player, words, param)

    if param == "" then
        player:sendCancelMessage("Command param required.")
        player:sendCancelMessage("Usage: /setskill <playername>, <skill or 'level'/'magic'>, <exact_level>")
        return true
    end

    local split = param:split(",")
    if #split < 3 then
        player:sendCancelMessage("Usage: /setskill <playername>, <skill or 'level'/'magic'>, <exact_level>")
        return true
    end

    -- Parse parameters
    local targetPlayerName = split[1]:trim()
    local targetPlayer = Player(targetPlayerName)

    if not targetPlayer then
        player:sendCancelMessage("Player not found.")
        return true
    end

    local skillParam = split[2]:trim():lower()
    local skillAmount = tonumber(split[3]:trim())

    if not skillAmount or skillAmount < 0 then
        player:sendCancelMessage("Invalid level. Must be a positive number.")
        return true
    end

    local skillPrefix = skillParam:sub(1, 1)

    -- Handle player level setting
    if skillPrefix == "l" then
        targetPlayer:setLevel(skillAmount)
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has set your level to %d.", player:getName(), skillAmount))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully set player %s level to %d.", targetPlayer:getName(), skillAmount))

    -- Handle magic level setting
    elseif skillPrefix == "m" then
        targetPlayer:setMagicLevel(skillAmount, 0)
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has set your magic level to %d.", player:getName(), skillAmount))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully set player %s magic level to %d.", targetPlayer:getName(), skillAmount))

    -- Handle regular skill setting
    else
        local skillId = getSkillId(skillParam)
        if not skillId then
            player:sendCancelMessage("Invalid skill name.")
            return true
        end
        targetPlayer:setSkillLevel(skillId, skillAmount, 0)
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has set your %s skill to level %d.", player:getName(), skillParam, skillAmount))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully set player %s %s skill to level %d.", targetPlayer:getName(), skillParam, skillAmount))
    end

    return true
end

setSkill:separator(" ")
setSkill:groupType("god")
setSkill:register()