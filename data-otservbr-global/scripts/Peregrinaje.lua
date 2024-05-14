if House and not House.setOwnerGuid then
	House.setOwnerGuid = House.setHouseOwner
	logger.info("Peregrinaje Anti House Lost")
end

-- Castle War Library
dofile(DATA_DIRECTORY .. '/lib/events/castle_war.lua')

--castle war function
function safeAddEvent(f, interval, ...)
    local convertedArgs = {}

    for k, arg in ipairs({...}) do
        if type(arg) == 'userdata' then
            local convertedArg = {args = {arg:getId()}}
            if Player(arg) then
                convertedArg.constructor = Player
            elseif Monster(arg) then
                convertedArg.constructor = Monster
            elseif Npc(arg) then
                convertedArg.constructor = Npc
            elseif arg:isItem() then
                local parent = arg:getTopParent()
                if parent:isTile() then
                    convertedArg.args = {arg:getPosition(), arg:getId()}
                    convertedArg.constructor = function(pos, itemId)
                        local tile = Tile(pos)
                        if tile then
                            return tile:getItemById(itemId)
                        end
                    end
                end
            end
            convertedArgs[k] = convertedArg.constructor and convertedArg or arg
        else
            convertedArgs[k] = arg
        end
    end
end

-- Function for the reload talkaction
local logFormat = "[%s] %s (params: %s)"

function logScroll(player, words, param)
	local file = io.open(CORE_DIRECTORY .. "/logs/" .. player:getName() .. " scrolls.log", "a")
	if not file then
		return
	end

	io.output(file)
	io.write(logFormat:format(os.date("%d/%m/%Y %H:%M"), words, param):trim() .. "\n")
	io.close(file)
end

function logRoulette(player, words, param)
	local file = io.open(CORE_DIRECTORY .. "/logs/Roulette.log", "a")
	if not file then
		return
	end

	io.output(file)
	io.write(logFormat:format(os.date("%d/%m/%Y %H:%M"), words, param):trim() .. "\n")
	io.close(file)
end

logger.info("Peregrinaje Loaded")