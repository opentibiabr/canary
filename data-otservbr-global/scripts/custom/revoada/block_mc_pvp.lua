local radius = 10

local blockMcEvent = CreatureEvent("BlockMCEvent")

function blockMcEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local player = creature:getPlayer()  
    if not player:isPlayer() then
        return true  -- Not a player, exit the event
    end
    
    -- We use the attacker here as the actual target of the damage
    local target = attacker

    -- Check if target is a valid player
    if not target:isPlayer() then
        return true
    end

    -- Get all spectators within the specified radius around the player
    local spectators = Game.getSpectators(player:getPosition(), false, true, 0, radius, 0, radius)
    if #spectators <= 0 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    
    -- Store IPs of players in range to prevent damage if same IP is found
    local ipsInRange = {}
    local playerIp = player:getIp()
    
    -- Loop through each spectator and check for matching IP
    for _, spectator in pairs(spectators) do
        -- Ensure spectator is a player
        if spectator:isPlayer() then
            if spectator:getIp() == playerIp then
                -- Block damage if the player and spectator share the same IP
                return 0, primaryType, 0, secondaryType
            end
        end
    end
    
    -- If no matching IP found in range, proceed with normal damage
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

blockMcEvent:register()
