local checkInbox = GlobalEvent("checkinbox")
function checkInbox.onThink(interval, lastExecution)
	local records = db.storeQuery('SELECT `player_id`, COUNT(`player_id`) FROM `player_inboxitems` GROUP BY `player_id` HAVING COUNT(`player_id`) > 10000')
	if records ~= false then
		local count = 0
		repeat
			local player_id = result.getNumber(records, 'player_id')
			db.asyncQuery('DELETE FROM `player_inboxitems` WHERE `player_id` = ' .. player_id)
			db.asyncQuery('DELETE FROM `player` WHERE `id` = ' .. player_id)
		until not result.next(records)
		result.free(records)
	end
	return true
end

checkInbox:interval(30000)
checkInbox:register()
