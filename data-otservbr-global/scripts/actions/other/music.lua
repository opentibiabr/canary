local MusicEffect = {
	[2948] = CONST_ME_SOUND_GREEN, 	--Wooden Flute
	[2949] = CONST_ME_SOUND_GREEN, 	--Lyre
	[2950] = CONST_ME_SOUND_GREEN, 	--Lute
	[14253] = CONST_ME_SOUND_GREEN, 	--Drum
	[2953] = CONST_ME_SOUND_BLUE, 	--Panpipes
	[2954] = CONST_ME_SOUND_GREEN, 	--Simple Fanfare
	[2955] = CONST_ME_SOUND_GREEN, 	--Fanfare
	[2956] = CONST_ME_SOUND_GREEN, 	--Royal Fanfare
	[2958] = CONST_ME_SOUND_RED, 	--War Horn
	[2959] = CONST_ME_SOUND_BLUE, 	--Piano
	[2960] = CONST_ME_SOUND_BLUE, 	--Piano
	[2961] = CONST_ME_SOUND_BLUE, 	--Piano
	[2962] = CONST_ME_SOUND_BLUE, 	--Piano
	[2963] = CONST_ME_SOUND_BLUE, 	--Harp
	[2964] = CONST_ME_SOUND_BLUE, 	--Harp
	[3219] = CONST_ME_SOUND_GREEN, 	--Waldo's Post Horn
	[3252] = CONST_ME_SOUND_GREEN, 	--Post Horn
	-- non movable instruments
	[3255] = CONST_ME_SOUND_GREEN, 	--Drum
	[3256] = CONST_ME_SOUND_GREEN, 	--Simple Fanfare
	[3103] = CONST_ME_SOUND_YELLOW, --Cornucopia
	[3258] = CONST_ME_SOUND_GREEN, 	--Lute
	[3259] = CONST_ME_SOUND_BLUE, 	--Horn of Sundering
	[3260] = CONST_ME_SOUND_GREEN, 	--Lyre
	[3261] = CONST_ME_SOUND_BLUE, 	--Panpipes
	--
	[2951] = CONST_ME_SOUND_BLUE, 	--Bongo Drum
	[2965] = CONST_ME_SOUND_GREEN, 	--Didgeridoo
	[2966] = CONST_ME_SOUND_RED, 	--War Drum
	[5786] = CONST_ME_SOUND_GREEN, 	--Wooden Whistle
	[12602] = CONST_ME_SOUND_BLUE, 	--Small Whistle
}

local music = Action()
function music.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if item.itemid == 2949 then
		if isInRange(player:getPosition(), Position(32695, 31717, 2), Position(32699, 31719, 2)) then
			local lyreProgress = player:getStorageValue(Storage.Diapason.Lyre)
			if lyreProgress < 7
					and player:getStorageValue(Storage.Diapason.Edala) ~= 1
					and player:getStorageValue(Storage.Diapason.LyreTimer) < os.time() then
				player:setStorageValue(Storage.Diapason.Lyre, math.max(0, lyreProgress) + 1)
				player:setStorageValue(Storage.Diapason.Edala, 1)
				player:setStorageValue(Storage.Diapason.LyreTimer, os.time() + 86400)
			end
		end
	elseif item.itemid == 2953 then
		if isInRange(player:getPosition(), Position(33540, 32245, 7), Position(33542, 32247, 7)) then
			local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
			local UnlikelyCouple = player:getStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple)
			local PanpipesTimer = player:getStorageValue(ThreatenedDreams.Mission03.PanpipesTimer)
			if UnlikelyCouple >= 2 and PanpipesTimer < os.time() then
				if UnlikelyCouple == 2 then
					player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 3)
				end
				player:setStorageValue(ThreatenedDreams.Mission03.PanpipesTimer, os.time() + 20 * 3600)
				player:setStorageValue(ThreatenedDreams.Mission03[1], 2)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Mysteriously some colourful music notes fall of the panpipes. - Hurry, they will fade away quickly.")
				player:addItem(25782, 1)
			end
		end
	end

	player:addAchievementProgress('Rockstar', 10000)
	item:getPosition():sendMagicEffect(MusicEffect[item.itemid])
	return true
end

for index, value in pairs(MusicEffect) do
	music:id(index)
end

music:register()
