function removefrags(player)
       playerid = player:getGuid()
    player:remove()
    db.query('UPDATE `player_kills` SET `time` = 1 WHERE `player_id` = '..playerid..'')
    return true
end 