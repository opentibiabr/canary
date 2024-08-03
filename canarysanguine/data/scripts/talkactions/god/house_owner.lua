local houseOwner = TalkAction("/owner")

function houseOwner.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local tile = Tile(player:getPosition())
	local house = tile and tile:getHouse()
	if not house then
		player:sendCancelMessage("You are not inside a house.")
		return true
	end

	if param == "" or param == "none" then
		house:setHouseOwner(0)
		return true
	end

	local targetPlayer = Player(param)
	if not targetPlayer then
		player:sendCancelMessage("Player not found.")
		return true
	end

	house:setHouseOwner(targetPlayer:getGuid())
	return true
end

houseOwner:separator(" ")
houseOwner:groupType("god")
houseOwner:register()
