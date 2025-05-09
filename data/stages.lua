-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 7,
		multiplier = 7,
	},
	{
		minlevel = 8,
		maxlevel = 100,
		multiplier = 100,
	},
	{
		minlevel = 101,
		maxlevel = 400,
		multiplier = 80,
	},
	{
		minlevel = 401,
		maxlevel = 1000,
		multiplier = 50,
	},
	{
		minlevel = 1000,
		multiplier = 15,
	},
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 50,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 30,
	},
	{
		minlevel = 81,
		maxlevel = 110,
		multiplier = 10,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 6,
	},
	{
		minlevel = 126,
		multiplier = 4,
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 30,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 20,
	},
	{
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10,
	},
	{
		minlevel = 101,
		multiplier = 4,
	},
}
