-- [OtServerBr]
-- Event scheduler lua scripts, on this file is possible to load any kind
-- of global values, create functions or create and register GlobalEvents using the revscript system.
-- For example you can load a 'local Example = GlobalEvent("example")' and register it with 'Example:register()',
-- adding the 'Example.onStartup()' or 'Example.onThink(interval)' with 'Example:interval(time)'.
-- With 'onStartup()' you can load any raid, for example loading a entire map/hunt and the choseen spawns.

-- Examples:
-- Loading map: Game.loadMap(DATA_DIRECTORY.. '/world/myMapFolder/myMapFile.otbm')
-- Loading spawn: addEvent(function() Game.loadSpawnFile(DATA_DIRECTORY.. '/world/mySpawnFolder/mySpawnFile.xml) end, 30 * 1000)

local Doble_Exp = GlobalEvent("Doble Exp")
function Doble_Exp.onStartup()
	return true
end

Doble_Exp:register()

local Doble_Loot = GlobalEvent("Doble Loot")
function Doble_Loot.onStartup()
	return true
end
--  10 seconds interval
Doble_Loot:register()


