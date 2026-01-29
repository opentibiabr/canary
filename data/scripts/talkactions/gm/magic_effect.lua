local magicEffect = TalkAction("/effect")

function magicEffect.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	

	local effect = tonumber(split[1])
	if effect ~= nil and effect > 0 then
		player:getPosition():sendMagicEffect(effect, nil, tonumber(split[2]))
	end

	return true
end

magicEffect:separator(" ")
magicEffect:groupType("gamemaster")
magicEffect:register()
