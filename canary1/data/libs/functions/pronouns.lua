Pronouns = {}

local pronounTable = {
	[PLAYERPRONOUN_THEY] = { subject = "they", object = "them", possessive = "their" },
	[PLAYERPRONOUN_SHE] = { subject = "she", object = "her", possessive = "her" },
	[PLAYERPRONOUN_HE] = { subject = "he", object = "him", possessive = "his" },
	[PLAYERPRONOUN_ZE] = { subject = "ze", object = "zir", possessive = "zir" },
}

function Pronouns.getPlayerSubjectPronoun(pronoun, name, sex)
	if pronoun == PLAYERPRONOUN_NAME then
		return name
	end
	local sexPronoun = sex == PLAYERSEX_FEMALE and PLAYERPRONOUN_SHE or PLAYERPRONOUN_HE
	return pronounTable[pronoun].subject or pronounTable[sexPronoun].subject or "they"
end

function Pronouns.getPlayerObjectPronoun(pronoun, name, sex)
	if pronoun == PLAYERPRONOUN_NAME then
		return name
	end
	local sexPronoun = sex == PLAYERSEX_FEMALE and PLAYERPRONOUN_SHE or PLAYERPRONOUN_HE
	return pronounTable[pronoun].object or pronounTable[sexPronoun].object or "them"
end

function Pronouns.getPlayerPossessivePronoun(pronoun, name, sex)
	if pronoun == PLAYERPRONOUN_NAME then
		return name .. "'s"
	end
	local sexPronoun = sex == PLAYERSEX_FEMALE and PLAYERPRONOUN_SHE or PLAYERPRONOUN_HE
	return pronounTable[pronoun].possessive or pronounTable[sexPronoun].possessive or "their"
end

function Pronouns.getVerbForPronoun(pronoun, pastTense)
	if pronoun == PLAYERPRONOUN_THEY then
		return pastTense and "were" or "are"
	else
		return pastTense and "was" or "is"
	end
end
