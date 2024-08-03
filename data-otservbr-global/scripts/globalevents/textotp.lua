local config = {
    interval = 6000,
    texts = {
        { pos = Position({x = 1226, y = 857, z = 8}), text = "Roullete Paladin", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
        { pos = Position({x = 1234, y = 857, z = 8}), text = "Roullete Sorcerer", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
        { pos = Position({x = 1222, y = 857, z = 8}), text = "Roullete Druid", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
        { pos = Position({x = 1230, y = 857, z = 8}), text = "Roullete Knight", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
        { pos = Position({x = 1228, y = 862, z = 8}), text = "Treiners", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
       { pos = Position({x = 1231, y = 862, z = 8}), text = "Hunts Room", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
       { pos = Position({x = 1225, y = 862, z = 8}), text = "Boss Room", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
	   { pos = Position(16988, 17128, 5), text = "Clique aqui para descer", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
	   { pos = Position(16987, 17129, 6), text = "Clique aqui para descer", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
	   { pos = Position(16987, 17130, 7), text = "Clique aqui para subir", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } }, 
       { pos = Position(32360, 32239, 7), text = "Top 1", effects = { CONST_ME_DRAWBLOOD } },
       { pos = Position(32362, 32239, 7), text = "Top 2", effects = { CONST_ME_DRAWBLOOD } },
       { pos = Position(32358, 32239, 7), text = "Top 3", effects = { CONST_ME_DRAWBLOOD } },
--        { pos = Position(32371, 32241, 6), text = "Distance", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
--        { pos = Position(32369, 32241, 6), text = "Club", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
--        { pos = Position(32367, 32241, 6), text = "Axe", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
--       { pos = Position(32365, 32241, 6), text = "Sword", effects = { CONST_ME_ICEAREA, CONST_ME_ENERGYHIT } },
		{ pos = Position(33627, 31422, 10), text = "Mirrored Nightmare", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33624, 31422, 10), text = "Furious Crater", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		-- { pos = Position(32321, 32244, 9), text = "Parabens!! Voce Terminou a Quest escolha seu item", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33621, 31422, 10), text = "Ebb and Flow", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33618, 31422, 10), text = "Rotten Wasteland", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33615, 31422, 10), text = "Claustrophobic Inferno", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33611, 31430, 10), text = "Boss Final", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		-- { pos = Position(33621, 31416, 10), text = "Sala Recompensa", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		-- { pos = Position(33621, 31435, 10), text = "Sair", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
--		{ pos = Position(33569, 31544, 10), text = "Acesso Soul-War", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
--		{ pos = Position(33556, 31524, 10), text = "Boss The Dread Maiden", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
--		{ pos = Position(33609, 31498, 10), text = "Boss The Fear Feaster", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
--		{ pos = Position(33611, 31527, 10), text = "Boss The Unwelcome", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
--		{ pos = Position(33572, 31447, 10), text = "Boss The Pale Worm", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
--		{ pos = Position(32177, 31925, 7), text = "Use a Scythe Na Estatua", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33192, 31691, 14), text = "Para Acessar e Preciso Pisar Pelo Menos 1 Trono Da Poi", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }
    }
}

local textOnMap = GlobalEvent("TextOnMap")

function textOnMap.onThink(interval)
    local player = Game.getPlayers()[1]
    if not player then
        return true
    end

    for k, info in pairs(config.texts) do
        player:say(info.text, TALKTYPE_MONSTER_SAY, false, nil, info.pos)
        info.pos:sendMagicEffect(info.effects[math.random(1, #info.effects)])
    end
    return true
end

textOnMap:interval(config.interval)
textOnMap:register()