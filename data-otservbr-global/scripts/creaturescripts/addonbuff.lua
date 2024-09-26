-- ⓥⓐⓖⓞⓢⓖⓐⓜⓘⓝⓖ ⓢⓔⓡⓥⓘⓒⓘⓞⓢ ⓟⓡⓞⓖⓡⓐⓜⓐⓒⓘⓞⓝ 2006-2023

-- No revender este script.

-- Mi Discord :  https://discord.gg/22GBHzqFxG

local addonBonus = CreatureEvent("AddonBonus")

-- Definir niveles y sus respectivos puntos requeridos
local levels = {
    { level = 1, requiredPoints = 30 },
    { level = 2, requiredPoints = 80 },
    { level = 3, requiredPoints = 160 },
    { level = 4, requiredPoints = 220 },
    { level = 5, requiredPoints = 320 },
    { level = 6, requiredPoints = 430 },
    { level = 7, requiredPoints = 550 },
    { level = 8, requiredPoints = 850 },
    { level = 9, requiredPoints = 1300 },
    { level = 10, requiredPoints = 1800 },
    { level = 11, requiredPoints = 2500 },
    { level = 12, requiredPoints = 3300 },
    -- Agregar más niveles según sea necesario
}

-- Verificar si el jugador tiene suficientes puntos para un nivel
local function checkLevel(points)
    if type(points) ~= "number" then
        print("Error: Invalid points value. Expected a number.")
        return 0
    end

    local playerLevel = 0  -- Inicializa el nivel del jugador en 0

    for _, levelData in ipairs(levels) do
        if points >= levelData.requiredPoints then
            playerLevel = levelData.level  -- Actualiza el nivel del jugador
        else
            break  -- Si no cumple con el nivel actual, no tiene sentido verificar los niveles superiores
        end
    end

    return playerLevel
end

-- Agregar esta función para limpiar las condiciones antiguas
local function clearOldConditions(player, oldConditions)
    for _, condition in pairs(oldConditions) do
        player:removeCondition(condition)
    end
end

function addonBonus.onLogin(player)
-- Definir diferentes condiciones
local conditions = {
    sorcerer = {
        Condition(CONDITION_ATTRIBUTES), -- condición para sorcerer - nivel 1
        Condition(CONDITION_ATTRIBUTES), -- condición para sorcerer - nivel 2
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 3
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 4
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 5
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 6
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 7
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 8
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 9
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 10
        Condition(CONDITION_ATTRIBUTES),  -- condición para sorcerer - nivel 11
        Condition(CONDITION_ATTRIBUTES)  -- condición para sorcerer - nivel 12
    },
    druid = {
        Condition(CONDITION_ATTRIBUTES), -- condición para druid - nivel 1
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 2
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 3
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 4
        Condition(CONDITION_ATTRIBUTES), -- condición para druid - nivel 5
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 6
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 7
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 8
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 9
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 10
        Condition(CONDITION_ATTRIBUTES),  -- condición para druid - nivel 11
        Condition(CONDITION_ATTRIBUTES)  -- condición para druid - nivel 12
    },
    paladin = {
        Condition(CONDITION_ATTRIBUTES), -- condición para paladin - nivel 1
        Condition(CONDITION_ATTRIBUTES), -- condición para paladin - nivel 2
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 3
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 4
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 5
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 6
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 7
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 8
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 9
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 10
        Condition(CONDITION_ATTRIBUTES),  -- condición para paladin - nivel 11
        Condition(CONDITION_ATTRIBUTES)  -- condición para paladin - nivel 12
    },
    knight = {
        Condition(CONDITION_ATTRIBUTES), -- condición para knight - nivel 1
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 2
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 3
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 4
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 5
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 6
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 7
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 8
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 9
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 10
        Condition(CONDITION_ATTRIBUTES),  -- condición para knight - nivel 11
        Condition(CONDITION_ATTRIBUTES)  -- condición para knight - nivel 12
    },
}
    -- Agregar más condiciones según sea necesario

-- Establecer parámetros para cada condición
for vocation, levelsTable in pairs(conditions) do
    for level, condition in pairs(levelsTable) do

        if vocation == "sorcerer" then
            if level == 1 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 30)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 180)
            elseif level == 2 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 45)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 270) 
			elseif level == 3 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 45)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 270) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1) 
			elseif level == 4 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 360) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1) 
			elseif level == 5 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 360) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2) 
			elseif level == 6 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 720) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2) 
			elseif level == 7 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 720) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3) 
			elseif level == 8 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3) 
                condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 500) 
                condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500) 
				
			elseif level == 9 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 4)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 400)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 800)
				
				
				
			elseif level == 10 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 2880) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 4) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1000)
				condition:setParameter(CONDITION_PARAM_INCREASE_FIREPERCENT, 5)
				condition:setParameter(CONDITION_PARAM_INCREASE_ENERGYPERCENT, 5)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 5)
				
				
				
			elseif level == 11 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 2880) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 5) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1300)
				condition:setParameter(CONDITION_PARAM_INCREASE_FIREPERCENT, 10)
				condition:setParameter(CONDITION_PARAM_INCREASE_ENERGYPERCENT, 10)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 10)
				
			elseif level == 12 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 2880) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 7) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 800) --100 = 1%
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 900)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1600)
				condition:setParameter(CONDITION_PARAM_INCREASE_FIREPERCENT, 15)
				condition:setParameter(CONDITION_PARAM_INCREASE_ENERGYPERCENT, 15)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 15)
            end
      
     	  elseif vocation == "druid" then
            if level == 1 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 30)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 180)				
            elseif level == 2 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 45)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 270)
			elseif level == 3 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 45)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 270) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
				
			elseif level == 4 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 360) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1) 
			elseif level == 5 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 360) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2) 
			elseif level == 6 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 720) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2) 
			elseif level == 7 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 720) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3) 
			elseif level == 8 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3) 
                condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 500) 
                condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500) 
			elseif level == 9 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 4)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 400)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 800)
		    elseif level == 10 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 2880) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 4) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1000)
				condition:setParameter(CONDITION_PARAM_INCREASE_EARTHPERCENT, 5)
				condition:setParameter(CONDITION_PARAM_INCREASE_ICEPERCENT, 5)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 5)
			elseif level == 11 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 2880) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 5) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1300)
				condition:setParameter(CONDITION_PARAM_INCREASE_EARTHPERCENT, 10)
				condition:setParameter(CONDITION_PARAM_INCREASE_ICEPERCENT, 10)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 10)
			elseif level == 12 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 2880) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 7) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 800) --100 = 1%
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 900)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1600)
				condition:setParameter(CONDITION_PARAM_INCREASE_EARTHPERCENT, 15)
				condition:setParameter(CONDITION_PARAM_INCREASE_ICEPERCENT, 15)	
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 15)
            end
       
	   elseif vocation == "paladin" then
            if level == 1 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 90)
            elseif level == 2 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 90)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 135) 
			elseif level == 3 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 90)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 135)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 1) 
			elseif level == 4 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 180)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 1) 
			elseif level == 5 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 180)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 2) 
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1) 
			elseif level == 6 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 360)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 2) 
				condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
			elseif level == 7 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 360)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 3)
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)				
			elseif level == 8 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 720)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 3)
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1) 
			    condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 500) 
                condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500) 
			    condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 5)			
				condition:setParameter(CONDITION_PARAM_INCREASE_HOLYPERCENT, 8)
			elseif level == 9 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 720)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 4)
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 400)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 800)	
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 8)			
				condition:setParameter(CONDITION_PARAM_INCREASE_HOLYPERCENT, 13)				
			elseif level == 10 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 920)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 5)
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 900)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 10)			
				condition:setParameter(CONDITION_PARAM_INCREASE_HOLYPERCENT, 16)			
			elseif level == 11 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 920)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 6)
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2) 	
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1300)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 15)			
				condition:setParameter(CONDITION_PARAM_INCREASE_HOLYPERCENT, 25)			
			elseif level == 12 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 920)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 1440)
                condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 8)
                condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3) 
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 800) --100 = 1%
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 900)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1600)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 25)
				condition:setParameter(CONDITION_PARAM_INCREASE_HOLYPERCENT, 30)				
            end
       
	   elseif vocation == "knight" then
            if level == 1 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 90)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 30)
            elseif level == 2 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 135)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 45)
			elseif level == 3 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 135)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 45)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 1)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 1)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 1)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 1)
			elseif level == 4 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 180)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 1)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 1)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 1)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 1)
			elseif level == 5 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 180)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 60)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 2)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 2)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 2)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 2)
			elseif level == 6 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 360)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 2)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 2)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 2)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 2)
			elseif level == 7 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 360)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 120)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 3)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 3)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 3)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 3)
			    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
			elseif level == 8 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 720)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 3)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 3)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 3)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 3)
			    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 600) 
                condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 300) 
			elseif level == 9 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 720)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 240)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 4)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 4)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 4)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 4)
			    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 800)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 300)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 400)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 800)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 5)
			elseif level == 10 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 1440)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 5)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 5)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 5)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 5)
			    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 1000)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 300)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 900)
				condition:setParameter(CONDITION_PARAM_INCREASE_FIREPERCENT, 8)
				condition:setParameter(CONDITION_PARAM_INCREASE_ENERGYPERCENT, 8)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 8)
				condition:setParameter(CONDITION_PARAM_INCREASE_ICEPERCENT, 8)
				condition:setParameter(CONDITION_PARAM_INCREASE_EARTHPERCENT, 8)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 12)
			
			elseif level == 11 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 1440)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 6)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 6)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 6)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 6)
			    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 1200)
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 400)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 600)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1300)
				condition:setParameter(CONDITION_PARAM_INCREASE_FIREPERCENT, 13)
				condition:setParameter(CONDITION_PARAM_INCREASE_ENERGYPERCENT, 13)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 13)
				condition:setParameter(CONDITION_PARAM_INCREASE_ICEPERCENT, 13)
				condition:setParameter(CONDITION_PARAM_INCREASE_EARTHPERCENT, 13)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 15)
			elseif level == 12 then
                condition:setParameter(CONDITION_PARAM_TICKS, -1)
                condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, 1440)
                condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, 480)
                condition:setParameter(CONDITION_PARAM_SKILL_SWORD, 8)
                condition:setParameter(CONDITION_PARAM_SKILL_CLUB, 8)
                condition:setParameter(CONDITION_PARAM_SKILL_AXE, 8)
                condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 8)
			    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2)
				condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, 1500) --100 = 1%
				condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 500)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 700)
				condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 1600)			
				condition:setParameter(CONDITION_PARAM_INCREASE_FIREPERCENT, 20)
				condition:setParameter(CONDITION_PARAM_INCREASE_ENERGYPERCENT, 20)
				condition:setParameter(CONDITION_PARAM_INCREASE_DEATHPERCENT, 20)
				condition:setParameter(CONDITION_PARAM_INCREASE_ICEPERCENT, 20)
				condition:setParameter(CONDITION_PARAM_INCREASE_EARTHPERCENT, 20)
				condition:setParameter(CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 25)
            end
        end
    end
end


    -- Obtener la identificación del jugador
    local playerId = player:getGuid()

    -- Obtener puntos del jugador desde la base de datos (asumo que tienes una columna llamada 'buffpoints')
    local playerPointsQuery = db.storeQuery('SELECT `buffpoints` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')
    local playerPoints = Result.getNumber(playerPointsQuery, "buffpoints")

    -- Obtener la vocación del jugador desde la base de datos (asumo que tienes una columna llamada 'vocation')
    local playerVocationQuery = db.storeQuery('SELECT `vocation` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')
    local playerVocation = Result.getNumber(playerVocationQuery, "vocation")

    -- Verificar el nivel actual del jugador
    local playerLevel = checkLevel(playerPoints)

    -- Obtener las condiciones actuales del jugador
    local oldConditions = {}
    for _, conditionTable in pairs(conditions) do
        for _, condition in pairs(conditionTable) do
            table.insert(oldConditions, condition)
        end
    end

    -- Limpiar las condiciones antiguas antes de aplicar las nuevas
    clearOldConditions(player, oldConditions)

    -- Verificar si el jugador tiene suficientes puntos y el nivel requerido para las bonificaciones
    if playerLevel > 0 then
        print("Player Level:", playerLevel) 
        -- Aplicar la bonificación correspondiente para la vocación del jugador
        local function aplicarBonusAlJugador(condition, message)
            player:addCondition(condition)
            player:getPosition():sendMagicEffect(math.random(CONST_ME_FIREWORK_YELLOW, CONST_ME_FIREWORK_BLUE))
            player:say(message, TALKTYPE_MONSTER_SAY)
        end

    if playerVocation == 1 or playerVocation == 5 then -- sorcerer - master sorcerer
        if playerLevel == 1 and playerPoints >= levels[playerLevel].requiredPoints then
		--print("Applying Level 1 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[1], "Nivel 1 de Buff de Sorcerer. (+30 Health, +180 Mana)!")
        elseif playerLevel == 2 and playerPoints >= levels[2].requiredPoints then
		--print("Applying Level 2 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[2], "Nivel 2 de Buff de Sorcerer. (+45 Health, +270 Mana)!")
	    elseif playerLevel == 3 and playerPoints >= levels[3].requiredPoints then
		--print("Applying Level 3 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[3], "Nivel 3 de Buff de Sorcerer. (+45 Health, +270 Mana, +1 Magic Lvl)!")
	    elseif playerLevel == 4 and playerPoints >= levels[4].requiredPoints then
		--print("Applying Level 4 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[4], "Nivel 4 de Buff de Sorcerer. (+60 Health, +360 Mana, +1 Magic Lvl)!")
	    elseif playerLevel == 5 and playerPoints >= levels[5].requiredPoints then
		--print("Applying Level 5 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[5], "Nivel 5 de Buff de Sorcerer. (+60 Health, +360 Mana, +2 Magic Lvl)!")
	    elseif playerLevel == 6 and playerPoints >= levels[6].requiredPoints then
		--print("Applying Level 6 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[6], "Nivel 6 de Buff de Sorcerer. (+120 Health, +720 Mana, +2 Magic Lvl)!")
	    elseif playerLevel == 7 and playerPoints >= levels[7].requiredPoints then
		--print("Applying Level 7 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[7], "Nivel 7 de Buff de Sorcerer. (+120 Health, +720 Mana, +3 Magic Lvl)!")
	    elseif playerLevel == 8 and playerPoints >= levels[8].requiredPoints then
		--print("Applying Level 8 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[8], "Nivel 8 de Buff de Sorcerer. (+240 Health, +1440 Mana, +3 Magic Lvl, +5% Life Leech, +5% Mana Leech)!")
	    elseif playerLevel == 9 and playerPoints >= levels[9].requiredPoints then
		--print("Applying Level 9 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[9], "Nivel 9 de Buff de Sorcerer. (+240 Health, +1440 Mana, +4 Magic Lvl, +5% Life Leech, +5% Mana Leech, +4% Crit Chance, +8% Crit Damage)!")
	    elseif playerLevel == 10 and playerPoints >= levels[10].requiredPoints then
		--print("Applying Level 10 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[10], "Nivel 10 de Buff de Sorcerer. (+480 Health, +2880 Mana, +4 Magic Lvl, +6% Life Leech, +6% Mana Leech, +5% Crit Chance, +10% Crit Damage, +15% Fire, +10% Energy, +10% Death)!")
	    elseif playerLevel == 11 and playerPoints >= levels[11].requiredPoints then
		--print("Applying Level 11 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[11], "Nivel 11 de Buff de Sorcerer. (+480 Health, +2880 Mana, +5 Magic Lvl, +7% Life Leech, +7% Mana Leech, +6% Crit Chance, +13% Crit Damage, +20% Fire, +15% Energy, +15% Death)!")
	    elseif playerLevel == 12 and playerPoints >= levels[12].requiredPoints then
		--print("Applying Level 12 Bonus")
            aplicarBonusAlJugador(conditions.sorcerer[12], "Nivel 12 de Buff de Sorcerer. (+480 Health, +2880 Mana, +7 Magic Lvl, +8% Life Leech, +9% Mana Leech, +7% Crit Chance, +16% Crit Damage, +30% Fire, +25% Energy, +20% Death)!")
        end
        
        elseif playerVocation == 2 or playerVocation == 6 then -- druid - elder druid
            if playerLevel == 1 and playerPoints >= levels[1].requiredPoints then
			--print("Applying Level 1 Bonus")
                aplicarBonusAlJugador(conditions.druid[1], "Nivel 1 de Buff de Druid. (+30 Health, +180 Mana)!")
            elseif playerLevel == 2 and playerPoints >= levels[2].requiredPoints then
			--print("Applying Level 2 Bonus")
                aplicarBonusAlJugador(conditions.druid[2], "Nivel 2 de Buff de Druid. (+45 Health, +270 Mana)!")
		    elseif playerLevel == 3 and playerPoints >= levels[3].requiredPoints then
		    --print("Applying Level 3 Bonus")
                aplicarBonusAlJugador(conditions.druid[3], "Nivel 3 de Buff de Druid. (+45 Health, +270 Mana, +1 Magic Lvl)!")
		    elseif playerLevel == 4 and playerPoints >= levels[4].requiredPoints then
		    --print("Applying Level 4 Bonus")
                aplicarBonusAlJugador(conditions.druid[4], "Nivel 4 de Buff de Druid. (+60 Health, +360 Mana, +1 Magic Lvl)!")
		    elseif playerLevel == 5 and playerPoints >= levels[5].requiredPoints then
		    --print("Applying Level 5 Bonus")
                aplicarBonusAlJugador(conditions.druid[5], "Nivel 5 de Buff de Druid. (+60 Health, +360 Mana, +2 Magic Lvl)!")
		    elseif playerLevel == 6 and playerPoints >= levels[6].requiredPoints then
		    --print("Applying Level 6 Bonus")
                aplicarBonusAlJugador(conditions.druid[6], "Nivel 6 de Buff de Druid. (+120 Health, +720 Mana, +2 Magic Lvl)!")
		    elseif playerLevel == 7 and playerPoints >= levels[7].requiredPoints then
		    --print("Applying Level 7 Bonus")
                aplicarBonusAlJugador(conditions.druid[7], "Nivel 7 de Buff de Druid. (+120 Health, +720 Mana, +3 Magic Lvl)!")
		    elseif playerLevel == 8 and playerPoints >= levels[8].requiredPoints then
		    --print("Applying Level 8 Bonus")
               aplicarBonusAlJugador(conditions.druid[8], "Nivel 8 de Buff de Druid. (+240 Health, +1440 Mana, +3 Magic Lvl, +5% Life Leech, +5% Mana Leech)!")
		    elseif playerLevel == 9 and playerPoints >= levels[9].requiredPoints then
		    --print("Applying Level 9 Bonus")
               aplicarBonusAlJugador(conditions.druid[9], "Nivel 9 de Buff de Druid. (+240 Health, +1440 Mana, +4 Magic Lvl, +5% Life Leech, +5% Mana Leech, +4% Crit Chance, +8% Crit Damage)!")
		    elseif playerLevel == 10 and playerPoints >= levels[10].requiredPoints then
		    --print("Applying Level 10 Bonus")
               aplicarBonusAlJugador(conditions.druid[10], "Nivel 10 de Buff de Druid. (+480 Health, +2880 Mana, +4 Magic Lvl, +6% Life Leech, +6% Mana Leech, +5% Crit Chance, +10% Crit Damage, +15% Earth, +10% Ice, +10 Death)!")
		    elseif playerLevel == 11 and playerPoints >= levels[11].requiredPoints then
		    --print("Applying Level 11 Bonus")
               aplicarBonusAlJugador(conditions.druid[11], "Nivel 11 de Buff de Druid. (+480 Health, +2880 Mana, +5 Magic Lvl, +7% Life Leech, +7% Mana Leech, +6% Crit Chance, +13% Crit Damage, +20% Earth, +15% Ice, +15 Death)!")
		    elseif playerLevel == 12 and playerPoints >= levels[12].requiredPoints then
		    --print("Applying Level 12 Bonus")
               aplicarBonusAlJugador(conditions.druid[12], "Nivel 12 de Buff de Druid. (+480 Health, +2880 Mana, +7 Magic Lvl, +8% Life Leech, +9% Mana Leech, +7% Crit Chance, +16% Crit Damage, +30% Earth, +25% Ice, +20 Death)!")
            end
        
		elseif playerVocation == 3 or playerVocation == 7 then -- paladin - royal paladin
            if playerLevel == 1 and playerPoints >= levels[1].requiredPoints then
			--print("Applying Level 1 Bonus")
                aplicarBonusAlJugador(conditions.paladin[1], "Nivel 1 de Buff de Paladin. (+60 Health, +90 Mana)!")
            elseif playerLevel == 2 and playerPoints >= levels[2].requiredPoints then
			--print("Applying Level 2 Bonus")
                aplicarBonusAlJugador(conditions.paladin[2], "Nivel 2 de Buff de Paladin. (+90 Health, +135 Mana)!")
			 elseif playerLevel == 3 and playerPoints >= levels[3].requiredPoints then
			--print("Applying Level 3 Bonus")
                aplicarBonusAlJugador(conditions.paladin[3], "Nivel 3 de Buff de Paladin. (+90 Health, +135 Mana, +1 Distance)!")
			 elseif playerLevel == 4 and playerPoints >= levels[4].requiredPoints then
			--print("Applying Level 4 Bonus")
                aplicarBonusAlJugador(conditions.paladin[4], "Nivel 4 de Buff de Paladin. (+120 Health, +180 Mana, +1 Distance)!")
			 elseif playerLevel == 5 and playerPoints >= levels[5].requiredPoints then
			--print("Applying Level 5 Bonus")
                aplicarBonusAlJugador(conditions.paladin[5], "Nivel 5 de Buff de Paladin. (+120 Health, +180 Mana, +2 Distance, +1 Magic Lvl)!")
			 elseif playerLevel == 6 and playerPoints >= levels[6].requiredPoints then
			--print("Applying Level 6 Bonus")
                aplicarBonusAlJugador(conditions.paladin[6], "Nivel 6 de Buff de Paladin. (+240 Health, +360 Mana, +2 Distance, +1 Magic Lvl)!")
			 elseif playerLevel == 7 and playerPoints >= levels[7].requiredPoints then
			--print("Applying Level 7 Bonus")
                aplicarBonusAlJugador(conditions.paladin[7], "Nivel 7 de Buff de Paladin. (+240 Health, +360 Mana, +3 Distance, +1 Magic Lvl)!")
			 elseif playerLevel == 8 and playerPoints >= levels[8].requiredPoints then
			--print("Applying Level 8 Bonus")
                aplicarBonusAlJugador(conditions.paladin[8], "Nivel 8 de Buff de Paladin. (+480 Health, +720 Mana, +3 Distance, +1 Magic Lvl, +5% Life Leech, +5% Mana Leech)!")
			 elseif playerLevel == 9 and playerPoints >= levels[9].requiredPoints then
			--print("Applying Level 9 Bonus")
                aplicarBonusAlJugador(conditions.paladin[9], "Nivel 9 de Buff de Paladin. (+480 Health, +720 Mana, +4 Distance, +2 Magic Lvl, +5% Life Leech, +5% Mana Leech, +4% Crit Chance, +8% Crit Dmg)!")
			 elseif playerLevel == 10 and playerPoints >= levels[10].requiredPoints then
			--print("Applying Level 10 Bonus")
                aplicarBonusAlJugador(conditions.paladin[10], "Nivel 10 de Buff de Paladin. (+920 Health, +1440 Mana, +5 Distance, +2 Magic Lvl, +6% Life Leech, +6% Mana Leech, +5% Crit Chance, +9% Crit Dmg, +5% Physical, +10% Holy)!")
			 elseif playerLevel == 11 and playerPoints >= levels[11].requiredPoints then
			--print("Applying Level 11 Bonus")
                aplicarBonusAlJugador(conditions.paladin[11], "Nivel 11 de Buff de Paladin. (+920 Health, +1440 Mana, +6 Distance, +2 Magic Lvl, +7% Life Leech, +7% Mana Leech, +6% Crit Chance, +13% Crit Dmg, +5% Physical, +15% Holy)!")
			 elseif playerLevel == 12 and playerPoints >= levels[12].requiredPoints then
			--print("Applying Level 12 Bonus")
                aplicarBonusAlJugador(conditions.paladin[12], "Nivel 12 de Buff de Paladin. (+920 Health, +1440 Mana, +8 Distance, +3 Magic Lvl, +8% Life Leech, +9% Mana Leech, +7% Crit Chance, +16% Crit Dmg, +10% Physical, +20% Holy)!")
			end
          

		  elseif playerVocation == 4 or playerVocation == 8 then -- knight - elite knight
            if playerLevel == 1 and playerPoints >= levels[1].requiredPoints then
			--print("Applying Level 1 Bonus")
                aplicarBonusAlJugador(conditions.knight[1], "Nivel 1 de Buff de Knight. (+90 Health, +30 Mana)!")
            elseif playerLevel == 2 and playerPoints >= levels[2].requiredPoints then
			--print("Applying Level 2 Bonus")
                aplicarBonusAlJugador(conditions.knight[2], "Nivel 2 de Buff de Knight. (+135 Health, +45 Mana)!")
		    elseif playerLevel == 3 and playerPoints >= levels[3].requiredPoints then
			--print("Applying Level 3 Bonus")
                aplicarBonusAlJugador(conditions.knight[3], "Nivel 3 de Buff de Knight. (+135 Health, +45 Mana, +1 Sword, +1 Axe, +1 Club, +1 Shield)!")
		    elseif playerLevel == 4 and playerPoints >= levels[4].requiredPoints then
			--print("Applying Level 4 Bonus")
                aplicarBonusAlJugador(conditions.knight[4], "Nivel 4 de Buff de Knight. (+180 Health, +60 Mana, +1 Sword, +1 Axe, +1 Club, +1 Shield)!")
		    elseif playerLevel == 5 and playerPoints >= levels[5].requiredPoints then
			--print("Applying Level 5 Bonus")
                aplicarBonusAlJugador(conditions.knight[5], "Nivel 5 de Buff de Knight. (+180 Health, +60 Mana, +2 Sword, +2 Axe, +2 Club, +2 Shield)!")
		    elseif playerLevel == 6 and playerPoints >= levels[6].requiredPoints then
			--print("Applying Level 6 Bonus")
                aplicarBonusAlJugador(conditions.knight[6], "Nivel 6 de Buff de Knight. (+360 Health, +120 Mana, +2 Sword, +2 Axe, +2 Club, +2 Shield)!")
		    elseif playerLevel == 7 and playerPoints >= levels[7].requiredPoints then
			--print("Applying Level 7 Bonus")
                aplicarBonusAlJugador(conditions.knight[7], "Nivel 7 de Buff de Knight. (+360 Health, +120 Mana, +3 Sword, +3 Axe, +3 Club, +3 Shield, +1 Magic Lvl)!")
		    elseif playerLevel == 8 and playerPoints >= levels[8].requiredPoints then
			--print("Applying Level 8 Bonus")
                aplicarBonusAlJugador(conditions.knight[8], "Nivel 8 de Buff de Knight. (+720 Health, +240 Mana, +3 Sword, +3 Axe, +3 Club, +3 Shield, +1 Magic Lvl, +6% Life Leech, +3% Mana Leech)!")
		    elseif playerLevel == 9 and playerPoints >= levels[9].requiredPoints then
			--print("Applying Level 9 Bonus")
                aplicarBonusAlJugador(conditions.knight[9], "Nivel 9 de Buff de Knight. (+720 Health, +240 Mana, +4 Sword, +4 Axe, +4 Club, +4 Shield, +1 Magic Lvl, +8% Life Leech, +3% Mana Leech, +4% Crit Chance, +8% Crit Damage, +5% Physical)!")
		    elseif playerLevel == 10 and playerPoints >= levels[10].requiredPoints then
			--print("Applying Level 10 Bonus")
                aplicarBonusAlJugador(conditions.knight[10], "Nivel 10 de Buff de Knight. (+1440 Health, +480 Mana, +5 Sword, +5 Axe, +5 Club, +5 Shield, +1 Magic Lvl, +10% Life Leech, +3% Mana Leech, +5% Crit Chance, +9% Crit Damage, +12% Physical, +8% Elemental)!")
		    elseif playerLevel == 11 and playerPoints >= levels[11].requiredPoints then
			--print("Applying Level 11 Bonus")
                aplicarBonusAlJugador(conditions.knight[11], "Nivel 11 de Buff de Knight. (+1440 Health, +480 Mana, +6 Sword, +6 Axe, +6 Club, +6 Shield, +1 Magic Lvl, +12% Life Leech, +4% Mana Leech, +6% Crit Chance, +13% Crit Damage, +15% Physical, +13% Elemental)!")
		    elseif playerLevel == 12 and playerPoints >= levels[12].requiredPoints then
			--print("Applying Level 12 Bonus")
                aplicarBonusAlJugador(conditions.knight[12], "Nivel 12 de Buff de Knight. (+1440 Health, +480 Mana, +8 Sword, +8 Axe, +8 Club, +8 Shield, +2 Magic Lvl, +15% Life Leech, +5% Mana Leech, +7% Crit Chance, +16% Crit Damage, +25% Physical, +20% Elemental)!")
            end
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No tienes suficientes puntos para ningun Nivel de Buff. Completa Addons para obtener Buffs.")
    end

    return true
end

addonBonus:register()