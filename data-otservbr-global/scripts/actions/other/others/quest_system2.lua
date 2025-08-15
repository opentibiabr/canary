local config = {
	[2285] = { -- The Djinn War Quest - lamp
		items = {
			{ itemId = 3243 },
		},
		storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03,
		formerValue = 1,
		newValue = 2,
		needItem = { itemId = 3231 },
		effect = CONST_ME_MAGIC_BLUE,
	},
	[3018] = {
		items = {
			{ itemId = 3219 },
		},
		storage = Storage.Quest.U7_24.ThePostmanMissions.Mission08,
		formerValue = 1,
		newValue = 2,
	},
	[3020] = {
		items = {
			{ itemId = 145 },
		},
		storage = Storage.Quest.U8_1.TheTravellingTrader.Mission02,
		formerValue = 3,
		newValue = 4,
	},
	[3024] = {
		items = {
			{ itemId = 3243 },
		},
		storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission03,
		formerValue = 1,
		newValue = 2,
		needItem = { itemId = 3231 },
		effect = CONST_ME_MAGIC_RED,
	},
	[3084] = {
		items = {
			{ itemId = 8829 },
		},
		storage = Storage.Quest.U8_4.InServiceOfYalahar.MatrixReward,
	},
	[3085] = {
		items = {
			{ itemId = 8828 },
		},
		storage = Storage.Quest.U8_4.InServiceOfYalahar.MatrixReward,
	},
	[3112] = {
		items = {
			{ itemId = 2820, text = "<the paper is old and tattered, you can only make out a signature:> Tylaf, apprentice of Hjaern" },
		},
		storage = Storage.Quest.U8_0.TheIceIslands.Questline,
		formerValue = 35,
		newValue = 36,
		missionStorage = { key = Storage.Quest.U8_0.TheIceIslands.Mission09, value = 2 },
	},
	[3116] = {
		items = {
			{ itemId = 3217 },
		},
		storage = Storage.Quest.U7_24.ThePostmanMissions.Mission09,
		formerValue = 1,
		newValue = 2,
	},
	[3120] = {
		items = {
			{ itemId = 3218 },
		},
		storage = Storage.Quest.U7_24.ThePostmanMissions.Mission05,
		formerValue = 1,
		newValue = 2,
	},
	[3162] = {
		items = {
			{ itemId = 637 },
		},
		storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline,
		formerValue = 1,
		newValue = 2,
		say = "A batch of documents has been stashed in the shelf. These might be of interest to Zalamon.",
		effect = CONST_ME_POFF,
	},
	[4010] = {
		items = {
			{ itemId = 4832 },
		},
		storage = Storage.Quest.U7_6.TheApeCity.HolyApeHair,
	},
	[9136] = {
		items = {
			{ itemId = 2972, actionId = 3980 },
		},
		storage = Storage.Quest.U5_0.DeeperFibulaKey,
	},
	[9226] = {
		items = {
			{ itemId = 3397 },
		},
		storage = Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc,
		formerValue = 2,
		newValue = 3,
	},
	-- Hydra Egg Quest
	[9255] = {
		items = {
			{ itemId = 4839 },
		},
		storage = Storage.Quest.U7_6.HydraEggQuest,
	},
	[9256] = {
		items = {
			{ itemId = 4829, decay = true },
		},
		storage = Storage.Quest.U7_6.TheApeCity.WitchesCapSpot,
		time = true,
	},
	[9259] = {
		items = {
			{ itemId = 10159 },
		},
		storage = Storage.Quest.U8_54.UnnaturalSelection.Mission01,
		formerValue = 1,
		newValue = 2,
		say = "You dig out a skull from the pile of bones. That must be the skull Lazaran talked about.",
	},
	[9266] = {
		items = {
			{ itemId = 7936 },
		},
		storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission06,
		formerValue = 2,
		newValue = 3,
		say = "To buy some time you replace the fish with a piece of carrot.",
	},
	[9277] = {
		items = {
			{ itemId = 652 },
		},
		storage = Storage.Quest.U8_1.SecretService.RottenTree,
	},
	[50112] = {
		items = {
			{ itemId = 3725, count = 10 },
		},
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.BrownMushrooms,
	},
	[50125] = {
		items = {
			{ itemId = 8777 },
		},
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.JusticeForAll,
		formerValue = 3,
		newValue = 4,
	},
	[65201] = {
		items = {
			{ itemId = 2968, actionId = 3980 },
		},
		storage = 857440,
	},
	[65207] = {
		items = {
			{ itemId = 3551, count = 1 },
		},
		storage = 857445,
	},
	[65208] = {
		items = {
			{ itemId = 3377, count = 1 },
		},
		storage = 857446,
	},
	[65210] = {
		items = {
			{ itemId = 3147, count = 3 },
		},
		storage = 857448,
	},
	[14037] = {
		items = {
			{
				itemId = 2820,
				text = [[
History of the Augur, Part II

They brought more and more people to Yalahar. Not all of them became Augur, a good part of them lived in Yalahar as ordinary citizens. At some point, the city had reached a much larger population than under the rule of the true Yalahari, and it became difficult to provide food and shelter for everyone. Time and overuse took it's toll on the city. Over the years, more and more parts of the city were lost due to ignorance, lack of resources, or catastrophes. The new Yalahari were unable to restore broken machines and devices, and their efforts to retake certain parts of the city with the help of the Augur caused only more disaster. So the new Yalahari decided to stay in the city's centre, letting the Augur care for the rest of the city as well as they could. Still, their image as Yalahari allowed them to claim supremacy and to rule over the whole city. This all did not matter too much to our ancestors. The new Yalahari were neither cruel nor overly abusive, and they still wielded the powerful weapons and armors of the true Yalahari. So they stuck to the status quo and continued to work for the Yalahari despite everything they had found out. This worked quite well although the city was still declining and great parts of it had been lost to chaos and anarchy.

Lately, though, things started to change. It is not a dramatic change but it can be recognised gradually at many places. Some of the known routines in the orders of the Yalahari have altered. There are more and more orders who have a dubious purpose. The most frightening thing is that some orders obviously hint at a person with Yalahari knowledge that had been considered as lost for centuries. The overwhelming majority of the new Yalahari still clings to their ignorant and self-centred ways, but perhaps one of them or a small group has discovered some hidden secrets of their vanished masters. It is also possible that something completely different is happening, we simply don't know. But these new orders that seem to aim at restoring order in the city have some bitter taste. They are somewhat oppressive and destructive, not in an obvious way, though. Taken together, they paint a dark picture of Yalahar's future. A future of oppression, betrayal, and a much stricter rule by the Yalahari.]],
				name = "History of the Augur, Part II",
			},
			{
				itemId = 2820,
				text = [[
History of the Augur, Part I

We, the families of the Augur, have been living here for many generations. In the course of time, we acquired certain insights in the ways of our masters, the Yalahari. Many years ago, things used to be very different in this city. Once it was a marvel to behold, but then it started to decay slowly and steadily. This process of deterioration begun in the far past, long before our ancestors came[ here. At the time they were brought here by the Yalahari as helpers and workers, the city already showed signs of decline. Despite their claim of having great power, the Yalahari could do little to stop the catastrophes that should occur. Neither did they do anything to restore the damaged parts of the city. Still, it took many centuries until the city had reached the pitiful state that you can witness today.

Some decades ago, a group of Augur suspected that we all were lied to by our masters. They started to look for clues that proved their assumptions, and secretly gathered parts of the puzzle one by one. For all we know, there had been indeed a powerful race called the Yalahari that built this city to distance itself from the wars of some capricious gods. So far the tales that our masters had told us, have been true. These Yalahari were served by a group of Augur such as us. They were their helpers and workers, and the Yalahari shared some of their luxuries and achievements with them. The Yalahari concentrated on research and art, and left the more manual work to their servants, who often only knew what they had to do without understanding their tasks. At one far-away point in history, the Yalahari seemingly vanished. Certain clues that our ancestors gathered, hint that they locked themselves in the city's centre and cut off all contact to their helpers. When the Augur sometime later dared to enter the inner city, the Yalahari were all gone - vanished without a trace. After getting over the initial shock, the Augur assumed the role of the Yalahari themselves. For a while they tried to get familiar with some of the secrets of their lost masters, but they were only able to understand the most basic concepts of the Yalahari's knowledge. They stuck to their usual tasks to keep the city running. Still, they were too few to keep the enormous city, of which they understood so little, in shape.

So they decided to recruit Augur on their own. This way most of our forefathers came to Yalahar. In the meanwhile, the former Augur retreated into the inner city.]],
				name = "History of the Augur, Part I",
			},
		},
		storage = Storage.Quest.U8_4.InServiceOfYalahar.NotesPalimuth,
		formerValue = 0,
		newValue = 1,
	},
	[14038] = {
		items = {
			{
				itemId = 2820,
				text = [[
Manifest of the Yalahari, Part II

It is obvious that such greatness comes not without sacrifices, but we will make sure to keep them to a minimum. All of our decisions serve a greater good, of course. Even if this is not always obvious, in the end things will work out and provide us all with a better life and a bright future.

Based on the ruins of our former glory, it is hard to imagine how magnificent this future will be, but we, the Yalahari, still carry the vision of what we want to accomplish in our hearts. To bring this vision to life is our greatest goal which we all work towards.

There are elements that see their power and influence waning in these days of change. They are afraid of the things to come, and in their ignorance they cling to the rotting reality they know all too well. They created their own little niches of power and influence and feel guilty for neglecting their duties, and with that also for the decay of the city. They are surely already approaching unsuspecting outsiders to poison their minds with selfish lies. For generations the Augur, once the pride of our people, have done things the same way they had known for generations, and everyone can see where it has taken Yalahar.]],
				name = "Manifest of the Yalahari, Part II",
			},
			{
				itemId = 2820,
				text = [[
Manifest of the Yalahari, Part I

The city has been neglected for far too long. We concentrated on our research and spiritual evolution and have turned a blind eye on the needs of the people that are our subjects. We have too strongly relied on the help of the Augur who in turn did little but the same routines for many generations. We have decided it is time to take initiative. The experiment to give people too much freedom and too little guidance has to be stopped before all is lost. We have a responsibility for this city and the people living here. Only with our help, they will be able to flourish and to overcome the shadows of the past. The city can be rebuilt and restored to at least some of its former glory when we diligently work for it. It will be hard and it will take the help of determined individuals to assist us in our efforts. However, in the long run, order will be completely re-established and Yalahar will once again be the magnificent city it used to be.

Only with drastic decisions and changes, this great goal can be achieved. We will have to get through hard times and prepare for them as good as we can. Most importantly, a good city needs a solid base. For this reason we have to start at the bottom to clean things up. We have to be precise and consequent in our decisions and actions. This way we will be able to create a solid base for the city.

To some extent, we have to work like a gardener. The rotten parts have to be cut off, and the healthy parts have to be cherished. The city has to be retaken. Then order can be restored and the actual rebuilding can begin. In the end, the city will once again be a centre of prosperity and a shining light in a dark world.]],
				name = "Manifest of the Yalahari, Part I",
			},
		},
		storage = Storage.Quest.U8_4.InServiceOfYalahar.NotesAzerus,
		formerValue = 0,
		newValue = 1,
	},
	[14039] = {
		items = {
			{ itemId = 8818 },
		},
		storage = Storage.Quest.U8_4.InServiceOfYalahar.AlchemistFormula,
		formerValue = 0,
		newValue = 1,
	},
	[14040] = {
		items = {
			{
				itemId = 2832,
				text = [[
Tunnelling guide
----------------
by Gromward Hammerfist

'The art of building a tunnel lies in the nature of dwarfes.' That's what my grand grand grandfather used to say. First of all I'd like to give you a small historical review of tunnelling. .....<you skip the first 1000 pages containing dwarfen tunnelling history>.

Repairing collapsed tunnels:
Equipment: Pick, tree or bricklayers kit
Before picking away the rubble you need to place a buttress otherwise the tunnel will collapse over and over again. If you don't have a matching tree at hand you could still build a brickwall to stabilize the tunnel. Good luck!

Repairing gaps:
Equipment: Wood, wooden ties, hammer, nails, metal fitting
For each missing part (on the basis of a standard rail) I recommend to use three pieces of wood. Lock them in position by at least 6 nails. For the rail itself use a saw on a piece of wood to build your wooden ties. Then place two metal fittings on them and you can make your first ride on your new rail. Congratulations!

Building a rail on lava:
I advice not to try that until you have at least 20 years experience in rail construction......<Well, seems like you don't match the premises.>

Adventuring old tunnels:
Be aware that our kind mastered the art of tunnelling. It may take you a whole life to understand the techniques that are used and it takes generations to know all the tunnels of a mine and all their exits. You even may find an exit that you never expected to.

To sum up
If you are no dwarf don't even try to think that you have a chance of mastering the art of tunnelling. If you are a dwarf I wish you good luck and don't abandon faith. There is a light at the end of the tunnel.

Yours

Gromward Hammerfist]],
				name = "Tunnelling Guide",
			},
		},
		storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.TunnellingGuide,
	},
	[20003] = {
		items = {
			{
				itemId = 2822,
				text = [[
The map shows the original floor plan of this mine. You recognise your position and that the shaft to the south actually would reach much further.

(In the lower right corner someone scribbled a note how to use the hoist on the first mine floor.)]],
			},
		},
		storage = Storage.Quest.U8_0.TheIceIslands.FormorgarMinesHoistSkeleton,
	},
	[14041] = {
		items = {
			{
				itemId = 28461,
				text = [[
This page seems to be part of a book about ancient rituals, mystic incantations and far away places. Besides a very prominent symbol, embedded in the text, a spell can be deciphered from the strange script:

~ As daylight fades, mix chalk or bone meal with your own blood and water ~
~ Draw with it a circle in the middle of the room ~
~ Stand in this sphere when drawing the symbol "Of Night And Day Intersecting Ostensum Est"
~ Utter all of the following words loudly with clear voice: CERTAGIA SALABANTHR DANNHE GENT'HO" ~
~ Looking upward, repeat the incatation and you shall teleport the periphery of your body ~]],
				name = "Falcon Bastion Access",
			},
		},
		storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.FalconBastionAccess,
	},
	[20002] = {
		items = {
			{
				itemId = 21413,
				text = [[
"Still it is hard to believe that I finally
found the mystical rock formations near
Darashia, known as Lion's Rock.
According to ancient records there is a
temple for an unknown, probably long
forgotten deity, built in the tunnels deep
below the rock centuries ago. This holy
site was once guarded by mystical lions
and they may still be down there. But
yet I haven't succeeded in entering the
inner sanctum. The entrance to the
lower temple areas is protected by an
old and powerful enchantment. I
studied the inscriptions on the temple
walls and thus learned that the key to
the inner sanctum is the passing of
three tests. The first test is the Lion's
Strength. In order to honour the site's
mystical cats of prey one has to hunt
and slay a cobra. The cobra's tongue
must be laid down at a stone statue as
a sacrifice. The second test is the
Lion's Beauty. One has to burn the
petals of a lion's mane flower on a coal
basin. In the sand at the rock's foot I
saw some dried lion's mane petals.
Maybe these flowers grow somewhere
upwards. The third test is called the
Lion's Tears. It seems one has to purify
an ornamented stone pedestal with ..."
At this point the records end because
the parchment is destroyed. It seems
that is was torn by a big paw ...]],
			},
		},
		storage = Storage.Quest.U10_70.LionsRock.OuterSanctum.Skeleton,
	},
	-- 65203 reservado
}

local questSystem2 = Action()

function questSystem2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end

	if (useItem.time and player:getStorageValue(useItem.storage) > os.time()) or player:getStorageValue(useItem.storage) ~= (useItem.formerValue or -1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. ItemType(item.itemid):getName() .. " is empty.")
		return true
	end

	if useItem.needItem then
		if player:getItemCount(useItem.needItem.itemId) < (useItem.needItem.count or 1) then
			return false
		end
	end

	local items, reward = useItem.items
	local size = #items
	if size == 1 then
		reward = Game.createItem(items[1].itemId, items[1].count or 1)
	end

	local result = ""
	if reward then
		local ret = ItemType(reward.itemid)
		if ret:isRune() then
			result = ret:getArticle() .. " " .. ret:getName() .. " (" .. reward.type .. " charges)"
		elseif reward:getCount() > 1 then
			result = reward:getCount() .. " " .. ret:getPluralName()
		elseif ret:getArticle() ~= "" then
			result = ret:getArticle() .. " " .. ret:getName()
		else
			result = ret:getName()
		end

		if items[1].actionId then
			reward:setActionId(items[1].actionId)
		end

		if items[1].text then
			reward:setText(items[1].text)
		end

		if items[1].name then
			reward:setName(items[1].name)
		end

		if items[1].decay then
			reward:decay()
		end
	else
		if size > 8 then
			reward = Game.createItem(2854, 1)
		else
			reward = Game.createItem(2853, 1)
		end

		for i = 1, size do
			local tmp = Game.createItem(items[i].itemId, items[i].count or 1)
			if reward:addItemEx(tmp) ~= RETURNVALUE_NOERROR then
				logger.warn("[questSystem2.onUse] - Could not add quest reward to container")
			else
				if items[i].actionId then
					tmp:setActionId(items[i].actionId)
				end

				if items[i].text then
					tmp:setText(items[i].text)
				end

				if items[i].name then
					tmp:setName(items[i].name)
				end

				if items[i].decay then
					tmp:decay()
				end
			end
		end
		local ret = ItemType(reward.itemid)
		result = ret:getArticle() .. " " .. ret:getName()
	end

	if player:addItemEx(reward) ~= RETURNVALUE_NOERROR then
		local weight = reward:getWeight()
		if player:getFreeCapacity() < weight then
			player:sendCancelMessage("You have found " .. result .. ". Weighing " .. string.format("%.2f", (weight / 100)) .. " oz, it is too heavy.")
		else
			player:sendCancelMessage("You have found " .. result .. ", but you have no room to take it.")
		end
		return true
	end

	if useItem.say then
		player:say(useItem.say, TALKTYPE_MONSTER_SAY)
	end

	if useItem.needItem then
		player:removeItem(useItem.needItem.itemId, useItem.needItem.count or 1)
	end

	if useItem.effect then
		toPosition:sendMagicEffect(useItem.effect)
	end

	if useItem.missionStorage then
		player:setStorageValue(useItem.missionStorage.key, useItem.missionStorage.value)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. result .. ".")
	if useItem.time then
		player:setStorageValue(useItem.storage, os.time() + 86400)
	else
		player:setStorageValue(useItem.storage, useItem.newValue or 1)
	end
	return true
end

questSystem2:aid(2001)
questSystem2:register()
