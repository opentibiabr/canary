local addAchievement = TalkAction("/addachievement")

function addAchievement.onSay(player, words, param)
	logCommand(player, words, param)
	local params = param:split(",")
	if #params < 2 then
		player:sendCancelMessage("Usage: /addachievement playerName, achievementId|Name")
		return true
	end

	local targetPlayerName, achievementIdentifier = params[1], params[2]
	local targetPlayer = Player(targetPlayerName)
	if not targetPlayer then
		player:sendCancelMessage("Player " .. targetPlayerName .. " is not online.")
		return true
	end

	local achievementId = tonumber(achievementIdentifier)
	local achievementName = tostring(achievementIdentifier):lower():trimSpace():titleCase()
	local achievementInfo = achievementId and Game.getAchievementInfoById(achievementId) or Game.getAchievementInfoByName(achievementName)
	if achievementInfo.id == 0 or achievementInfo.name == nil then
		player:sendCancelMessage("Invalid achievement. Use valid ID or name.")
		return true
	end

	targetPlayer:addAchievement(achievementInfo.id, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Achievement " .. achievementInfo.name .. " added successfully to " .. targetPlayerName .. ".")
	return true
end

addAchievement:separator(" ")
addAchievement:groupType("god")
addAchievement:register()

local removeAchievement = TalkAction("/removeachievement")

function removeAchievement.onSay(player, words, param)
	logCommand(player, words, param)
	local params = param:split(",")
	if #params < 2 then
		player:sendCancelMessage("Usage: /removeachievement playerName, achievementId")
		return true
	end

	local targetPlayerName, achievementIdentifier = params[1], params[2]
	local targetPlayer = Player(targetPlayerName)
	if not targetPlayer then
		player:sendCancelMessage("Player " .. targetPlayerName .. " is not online.")
		return true
	end

	local achievementId = tonumber(achievementIdentifier)
	local achievementName = tostring(achievementIdentifier):lower():trimSpace():titleCase()
	local achievementInfo = achievementId and Game.getAchievementInfoById(achievementId) or Game.getAchievementInfoByName(achievementName)
	if not achievementInfo then
		player:sendCancelMessage("Invalid achievement identifier. Use either ID or name.")
		return true
	end

	targetPlayer:removeAchievement(achievementInfo.id)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Achievement " .. achievementInfo.name .. " removed successfully.")
	return true
end

removeAchievement:separator(" ")
removeAchievement:groupType("god")
removeAchievement:register()

local checkAchievements = TalkAction("/checkachievements")

function checkAchievements.onSay(player, words, param)
	logCommand(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: /checkachievements playerName")
		return true
	end

	local targetPlayer = Player(param)
	if not targetPlayer then
		player:sendCancelMessage("Player " .. param .. " is not online.")
		return true
	end

	local ACHIEVEMENTS = targetPlayer:getAchievements()
	local message = "Achievements: "
	for _, achievementId in pairs(ACHIEVEMENTS) do
		local achievementInfo = Game.getAchievementInfoById(achievementId)
		message = message .. achievementInfo.name .. ", "
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	return true
end

checkAchievements:separator(" ")
checkAchievements:groupType("god")
checkAchievements:register()
