local quest = {
	name = "Threatened Dreams",
	startStorageId = Storage.Quest.U11_40.ThreatenedDreams.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Troubled Animals",
			storageId = Storage.Quest.U11_40.ThreatenedDreams.Mission01[1],
			missionId = 10429,
			startValue = 1,
			endValue = 16,
			states = {
				[1] = "You met the talking white deer Alkestios. It turned out he is actually a fae - and needs help. Search \z
				out a poacher camp north of the Green Claw Swamps and keep the poachers from hunting white deers.",
				[2] = "You found a book with legends in the poacher camp. You asked Ahmed to add a story about how it brings \z
				ill luck to kill a white deer, hopefully the poachers will desist from hunting Alkestios.",
				[3] = "You returned to the poacher camp and placed the faked book noticeably on a table. You're quite sure the \z
				poachers will discover it soon and desist from hunting Alkestios.",
				[4] = "Alkestios asked you for help on another issue. There seemms to be a problem with a wolf mother and her \z
				whelps. Find the snake Ikassis in the north-west of Edron and talk to her, she knows more.",
				[5] = "The snake Ikassis asked you to find a female wolf in the south of Cormaya. The animal is in need of \z
				help, yet Ikassis didn't know any details.",
				[6] = "You found the ghostly wolf and promised to search for her lost whelps. The wolf told you to start \z
				your search at Ulderek's Rock",
				[7] = "At Ulderek's Rock you found a sleeping war wolf. It might actually be the now grown up whelp you were \z
				looking for. The skeleton nearby implies that the hunter didn't survive his misdeed.",
				[8] = "You talked to Irmana in Venore and she gave you the fur of one of the wolf whelps you're searching for. \z
				You should talk to their mother's ghost.",
				[9] = "As the ghostly wolf asked you, you placed the whelp fur in the mouth of a nearby stone, that is shaped \z
				like a big face.",
				[10] = "You redeemed the ghostly wolf. You should return to Ikassis and tell her about it.",
				[11] = "Ikassis was happy to hear that you redeemed the ghostly wolf. But she asked you to help someone else: \z
				one of her sisters. You can find her in the guise of swan at a river sourth-east of Ikassis.",
				[12] = "You met a swan that in truth is a swan maiden, a kind of fae. These fae have magical cloaks that allow \z
				them to shape change between swan and girl. Find this maiden's cloak that was stolen by a troll.",
				[13] = "The troll Grarkharok sold the cloak to Tereban and he lost it during a flight with magic carpet. The \z
				cloak's feathers are now scattered along the carpet's beeline between Edron and Darashia.",
				[14] = "You found many swan feathers on Edron and in Darama desert. Now you should have enough for an entire \z
				cloak. You should talk to the swan maiden.",
				[15] = "You found enough magical swan feathers. The swan maiden will now be able to restore her cloak. You \z
				should talk to Alkestios again.",
				[16] = "Alkestios was very happy about your support. You earned the Fae's trust and may now enter their secret \z
				realm. Search for an elemental shrine of ice, fire, earth or energy to reach Feyrist.",
			},
		},
		[2] = {
			name = "Nightmare Intruders",
			storageId = Storage.Quest.U11_40.ThreatenedDreams.Mission02[1],
			missionId = 10430,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = function(player)
					return string.format(
						"The fae queen asked for your help: Feyrist is threatened by intruders from Roshamuul. Kill 200 nightmare \z
						monsters and Kroazur. - You killed %d weakened frazzlemaws and %d efeebled silencers.",
						(math.max(player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission02.FrazzlemawsCount), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission02.EnfeebledCount), 0))
					)
				end,
				[2] = "You killed 200 of the nightmare monsters that are invading Feyrist. Maelyrra was very happy but it seems \z
				she still has other problems. She may need your help once more.",
				[3] = "Maelyrra asked you to retrieve an artefact for her: the moon mirror. It was stolen by the tainted fae \z
				who inhabit the caves underneath Feyrist. She also asked you to free some captured fairies.",
				[4] = "You found the moon mirror and freed the captured fairies. Maelyrra was very happy but it seems she \z
				has another problem. Perhaps you should offer your assistance once more.",
				[5] = "The barrier that protects Feyrist from the outside world is weakened. To strengthen it again you \z
				need to find the starlight vial and the sun catcher. Ask Aurita and Taegen for these items.",
				[6] = "Gather sunlight, starlight and moon rays. You have to do this with the sun catcher on the beach, with \z
				the starlight vial high in the mountains and with the moon mirror on a glade in the forest.",
				[7] = "You may now repair the barrier. Charge the five moon sculptures of Feyrist with moon rays, the five \z
				dreambird trees with starlight and the five sun mosics with sunlight.",
				[8] = "You repaired tha magical barrier that protects Feyrist from the outside world. The fae's secret realm \z
				is safe again.",
			},
		},
		[3] = {
			name = "An Unlikely Couple",
			storageId = Storage.Quest.U11_40.ThreatenedDreams.Mission03[1],
			missionId = 10431,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Help Aurita and Taegen and find a spell to transform Aurita's fishtail into legs temporarily. A \z
				fairy in a small fae village in the southwest of Feyrist might know more.",
				[2] = "You have succesfully created the magical music notes for the mermaid Aurita. Talk to the faun \z
				Taegen, he also needs your help.",
				[3] = "The faun Taegen wants to spend some time with his lover, the mermaid Aurita. He wants to visit her \z
				home and thus must be able to breath under water. Therefore he needs the rare raven herb.",
				[4] = "You found the rare raven herb and gave it to Taegen. Now he will create a sun catcher for you. \z
				You may also ask Aurita for the starlight vial now.",
			},
		},
	},
}

return quest
