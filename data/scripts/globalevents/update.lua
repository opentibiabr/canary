local fileToUpdate = "data/update.lua"
dofile(fileToUpdate)

local update = GlobalEvent("Update")
function update.onStartup()
	if updated then
		db.query("UPDATE `players` SET `posx` = 0, `posy` = 0, `posz` = 0;")
		local readFile = io.open(fileToUpdate,'r')
		if readFile then
			io.input(readFile)
			local str = io.read()
			io.close(readFile)
			local ae = string.match(str,"updated = true")
			if ae then
				afterUpdate = 'updated = false'
				local updateFile=io.open(fileToUpdate, "w")
				io.output(updateFile)
				io.write(afterUpdate)
				io.close(updateFile)
				Spdlog.warn("All players sent to temple. Check if 'data/update.lua' contains 'updated = false'.")
			end
		end
	end
	return true
end
update:register()
