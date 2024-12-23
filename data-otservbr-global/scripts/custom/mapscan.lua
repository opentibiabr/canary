local minimap = TalkAction("/minimap")

function minimapStart(player, minX, maxX, minY, maxY, x, y, z)
		player:sendCancelMessage("Scan started: " .. os.time())
		--print("Minimap scan start", player:getName(), minX, maxX, minY, maxY, x, y, z)
		minimapScan(player:getId(), minX, maxX, minY, maxY, minX - 5, minY, z)
end

function minimapScan(cid, minX, maxX, minY, maxY, x, y, z, lastProgress)
   local player = Player(cid)

   if not player then
      --print("Minimap scan stopped - player logged out", cid, minX, maxX, minY, maxY, x, y, z)
      return
   end

   local scanStartTime = os.time()
   local teleportsDone = 0
   while true do
      if scanStartTime + maxEventExecutionTime < os.time() then
         lastProgress = sendScanProgress(player, minX, maxX, minY, maxY, x, y, z, lastProgress)
         addEvent(minimapScan, addEventDelay, cid, minX, maxX, minY, maxY, x, y, z, lastProgress)
         break
      end

      x = x + distanceBetweenPositionsX
      if x > maxX then
         x = minX
         y = y + distanceBetweenPositionsY
         if y > maxY then
            player:sendCancelMessage("Scan finished: " .. os.time())
            --print("Minimap scan complete", player:getName(), minX, maxX, minY, maxY, x, y, z)
            break
         end
      end

      if teleportToClosestPosition(player, x, y, z) then
         teleportsDone = teleportsDone + 1
         lastProgress = sendScanProgress(player, minX, maxX, minY, maxY, x, y, z, lastProgress)

         --print("Minimap scan teleport", player:getName(), minX, maxX, minY, maxY, x, y, z, progress, teleportsDone)
         if teleportsDone == teleportsPerEvent then
            addEvent(minimapScan, addEventDelay, cid, minX, maxX, minY, maxY, x, y, z, progress)
            break
         end
      end
   end
end

function teleportToClosestPosition(player, x, y, z)
   -- direct to position
   local tile = Tile(x, y, z)

   if not tile or not tile:getGround() or tile:hasFlag(TILESTATE_TELEPORT) or not player:teleportTo(tile:getPosition()) then
      for distance = 1, 3 do
         -- try to find some close tile
         for changeX = -distance, distance, distance do
            for changeY = -distance, distance, distance do
               tile = Tile(x + changeX, y + changeY, z)
               if tile and tile:getGround() and not tile:hasFlag(TILESTATE_TELEPORT) and player:teleportTo(tile:getPosition()) then
                  return true
               end
            end
         end
      end

      return false
   end

   return true
end

function sendScanProgress(player, minX, maxX, minY, maxY, x, y, z, lastProgress)
   local progress = math.floor(((y - minY + (((x - minX) / (maxX - minX)) * distanceBetweenPositionsY)) / (maxY - minY)) * 100)
   if progress ~= lastProgress then
      player:sendCancelMessage("Scan progress: ~" .. progress .. "%")
   end

   return progress
end

function minimap.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	distanceBetweenPositionsX = 8
	distanceBetweenPositionsY = 8
	addEventDelay = 100
	teleportsPerEvent = 3
	maxEventExecutionTime = 1000

	local splited = param:split(",")
	
	if #splited ~= 5 then
      player:sendCancelMessage("Command requires 5 parameters: /minimap minX, maxX, minY, maxY, z")
      return false
   end

	   for key, position in pairs(splited) do
		  local value = tonumber(position)

		  if not value then
			 player:sendCancelMessage("Invalid parameter " .. key .. ": " .. position)
			 return false
		  end

		  splited[key] = value
	   end
	   
	minimapStart(player, splited[1], splited[2], splited[3], splited[4], splited[1] - distanceBetweenPositionsX, splited[3], splited[5])
	return false
end

minimap:groupType("god")
minimap:separator(" ")
minimap:register()
