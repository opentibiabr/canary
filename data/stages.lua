-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 8,
		multiplier = 20
	}, {
		minlevel = 9,
		maxlevel = 20,
		multiplier = 10
	}, {
		minlevel = 21,
		maxlevel = 50,
		multiplier = 5
	}, {
		minlevel = 51,
		maxlevel = 100,
		multiplier = 4
	}, {
		minlevel = 101,
		maxLevel = 150,
		multiplier = 3
	}, {
		minLevel = 151,
		multiplier = 2
	}
}

skillsStages = {
	{
		minlevel = 0,
		multiplier = 2
	}
}

magicLevelStages = {
	{
		minlevel = 0,
		multiplier = 2
	}
}
