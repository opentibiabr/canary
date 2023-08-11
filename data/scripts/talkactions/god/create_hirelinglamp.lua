local talk = TalkAction("/hireling")

function talk.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local split = param:split(",")
	local name = split[1] ~= "" and split[1] or "Hireling " .. player:getName()
	local sex = split[2] and tonumber(split[2]) or 1

	local result = player:addNewHireling(name, sex)
	if result then
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return true
end

talk:separator(" ")
talk:groupType("god")
talk:register()
