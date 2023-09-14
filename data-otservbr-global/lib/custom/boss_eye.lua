function Player:sendBossWindow(bosseye)

-- Modal window design
	local window = ModalWindow 
	{
		title = bosseye.mainTitle, -- Title of the modal window
		message = bosseye.mainMsg, -- The message to be displayed on the modal window
	}

	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Cancel")

	-- Set what button is pressed when the player presses enter or escape
	window:setDefaultEscapeButton("Cancel")
	
	
	window:addChoice("-- Soul War Bosses --")

	if self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarHatredTimer) > os.time() then
		window:addChoice("Goshnars Hatred [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarHatredTimer)) .."]")
	else
		window:addChoice("Goshnars Hatred [ON]")
	end
	
	if self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarMaliceTimer) > os.time() then
		window:addChoice("Goshnars Malice [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarMaliceTimer)) .."]")
	else
		window:addChoice("Goshnars Malice [ON]")
	end
	
	if self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarSpiteTimer) > os.time() then
		window:addChoice("Goshnars Spite [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarSpiteTimer)) .."]")
	else
		window:addChoice("Goshnars Spite [ON]")
	end
	
	if self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarCrueltyTimer) > os.time() then
		window:addChoice("Goshnars Cruelty [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarCrueltyTimer)) .."]")
	else
		window:addChoice("Goshnars Cruelty [ON]")
	end
	
	if self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarGreedTimer) > os.time() then
		window:addChoice("Goshnars Greed [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarGreedTimer)) .."]")
	else
		window:addChoice("Goshnars Greed [ON]")
	end
	
	if self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarMegalomaniaTimer) > os.time() then
		window:addChoice("Goshnars Megalomania [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarMegalomaniaTimer)) .."]")
	else
		window:addChoice("Goshnars Megalomania [ON]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Cobra Bastion --")
	
	if self:getStorageValue(Storage.GraveDanger.CobraBastion.ScarlettTimer) > os.time() then
		window:addChoice("Scarlett Etzel [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.GraveDanger.CobraBastion.ScarlettTimer)) .."]")
	else
		window:addChoice("Scarlett Etzel [ON]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Kilmaresh --")
	
	if self:getStorageValue(Storage.Kilmaresh.UrmahlulluTimer) > os.time() then
		window:addChoice("Urmahlullu [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Kilmaresh.UrmahlulluTimer)) .."]")
	else
		window:addChoice("Urmahlullu [ON]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Falcons Bastion --")	
	
	if self:getStorageValue(Storage.TheSecretLibrary.TheOrderOfTheFalcon.OberonTimer) > os.time() then
		window:addChoice("Oberon [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.TheSecretLibrary.TheOrderOfTheFalcon.OberonTimer)) .."]")
	else
		window:addChoice("Oberon [ON]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Lions Bastion --")
	
	if self:getStorageValue(Storage.TheOrderOfTheLion.Drume.Timer) > os.time() then
		window:addChoice("Drume [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.TheOrderOfTheLion.Drume.Timer)) .."]")
	else
		window:addChoice("Drume [ON]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Warzone --")
	
	if self:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelow) > os.time() then
		window:addChoice("The Baron From Below [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelow)) .."]")
	else
		window:addChoice("The Baron From Below [ON]")
	end
	
	if self:getStorageValue(GlobalStorage.BigfootBurden.Versperoth) > os.time() then
		window:addChoice("Versperoth [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(GlobalStorage.BigfootBurden.Versperoth)) .."]")
	else
		window:addChoice("Versperoth [ON]")
	end
	
	if self:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepths) > os.time() then
		window:addChoice("The Duke Of The Depths [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepths)) .."]")
	else
		window:addChoice("The Duke Of The Depths [ON]")
	end
	
	--if self:getStorageValue(Storage.Bosses.Deathstrike) > os.time() then
		--window:addChoice("Deathstrike [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Bosses.Deathstrike)) .."]")
	--else
		--window:addChoice("Deathstrike [ON]")
	--end
	
	--if self:getStorageValue(Storage.Bosses.Gnomevil) > os.time() then
		--window:addChoice("Gnomevil [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Bosses.Gnomevil)) .."]")
	--else
		--window:addChoice("Gnomevil [ON]")
	--end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Forgotten Knowledge --")
	
	if self:getStorageValue(Storage.ForgottenKnowledge.LadyTenebrisTimer) > os.time() then
		window:addChoice("Lady Tenebris [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.LadyTenebrisTimer)) .."]")
	else
		window:addChoice("Lady Tenebris [ON]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.LloydTimer) > os.time() then
		window:addChoice("Lloyd [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.LloydTimer)) .."]")
	else
		window:addChoice("Lloyd [ON]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.ThornKnightTimer) > os.time() then
		window:addChoice("Mounted Thorn Knight [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.ThornKnightTimer)) .."]")
	else
		window:addChoice("Mounted Thorn Knight [ON]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.DragonkingTimer) > os.time() then
		window:addChoice("Dragonking Zyrtarch [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.DragonkingTimer)) .."]")
	else
		window:addChoice("Dragonking Zyrtarch [ON]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.HorrorTimer) > os.time() then
		window:addChoice("Melting Frozen Horror [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.HorrorTimer)) .."]")
	else
		window:addChoice("Melting Frozen Horror [ON]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer) > os.time() then
		window:addChoice("The Time Guardian [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer)) .."]")
	else
		window:addChoice("The Time Guardian [ON]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.LastLoreTimer) > os.time() then
		window:addChoice("The Last Lore Keeper [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.LastLoreTimer)) .."]")
	else
		window:addChoice("The Last Lore Keeper [ON]")
	end

	
	window:addChoice("-----------------------")
	window:addChoice("-- Bosses --")
	
	if self:getStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.KingZelosTimer) > os.time() then
		window:addChoice("King Zelos [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.KingZelosTimer)) .."]")
	else
		window:addChoice("King Zelos [ON]")
	end
	
	-- Send the window to player
	window:sendToPlayer(self)
end