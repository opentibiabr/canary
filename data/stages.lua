-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 8,
		multiplier = 40
	},
	{
		minlevel = 9,
		maxlevel = 60,
		multiplier = 300
	}, {
		minlevel = 61,
		maxlevel = 100,
		multiplier = 280
	}, {
		minlevel = 101,
		maxlevel = 150,
		multiplier = 260
	}, {
		minlevel = 151,
		maxlevel = 200,
		multiplier = 240
	}, {
		minlevel = 201,
        maxlevel = 250,
		multiplier = 220
     }, {
		minlevel = 251,
        maxlevel = 300,
		multiplier = 170
        },  {
		minlevel = 301,
        maxlevel = 350,
		multiplier = 110
        }, {
		minlevel = 351,
        maxlevel = 400,
		multiplier = 80
        }, {
		minlevel = 401,
        maxlevel = 500,
		multiplier = 60
        }, {
		minlevel = 501,
        maxlevel = 600,
		multiplier = 40
        },{
        minlevel = 601,
        maxlevel = 700,
		multiplier = 30
        }, {
        minlevel = 701,
        maxlevel = 800,
		multiplier = 20
        }, {
		minlevel = 801,
        maxlevel = 900,
		multiplier = 10
        }, {
        minlevel = 901,
        maxlevel = 1000,
		multiplier = 8
         },	{
        minlevel = 1001,
        maxlevel = 1200,
		multiplier = 5
         }, {
        minlevel = 1201,
        maxlevel = 1600,
		multiplier = 2
         },{
        minlevel = 1601,           
		multiplier = 1.5
	}
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 25
	}, {
		minlevel = 61,
		maxlevel = 80,
		multiplier = 20
	}, {
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10
	}, {
		minlevel = 101,
		maxlevel = 125,
		multiplier = 5
	}, {
		minlevel = 126,
		multiplier = 2
	}
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 25
	}, {
		minlevel = 61,
		maxlevel = 80,
		multiplier = 20
	}, {
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10
	}, {
		minlevel = 101,
		maxlevel = 125,
		multiplier = 5
	}, {
		minlevel = 126,
		multiplier = 2
	}
}