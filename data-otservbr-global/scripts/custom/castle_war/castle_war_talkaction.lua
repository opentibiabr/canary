local TELEPORT_POSITION = Position(32360, 32239, 7) -- CastleWar
local TELEPORT_ACTIONID = 38135
local TELEPORT_ITEMID = 1949

local function removeTeleport()
local teleport = Tile(TELEPORT_POSITION):getItemById(TELEPORT_ITEMID)
	if teleport then
		teleport:remove()
	else
		error("There is no teleport.")
	end	
end

local castlewar = TalkAction("/opencastle")
function castlewar.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	local teleport = Game.createItem(TELEPORT_ITEMID, 1, TELEPORT_POSITION)	
	if teleport then
		teleport:setActionId(TELEPORT_ACTIONID)
		local message = "[Castle War] The castle has been opened and will close in 60 minutes."
		Game.broadcastMessage(string.format(message, MESSAGE_GAME_HIGHLIGHT))
	else
		error("Error to create the Castle teleport.")
	end
	addEvent(removeTeleport, 60 * 60 * 1000)
	Castle:load()
	
	return false
end
castlewar:separator(" ")
castlewar:groupType("god")
castlewar:register()