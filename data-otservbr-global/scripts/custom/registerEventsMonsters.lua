--[[
  _             _____ _  __
 | |    ___  __|_   _| |/ /
 | |   / _ \/ _ \| | | ' / 
 | |__|  __/ (_) | | | . \ 
 |_____\___|\___/|_| |_|\_\
                           
TKDev Community: https://discord.gg/phJZeHa2k4
]]

local registerEvents = {
    "taskSystem",
    "custom_exp_damage_effect",
    "monsterHuntKill",
}
local leotk_onDeath_Startup = GlobalEvent("LeoTK-OnDeath-StartUp")
function leotk_onDeath_Startup.onStartup()
    local blockedNames = { "..." }
    local function leotk_findMonstersInDir(dir)
      local monsters = {}
      local command
      if package.config:sub(1, 1) == "\\" then  -- Windows
          command = 'dir "' .. dir .. '" /b /s'
      else  -- Linux or other Unix-like systems
          command = 'find "' .. dir .. '" -type f'
      end
  
      local p = io.popen(command)
      if not p then
          logger.error("[LeoTK OnDeath Register] Error opening directory: " .. dir)
          return monsters
      end
      
      for file in p:lines() do
          if file:match("%.lua$") then
              local fileHandle = io.open(file, "r")
              if fileHandle then
                  local content = fileHandle:read("*all")
                  fileHandle:close()
                  local monsterName = content:match('Game%.createMonsterType%("%s*(.-)%s*"%)')
                  if monsterName then
                      table.insert(monsters, monsterName)
                  end
              else
                  logger.error("[LeoTK OnDeath Register] Error opening file: " .. file)
              end
          end
      end
      p:close()
      return monsters
  end
    local function getCurrentDir()
        local isWindows = package.config:sub(1,1) == "\\"
        local command = isWindows and "cd" or "pwd"
        local currentDir = io.popen(command):read("*l")
        
        if not currentDir then
            logger.error("[LeoTK OnDeath Register] Could not retrieve current directory.")
            return nil
        end
        return currentDir
    end

    local function leotk_loadMonsterList(dataPack)
      local monsters = {}
      local currentDir = getCurrentDir()
      if not currentDir then
          return monsters
      end
        --logger.info("[Guild Level] Starting search from current directory: " .. currentDir)

        local dataDir
        if dataPack == "data-canary" then
            dataDir = currentDir .. (isWindows and "\\data-canary" or "/data-canary")
        elseif dataPack == "data-otservbr-global" then
            dataDir = currentDir .. (isWindows and "\\data-otservbr-global" or "/data-otservbr-global")
        else
            logger.error("[LeoTK OnDeath Register] Invalid data pack selected.")
            return monsters
        end

        local foundMonsters = leotk_findMonstersInDir(dataDir)
        for _, monster in ipairs(foundMonsters) do
            table.insert(monsters, monster)
        end
        logger.info("[LeoTK OnDeath Register] Monsters Valid: " .. #monsters)
        return monsters
    end

    local selectedDataPack = configManager.getString(configKeys.DATA_DIRECTORY)
    local monsters = leotk_loadMonsterList(selectedDataPack)
    if #monsters > 0 then
        --logger.info("[LeoTK OnDeath Register] Monsters = {" .. table.concat(monsters, ", ") .. "}")
    else
        logger.error("[LeoTK OnDeath Register] No monsters found.")
    end

    for _, monster in ipairs(monsters) do
        if table.contains(blockedNames, monster) then
            --logger.info("[LeoTK OnDeath Register] Monster name {} is blocked.", monster)
        else
            local mType = MonsterType(monster)
            if not mType then
                logger.error("[LeoTK OnDeath Register] monster with name {} is not a valid MonsterType", monster)
            else
                --logger.info("[LeoTK OnDeath Register] Register Apply onDeath in :".. monster)
                --logger.info("[LeoTK OnDeath Register] Events: " .. table.concat(registerEvents, ", "))
                for _, eventName in ipairs(registerEvents) do
                    if mType:isRewardBoss() then
                    else
                        mType:registerEvent(eventName)
                    end    
                end
            end
        end
    end
end

leotk_onDeath_Startup:register()