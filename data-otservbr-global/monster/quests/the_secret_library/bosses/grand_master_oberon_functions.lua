GrandMasterOberonAsking = {
	[1] = {msg = "You appear like a worm among men!"},
	[2] = {msg = "The world will suffer for its iddle laziness!"},
	[3] = {msg = "People fall at my feet when they see me coming!"},
	[4] = {msg = "This will be the end of mortal man!"},
	[5] = {msg = "I will remove you from this plane of existence!"},
	[6] = {msg = "Dragons will soon rule this world, I am their herald!"},
	[7] = {msg = "The true virtue of chivalry are my belief!"},
	[8] = {msg = "I lead the most honourable and formidable following of knights!"},
	[9] = {msg = "ULTAH SALID'AR, ESDO LO!"},
}

GrandMasterOberonResponses = {
	[1] = {msg = "How appropriate, you look like something worms already got the better of!"},
	[2] = {msg = "Are you ever going to fight or do you prefer talking!"},
	[3] = {msg = "Even before they smell your breath?"},
	[4] = {msg = "Then let me show you the concept of mortality before it!"},
	[5] = {msg = "Too bad you barely exist at all!"},
	[6] = {msg = "Excuse me but I still do not get the message!"},
	[7] = {msg = "Dare strike up a Minnesang and you will receive your last accolade!"},
	[8] = {msg = "Then why are we fighting alone right now?"},
	[9] = {msg = "SEHWO ASIMO, TOLIDO ESD!"},
}

GrandMasterOberonConfig = {
	Storage = {
		Asking = 1,
		Life = 2,
		Exhaust = 3,
	},
	Monster = {
		"Falcon Knight",
		"Falcon Paladin"
	},
	AmountLife = 3
}

local function healOberon(monster)
	local storage = monster:getStorageValue(GrandMasterOberonConfig.Storage.Life)
	monster:setStorageValue(GrandMasterOberonConfig.Storage.Life, storage + 1)
	monster:addHealth(monster:getMaxHealth())

end

function SendOberonAsking(monster)
	monster:registerEvent('OberonImmunity')
	local random = math.random(#GrandMasterOberonAsking)
	monster:say(GrandMasterOberonAsking[random].msg, TALKTYPE_MONSTER_SAY)
	monster:setStorageValue(GrandMasterOberonConfig.Storage.Asking, random)

	healOberon(monster)

	Game.createMonster(GrandMasterOberonConfig.Monster[math.random(#GrandMasterOberonConfig.Monster)], monster:getPosition(), true, true)
end
