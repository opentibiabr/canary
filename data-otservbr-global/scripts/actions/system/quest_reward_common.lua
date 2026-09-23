-- Compatibility configuration for the legacy reward handler.
-- New World rewards are authored in world JSON and use the same execution helper.

local AttributeTable = {
	[6013] = {
		text = [[
Hardek *
Bozo *
Sam ****
Oswald
Partos ***
Quentin *
Tark ***
Harsky ***
Stutch *
Ferumbras *
Frodo **
Noodles ****]],
	},
	[6112] = {
		text = [[
... the dream master retreated to the world behind the curtains of awareness, I can't reach him, now that the last hall of dreams is lost to the forces of evil.
I sealed Goshnar's grave so no one can enter the pits without knowing our secret.
I will try to retreat to Knightwatch Tower and wait for a dreamer in possession of the key.
So we can travel on one of the dream paths to a saver place to regroup and to plan a counter-attack.
I fear we have to recruit new members and we have only little time left to train them.
I hope Taciror will not waste our last forces in a futile attack on the Ruthless Seven.
Our order has never truly recovered from the losses in our war against Goshnar and his undead hordes.
Now that our leaders and best warriors have died in the attack on the demonic forces, we don't stand a chance against our enemies.
Our only hope is to gather new forces and to recapture the chamber of dreams.
Of course I know the right method to distract Hugo long enough to get past him.
The dream master is important to teach our recruits in the old ways and in the art of dreamwalking.
We need a leader for our cause and we need him badly. Headless we will fail and fall.
It is already uncertain who took the Nightmare Chronicles out of the pits and I have no idea where they are hidden.
They are fighting about power and influence but unity is the key to success. Our whole order is centred about unity.
All our rituals and procedures rooted on unity and sharing, they can't neglect that.
]],
	},
	[6183] = {
		text = [[
Looks like the fox is out!
More luck next time!
Signed:
the horned fox
]],
	},
}

local achievementTable = {
	-- [chestUniqueId] = "Achievement name",
	-- Annihilator
	[6085] = "Annihilator",
	[6086] = "Annihilator",
	[6087] = "Annihilator",
	[6088] = "Annihilator",
}

local executeReward = dofile(DATA_DIRECTORY .. "/lib/core/world_quest_reward.lua")
local questReward = Action()

function questReward.onUse(player, item, fromPosition, itemEx, toPosition)
	local setting = ChestUnique and ChestUnique[item.uid]
	return executeReward(player, item, setting, AttributeTable[item.uid], achievementTable[item.uid])
end

for uniqueRange = 5000, 9000 do
	questReward:uid(uniqueRange)
end

for uniqueRange = 10000, 12000 do
	questReward:uid(uniqueRange)
end

questReward:uid(14092)

questReward:register()
