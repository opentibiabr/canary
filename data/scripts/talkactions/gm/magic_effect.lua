local magicEffect = TalkAction("/effect")

function magicEffect.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local effect = tonumber(param)
	if effect ~= nil and effect > 0 then
		player:getPosition():sendMagicEffect(effect)
	end

	return true
end

magicEffect:separator(" ")
magicEffect:groupType("gamemaster")
magicEffect:register()
