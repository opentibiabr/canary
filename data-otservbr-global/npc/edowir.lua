local internalNpcName = "Edowir"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 58,
	lookLegs = 96,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "I'm just an old man, but I know a lot about Tibia." },
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

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I gather wisdom and knowledge. I am also an astrologer." })

npcHandler:setMessage(MESSAGE_GREET, "Oh, hello |PLAYERNAME|! How nice of you to visit an old man like me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Come back whenever you're in need of wisdom.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back whenever you're in need of wisdom.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "brotherhood of bones" }, StdModule.say, { npcHandler = npcHandler, text = "This brotherhood was an secret society of necromancers and followers of purest evil. They were vanquished long ago by their arch enemies, the Nightmare Knights." })
keywordHandler:addKeyword({ "triangle of terror" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The Triangle of Terror is a cabal of three archdemons that have put aside their quarrels to establish some power in the shadows of the Ruthless Seven. Although they are all very mighty demons, compared to one of the seven, they appear weak ... So they try not to interfere much with the doings of the seven and look for power elsewhere. Their members are Morgaroth, the schemer, Ghazbaran, the lord of blades and Zoralurk, the demon with the thousand faces.",
})
keywordHandler:addKeyword({ "nightmare knights" }, StdModule.say, { npcHandler = npcHandler, text = "The Nightmare Knights were an ancient order dedicated to fight evil. They were guided by prophetic dreams. The order ceased to exist after their war against the Brotherhood of Bones." })
keywordHandler:addKeyword({ "stone skin amulet" }, StdModule.say, { npcHandler = npcHandler, text = "Though they possess only a few charges, stone skin amulets are sought after because they offer complete protection from physical damage." })
keywordHandler:addKeyword({ "war of the djinn" }, StdModule.say, { npcHandler = npcHandler, text = "Although some priests claim that a war was fought on behalf of the gods, it seems more likely that this was kind of a civil war between the Djinn of good and the Djinn of evil." })
keywordHandler:addKeyword({ "necromant nectar" }, StdModule.say, { npcHandler = npcHandler, text = "There is no such thing, believe me. The dead don't care for taste." })
keywordHandler:addKeyword({ "shielding amulet" }, StdModule.say, { npcHandler = npcHandler, text = "These amulets are a more powerful version of the elven amulets. They were created by a race long gone from this plane, and offer significant protection against every kind of damage." })
keywordHandler:addKeyword({ "strange talisman" }, StdModule.say, { npcHandler = npcHandler, text = "These amulets protect you against harm from energy attacks and magic fields." })
keywordHandler:addKeyword({ "chalice of life" }, StdModule.say, { npcHandler = npcHandler, text = "This chalice was a tool of the gods which they created to make their task to create life easier. Zathroth who lacked the knowledge of creation stole that chalice and used it to spawn his evil minions." })
keywordHandler:addKeyword({ "demon overlords" }, StdModule.say, { npcHandler = npcHandler, text = "The overlords of the demonkind are more powerful than even demonlords are. They are nearly indestructible. Armoured with layers of impenetrable hide and endowed with awesome magical power, demon overlords are true incarnation of death." })
keywordHandler:addKeyword({ "pits of inferno" }, StdModule.say, { npcHandler = npcHandler, text = "An infernal place in which the nightmare knights created a base to fight the minions of evil. It was lost when the Ruthless Seven conquered it." })
keywordHandler:addKeyword({ "plains of havoc" }, StdModule.say, { npcHandler = npcHandler, text = "Somewhere in the Plains of Havoc, where the Necromant King was defeated, lies the secret entrance to the Pits of Inferno." })
keywordHandler:addKeyword({ "dragon necklace" }, StdModule.say, { npcHandler = npcHandler, text = "The core piece of these amulets is a little dragon scale. It protects you to some extent against fire damage." })
keywordHandler:addKeyword({ "garlic necklace" }, StdModule.say, { npcHandler = npcHandler, text = "This charm, feared and despised by the undead, protects your lifeforce from life-draining powers." })
keywordHandler:addKeyword({ "platinum amulet" }, StdModule.say, { npcHandler = npcHandler, text = "These powerful amulets are usually blessed by some god. They offer additional armour and protection." })
keywordHandler:addKeyword({ "ring of healing" }, StdModule.say, { npcHandler = npcHandler, text = "This ring increases the rate with which you heal your physical wounds." })
keywordHandler:addKeyword({ "ruthless seven" }, StdModule.say, { npcHandler = npcHandler, text = "They are more than a myth, they are a horrible reality. It is possible that they still reside in the pits of inferno." })
keywordHandler:addKeyword({ "amulet of life" }, StdModule.say, { npcHandler = npcHandler, text = "These amulets were created and enchanted by powerful magicians and priests. They protect both body and soul from the losses caused by the trauma of death." })
keywordHandler:addKeyword({ "mesh kaha rogh" }, StdModule.say, { npcHandler = npcHandler, text = "The so-called singing steel causes a constant humming while it is forged. It is said this was a sign of its absorbing magic powers in the process, and it was presumably easy to enchant. ... Sadly, the secret where to mine or how to create this ore has been lost in the course of time." })
keywordHandler:addKeyword({ "paradox tower" }, StdModule.say, { npcHandler = npcHandler, text = "The Paradox Tower was home of a mighty but mad wizard. It is said that only the cunning and mad can brave the tests of that tower to gain its treasures." })
keywordHandler:addKeyword({ "certain human" }, StdModule.say, { npcHandler = npcHandler, text = "This human showed no fear and did not yield under torture. They could bend him, but they never managed to break him. Impressed by this mortal, Gabel talked to him and learned about his philosophy." })
keywordHandler:addKeyword({ "banshee queen" }, StdModule.say, { npcHandler = npcHandler, text = "The legendary banshee queen is incredibly old and likely next to invincible. She's rumoured to have her lair in the deepest caverns of the ghostlands. She seems to be more likely to talk than her sisters, but is certainly even more evil than them." })
keywordHandler:addKeyword({ "mount sternum" }, StdModule.say, { npcHandler = npcHandler, text = "Behind the mountain lies a land of great danger." })
keywordHandler:addKeyword({ "bronze amulet" }, StdModule.say, { npcHandler = npcHandler, text = "Some creatures are able to attack your magic power rather than your lifeforce. This amulet bestows some protection against those attacks." })
keywordHandler:addKeyword({ "silver amulet" }, StdModule.say, { npcHandler = npcHandler, text = "This amulet purifies your blood. It will reduce the damage caused by poison." })
keywordHandler:addKeyword({ "evil minions" }, StdModule.say, { npcHandler = npcHandler, text = "The Djinn were the result of his first attempts. They were powerful and quite evil, but not as evil as Zathroth wished and quite independent in their thinking. Finally he discarded them and decided his second try would become his masterpiece." })
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "A shame he's gone. He could have become somewhat of a tourist magnet." })
keywordHandler:addKeyword({ "elven amulet" }, StdModule.say, { npcHandler = npcHandler, text = "These ancient elven artefacts are highly enchanted and grant some protection against any form of damage." })
keywordHandler:addKeyword({ "za'kalortith" }, StdModule.say, { npcHandler = npcHandler, text = "This is the metal of 'evil', the hell-forged iron no ordinary flames can melt. It is rumoured to be harvested in hell from iron rocks in which damned souls were imprisoned." })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I am fine, thank you." })
keywordHandler:addKeyword({ "masterpiece" }, StdModule.say, { npcHandler = npcHandler, text = "Zathroth channelled all the hatred and foulness he could muster. He added the burning rage of his son Blog and mixed it with fire. The energy that was released destroyed the chalice, but Zathroth had succeeded in creating the first demon." })
keywordHandler:addKeyword({ "soul vortex" }, StdModule.say, { npcHandler = npcHandler, text = "The gods created the vortex to guide powerful souls to our world so they might join the battle for creation." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "Although lovely, the city of the elves lacks the grace and the vibrance of the elven cities of old. The elves are still working on improvement of their settlement." })
keywordHandler:addKeyword({ "shadowthorn" }, StdModule.say, { npcHandler = npcHandler, text = "The elves of Shadowthorn are hosile to intruders. Their Kuridai leaders practise some sinister cults and the other castes are more their minions then their equals." })
keywordHandler:addKeyword({ "magic items" }, StdModule.say, { npcHandler = npcHandler, text = "Magic items are numerous. If you would like some details, please ask me about a specific item." })
keywordHandler:addKeyword({ "stealthring" }, StdModule.say, { npcHandler = npcHandler, text = "These rings were created by an ancient, long since forgotten race. It is said they valued secrecy above all. They used these magic rings to make themselves invisible." })
keywordHandler:addKeyword({ "magic metal" }, StdModule.say, { npcHandler = npcHandler, text = "There are several kinds of magic metals in our world, the best known are called Mesh Kaha Rogh, Za'Kalortith, Uth'Byth, Uth'Morc, Uth'Amon, Uth'Maer, Uth'Doon, and Zatragil." })
keywordHandler:addKeyword({ "philosophy" }, StdModule.say, { npcHandler = npcHandler, text = "The human whom the Djinn had caught was none other but Daraman. The mighty Gabel was intrigued by his philosophy and changed his ways according to Daraman's teachings." })
keywordHandler:addKeyword({ "archdemons" }, StdModule.say, { npcHandler = npcHandler, text = "The archdemons are few, and extremely rare. And a good thing, too, for they are the rulers of the demon race. They are vain and powerhungry creatures who tend to form only small cabals and fight each other instead of allying against creation." })
keywordHandler:addKeyword({ "ghostlands" }, StdModule.say, { npcHandler = npcHandler, text = "The ancient structures that were found deep beneath the ghostlands were built by an unkown race for an unknown purpose. It's quite certain that, whatever they were once used for, they now cause madness and ghost sightings in the surrounding area." })
keywordHandler:addKeyword({ "mintwallin" }, StdModule.say, { npcHandler = npcHandler, text = "The underground city of the minotaurs can be reached through a dangerous passage from the old temple." })
keywordHandler:addKeyword({ "old temple" }, StdModule.say, { npcHandler = npcHandler, text = "In the old days the underground temple was built for the glory of Banor after a victory over the orcish hordes. It is now an abandoned and dreary place overrun by rotworms." })
keywordHandler:addKeyword({ "energyring" }, StdModule.say, { npcHandler = npcHandler, text = "These rings were created by the sorcerers' guilds of old. They temporarily provide their wielders with a shield of magic." })
keywordHandler:addKeyword({ "knowledge" }, StdModule.say, { npcHandler = npcHandler, text = "Well, just ask me about anything that might be of interest. We will see if I can help you." })
keywordHandler:addKeyword({ "civil war" }, StdModule.say, { npcHandler = npcHandler, text = "In the war of the Djinn citys were levelled, lands were cursed and islands sunk. Finally, Malor was caught and imprisoned in an enchanted bottle. His followers fled this plane, while the good djinn laid to rest to recover their strength." })
keywordHandler:addKeyword({ "teachings" }, StdModule.say, { npcHandler = npcHandler, text = "The teachings of asceticism, inner peace and ascension appealed to the Djinn, although in the beginning this was probably only because of his vanity and his greed for divinity. However, Malor and his followers opposed him." })
keywordHandler:addKeyword({ "morgaroth" }, StdModule.say, { npcHandler = npcHandler, text = "Morgaroth belongs to the cabal Triangle of Terror. He usually has minions to do his work rather than doing it himself. Although sometimes he enters our world in person to inspire the fear his cabal is built upon." })
keywordHandler:addKeyword({ "ghazbaran" }, StdModule.say, { npcHandler = npcHandler, text = "Ghazbaran is a member of the demonic cabal Triangle of Terror. He likes the physical challenge and combat as much as the pain and death he inflicts." })
keywordHandler:addKeyword({ "orshabaal" }, StdModule.say, { npcHandler = npcHandler, text = "Orshabaal is one of the many servants of the Ruthless Seven. By far weaker than his masters, he seems to have developed some kind of inferiority complex which he tries to compensate by raiding our world and slaying as many innocents as he can." })
keywordHandler:addKeyword({ "necromant" }, StdModule.say, { npcHandler = npcHandler, text = "How could they try to understand death, if they don't care to understand life?" })
keywordHandler:addKeyword({ "kazordoon" }, StdModule.say, { npcHandler = npcHandler, text = "The ancient fortress city of the dwarfs was carved into the mountain known as 'The Big Old One'. It is quite hidden and heavily guarded to withstand any assault." })
keywordHandler:addKeyword({ "rookgaard" }, StdModule.say, { npcHandler = npcHandler, text = "It was on Rookgaard where the soul vortex appeared. The Thaian kingdom holds an outpost there to protect the vortex and to guide the newly-arrived souls." })
keywordHandler:addKeyword({ "powerring" }, StdModule.say, { npcHandler = npcHandler, text = "This kind of ring will increase your skill when fighting with bare hands." })
keywordHandler:addKeyword({ "mightring" }, StdModule.say, { npcHandler = npcHandler, text = "This ring will give you limited protection against any kind of damage." })
keywordHandler:addKeyword({ "swordring" }, StdModule.say, { npcHandler = npcHandler, text = "This ring will increase your skill when wielding swords." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "The ancient dwarven kings forged it using magic metal , which they took from cyclopses who found it in the heart of a fallen star." })
keywordHandler:addKeyword({ "sorcerer" }, StdModule.say, { npcHandler = npcHandler, text = "Mages claim to be wise, but how wise can it be to sacrifice your life to books and scrolls and not for the people?" })
keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "The town of Darashia is built around one of the few sweet water supplies of Darama. It is famous for its sand wasp honey and its sandworm stew." })
keywordHandler:addKeyword({ "zoralurk" }, StdModule.say, { npcHandler = npcHandler, text = "Zoralurk is said to be a member of the demon cabal called Triangle of Terror. She is rumoured to wander the lands in many disguises, poisoning the body and minds of people by word or deed." })
keywordHandler:addKeyword({ "abdaisim" }, StdModule.say, { npcHandler = npcHandler, text = "The Abdaisim are what humans would call 'independent elves'. They take shelter wherever they might find it, are wanderers and explorers. They only keep loose contact with the elven society." })
keywordHandler:addKeyword({ "deraisim" }, StdModule.say, { npcHandler = npcHandler, text = "One could call the Deraisim the scouts and rangers of elvenkind. Although all elves are formidable in that area, the Deraisim excel them all." })
keywordHandler:addKeyword({ "zathroth" }, StdModule.say, { npcHandler = npcHandler, text = "Zathroth is the dark twin of Uman. They are one and they are two separate entities. We mortals can't really grasp this concept. He is the patron of dark magic and even darker secrets, the lust for dominance through cunning, and manipulation." })
keywordHandler:addKeyword({ "clubring" }, StdModule.say, { npcHandler = npcHandler, text = "This ring will increase your skill when wielding a club weapon." })
keywordHandler:addKeyword({ "lifering" }, StdModule.say, { npcHandler = npcHandler, text = "These rings improve your regenerative powers, accelerating the recovery of both your mana and your lifeforce." })
keywordHandler:addKeyword({ "uth'byth" }, StdModule.say, { npcHandler = npcHandler, text = "This steel absorbs magic. While it is of inferior quality compared to ordinary steel, its absorbing qualities make it important though." })
keywordHandler:addKeyword({ "uth'morc" }, StdModule.say, { npcHandler = npcHandler, text = "What makes this black steel exceptional is its lightness and peculiar property of lacking the common steel 'noise'. It is also called 'silent steel' or 'thief's steel' for this reason." })
keywordHandler:addKeyword({ "uth'amon" }, StdModule.say, { npcHandler = npcHandler, text = "The luminescent brightsteel is used for artwork mainly. In ancient times, items of great magic power were crafted using brightsteel. Those crafts were lost with the races who held the secret to them." })
keywordHandler:addKeyword({ "uth'maer" }, StdModule.say, { npcHandler = npcHandler, text = "The dwarfs call it heartiron and claim it is part of the heart of The Big Old One. Therefore, they hold it sacred and its use is limited and regulated." })
keywordHandler:addKeyword({ "uth'doon" }, StdModule.say, { npcHandler = npcHandler, text = "The dwarven high steel is relatively common but expensive and still hard to come by. The elite dwarven weaponry and armours are made of Uth'Doon." })
keywordHandler:addKeyword({ "zatragil" }, StdModule.say, { npcHandler = npcHandler, text = "The so-called dreamsilver is a legendary metal. Almost everything we know about it are rumours only." })
keywordHandler:addKeyword({ "paladin" }, StdModule.say, { npcHandler = npcHandler, text = "A paladin is more than just a knight armed with a bow and some spells, though most seem to be unaware of that fact." })
keywordHandler:addKeyword({ "riddler" }, StdModule.say, { npcHandler = npcHandler, text = "As far as I can tell, this creature is not fond of cheaters and won't allow them to pass his tests." })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, text = "Dungeons are a place of danger, not of joy. Keep that in mind on your travels." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "Man or monster, the difference is often just a matter of hides and scales." })
keywordHandler:addKeyword({ "daraman" }, StdModule.say, { npcHandler = npcHandler, text = "Daraman was a sage with ambition, that's for sure. His philosophy centred around the idea that by controlling yourself you could improve yourself. The closer you are coming to perfection, the closer you are to ascending to divinity." })
keywordHandler:addKeyword({ "banshee" }, StdModule.say, { npcHandler = npcHandler, text = "The banshees are creatures that grief and despair turned into vengeful spirits after their death. Their wail is deadly, and they draw new strength from the pain and fear of others." })
keywordHandler:addKeyword({ "endulos" }, StdModule.say, { npcHandler = npcHandler, text = "Endulos was not a great warrior, but a man of wit and genius. After many of his brethren of the Nightmare Knights had fallen prey to the beast, he came up with a cunning plan to end this threat." })
keywordHandler:addKeyword({ "goshnar" }, StdModule.say, { npcHandler = npcHandler, text = "The Necromant King. He is dead forever, and that is the nicest thing I can say about him. May he rot in his tomb." })
keywordHandler:addKeyword({ "dwarves" }, StdModule.say, { npcHandler = npcHandler, text = "The small but strong dwarves are tireless workers and fierce warriors. They are familiar with several crafts and mastered most of them. In our days their smithing skills are rivalled only by those of the cyclopses." })
keywordHandler:addKeyword({ "kuridai" }, StdModule.say, { npcHandler = npcHandler, text = "The Kuridai are the craftsmen and warriors of elvenkind. They are always moving, always scheming. They are the most aggressive elves and distrust outsiders. An outsider might be each non-Kuridai to them." })
keywordHandler:addKeyword({ "teshial" }, StdModule.say, { npcHandler = npcHandler, text = "Its said that those elves were the masters of the dreams. Which many consider a special brand of magic. They seem to have vanished from the face of Tibia ages ago, however, and their fate is unknown." })
keywordHandler:addKeyword({ "cyclops" }, StdModule.say, { npcHandler = npcHandler, text = "Cyclopses are seen as the smiths of Blog, whom they call 'the ragehammer' or 'ragehammerer'. Indeed their skills create mostly crude and nasty-looking weapons and armor, but which are incredibly effective nonetheless." })
keywordHandler:addKeyword({ "axering" }, StdModule.say, { npcHandler = npcHandler, text = "This ring will increase your skill when wielding any kind of axe." })
keywordHandler:addKeyword({ "edowir" }, StdModule.say, { npcHandler = npcHandler, text = "That's me, but don't worry about remembering my name. I will forget your name as well." })
keywordHandler:addKeyword({ "gossip" }, StdModule.say, { npcHandler = npcHandler, text = "Rumours are an unsafe path to follow." })
keywordHandler:addKeyword({ "rumour" }, StdModule.say, { npcHandler = npcHandler, text = "Rumours are an unsafe path to follow." })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, text = "Those who live by the sword get shot by those who don't." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Knights could be artists, but tend to become sellswords." })
keywordHandler:addKeyword({ "knight" }, StdModule.say, { npcHandler = npcHandler, text = "Knights could be artists, but tend to become sellswords." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Druids seek enlightenment in nature, but they often just find what they brought with them." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "Mages claim to be wise, but how wise can it be to sacrifice your life to books and scrolls and not for the people?" })
keywordHandler:addKeyword({ "jester" }, StdModule.say, { npcHandler = npcHandler, text = "Who laughs last, thinks slowest." })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "A strong wall may protect from an assault, but what will protect you from the enemy within?" })
keywordHandler:addKeyword({ "drefia" }, StdModule.say, { npcHandler = npcHandler, text = "The dreaded town of Drefia was once a haven for heretics, necromancers and demon worshippers. Its was destroyed in the war of the Djinn." })
keywordHandler:addKeyword({ "darama" }, StdModule.say, { npcHandler = npcHandler, text = "The desert lands of Darama are harsh and unforgiving. Therefore Daraman led his people there to found a new community based upon his teachings." })
keywordHandler:addKeyword({ "cabals" }, StdModule.say, { npcHandler = npcHandler, text = "There are at least five demonic cabals of archdemons. The ruthless seven are the most prominent and powerful." })
keywordHandler:addKeyword({ "defile" }, StdModule.say, { npcHandler = npcHandler, text = "Whatever the original meaning of that underground complex was, it is now like an open wound in the nearby lands, spreading madness and attracting all kinds of ghosts and apparitions." })
keywordHandler:addKeyword({ "legend" }, StdModule.say, { npcHandler = npcHandler, text = "As far as we know, once a terrible beast roamed the lands we now call the Plains of Havoc. It was so fierce that no one dared to even dream about killing it. It was finally tricked by the knight Endulos." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "A city in the far north. It separated itself from the Thaian kingdom about 100 years ago. Now it is ruled by a dynasty of queens." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "Venore is a centre of commerce and trade. Its ambitious trade barons are nominally subjects of the Thaian kingdom." })
keywordHandler:addKeyword({ "castes" }, StdModule.say, { npcHandler = npcHandler, text = "The elven society is dividded into certain castes, the cenath, the kuridai, the deraisim, the abdaisim and the legendary teshial." })
keywordHandler:addKeyword({ "cenath" }, StdModule.say, { npcHandler = npcHandler, text = "The Cenath favour magic above all other. They are the keepers of elven lore and wisdom. They are responsible for the astounding feats of druidic magic the elves are capable of." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "I believe that true love is stronger than all magic, don't you agree?" })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "A paladin is more than just a knight armed with a bow and some spells, though most seem to be unaware of that fact." })
keywordHandler:addKeyword({ "druid" }, StdModule.say, { npcHandler = npcHandler, text = "Druids seek enlightenment in nature, but they often just find what they brought with them." })
keywordHandler:addKeyword({ "sewer" }, StdModule.say, { npcHandler = npcHandler, text = "Sewers are sometimes the safer ways to get where you want to go." })
keywordHandler:addKeyword({ "djinn" }, StdModule.say, { npcHandler = npcHandler, text = "Legend has it that the Djinn were created by Zathroth by using the stolen chalice of life. They roamed the world for Aeons causing strife and despair until Gabel, one of their lords, met a very special human." })
keywordHandler:addKeyword({ "malor" }, StdModule.say, { npcHandler = npcHandler, text = "Malor was second in power only to Gabel and his followers among the Djinn were many. It was not easy for the evil Djinn to change their ways, and many preferred to follow Malor instead of Gabel. In the end a civil war erupted." })
keywordHandler:addKeyword({ "gabel" }, StdModule.say, { npcHandler = npcHandler, text = "Gabel was the most powerful among the Djinn lords. He was cruel and merciless, until one day his minions brought a certain human to him whom they had captured and tortured." })
keywordHandler:addKeyword({ "demon" }, StdModule.say, { npcHandler = npcHandler, text = "Demons are the servants of evil. More or less devoted servers of Zathroth they cause strife and havoc wherever they appear. Their masters are known as Demonlords, Demon Overlords and Archdemons." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "If Tibia is a fallen god, does that makes us the maggots crawling on it?" })
keywordHandler:addKeyword({ "edron" }, StdModule.say, { npcHandler = npcHandler, text = "Edron is the latest colony of the Thaian kingdom. However, structures of an earlier colonisation have been found. We cannot tell if those inhabitants were human or of any other known race." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "Thais is the capital of an ancient human kingdom. Once its rule was more or less undisputed. In the years the strength of the Thaian kingdom eroded by different events." })
keywordHandler:addKeyword({ "dwarf" }, StdModule.say, { npcHandler = npcHandler, text = "The small but strong dwarves are tireless workers and fierce warriors. They are familiar with several crafts and mastered most of them. In our days their smithing skills are rivalled only by those of the cyclopses." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Edowir, but don't worry about remembering my name. I will forget your name as well." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time is a pillar and our lives wind around it like vines." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "Who laughs last, thinks slowest." })
keywordHandler:addKeyword({ "joke" }, StdModule.say, { npcHandler = npcHandler, text = "Who laughs last, thinks slowest." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Kings are children adorned with crowns." })
keywordHandler:addKeyword({ "hugo" }, StdModule.say, { npcHandler = npcHandler, text = "I think you are referring to the beast Hugo that is said to still haunt the Plains of Havoc. The legends which tell of this creature are ancient and almost forgotten." })
keywordHandler:addKeyword({ "plan" }, StdModule.say, { npcHandler = npcHandler, text = "He lured Hugo into a trap. Bound by roots and stones charged with powerful magic he could not move anymore. Now, the beast lies trapped in a hidden cave for all eternity." })
keywordHandler:addKeyword({ "cave" }, StdModule.say, { npcHandler = npcHandler, text = "The legends tell us that the Nightmare Knights trapped it beneath one of their fortresses, or rather that they built a fortress on top of his eternal prison." })
keywordHandler:addKeyword({ "uman" }, StdModule.say, { npcHandler = npcHandler, text = "Uman is the light twin of Zathroth. Their unity and separation at once is a concept we cannot hope to grasp. He is the patron of light magic, the knowledge that benefits all and brings progress to the society." })
keywordHandler:addKeyword({ "blog" }, StdModule.say, { npcHandler = npcHandler, text = "Blog is the god of rage and fierce battle. He's also the patron of power, although a power to oppress and bully others around. He is the son of Zathroth and one of the Tibian suns." })
keywordHandler:addKeyword({ "age" }, StdModule.say, { npcHandler = npcHandler, text = "Growing old is mandatory, growing up is optional." })
keywordHandler:addKeyword({ "old" }, StdModule.say, { npcHandler = npcHandler, text = "Growing old is mandatory, growing up is optional." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "Learn about the gods to learn from the gods." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
