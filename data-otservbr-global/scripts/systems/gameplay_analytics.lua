local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics.lua")

local startup = GlobalEvent("GameplayAnalyticsStartup")
function startup.onStartup()
    Analytics.startRuntime()
    return true
end
startup:register()

local shutdown = GlobalEvent("GameplayAnalyticsShutdown")
function shutdown.onShutdown()
    Analytics.stopRuntime()
    return true
end
shutdown:register()

local health = CreatureEvent("GameplayAnalyticsHealth")
function health.onHealthChange(creature, attacker, primaryValue, primaryType, secondaryValue, secondaryType, origin)
    if not Analytics.isEnabled() then
        return primaryValue, primaryType, secondaryValue, secondaryType
    end

    local function ownerPlayer(source)
        if not source then
            return nil
        end
        if source:isPlayer() then
            return source
        end
        local master = source:getMaster()
        if master and master:isPlayer() then
            return master
        end
        return nil
    end

    local sourcePlayer = ownerPlayer(attacker)
    local targetPlayer = creature:isPlayer() and creature or nil
    local totalDamage = 0
    local totalHealing = 0

    if primaryValue < 0 then
        totalDamage = totalDamage + math.abs(primaryValue)
    elseif primaryValue > 0 then
        totalHealing = totalHealing + primaryValue
    end
    if secondaryValue < 0 then
        totalDamage = totalDamage + math.abs(secondaryValue)
    elseif secondaryValue > 0 then
        totalHealing = totalHealing + secondaryValue
    end

    if totalDamage > 0 then
        if sourcePlayer and (Analytics.config.trackPvP or not creature:isPlayer()) then
            Analytics.recordDamageDealt(sourcePlayer, creature, totalDamage, primaryType)
        end
        if targetPlayer and (Analytics.config.trackPvP or not (attacker and attacker:isPlayer())) then
            Analytics.recordDamageReceived(targetPlayer, attacker, totalDamage, primaryType)
        end
    elseif totalHealing > 0 and sourcePlayer and targetPlayer then
        local missingBefore = math.max(0, targetPlayer:getMaxHealth() - targetPlayer:getHealth())
        local effective = math.min(totalHealing, missingBefore)
        Analytics.recordHealing(sourcePlayer, targetPlayer, effective, math.max(0, totalHealing - effective))
    end

    return primaryValue, primaryType, secondaryValue, secondaryType
end
health:register()

local mana = CreatureEvent("GameplayAnalyticsMana")
function mana.onManaChange(creature, attacker, primaryValue, primaryType, secondaryValue, secondaryType, origin)
    if Analytics.isEnabled() and creature:isPlayer() then
        local spent = 0
        if primaryValue < 0 then
            spent = spent + math.abs(primaryValue)
        end
        if secondaryValue < 0 then
            spent = spent + math.abs(secondaryValue)
        end
        if spent > 0 then
            Analytics.recordManaSpent(creature, spent)
        end
    end
    return primaryValue, primaryType, secondaryValue, secondaryType
end
mana:register()

local login = CreatureEvent("GameplayAnalyticsLogin")
function login.onLogin(player)
    if not Analytics.isEnabled() then
        return true
    end
    player:registerEvent("GameplayAnalyticsHealth")
    player:registerEvent("GameplayAnalyticsMana")
    player:registerEvent("GameplayAnalyticsDeath")
    player:registerEvent("GameplayAnalyticsKill")
    player:registerEvent("GameplayAnalyticsExperience")
    Analytics.start(player)
    return true
end
login:register()

local logout = CreatureEvent("GameplayAnalyticsLogout")
function logout.onLogout(player)
    if Analytics.isEnabled() then
        Analytics.finish(player, "logout")
    end
    return true
end
logout:register()

local death = CreatureEvent("GameplayAnalyticsDeath")
function death.onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if Analytics.isEnabled() and player:isPlayer() then
        Analytics.recordDeath(player)
    end
    return true
end
death:register()

local kill = CreatureEvent("GameplayAnalyticsKill")
function kill.onKill(player, target)
    if Analytics.isEnabled() and player:isPlayer() then
        Analytics.recordKill(player, target)
    end
    return true
end
kill:register()

local experience = CreatureEvent("GameplayAnalyticsExperience")
function experience.onGainExperience(player, source, experienceValue, rawExperience)
    if Analytics.isEnabled() and source then
        Analytics.recordExperience(player, experienceValue, rawExperience)
    end
    return experienceValue
end
experience:register()

-- Every monster must carry the health-change event so outgoing player damage can
-- be measured after final combat reductions. EventCallback.onSpawn is global and
-- does not require editing individual monster definitions.
local spawnCallback = EventCallback
function spawnCallback.onSpawn(creature, position, startup, artificial)
    if Analytics.isEnabled() and creature:isMonster() then
        creature:registerEvent("GameplayAnalyticsHealth")
    end
    return true
end
spawnCallback:register()

local analyticsCommand = TalkAction("/analytics")
function analyticsCommand.onSay(player, words, param)
    if player:getAccountType() < ACCOUNT_TYPE_GAMEMASTER then
        return false
    end

    local command = param:trim():lower()
    if command == "flush" then
        Analytics.flush()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gameplay Analytics queue flushed.")
        return false
    end

    if command == "enable" then
        Analytics.config.enabled = true
        Analytics.startRuntime()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gameplay Analytics enabled until restart.")
        return false
    end

    if command == "disable" then
        Analytics.stopRuntime()
        Analytics.config.enabled = false
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gameplay Analytics disabled until restart.")
        return false
    end

    local status = Analytics.status()
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
        "Gameplay Analytics: enabled=%s, running=%s, active=%d, queued=%d, detail=%d, lastFlush=%d",
        tostring(status.enabled), tostring(status.running), status.activeSessions,
        status.queuedSessions, status.detailLevel, status.lastFlush
    ))
    return false
end
analyticsCommand:separator(" ")
analyticsCommand:groupType("god")
analyticsCommand:register()
