local testLook = TalkAction("/testlook")

function testLook.onSay(player, words, param)
	-- Log seguro (opcional, mas recomendado para GOD)
	if logCommand then
		logCommand(player, words, param)
	end

	local lookType = tonumber(param)
	if not lookType or lookType <= 0 then
		player:sendCancelMessage("Usage: /testlook <LookType ID>")
		return true
	end

	-- Aplica o outfit mantendo addons/colors atuais
	local outfit = player:getOutfit()
	outfit.lookType = lookType
	player:setOutfit(outfit)

	return true
end

testLook:separator(" ")
testLook:groupType("god")
testLook:register()
