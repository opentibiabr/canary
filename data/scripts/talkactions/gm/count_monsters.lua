local xml_monster_dir = DATA_DIRECTORY .. "/world/otservbr-monster.xml"
local new_file_name = "monster_count.txt"

local count_monsters = TalkAction("/countmonsters")

function count_monsters.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local open_file = io.open(xml_monster_dir, "r")
	local writing_file = io.open(new_file_name, "w+")
	local file_read = open_file:read("*all")

	open_file:close()

	local monsters = {}

	for str_match in file_read:gmatch('<monster name="(.-)"') do
		local ret_table = monsters[str_match]
		if ret_table then
			monsters[str_match] = ret_table + 1
		else
			monsters[str_match] = 1
		end
	end

	writing_file:write("--- Total of monsters on server ---\n")

	for monster, count in pairsByKeys(monsters) do
		writing_file:write(monster .. " - " .. count .. "\n")
	end

	writing_file:close()

	return true
end

count_monsters:separator(" ")
count_monsters:groupType("gamemaster")
count_monsters:register()
