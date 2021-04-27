local config = {
	[1] = {
		text = "You hold the skull up high. You can resist the urge to have it look through a telescope though.",
		position = Position(33263, 31834, 1)
	},
	[2] = {
		text = "You hold up the skull and let it take a peek over the beautiful elven town through the dense leaves.",
		position = Position(32711, 31668, 1)
	},
	[3] = {
		text = "Thanita gives you a really strange look as you hold up the skull, but oh well.",
		position = Position(32537, 31772, 1)
	},
	[4] = {
		text = "That was a real easy one. And you are used to getting strange looks now, so whatever!",
		position = Position(33216, 32450, 1)
	},
	[5] = {
		text = "Wow, it's hot up here. Luckily the skull can't get a sunburn any more, \z
			but you can, so you better descend again!",
		position = Position(33151, 32845, 2)
	},
	[6] = {
		text = "Considering that higher places around here aren't that easy to reach, \z
			you think the view from here is tolerably good.",
		position = Position(32589, 32801, 4)
	},
	[7] = {
		text = "Yep, that's a pretty high spot. \z
			If Lazaran ever sees what the skull sees, he'd be pretty satisfied with that nice view.",
		position = Position(32346, 32808, 2)
	},
	[8] = {
		text = "Well, there are higher spots around here, but none of them is as easily reachable as this one. \z
			It just has to suffice.",
		position = Position(32789, 31238, 3)
	},
	[9] = {
		text = "Nice! White in white as far as the eye can see. Time to leave before your fingers turn into icicles.",
		position = Position(32236, 31096, 2)
	},
	[10] = {
		text = "That's definitely one of the highest spots in whole Tibia. \z
			If that's not simply perfect you don't know what it is.",
		position = Position(32344, 32265, 0)
	},
	[11] = {
		text = "What a beautiful view. Worthy of a Queen indeed! Time to head back to Lazaran and show him what you got.",
		position = Position(32316, 31752, 0)}
}

local mission2AllAroundTheWorld = MoveEvent()

function mission2AllAroundTheWorld.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetValue = config[player:getStorageValue(Storage.UnnaturalSelection.Mission02)]
	if not targetValue then
		return true
	end

	if player:getPosition() == targetValue.position and player:getItemCount(11076) >= 1 then
		--Questlog, Unnatural Selection Quest "Mission 2: All Around the World"
		player:setStorageValue(Storage.UnnaturalSelection.Mission02, player:getStorageValue(Storage.UnnaturalSelection.Mission02) + 1)
		player:say(targetValue.text, TALKTYPE_MONSTER_SAY)
	end
	return true
end

mission2AllAroundTheWorld:type("stepin")
mission2AllAroundTheWorld:aid(12332)
mission2AllAroundTheWorld:register()
