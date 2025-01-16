local config = {
    bossName = "Brain Head",
    requiredLevel = 250,
    timeToFightAgain = 10, -- Em horas
    destination = Position(31963, 32324, 10),
    exitPosition = Position(31971, 32325, 10),
    spawnPositions = {
        boss = Position(31954, 32325, 10),
        minions = {
            Position(31953, 32324, 10), Position(31955, 32324, 10),
            Position(31953, 32326, 10), Position(31955, 32326, 10),
            Position(31960, 32320, 10), Position(31960, 32330, 10),
            Position(31947, 32320, 10), Position(31947, 32330, 10),
        }
    },
    maxPlayers = 5,
    prepTime = 5, -- Tempo em segundos para entrada de jogadores
    fightDuration = 270, -- Tempo em segundos de duração do combate
}

local entrancesTiles = {
	{ x = 31937, y = 32324, z = 10 },
	{ x = 31937, y = 32325, z = 10 },
	{ x = 31937, y = 32326, z = 10 },
	{ x = 31951, y = 32310, z = 10 },
	{ x = 31952, y = 32309, z = 10 },
	{ x = 31952, y = 32310, z = 10 },
	{ x = 31953, y = 32309, z = 10 },
	{ x = 31953, y = 32310, z = 10 },
	{ x = 31954, y = 32310, z = 10 },
	{ x = 31954, y = 32311, z = 10 },
	{ x = 31955, y = 32311, z = 10 },
	{ x = 31956, y = 32309, z = 10 },
	{ x = 31956, y = 32310, z = 10 },
	{ x = 31956, y = 32311, z = 10 },
	{ x = 31957, y = 32308, z = 10 },
	{ x = 31957, y = 32309, z = 10 },
	{ x = 31957, y = 32310, z = 10 },
	{ x = 31951, y = 32339, z = 10 },
	{ x = 31952, y = 32339, z = 10 },
	{ x = 31953, y = 32339, z = 10 },
	{ x = 31953, y = 32340, z = 10 },
	{ x = 31954, y = 32340, z = 10 },
	{ x = 31955, y = 32340, z = 10 },
	{ x = 31955, y = 32341, z = 10 },
	{ x = 31969, y = 32323, z = 10 },
	{ x = 31969, y = 32324, z = 10 },
	{ x = 31969, y = 32325, z = 10 },
	{ x = 31969, y = 32326, z = 10 },
	{ x = 31969, y = 32327, z = 10 },
	{ x = 31970, y = 32323, z = 10 },
	{ x = 31970, y = 32324, z = 10 },
	{ x = 31970, y = 32326, z = 10 },
}

local locked = false
local playersInRoom = {}

-- Função para spawnar o boss e minions
local function spawnMonsters()    
    Game.createMonster(config.bossName, config.spawnPositions.boss)

    for _, pos in ipairs(config.spawnPositions.minions) do
        Game.createMonster("Cerebellum", pos)
    end
end

-- Função para limpar monstros e resetar a sala
local function resetRoom()    
    for _, pos in ipairs(config.spawnPositions.minions) do
        local creature = Tile(pos):getTopCreature()
        if creature and creature:isMonster() then
            creature:remove()
        end
    end

    local bossTile = Tile(config.spawnPositions.boss)
    local boss = bossTile:getTopCreature()
    if boss and boss:isMonster() then
        boss:remove()
    end

    playersInRoom = {}
    locked = false
end

-- Função de teleport com mensagem
local function teleportPlayer(player, message)    
    player:teleportTo(config.exitPosition, true)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    if message then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
    end
end

-- Função para iniciar o combate após o tempo de preparação
local function startFight()    
    spawnMonsters()
    locked = true

    -- Encerrar combate após a duração definida
    addEvent(function()        
        resetRoom()
    end, config.fightDuration * 1000)
end

-- Evento de step-in
local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
    if not creature or not creature:isPlayer() then        
        return false
    end

    local player = creature    

    if player:getLevel() < config.requiredLevel then
        return teleportPlayer(player, "Você precisa ser nível " .. config.requiredLevel .. " ou superior.")
    end

    if locked then
        return teleportPlayer(player, "A sala já está em combate.")
    end

    local timeLeft = player:getBossCooldown(config.bossName) - os.time()
    if timeLeft > 0 then
        return teleportPlayer(player, "Você precisa esperar " .. getTimeInWords(timeLeft) .. " para enfrentar " .. config.bossName .. " novamente.")
    end

    -- Adicionar jogador à sala
    table.insert(playersInRoom, player:getId())
    player:teleportTo(config.destination)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    player:setBossCooldown(config.bossName, os.time() + config.timeToFightAgain * 3600)
    player:sendBosstiaryCooldownTimer()

    -- Verificar se é o primeiro jogador e iniciar o timer de preparação
    if #playersInRoom == 1 then        
        addEvent(function()
            if #playersInRoom > 0 and not locked then
                startFight()
            end
        end, config.prepTime * 1000)
    end

    -- Verificar limite de jogadores
    if #playersInRoom > config.maxPlayers then
        return teleportPlayer(player, "O máximo de jogadores permitidos na sala é " .. config.maxPlayers .. ".")
    end
end

-- Registrar tiles de entrada
for _, tile in ipairs(entrancesTiles) do    
    teleportBoss:position(tile)
end

teleportBoss:type("stepin")
teleportBoss:register()

-- Teleporte de saída
SimpleTeleport(Position(31946, 32334, 10), config.exitPosition)
