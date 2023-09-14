

local config = {
max = 5, -- pra 3 tem que colocar 4
text = "Sao permitidos apenas 4 MultiClients!",
group_id = 1 -- only kick player with group id 1 (normal players)
}

local accepted_ip_list = ""

function getPlayersByIp(ip)	
	local result = {}
	local players, player = Game.getPlayers()
	for i = 1, #players do -- retorna players online
		player = players[i] -- comeca tratar playes 1 por 1 [i]
		
		if player:getIp() == ip then
			result[#result + 1] = player
		end
	end
	return result
end

local antimclogin = CreatureEvent("antimcLogin")
function antimclogin.onLogin(player)
	if getPlayerGroupId(player) == config.group_id then		
		if #getPlayersByIp(player:getIp()) > config.max then
		doPlayerPopupFYI(player, config.text)
				 addEvent(function()
					if player then
						player:remove()
					end
				end,3000)
			return true
		end
	end
	return true
end
antimclogin:register()


-- function getPlayersByIPAddress(ip)
	
	-- local masked = bit.band(ip)
	-- local result = {}
	-- for _, player in ipairs(Game.getPlayers()) do
		-- if player:getIp()) == masked then
			-- result[#result + 1] = player:getId()
		-- end
	-- end
	-- return result
-- end