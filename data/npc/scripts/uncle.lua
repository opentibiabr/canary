local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local fire = Condition(CONDITION_FIRE)
fire:setParameter(CONDITION_PARAM_DELAYED, true)
fire:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
fire:addDamage(25, 9000, -10)

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

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.SecretService.Quest, 1)
			npcHandler:say('Then welcome to the family.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.SecretService.AVINMission01, 4)
			player:setStorageValue(Storage.SecretService.Quest, 3)
			npcHandler:say('I hope you did not make this little pest too nervous. He isn\'t serving us too well by hiding under some stone or something like that. However, nicely done for your first job.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(7705, 1) then
				player:setStorageValue(Storage.SecretService.AVINMission02, 2)
				player:setStorageValue(Storage.SecretService.Quest, 5)
				npcHandler:say('Ah, yes. This will be a most interesting lecture.', cid)
			else
				npcHandler:say('Please bring me the file AH-X17L89.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 4 then
			player:setStorageValue(Storage.SecretService.AVINMission03, 4)
			player:setStorageValue(Storage.SecretService.Quest, 7)
			npcHandler:say('Does it not warm up your heart if you can bring a little joy to the people while doing your job? Well, don\'t get carried away, most part of your job is not warming up hearts but tearing them out.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			player:setStorageValue(Storage.SecretService.AVINMission04, 3)
			player:setStorageValue(Storage.SecretService.Quest, 9)
			npcHandler:say('Good work getting rid of that nuisance.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 6 then
			if player:removeItem(7708, 1) then
				player:setStorageValue(Storage.SecretService.AVINMission05, 2)
				player:setStorageValue(Storage.SecretService.Quest, 11)
				npcHandler:say('Fine, fine. This will serve us quite well. Ah, don\'t give me that look... you are not that stupid, are you?', cid)
			else
				npcHandler:say('Come back when you\'ve found the ring.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 7 then
			player:setStorageValue(Storage.SecretService.AVINMission06, 3)
			player:setStorageValue(Storage.SecretService.Quest, 13)
			npcHandler:say('Even if the present has not improved our relations, the weapons will enable the barbarians to put more pressure on Svargrond and Carlin. So in any case we profited from the present.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 8 then
			if player:removeItem(7699, 1) then
				player:setStorageValue(Storage.SecretService.Mission07, 2)
				player:setStorageValue(Storage.SecretService.Quest, 15)
				player:addItem(7962, 1)
				npcHandler:say({
				'You have proven yourself as very efficient. The future may hold great things for you in store ...',
				'Take this token of gratitude. I hope you can use well what you will find inside!'
				}, cid)
			else
				npcHandler:say('Please bring me proof of the mad technomancers defeat!', cid)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') then
		npcHandler:say('As you wish.', cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'join') then
		if player:getStorageValue(Storage.SecretService.Quest) < 1 then
			npcHandler:say({
				'Well, well, well! As you might know, we are entrusted by the Venorean tradesmen to ensure the safety of their ventures ...',
				'This task often puts our representatives in rather dangerous and challenging situations. On the other hand, you can expect a generous compensation for your efforts on our behalf...',
				'Just keep in mind though that we expect quick action and that we are rather intolerant to needless questions and moral doubts ...',
				'If you join our ranks, you cannot join the service of another city! So do I understand you correctly, you want to join our small business?'
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'mission') then
		if player:getStorageValue(Storage.SecretService.Quest) == 1 and player:getStorageValue(Storage.SecretService.TBIMission01) < 1 and player:getStorageValue(Storage.SecretService.CGBMission01) < 1 then
			player:setStorageValue(Storage.SecretService.Quest, 2)
			player:setStorageValue(Storage.SecretService.AVINMission01, 1)
			player:addItem(14326, 1)
			npcHandler:say('Let\'s start with a rather simple job. There is a contact in Thais with that we need to get in touch again. Deliver this note to Gamel in Thais. Get an answer from him. If he is a bit reluctant, be \'persuasive\'.', cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission01) == 3 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.SecretService.AVINMission01) == 4 and player:getStorageValue(Storage.SecretService.Quest) == 3 then
			player:setStorageValue(Storage.SecretService.Quest, 4)
			player:setStorageValue(Storage.SecretService.AVINMission02, 1)
			npcHandler:say({
				'Our Thaian allies are sometimes a bit forgetful. For this reason we are not always informed timely about certain activities. We won\'t insult our great king by pointing out this flaw ...',
				'Still, we are in dire need of these information so we are forced to take action on our own. Travel to the Thaian castle and \'find\' the documents we need. They have the file name AH-X17L89. ...',
				'Now go to Thaian castle and get the File.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission02) == 1 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.SecretService.AVINMission02) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 5 then
			player:setStorageValue(Storage.SecretService.Quest, 6)
			player:setStorageValue(Storage.SecretService.AVINMission03, 1)
			player:addItem(7706, 1)
			npcHandler:say({
				'The oppression of Carlin\'s men by their lunatic women is unbearable to some of our authorities. We see it as our honourable duty to support the male resistance in Carlin ...',
				'The poor guys have some speakeasy in the sewers. Bring them this barrel of beer with our kind regards to strengthen their resistance.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission03) == 3 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.SecretService.AVINMission03) == 4 and player:getStorageValue(Storage.SecretService.Quest) == 7 then
			player:setStorageValue(Storage.SecretService.Quest, 8)
			player:setStorageValue(Storage.SecretService.AVINMission04, 1)
			npcHandler:say({
				'As you know, our lovely city is a bastion of civilisation surrounded by numerous hazards. The nearby Plains of Havoc and the hostile elven town Shadowthorn are only a few of the obstacles we have to overcome on an almost daily basis ...',
				'Against all odds, we managed to gain some modest profit by exploiting these circumstances in one way or the other. Recently though, one of our neighbours went too far...',
				'In some ruin in the midst of the Green Claw Swamp, a dark knight had fancied himself as the lord of the swamp for quite a while ...',
				'For some years, we had some sort of gentleman\'s agreement. In exchange for some supplies and luxuries, the deranged knight used his ominous influence over the local bonelord species to supply us with ... certain goods ...',
				'However, lately the black knight has proven himself to be no gentleman at all. In a fit of unprovoked rage, he slew our emissary and almost all of his henchmen ...',
				'Even though we can live with this loss, it becomes obvious that the knight\'s madness gets worse which makes him unbearable as a neighbour. Find him in his hideout in the Green Claw Swamp and get rid of him.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission04) == 2 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 5
		elseif player:getStorageValue(Storage.SecretService.AVINMission04) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 9 then
			player:setStorageValue(Storage.SecretService.Quest, 10)
			player:setStorageValue(Storage.SecretService.AVINMission05, 1)
			npcHandler:say('I need you to locate a lost ring on the Isle of the Kings for me, get back to me once you have it.', cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission05) == 1 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 6
		elseif player:getStorageValue(Storage.SecretService.AVINMission05) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 11 then
			player:setStorageValue(Storage.SecretService.Quest, 12)
			player:setStorageValue(Storage.SecretService.AVINMission06, 1)
			player:addItem(7707, 1)
			npcHandler:say({
				'We try to establish new trade agreements with various potential customers. Sometimes we have to offer some presents in advance to ensure that trade is prospering and flourishing. It will be your task to deliver one of those little presents ...',
				'The northern barbarians are extremely hostile to us. The ones living in Svargrond are poisoned by the lies of agitators from Carlin. The barbarians that are also known as raiders are another story though ...',
				'Of course they are extremely wild and hostile but we believe that we will sooner or later profit from it when we are able to improve our relations. Please deliver this chest of weapons to the barbarians as a sign of our good will ...',
				'Unfortunately, most of them will attack you on sight. It will probably take some time until you find somebody that is willing to talk to you and to accept the weapons.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission06) == 2 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.SecretService.AVINMission06) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 13 then
			player:setStorageValue(Storage.SecretService.Quest, 14)
			player:setStorageValue(Storage.SecretService.Mission07, 1)
			npcHandler:say({
				'Some dwarven criminal called Blowbeard dares to blackmail our city. He threatens to destroy the whole city and demands an insane amount of gold ...',
				'Of course we are not willing to give him a single gold coin. It will be your job to get rid of this problem. Go and kill this infamous dwarf ...',
				'His laboratory is near the technomancer hall. Bring me his beard as proof of his demise.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.AVINMission06) == 3 and player:getStorageValue(Storage.SecretService.Mission07) == 1 then
			npcHandler:say('Do you have news to make old Uncle happy?', cid)
			npcHandler.topic[cid] = 8
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
