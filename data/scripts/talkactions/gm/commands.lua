local gmAndGodCommands = TalkAction("/commands")

function gmAndGodCommands.onSay(player, words, param)
	local accountType = player:getAccountType()

	-- Commands
	local charmsCommands = '\n\nCharms Functions: \n\n'
		.. '/addcharms playerName, amount \n'
		.. '/resetcharms playerName, amount \n'
		.. '/charmexpansion playerName \n'
		.. '/charmrunes playerName \n'
		.. '/setbestiary playerName, monsterName, amount \n'

	local forgeCommands = '\n\nDusts Functions: \n\n'
		.. '/adddusts playerName, dustAmount[0-100] \n'
		.. '/removedusts playerName, dustAmount[0-100] \n'
		.. '/getdusts playerName \n'
		.. '/setdusts playerName, dustAmount[0-100] \n'
		.. '/fiendish (goto fiendish monster) \n'
		.. '/influenced (goto influenced monster) \n'
		.. '/openforge \n'

	local managerTutorCommands = '\n\nManager Tutor Functions: \n\n'
		.. '/addtutor playerName \n'
		.. '/removetutor playerName \n'

	local storageCommands = '\n\nStorage Functions: \n\n'
		.. '/addstorage key, value, playerName \n'
		.. '/getstorage playerName, key \n'
		.. '/setstorage playerName, key, newValue \n'

	local vipCommands = '\n\nVIP Functions: \n\n'
		.. '/vip [adddays, removedays], playerName, amount \n'
		.. '/vip check, playerName \n'
		.. '/vip addinfinite, playerName \n'
		.. '/vip remove, playerName \n'

	local text = 'Available commands: \n\n'

	if accountType == ACCOUNT_TYPE_GAMEMASTER then
		text = text .. '/ban playerName \n'
			.. '/ban playerName \n'
			.. '/bless playerName \n'
			.. '/b text \n'
			.. charmsCommands
			.. '/clean \n'
			.. '/down \n'
			.. '/getlook \n'
			.. '/ghost \n'
			.. '/goldrank \n'
			.. '/info playerName \n'
			.. '/kick playerName \n'
			.. '/looktype [id : number] \n'
			.. '/mc (mc check) \n'
			.. '/openserver \n'
			.. '/pos \n'
			.. '/c (push creature) \n'
			.. '/t [playerName] (move temple) \n'
			.. '/r (remove thing in front of you) \n'
			.. '/a (skip tile) \n'
			.. '/spy playerName \n'
			.. '/raid raidName \n'
			.. '/goto (teleport to creature) \n'
			.. '/town townName/townID [thais, carlin, venore, yalahar, etc..] \n'
			.. '/unban playerName \n'
			.. '/up \n\n'
	elseif accountType == ACCOUNT_TYPE_GOD then
		text = text
			.. '/addaddons playerName \n'
			.. '/addmoney playerName, value \n'
			.. '/addmounts playerName \n'
			.. '/addoutfit playerName, lookType \n'
			.. '/addslcoins playerName, amount (give shadowlux coins) \n'
			.. '/addskill playerName, skill [level, magic, axe, sword, club, fist] \n'
			.. '/ban playerName \n'
			.. '/bless playerName \n'
			.. '/b text \n'
			.. charmsCommands
			.. '/clean \n'
			.. '/closeserver [shutdown] \n'
			.. '/hireling (create hireling lamp)\n'
			.. '/i id/name [, amount] (create item, optional amount: , 1 - 100) \n'
			.. '/m monsterName (wild monster) \n'
			.. '/n npcName \n'
			.. '/spawn monsterName \n'
			.. '/s monsterName (summon) \n'
			.. '/createtp posX, posY, posZ \n'
			.. '/down \n'
			.. forgeCommands
			.. '/getlook \n'
			.. '/ghost \n'
			.. '/goldrank \n'
			.. '/owner [, playerName] (pass or remove ownership of house) \n'
			.. '/info playerName \n'
			.. '/ipban playerName \n'
			.. '/kick playerName \n'
			.. '/looktype [id : number] \n'
			.. '/effect [id : number] \n'
			.. managerTutorCommands
			.. '/mc (mc check) \n'
			.. '/openserver \n'
			.. '/pos \n'
			.. '/c (push creature) \n'
			.. '/t [playerName] (move temple) \n'
			.. '/reload [option] \n'
			.. '/r (remove thing in front of you) \n'
			.. '/save \n'
			.. '/setlight color (0-1500), (1-32) \n'
			.. '/a (skip tile) \n'
			.. '/spy playerName \n'
			.. '/raid raidName \n'
			.. storageCommands
			.. '/goto (teleport to player or monster) \n'
			.. '/teleport posX, posY, posZ (in front of tp id 1949) \n'
			.. '/town townName/townID [thais, carlin, venore, yalahar, etc..] \n'
			.. '/unban playerName \n'
			.. '/up \n'
			.. vipCommands

		player:showTextDialog(2597, text)
	end
	return false
end

gmAndGodCommands:groupType("gamemaster")
gmAndGodCommands:register()
