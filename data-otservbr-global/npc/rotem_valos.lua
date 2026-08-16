local internalNpcName = "Rotem Valos"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 335,
	lookHead = 79,
	lookBody = 77,
	lookLegs = 79,
	lookFeet = 94,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "<sigh> The world has grown complicated since my youth." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "adventurers" }, StdModule.say, { npcHandler = npcHandler, text = "Welcome to the Adventurers' Guild, my friend." })
keywordHandler:addKeyword({ "adventuring" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Much of your adventuring life will be exploring and hunting monsters on your own. There are many places all over the world that are crowded with fearsome monsters and fascinating treasures. ... More often than not, it will be up to you to decide where and how to get experience and wealth in a way that suits your tastes. Explore the world, but be careful. There are things out there that pose a challenge even to experienced adventurers. ... While you are inexperienced and weak, there is a plethora of creatures that can easily kill you. So never be too bold in unknown territory! ... If you jump down a hole, be prepared to immediately climb up again. When facing enemies of unknown strength, try to fight only one at once. ... Always keep in mind that you need time and resources for your way back and that any enemy corpses you might find, could indicate you might have to face these enemies on your way back. ... Sometimes, missions suiting your experience level might lead you to dangerous, unknown parts of the world, and might require you to join forces with other adventurers. ... From time to time, certain areas of the world are also threatened by dangerous creatures, trying to invade. Usually, this will be felt throughout the world, so everyone is alerted to such an event. ... If you are close to one of these events, you might want to participate. In that case, you will need to work together with other heroes to defeat the enemy invasion. ... It takes large organised groups to reach and defeat the monsters at the remote spots where they appear. ... If you prefer less violent affairs however, there are also several seasonal events which are usually not overly violent in nature, where you can join in. ... Talk to one of the local towncriers now and then to learn what is happening in the world. Most of those events require some form of travelling though, so be prepared to see more of the world!",
})
keywordHandler:addKeyword({ "resurrected" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "When you die in Tibia, you will be resurrected in the temple of the city you chose as your home. You can change your home city, and thus the point of your resurrection, in a temple in any city. ... In those temples or sometimes at special places you will find special teleporters that make you an 'inhabitant' of that particular city. That means you will be resurrected there, regardless of where you died in Tibia. ... However, this can mean a long way to travel to the site of your demise, and might strand you in a city without any money. So you'd better make sure to always have cash on your bank account! ... To prevent some of your losses in case of death, you can do another thing as well: you can acquire blessings at certain temples.",
})
keywordHandler:addKeyword({ "information" }, StdModule.say, { npcHandler = npcHandler, text = "What do you wish to know? Is it about death, the blessings, or the vocation promotion?" })
keywordHandler:addKeyword({ "promotions" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "A promotion is available to premium account adventurers with some basic experience, at level 20. ... A promotion will increase your health and mana regeneration, help you lose less experience and training if you die, and will give you access to additional useful and powerful spells. ... A promotion is available from me or one of the great leaders of the nations for the cost of 20.000 gold. ... If you are prepared for your promotion, let us talk about your advancement.",
})
keywordHandler:addKeyword({ "equipment" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "You become stronger in several ways, some more obvious than others. First of all, there is your equipment. Better equipment means you are harder to kill. ... Equipment can be dropped as loot by killed creatures. Stronger monsters drop better loot of course. You might get equipment as a reward from some missions, which is especially true for the most experienced adventurers. ... You can also buy equipment offered by other players in the market, accessible via the depot. Then there are your skills - when they improve, so does your chance to cope with enemies that you encounter on your travels.",
})
keywordHandler:addKeyword({ "blessings" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Blessings are something the gods bestow upon us in order to protect us. They are expensive though, and require a lot of costly travel. So it might take a while until blessings are an option for an adventurer. ... In case of death, blessings will reduce the loss of experience. The different blessings are cumulative, and add up with each other. However, blessings are spent once you die, and will have to be renewed again. ... Therefore, blessings are mainly a tool for the experienced adventurer who has a lot to lose when he dies.",
})
keywordHandler:addKeyword({ "stronger" }, StdModule.say, { npcHandler = npcHandler, text = "You become stronger in several ways, some more obvious than others. First of all, there is your equipment. Better equipment means you are harder to kill. Then there's your skill and experience, and your vocation, for example." })
keywordHandler:addKeyword({ "vocation" }, StdModule.say, { npcHandler = npcHandler, text = "Your vocation is what you chose to be - either a knight, paladin, druid or sorcerer. Each vocation has its own fighting technique and skills." })
keywordHandler:addKeyword({ "products" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Creature products come in all forms, colors and tastes. The simplest creature product is likely to be something edible. You want to carry as much food as possible, but it is probably the first thing to get rid of to carry some valuable loot. ... Other products are bought by specific alchemists, trophy hunters or curiosity collectors. Other items might play a role in certain missions, or are useful for obtaining certain items that people value. ... So you can either ask around if certain inhabitants are interested in particular creature products, or try to sell them to other heroes in the market - which you can access via your depot. ... Depots and the market itself is global, so there is no need to check another city, the market is always the same. If you are unsure if an item is worth to be kept, keep it in your depot until you learned about its worth.",
})
keywordHandler:addKeyword({ "premium" }, StdModule.say, { npcHandler = npcHandler, text = "If you have a premium account and were blessed by the gods, you can also use the training statues for some meditative combat training. This means your skills are trained while your character is logged out." })
keywordHandler:addKeyword(
	{ "leaders" },
	StdModule.say,
	{ npcHandler = npcHandler, text = "The great leaders of the world who grant a promotion to adventurers are King Tibianus in Thais, Queen Eloise of Carlin, the emperors Kruzak of Kazordoon and Rehal of Beregar, ... and on behalf of the pharaoh himself, the grand vizier Ishebad in Ankrahmun. ... Don't forget that you can get your promotion also from me if you don't like those royal ceremonies." }
)
keywordHandler:addKeyword({ "things" }, StdModule.say, { npcHandler = npcHandler, text = "For example, fighting is something you can - and will - do a lot of in your adventuring life, either for a mission or on your own, in order to become stronger. Also, fighting will get you different kinds of loot." })
keywordHandler:addKeyword({ "travel" }, StdModule.say, { npcHandler = npcHandler, text = "You may talk to Charos upstairs to change your destination city at our teleporters. But you have to know that this service is only available to new heroes, and only for a given number of times. ... Charos will tell you how often you can change your destination city." })
keywordHandler:addKeyword({ "spells" }, StdModule.say, { npcHandler = npcHandler, text = "Another way to become more powerful is to learn new spells, if your vocation uses spells. You can learn spells at certain places in each city - usually the local guild of your vocation, but that may vary from city to city." })
keywordHandler:addKeyword({ "skill" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Be careful not to die, as you lose skill points with each death! Skills increase by using them. So when you fight a creature, you will always grow a little more skilled with the weapon or magic skill that you use. ... Then there is your experience, of course. The more experience you have gained, the more life force and mana you have at your disposal. As you probably already know, you get experience through fighting things, and some missions. ... Premium accounts have two additional possibilities, as they can also use training statues and get promotions.",
})
keywordHandler:addKeyword({ "death" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Death is always a threat. When you are resurrected in the temple, you will find you might have lost quite a lot of your equipment. You might want to try to retrieve the more valuable stuff from your dead body. ... Your dead body will take a while before it decays, and can be looted - by anyone. But before you run off into danger, remember: You will need a ROPE or a shovel to reach certain spots. ... It is likely that you lost your rope when you died, so you might need to replace it. For this purpose, it might be a good idea to have stashed some basic equipment in your depot. ... This will spare you valuable time when you hurry back to your corpse. Remember that each city has its own depot! ... Another thing that you can do to prevent some of your losses in case of death, is to acquire blessings at certain temples.",
})
keywordHandler:addKeyword({ "depot" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "What you stash in the depot of one city, is global, thus can be retrieved at a depot in another city. Your bank account as well as your inbox are global, and can be accessed from every city. ... Whenever you deposit or withdraw money anywhere in the world, it will be the same money balance that is changed. ... Also, through your depot, you can access the market to trade items with other players, to buy or sell items there. ... To prevent some of your losses in case of death, you might also want to acquire blessings at certain temples.",
})
keywordHandler:addKeyword({ "fasul" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry but this is a matter I'm not prepared to discuss ... yet." })
keywordHandler:addKeyword({ "eremo" }, StdModule.say, { npcHandler = npcHandler, text = "It is said that he lives on a small island near the city of Edron. Maybe the people there know more about him." })
keywordHandler:addKeyword({ "loot" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The simplest loot is probably junk, but other stuff dropped by slain monsters might be worth something to one of the inhabitants; or you can sell it to some vendors. Dropped creature products often are not that heavy, so they might be worth keeping. ... Check if any dropped weapons or armor are better than what you have. Even if they're not, it might be worth keeping them to sell them to a weapon or armor vendor. ... Provided you have the capacity to carry it, that is! But don't become overconfident and forget about death! If you die, you lose part of what you carry, so you might want to stash some spare equipment at the depot.",
})
keywordHandler:addKeyword({ "list" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "There were rumours of a lost sorcerer, frozen in his own home inside an enormous iceberg near Port Hope. So take a look there. And something is amiss in a dark place deep under Liberty Bay. ... The area has also fallen prey to dangerous insectoid creatures; look out for unnatural hive formations above ground. Nature revealed more caves in the Kha'Zeel mountains, where it's said that a fountain of fire leads the way to unimaginable riches. ... Unrest is stirring in an old ruin north of Edron, maybe it could be mapped while checking what's going on there? Furthermore, creatures of the sea are also gaining foothold - no pun intended - in the Liberty Bay area. ... A tall tower, deep south in the jungles of Tiquanda and yet unknown to us, stretches menacingly into the skies. ... There are also several unexplored caves full of spiders in the vicinity of Port Hope to the south-east. Maybe they lead to a sunken temple once said to be located in that area? Look out for rooms with statues! ... And while you're there, a forgotten and probably dangerous palace there seems to be occupied by demons. ... Cursed souls are haunting the swamps of Venore. Something is brewing in a system of caverns below. According to local gossip, there are strange sulphur formations right at the center of it; we need that mapped. ... Someone seems to have set up home in another strange cave to the northeast of Cormaya. Before he took to his heels, our informant found a cauldron there with a glistening substance - still warm to the touch. ... A small island to the north of Edron seems to be inhabited, there is no harbour there and none of the ships we know actually sails there - maybe you will find a way to chart its inhabitants' dwellings. ... A fellow adventurer stumbled upon an old tomb in Edron, reachable via a small cave to the south. He barely escaped its inhabitants and mumbled something about the power of... blood. ... The ice has revealed an ancient glacial cave near Port Hope. Parts of it may be flooded, however. A passage north of Ankrahmun leads to an old tomb. It's said to be teeming with scarabs, even very old ones. ... Also, another scarab-infested system of caverns can be found there, we don't know where exactly, but rumour has it that someone has erected an altar in it. So please try and find proof of this. ... There is also a rumour of a forbidden temple sanctuary to the east of Ankrahmun. We tried to find the entrance which is lost in the sands but failed numerous times. ... To the western coast of Cormaya, a mysterious well is said to lead to a lost grove of forest furies guarding or worshipping an earth elemental; nested deep underground amidst gardens of green. ... There are also some previously unexplored remains of an old fortress, directly north of Edron. We need those ruins charted as soon as possible of course. Alright, here's another map. Take care of it. And I mean more than you did last time.",
})
keywordHandler:addKeyword({ "lost" }, StdModule.say, { npcHandler = npcHandler, text = "I already gave you a map, come back later and I will see if I can fetch you a new one." })
keywordHandler:addKeyword({ "work" }, StdModule.say, { npcHandler = npcHandler, text = "We always need a hand charting Tibia. Our map of the world can't be detailed enough. Talk to me if you're interested or if you already have a map and lost it." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Welcome to the Adventurers' Guild, my friend." })
keywordHandler:addKeyword({ "map" }, StdModule.say, { npcHandler = npcHandler, text = "Looks like you found all the locations! Feel free to return here any time you like, we may have additional work for you!" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
