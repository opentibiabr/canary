local spawnNPCRefiller = Action()

local config = {
    itemID = 18935, -- ID do item que deve ser clicado para invocar o NPC
    npcName = "Refiller Particular", -- Nome do NPC a ser invocado
    message = "Olá, eu sou seu npc refiller particular! Vou ficar por 80 segundos apenas...", -- Mensagem que o NPC deve dizer ao ser invocado
    duration = 80, -- Dura??o em segundos que o NPC ficar? presente
    cooldown = 300, -- Tempo em segundos de cooldown para usar novamente o item
    distance = 1 -- Dist?ncia em que o NPC ser? criado do player
}

local NPC_STORAGE_BASE = 123211456 -- Substitua pelo valor do storage base desejado

function spawnNPCRefiller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.itemID then
       -- if not player:isPzLocked() and not player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) then
            local now = os.time()
            local npcStorage = NPC_STORAGE_BASE + player:getGuid() -- Storage ?nico para cada jogador
            
            local lastSpawnTime = player:getStorageValue(npcStorage)
            if lastSpawnTime < now - config.cooldown then
                local playerPos = player:getPosition()
                local destPos = Position(playerPos.x + config.distance, playerPos.y, playerPos.z)
                
                local tile = Tile(destPos)
                if tile and tile:getGround() then
                    local ground = tile:getGround()
                    if tile:isWalkable() then
                        local npc = Game.createNpc(config.npcName, destPos)
                        if npc then
                            npc:say(config.message, TALKTYPE_SAY)
                            addEvent(function()
                                npc:remove()
                                destPos:sendMagicEffect(CONST_ME_POFF)
                            end, config.duration * 1000)
                            
                            -- Armazena a informa??o do ?ltimo spawn no storage do jogador
                            player:setStorageValue(npcStorage, now)
                        end
                    else
                        player:sendCancelMessage("You can't create the NPC here.")
                    end
                end
            else
                local remainingTime = math.ceil((lastSpawnTime + config.cooldown - now) / 60)
                player:sendCancelMessage("You need to wait " .. remainingTime .. " minute(s) before using this again.")
            end
       -- else
        --    player:sendCancelMessage("You can't use this when you're in a fight.")
       --     Position(fromPosition):sendMagicEffect(CONST_ME_POFF)
      --  end
        return true
    end
    return false
end

spawnNPCRefiller:id(config.itemID)
spawnNPCRefiller:register()
