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

local vocations = {
          ['sorcerer'] = 0,
          ['druid'] = 1,
          ['paladin'] = 2,
          ['knight'] = {
               ['club'] = 3,
               ['axe'] = 4,
               ['sword'] = 5,
                    }
     }
local knightChoice = {}

local function greetCallback(cid)
    knightChoice[cid] = nil
    return true
end
local voices = {
     { text = "Not enough purple nightshade ... not enough liquid silver. *sigh*" },
     { text = "You think the full moon is a romantic affair? Think again!" },
     { text = "This place isn't safe. You should leave this island." }
}

npcHandler:addModule(VoiceModule:new(voices))
function creatureSayCallback(cid, type, msg)
     if not npcHandler:isFocused(cid) then
          if msg == "hi" or msg == "hello" then
               npcHandler:say("Greetings, visitor. I wonder what may lead you to this {dangerous} place.", cid)
               npcHandler:addFocus(cid)
          else
               return false
          end
     end

     local player = Player(cid)
     if not player then
          return false
     end

     if msgcontains(msg, 'tokens') then
     elseif isInArray({'dangerous', 'beasts'}, msg:lower()) then
          npcHandler:say("So you don't know it yet. This island, Grimvale, is affected by were-sickness. Many {pitiful}, who are stricken with the curse, dwell in the {tunnels} and caverns underneath the village and the nearby hurst.", cid)
     elseif msgcontains(msg, 'pitiful') then
          npcHandler:say("Yes, pitiful. For they are savage beasts now who regularly come up from below to attack the village. But once they were inhabitants of Grimvale, before they {changed}.", cid)
     elseif msgcontains(msg, 'changed') then
          npcHandler:say("Through a bite or even a scratch, you may be infected with the were-sickness. If that happens, there is little {hope} - until the next full moon you'll change into a were-creature, depending on the animal that hurt you.", cid)
     elseif msgcontains(msg, 'hope') then
          npcHandler:say("There is a plant, the purple nightshade. It blossoms exclusively in the light of the full moon and only underground, where the full moon's light is falling through fissures in the surface. Only this plant's blossoms are able to defeat the {were-sickness}.", cid)
     elseif isInArray({'were-sickness', 'curse'}, msg:lower()) then
          npcHandler:say({"It transforms peaceful villagers into savage beasts. We're not sure how this curse found the way into our small village. But one day it began. At first it befell just a few people. ...",
		  "In a full moon night they changed into bears and wolves, and tore apart their unsuspecting relatives while they were asleep. ...",
		  "Those merely wounded, first thought they were lucky. But then we realised they were changing, too. Later, others assumed the forms of badgers and boars also. ...",
		  "But that does not mean they were any less wild or dangerous than the others."}, cid)
     elseif msgcontains(msg, 'tunnels') then
          npcHandler:say({"We are not sure what they are doing down there. We're glad if they stay in the caverns and leave us alone. Only at full moon do they come up and threaten the island's surface and village. ...",
		  "I, however, have a {hunch} as to why they dwell so deep under the earth."}, cid)
     elseif msgcontains(msg, 'hunch') then
          npcHandler:say({"There are old legends about a subterranean temple that was once built in this area. Supposedly many {artefacts} are still hidden down there. ...",
		  "I don't have the time to tell you the entire tale, but there is a book downstairs in which you may read the whole story."}, cid)
     elseif msgcontains(msg, 'artefacts') then
          npcHandler:say("Yes, the story goes that there are ancient artefacts still hidden in the temple ruins, such as helmets in the form of wolven heads, for example. It is said that moonlight crystals are needed to enchant these artefacts.", cid)
     elseif msgcontains(msg, 'moon') then
          npcHandler:say({"Every month around the 13th, the single Tibian moon will by fully visible to us. That's when the curse hits us hardest. ...",
		  "The two days around the 13th, the 12th and the 14th, are considered 'Harvest Moon', those are the best to gather {nightshade}. However, only after it has reached its apex on the 13th, the curse strengthens. ...",
		  "We do not know what happens down there in those tunnels around that time but there is a presence there, we all feel - yet cannot quite fathom. ...",
		  "At full moon, humans transform into wild beasts: wolves, boars, bears and others. Some call it the {curse} of the Full Moon, others think it is a kind of sickness. .",
		  "During this time, we try to not leave the house, we shut the windows and hope it will pass. The curse will weaken a bit after that but it returns. Every month."}, cid)
     elseif msgcontains(msg, 'nightshade') then
          npcHandler:say("Three of these blossoms should suffice to heal some afflicted persons. But if you bring more I'd be grateful, of course.", cid)
     elseif msgcontains(msg, 'name') then
          npcHandler:say("My name is Maeryn.", cid)
     elseif msgcontains(msg, 'maeryn') then
          npcHandler:say("Yes, that's me.", cid)
     elseif msgcontains(msg, 'time') then
          npcHandler:say("It's exactly " .. getFormattedWorldTime() .. ".", cid)
     elseif msgcontains(msg, 'job') then
          npcHandler:say("I'm the protector of this little village. A bit of a self-proclaimed function, I admit, but someone has to watch over {Grimvale}. It is a {dangerous} place.", cid)
     elseif msgcontains(msg, 'grimvale') then
          npcHandler:say("The small island you are standing on. For a long time it was a peaceful and placid place. But lately it has become more {dangerous}.", cid)
     elseif msgcontains(msg, 'owin') then
          npcHandler:say("He's an experienced hunter and knows much about the woods, the animals that dwell there, and about the {werewolves}. He's devoted himself to finding out everything there is to know about the {Curse}.", cid)
     elseif msgcontains(msg, 'werewolves') then
          npcHandler:say("Yes, my friend, werewolves. They dwell here on {Grimvale}, threatening our life. The were-sickness transforms peaceful villagers into savage beasts. We're not sure how this curse found its way into our small village. But undoubtedly it did.", cid)
     elseif msgcontains(msg, 'gladys') then
          npcHandler:say("She's an old druid. She's been living here on {Grimvale} since she was a little girl, just like me. She's very interested in were-creature body parts. If you find any, I'm sure she will love to trade with you.", cid)
     elseif msgcontains(msg, 'cornell') then
          npcHandler:say("He's basically a ferryman nowadays, but I remember when he was our village's leading fisherman. He offers a ferry service between Grimvale and Edron. You must have met him - he sailed you here.", cid)
     elseif msgcontains(msg, 'werewolf helmet') then
          npcHandler:say("You brought the wolven helmet, as i see. Do you want to change something?", cid)
          npcHandler.topic[cid] = 1
     elseif msgcontains(msg, 'yes') then
	 if npcHandler.topic[cid] == 1 then
          npcHandler:say("So, which profession would you give preference to when enchanting the helmet: {knight}, {sorcerer}, {druid} or {paladin}?", cid)
          npcHandler.topic[cid] = 2
	 end
     elseif isInArray({'knight', 'sorcerer', 'druid', 'paladin'}, msg:lower()) and npcHandler.topic[cid] == 2  then
               local helmet = msg:lower()
               if not vocations[helmet] then
                    return false
               end
          if msg:lower() == 'knight' then
               npcHandler:say("And what would be your preferred weapon? {Club}, {axe} or {sword}", cid)
               knightChoice[cid] = helmet
               npcHandler.topic[cid] = 3
		  end
		  if npcHandler.topic[cid] == 2 then
               --if (Set storage if player can enchant helmet(need Grim Vale quest)) then
               player:setStorageValue(Storage.Grimvale.WereHelmetEnchant, vocations[helmet])
               npcHandler:say("So this is your choice. If you want to change it, you will have to come to me again.", cid)
               --else
               --npcHandler:say("Message when player do not have quest.", cid)
               --end
               npcHandler.topic[cid] = 0
		  end
     elseif isInArray({'axe', 'club', 'sword'}, msg:lower()) and npcHandler.topic[cid] == 3 then
               local weapontype = msg:lower()
               if not vocations[knightChoice[cid]][weapontype] then
                    return false
               else
                    --if (Set storage if player can enchant helmet(need Grim Vale quest)) then
                         player:setStorageValue(Storage.Grimvale.WereHelmetEnchant, vocations[knightChoice[cid]][weapontype])
                         npcHandler:say("So this is your choice. If you want to change it, you will have to come to me again.", cid)
                    --else
               --npcHandler:say("Message when player do not have quest.", cid)
                    --end
               knightChoice[cid] = nil
               npcHandler.topic[cid] = 0
               end
     elseif msgcontains(msg, 'bye') then
          npcHandler:say("Farewell, then.", cid)
          npcHandler:releaseFocus(cid)
	 end
end
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
