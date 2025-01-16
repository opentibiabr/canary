local config = {
	interval = 100 * 10000, -- 100 seconds
	text = "[Top Level]",
	effect = CONST_ME_TUTORIALSQUARE,
}

local event = GlobalEvent("TopLevelEffect")

function event.onThink(interval)
	local resultId = db.storeQuery("SELECT `name` FROM `players` WHERE `group_id` < 2 ORDER BY `level` DESC LIMIT 1;")
	if not resultId then
		return true
	end

	local player = Player(Result.getString(resultId, "name"))
	if player then
		local position = player:getPosition()
		position:sendMagicEffect(config.effect)
		player:say(config.text, TALKTYPE_MONSTER_SAY, false, nil, position)
	end

	Result.free(resultId)
	return true
end

event:interval(config.interval)
event:register()
