local entries = {
	{ 70010, "Rotten Blood Bundle", "Darklight Evoker", 1675, 1676, 216, { 44030 }, "Darkfire Devourer", "Mask of the Defiler", "Bundle_Rotten_Blood_1525.png" },
	{ 70011, "Sweet Honey Bundle", "Beekeeper", 1776, 1777, 231, { 48574, 48576 }, "Bumblebee", "Candy Chest and Beehive", "Bundle_Sweet_Honey_1525.png" },
	{ 70012, "Field Surgeon Bundle", "Field Surgeon", 1814, 1815, 237, { 50213, 50214 }, "Pallbearer", "Sickbed (two parts)", "Bundle_Field_Surgeon_1525.png" },
	{ 70013, "Martial Artist Bundle", "Martial Artist", 1837, 1838, 238, { 50435 }, "Satin Moth", "Wooden Dummy", "Bundle_Martial_Artist_1525.png" },
	{ 70014, "Shadow Vengeance Bundle", "Bat Knight", 1874, 1875, 239, { 51706 }, "Battle Werewolf", "Effigy of Winged Vengeance", "Bundle_Shadow_Vengeance_1525.png" },
	{ 70015, "Burning Ash Bundle", "Phoenix Evoker", 1920, 1921, 240, { 52867 }, "Flame Bear", "Barebone Grill", "Bundle_Burning_Ash_1525.png" },
}

local category = {
	icons = { "Category_Bundles.png" },
	name = "Bundles",
	rookgaard = false,
	state = GameStore.States.STATE_NONE,
	offers = {},
}

local details = {
	[70010] = {
		intro = "This exclusive bundle includes the Full Darklight Evoker Outfit, the Darkfire Devourer mount and the Mask of the Defiler.",
		decorations = { { "Mask of the Defiler", 44030, "use it to change its appearance" } },
	},
	[70011] = {
		savings = 380,
		decorations = { { "Candy Chest", 48574, "use it to open up some storage space" }, { "Beehive", 48576 } },
	},
	[70012] = {
		savings = 420,
		decorations = { { "Sickbed", 50213, "put the two parts together and use the bed to sleep and train your skills", 2 } },
	},
	[70013] = {
		savings = 340,
		decorations = { { "Wooden Dummy", 50435 } },
	},
	[70014] = {
		savings = 360,
		decorations = { { "Effigy of Winged Vengeance", 51706, "use it to change its appearance" } },
	},
	[70015] = {
		savings = 360,
		decorations = { { "Barebone Grill", 52867, "use it to change its appearance" } },
		story = "<i>What fades in time may seem lost...\nyet the flame purifies all, forging something mightier from the ashes.\nThe Burning Ash Bundle radiates fiery determination and will captivate anyone who draws power from the heat of the blaze.</i>",
	},
}
local mountLooks = { [216] = 1677, [231] = 1778, [237] = 1813, [238] = 1836, [239] = 1873, [240] = 1919 }

for _, entry in ipairs(entries) do
	local detail = details[entry[1]]
	local intro = detail.intro or string.format("You can save %d Tibia Coins by purchasing this bundle instead of buying each of the offers separately.", detail.savings)
	local sections = {
		intro,
		"Full " .. entry[3] .. " Outfit\n{character}\n{info} colours can be changed using the Outfit dialog\n{info} includes basic outfit and 2 addons which can be selected individually",
		entry[8] .. "\n{character}\n{speedboost}",
	}
	local products = {
		{ name = "Full " .. entry[3] .. " Outfit", type = GameStore.ConverType.SHOW_OUTFIT, sexId = { male = entry[4], female = entry[5] } },
		{ name = entry[8], type = GameStore.ConverType.SHOW_MOUNT, id = mountLooks[entry[6]] },
	}
	for _, decoration in ipairs(detail.decorations) do
		local box = decoration[4] == 2 and "{boxicon} comes in two boxes which can only be unwrapped by purchasing character" or "{box}"
		local section = decoration[1] .. "\n{house}\n" .. box .. "\n{storeinbox}"
		if decoration[3] then
			section = section .. "\n{useicon} " .. decoration[3]
		end
		sections[#sections + 1] = section .. "\n{backtoinbox}"
		products[#products + 1] = { name = decoration[1], type = GameStore.ConverType.SHOW_ITEM, id = decoration[2] }
	end
	if detail.story then
		sections[#sections + 1] = detail.story
	end
	category.offers[#category.offers + 1] = {
		id = entry[1],
		name = entry[2],
		price = 1500,
		count = 1,
		coinType = GameStore.CoinType.Transferable,
		type = GameStore.OfferTypes.OFFER_TYPE_BUNDLE,
		sexId = { male = entry[4], female = entry[5] },
		mountId = entry[6],
		decorations = entry[7],
		icons = { entry[10] },
		description = table.concat(sections, "\n\n"),
		products = products,
	}
end

return category
