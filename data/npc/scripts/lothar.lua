local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local voices = { {text = 'I enjoy the peace and solitude out here. You\'re welcome to be my guest as long as you behave in a quiet and tolerable manner.'} }
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'here'}, StdModule.say, {npcHandler = npcHandler, text = "Some call me {animal} whisperer. Others say I'm just crazy. I refer to myself as a simple {stable} keeper."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Some call me {animal} whisperer. Others say I'm just crazy. I refer to myself as a simple {stable} keeper."})
keywordHandler:addKeyword({'animal'}, StdModule.say, {npcHandler = npcHandler, text = "I love all animals, whether small or big. I also believe each one, even the wildest and most ferocious being, can be talked to, understood and {tamed}."})
keywordHandler:addKeyword({'stable'}, StdModule.say, {npcHandler = npcHandler, text = "It's my dream to shelter many different tamed animals. Maybe one day that dream will come true."})
keywordHandler:addKeyword({'tamed'}, StdModule.say, {npcHandler = npcHandler, text = "Well, usually you can tame animals with the help of a few simple items. If you've found such an {item}, show it to me and I might be able to help you with instructions on the taming process."})
keywordHandler:addKeyword({'item'}, StdModule.say, {npcHandler = npcHandler, text = "Well? Which item have you found and require advice for?"})
keywordHandler:addKeyword({'bag of apple slices'}, StdModule.say, {npcHandler = npcHandler, text = "That's among the favourite foods of donkeys, as far as I know. It's a shame I haven't really seen any donkey around. It could require a magic trick to actually get to meet one."})
keywordHandler:addKeyword({'bamboo leaves'}, StdModule.say, {npcHandler = npcHandler, text = "Pandas love to eat bamboo leaves, but the Tiquandan pandas are actually not that skilled at climbing, so they have a hard time getting some for themselves. You might be able to tame one with them."})
keywordHandler:addKeyword({'carrot on a stick'}, StdModule.say, {npcHandler = npcHandler, text = "I heard that terror birds really love carrots. I'd try waving it in front of one of those."})
keywordHandler:addKeyword({'decorative ribbon'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, what a pretty ribbon. Reminds me of the elusive dragonlings - they're quite elegant and vain. They would probably welcome a decorative element. They're sometimes spotted during volcano eruptions."})
keywordHandler:addKeyword({'diapason'}, StdModule.say, {npcHandler = npcHandler, text = "What a neat little elvish gadget. Did you know a diapason works with vibrations to create sound? I actually think this could work on a creature made of crystals."})
keywordHandler:addKeyword({'fist on a stick'}, StdModule.say, {npcHandler = npcHandler, text = "I'm against violence towards any creature. I've heard those barbarians in the desert use it for disobedient dromedaries."})
keywordHandler:addKeyword({'four-leaf clover'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, what a nice little plant! Did you know it's supposed to bring luck? So is the lady bug. Both of them might actually go well together."})
keywordHandler:addKeyword({'foxtail'}, StdModule.say, {npcHandler = npcHandler, text = "I've heard that there once was a gang of manta ray riders who liked to adorn their mantas with a foxtail. Don't ask me why, maybe they like how it floats in the wind when running really fast?"})
keywordHandler:addKeyword({'golem wrench'}, StdModule.say, {npcHandler = npcHandler, text = "What a strange device! This looks like a tool for someone who creates golems and modifies living creatures. You could probably tame a modded creature with it, but I doubt they live in the wild."})
keywordHandler:addKeyword({'giant shrimp'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, that's one of the favourite foods of a crustacea gigantica. I think you can just distract it with the food and quickly jump on its back."})
keywordHandler:addKeyword({'glow wine'}, StdModule.say, {npcHandler = npcHandler, text = "Have you ever encountered a magma crawler? They only eat and drink really hot things. You could probably try and make one drink some glow wine - and quickly mount it as long as it's drunk."})
keywordHandler:addKeyword({'golden can of oil'}, StdModule.say, {npcHandler = npcHandler, text = "Hm. What an interesting find. This is definitely not used for any sort of animal. Maybe a vehicle? I can imagine it could be used for a bike of some sorts."})
keywordHandler:addKeyword({'harness'}, StdModule.say, {npcHandler = npcHandler, text = "That looks like it might fit a draptor. If you can ever get close enough to one to catch it, I'd simply try putting it on while whispering calming words."})
keywordHandler:addKeyword({'hunting horn'}, StdModule.say, {npcHandler = npcHandler, text = "The sound of a hunting horn is often intimidating to forest creatures, but I heard that wild boars actually like it."})
keywordHandler:addKeyword({'iron loadstone'}, StdModule.say, {npcHandler = npcHandler, text = "Ironblights consist mainly of stone and iron. With a strong magnet like that you can basically force it to walk in the direction you're wanting it to."})
keywordHandler:addKeyword({'leather whip'}, StdModule.say, {npcHandler = npcHandler, text = "Try catching a midnight panther using that one. Don't hit the panther, mind you. Just let the whip crack in the air - I think that will work."})
keywordHandler:addKeyword({'leech'}, StdModule.say, {npcHandler = npcHandler, text = "As far as I know, leeches can be found in terrestrial, swampy areas. Leeches often help large animals such as water buffaloes to get rid of parasites."})
keywordHandler:addKeyword({'maxilla maximus'}, StdModule.say, {npcHandler = npcHandler, text = "You should show that giant jaw to a creature looking like the one you got it from. It will respect you when it sees those scary teeth."})
keywordHandler:addKeyword({'music box'}, StdModule.say, {npcHandler = npcHandler, text = "Where did you get that? What a rare treat. This must have been crafted by someone who truly loves both music and animals. I can't tell you anything else about it."})
keywordHandler:addKeyword({'nail case'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, a nail case..., I hate paring nails. But I heard gravediggers become trusting when they get the right treatment."})
keywordHandler:addKeyword({'nightmare horn'}, StdModule.say, {npcHandler = npcHandler, text = "How impressive, a nightmare horn. Have you ever encountered a shock head? Try hypnotizing them with your horn."})
keywordHandler:addKeyword({'reins'}, StdModule.say, {npcHandler = npcHandler, text = "You could probably ride a black sheep with these. Talk to it gently and carefully put on the reins."})
keywordHandler:addKeyword({'scorpion sceptre'}, StdModule.say, {npcHandler = npcHandler, text = "Wow, that's a rarity. Have you ever met one of those large sandstone scorpions? They're quite impressive. You need such a sceptre to show to one that you're its new master."})
keywordHandler:addKeyword({'slingshot'}, StdModule.say, {npcHandler = npcHandler, text = "That might be the only way to tame a bear. It has a sensitive spot right between the ears which will calm it down, but you're not strong enough for simple acupressure. Using the slingshot is likely to help you with that."})
keywordHandler:addKeyword({'slug drug'}, StdModule.say, {npcHandler = npcHandler, text = "As the name indicates - this can be used to make a slug much faster than it normally is! Once you've tamed it, it will race you wherever you want to go."})
keywordHandler:addKeyword({'sugar oat'}, StdModule.say, {npcHandler = npcHandler, text = "Create sugar oat by just mixing a bunch of sugar cane with a bunch of wheat. All horses love sugar oat! Sometimes when the horses from the horse station in Thais are on the loose, wild horses mix with the herd. Maybe they can be tamed?"})
keywordHandler:addKeyword({'sweet smelling bait'}, StdModule.say, {npcHandler = npcHandler, text = "The interesting part about that bait isn't the sweet stuff - it's the flies attracted to the sweet smell. Spiders love to eat flies, especially the Zaoan ones."})
keywordHandler:addKeyword({'tin key'}, StdModule.say, {npcHandler = npcHandler, text = "Hm! Now that's an interesting one. Where did you get that from? I could imagine it winds something up in a factory, but it's definitely not a normal animal."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "It's on the door."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "control unit") then
		npcHandler:say({
			'That\'s an interesting one, nothing like I have ever seen myself. What you describe is a device of which I heard that it grants literally \'complete\' control over some sort of... artificial thing? ...',
			'Well, if you ever happen to come about a stroke of luck and find such a thing - use it on an appropriate mount, it will probably be mechanical, driven by... something.'
		}, cid)
	elseif msgcontains(msg, "golden fir cone") then
		npcHandler:say({
			'Did you know that you can also create those by yourself? Trade a gold ingot with the sweaty cyclops in Ab\'Dendriel for a cup of molten gold. If you use that on a fir tree, you have a small chance to get a golden fir cone. ...',
			'Those are needed to impress the white deers that roam around Ab\'Dendriel sometimes, but I\'d wait until you are able to enrage one to make sure it has the necessary strength to carry you.'
		}, cid)
	elseif msgcontains(msg, "melting horn") then
		npcHandler:say({
			'It is said that ferocious creatures once thrived on lush islands in the far northern sea. They died aeons ago when times of great cold came and formed the icy wastes of Svargrond as we know them today. ...',
			'Travellers from the north have told stories of these creatures, watching them from within the ice in the deepest caves, still vigilant as if frozen in time. \'Ursagrodon\' they called them. ...',
			'With tinder and some kind of fireproof vessel, you could create a device to melt the ice surrounding their remains and see for yourself what this is all about.'
		}, cid)
	elseif isInArray({"arkarra", "stampor"}, msg) then
		npcHandler:say({
			'The stampor in the back? She\'s my friend, but she came to me out of her own free will. I must admit I\'ve never managed to tame any other stampor. ...',
			'I heard that there\'s some sort of voodoo magic which would allow you to summon a stampor, but I\'m not a voodoo expert, so I wouldn\'t know.'
		}, cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome to my humble hut, |PLAYERNAME|. What brings you {here}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care of yourself.")
npcHandler:addModule(FocusModule:new())
