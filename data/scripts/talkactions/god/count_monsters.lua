local xml_monster_dir = 'data/world/otservbr-spawn.xml' -- Diretório do arquivo onde contém os monstros.
local new_file_name = 'monster_count.txt'

local count_monsters = TalkAction("/countmonsters")

function count_monsters.onSay(player, words, param)

    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

	logCommand(player, words, param)

	local open_file = io.open(xml_monster_dir, "r")
	local writing_file = io.open(new_file_name, "w+")
	local file_read = open_file:read("*all")

	open_file:close()

	local monsters = {}

	for str_match in file_read:gmatch('<monster name="(.-)"') do
	local ret_table = monsters[str_match]
		if ret_table then
			monsters[str_match] = ret_table+1
		else
			monsters[str_match] = 1
		end
	end

	writing_file:write('--- Total de Monstros no Servidor ---\n')

	for monster, count in pairsByKeys(monsters) do
		--print(monster, count)
		writing_file:write(monster..' - '..count..'\n')
	end

	writing_file:close()

return false
end

count_monsters:separator(" ")
count_monsters:register()