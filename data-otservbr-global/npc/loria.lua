local internalNpcName = "Loria"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 138,
	lookHead = 96,
	lookBody = 118,
	lookLegs = 81,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

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
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Loria, a former apprentice of Alatar, the Sage." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am studying the power of magic all the time." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time means nothing to me." })
keywordHandler:addKeyword({ "alatar" }, StdModule.say, { npcHandler = npcHandler, text = "Well, he was my great master. He taught me all these fantastic things about magic. I really miss him." })
keywordHandler:addKeyword({ "lake" }, StdModule.say, { npcHandler = npcHandler, text = "I hope you like it. It is named like my master, Alatar, the Sage." })
keywordHandler:addKeyword({ "praise alatar" }, StdModule.say, { npcHandler = npcHandler, text = "I praise my master Alatar." })
keywordHandler:addKeyword({ "power" }, StdModule.say, { npcHandler = npcHandler, text = "Although your attack spells get stronger with your usage of magic, real power is gained by finding strategies to properly use your magic abilities." })
keywordHandler:addKeyword({ "kill" }, StdModule.say, { npcHandler = npcHandler, text = "Killing and destruction are just foolish steaps to entrophy." })
keywordHandler:addKeyword({ "necromant" }, StdModule.say, { npcHandler = npcHandler, text = "He lived in a lonely house in the south eastern part of Tibia beyond the mountains." })
keywordHandler:addKeyword({ "magic crystal" }, StdModule.say, { npcHandler = npcHandler, text = "The mystic crystal should be able to resurrect fresh corpses.." })
keywordHandler:addKeyword({ "xodet" }, StdModule.say, { npcHandler = npcHandler, text = "He runs a magic shop in the main road." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He runs an equipment shop close to the north gate of the city." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "He runs his magic shop in the southwest of the city. He sells runes and spells and helps you, if you want to become a sorcerer." })
keywordHandler:addKeyword({ "the first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "It's told that some hero killed him and absorbed his power." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "I could tell you much about all sorcerer spells, but you won't understand it. Anyway, feel free to ask me." })
keywordHandler:addKeyword({ "mana" }, StdModule.say, { npcHandler = npcHandler, text = "Mana is the source of all magic. If you use spells, it will drain mana from your energy pool. This mana regenerates slowly, if you eat, or if you drink those mana potions you can buy at Xodet's" })
keywordHandler:addKeyword({ "formula" }, StdModule.say, { npcHandler = npcHandler, text = "Which is the spell you need the formula to?" })
keywordHandler:addKeyword({ "spell" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, I can tell you a lot about all sorcerer spells. Feel free to ask me about the spell name or the formula to cast it." })
keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, text = "If you search someone, this spell will give you an idea of the direction you must head. You will not be able to see, whether he is below or above you." })
keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, text = "A ray of light will emerge from your flat hand to illuminate your environment." })
keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, text = "The paths to the next temple are long. Even in Tibia. So learn this spell, and be able to heal yourself during your travels. This spell will only cure small wounds, but it is pretty helpful." })
keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, { npcHandler = npcHandler, text = "You can activate this spell by pointing your index finger in the direction of your enemy, conjure the power of your rune and shoot the magic missiles in your enemy's body." })
keywordHandler:addKeyword({ "antidote" }, StdModule.say, { npcHandler = npcHandler, text = "This spell sucks the venom out of your veins, that some enemy might have injected." })
keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, text = "This spell will cure more wounds or greater ones at once. This is of course more 'mana intensive', but everybody will sooner or later get in a situation where mana is nothing - compared to life." })
keywordHandler:addKeyword({ "poison field" }, StdModule.say, { npcHandler = npcHandler, text = "This spell will create a single field of poisonous gas. Cast it on a creature you were not able to arrange a peace treaty with. If it has no antidote, watch what could happen if you forget yours." })
keywordHandler:addKeyword({ "fire field" }, StdModule.say, { npcHandler = npcHandler, text = "This spell acts similar to the 'poison field' spell, except that you create fire instead of poisonous gas. Don't enter it yourself or you will realize why it is said that 'fire eats everything'." })
keywordHandler:addKeyword({ "energy field" }, StdModule.say, { npcHandler = npcHandler, text = "This one will create a field of energy. Everyone stepping in will be struck from lightning. This field will not last as long as poison or fire fields, but it is more deadly." })
keywordHandler:addKeyword({ "heavy magic missile" }, StdModule.say, { npcHandler = npcHandler, text = "Remember the spell where you only got to wave your hand? Well, wave it twice and shoot a heavy magic missile at your enemy. This spell will create a rune with five charges." })
keywordHandler:addKeyword({ "magic shield" }, StdModule.say, { npcHandler = npcHandler, text = "Well, mages are more bookworms than sportsmen, and as such often neglect their physical fitness. In ancient tomes lies the power to use mana as an equivalent to life. So use this spell to survive." })
keywordHandler:addKeyword({ "fireball" }, StdModule.say, { npcHandler = npcHandler, text = "A perfect symbiosis of fire and wind. More is not to be said about this spell. Use this fireball as a warning or as your defence, but don't burn your fingers." })
keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, text = "Trapped again between fire, poison and energy fields? This spell will give you the ability to destruct the fields, so you can pass safely." })
keywordHandler:addKeyword({ "fire wave" }, StdModule.say, { npcHandler = npcHandler, text = "Turn to you opponent and release the forces of nature with a whisper of your voice. A triangle of fire will burn all persons in your view, so take care, in which direction you look!" })
keywordHandler:addKeyword({ "ultimate healing" }, StdModule.say, { npcHandler = npcHandler, text = "This spell is able to cure almost every injury at a higher cost than the other healing spells." })
keywordHandler:addKeyword({ "great fireball" }, StdModule.say, { npcHandler = npcHandler, text = "Imagine scaling the normal fireball by two and raising the fire temperature." })
keywordHandler:addKeyword({ "fire bomb" }, StdModule.say, { npcHandler = npcHandler, text = "With a snip of your finger you can cover the floor with a burning carpet that keeps on burning for a while." })
keywordHandler:addKeyword({ "firebomb" }, StdModule.say, { npcHandler = npcHandler, text = "With a snip of your finger you can cover the floor with a burning carpet that keeps on burning for a while." })
keywordHandler:addKeyword({ "poison wall" }, StdModule.say, { npcHandler = npcHandler, text = "With this one you can create a huge wall of poisonous gas. Many monsters will be too scared to pass the wall and if they do, they will choke from nausea." })
keywordHandler:addKeyword({ "fire wall" }, StdModule.say, { npcHandler = npcHandler, text = "As the poison wall, this spell creates an even larger wall of fire, burning everyone who passes." })
keywordHandler:addKeyword({ "firewall" }, StdModule.say, { npcHandler = npcHandler, text = "As the poison wall, this spell creates an even larger wall of fire, burning everyone who passes." })
keywordHandler:addKeyword({ "energy wall" }, StdModule.say, { npcHandler = npcHandler, text = "Attracts lightning bolts from the sky, to form a giant wall, seriously damaging everyone who passes." })
keywordHandler:addKeyword({ "energybeam" }, StdModule.say, { npcHandler = npcHandler, text = "A ray of energy will strike everyone in your current direction" })
keywordHandler:addKeyword({ "explosion" }, StdModule.say, { npcHandler = npcHandler, text = "A strong blast of fire wounds the opponent you point at, and the adjacent squares." })
keywordHandler:addKeyword({ "energy wave" }, StdModule.say, { npcHandler = npcHandler, text = "Shoots a triangular bundle of lightning bolts in the direction you look." })
keywordHandler:addKeyword({ "great energy beam" }, StdModule.say, { npcHandler = npcHandler, text = "A lightning bolt strikes the point you look at." })
keywordHandler:addKeyword({ "invisible" }, StdModule.say, { npcHandler = npcHandler, text = "This spell drains the colors out of you body, making yourself invisible for an hour or two." })
keywordHandler:addKeyword({ "summon creature" }, StdModule.say, { npcHandler = npcHandler, text = "This one gives you the ability to summon monsters that aid you in your battles." })
keywordHandler:addKeyword({ "creature illusion" }, StdModule.say, { npcHandler = npcHandler, text = "A good one to scare children. You can change your appearance to any monster. You can be as handsome as a ghoul!" })
keywordHandler:addKeyword({ "sudden death" }, StdModule.say, { npcHandler = npcHandler, text = "The best spell for deciding a battle within seconds. The spell tries to interrupt the opponents heart beat, leading to his instant death in most cases." })
keywordHandler:addKeyword({ "ultimate explosion" }, StdModule.say, { npcHandler = npcHandler, text = "A strong blast of fire wounds the opponent you point at, and the adjacent squares." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
