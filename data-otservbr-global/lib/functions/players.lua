function Player.getCookiesDelivered(self)
	local storage, amount =
		{
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.SimonTheBeggar,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Markwin,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Ariella,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Hairycles,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Djinn,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.AvarTar,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.OrcKing,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Lorbas,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Wyda,
			Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Hjaern,
		}, 0
	for i = 1, #storage do
		if self:getStorageValue(storage[i]) == 1 then
			amount = amount + 1
		end
	end
	return amount
end

function Player.checkGnomeRank(self)
	local points = self:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.Rank)
	local questProgress = self:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine)
	if points >= 30 and points < 120 then
		if questProgress <= 25 then
			self:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine, 26)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
		end
	elseif points >= 120 and points < 480 then
		if questProgress <= 26 then
			self:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine, 27)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
			self:addAchievement("Gnome Friend")
		end
	elseif points >= 480 and points < 1440 then
		if questProgress <= 27 then
			self:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine, 28)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
			self:addAchievement("Gnome Friend")
			self:addAchievement("Gnomelike")
		end
	elseif points >= 1440 then
		if questProgress <= 29 then
			self:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine, 30)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
			self:addAchievement("Gnome Friend")
			self:addAchievement("Gnomelike")
			self:addAchievement("Honorary Gnome")
		end
	end
	return true
end

function Player.addFamePoint(self)
	local points = self:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Constants.Spike_Fame_Points)
	local current = math.max(0, points)
	self:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Constants.Spike_Fame_Points, current + 1)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received a fame point.")
end

function Player.getFamePoints(self)
	local points = self:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Constants.Spike_Fame_Points)
	return math.max(0, points)
end

function Player.removeFamePoints(self, amount)
	local points = self:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Constants.Spike_Fame_Points)
	local current = math.max(0, points)
	self:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Constants.Spike_Fame_Points, current - amount)
end
