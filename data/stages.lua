-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 13000,
		multiplier = 22000,
	},
	{
		minlevel = 13001,
		maxlevel = 14000,
		multiplier = 12000,
	},
	{
		minlevel = 14001,
		maxlevel = 15000,
		multiplier = 8000,
	},
	{
		minlevel = 15001,
		multiplier = 1500,
	},
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 30,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 30,
	},
	{
		minlevel = 81,
		maxlevel = 110,
		multiplier = 20,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 10,
	},
	{
		minlevel = 126,
		multiplier = 8,
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 20,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 20,
	},
	{
		minlevel = 81,
		maxlevel = 100,
		multiplier = 20,
	},
	{
		minlevel = 101,
		maxlevel = 110,
		multiplier = 13,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 6,
	},
	{
		minlevel = 126,
		multiplier = 2,
	},
}
