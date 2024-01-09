local rookVocations = { 0 }
local sorcererVocations = { 1, 5 }
local druidVocations = { 2, 6 }
local paladinVocations = { 3, 7 }
local knightVocations = { 4, 8 }
local assassinVocations = { 9, 10 }
local mainVocations = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
local allVocations = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

local rewardsConfig = {
    -- 2cc and Magic Sword for every 20 level on main
    {
        level = 14,
        vocations = mainVocations,
        storage = 25099,
        items = {
            { 2871, 1 },
            { 3043, 1 },
            { 268, 20 },
            { 266, 10 },
            { 17512, 50 },
            { 60132, 2 },
            
        }
    },
	
	



    {
        level = 20,
        vocations = mainVocations,
        storage = 25100,
        items = {
            { 3043, 3 },
            { 268, 20 },
            { 266, 10 },
            { 60132, 2 },
            
        }
    },


	  -- vortex for 19 sorc
	  {
        level = 19,
        vocations = sorcererVocations,
        storage = 25101,
        items = {
            { 3072, 1 },
            
        }
    },
		  -- snakebitye for 19 druid
	  {
        level = 19,
        vocations = druidVocations,
        storage = 25101,
        items = {
            { 3069, 1 },
            
        }
    },
	
	
	
			  -- bow quiver arrow for paladin 19
	  {
        level = 20,
        vocations = paladinVocations,
        storage = 25101,
        items = {
            { 774, 100 },
			{ 7438, 1 },
			
            
        }
    },
		  -- sword club axe for knight 19
	  {
        level = 20,
        vocations = knightVocations,
        storage = 25101,
        items = {
            { 17812, 1 },
			{ 3317, 1 },
			{ 3311, 1 },
			{ 3425, 1 },
            
        }
    },
	
		  -- assassin 20
          {
            level = 20,
            vocations = assassinVocations,
            storage = 25101,
            items = {
                { 31969, 1 },
                
                
            }
        },
	
	
	  -- vortex for 26 sorc
	  {
        level = 33,
        vocations = sorcererVocations,
        storage = 25102,
        items = {
            { 3073, 1 },
            { 8072, 1 },
			{ 268, 50 },
			{ 266, 20 },
            { 3161, 100 },
            
        }
    },
		  -- snakebitye for 26 druid
	  {
        level = 33,
        vocations = druidVocations,
        storage = 25102,
        items = {
            { 3067, 1 },
            { 8072, 1 },
            { 268, 50 },
			{ 266, 20 },
            { 3161, 100 },
            
        }
    },
	
	  -- rp 30
	  {
        level = 30,
        vocations = paladinVocations,
        storage = 25102,
        items = {
            { 762, 200 },
			 { 7364, 100 },
             { 3161, 100 },
            
        }
    },
		  --ek 30
	  {
        level = 30,
        vocations = knightVocations,
        storage = 25102,
        items = {
            { 3280, 1 },
			 { 3320, 1 },
             { 7430, 1 },
            
        }
    },

    -- assassin 30
    {
        level = 30,
        vocations = assassinVocations,
        storage = 25102,
        items = {
            { 31970, 1 },
            { 3079, 1 },
            
            
        }
    },

	
		
	 -- vortex for 50 sorc
	  {
        level = 50,
        vocations = sorcererVocations,
        storage = 25103,
        items = {
            { 2866, 1 },
            { 8094, 1 },
            { 3210, 1 },
			 { 237, 200 },
			 { 3155, 100 },
             { 3161, 100 },
             { 60132, 2 },
            
        }
    },
		  -- snakebitye for 50 druid
	  {
        level = 50,
        vocations = druidVocations,
        storage = 25103,
        items = {
            { 2866, 1 },
            { 8082, 1 },
            { 3210, 1 },
            { 237, 200 },
            { 3155, 100 },
            { 3161, 100 },
            { 60132, 2 },
			  
            
        }
    },
	
	
	
	
			  -- bow quiver arrow for paladin 50
	  {
        level = 50,
        vocations = paladinVocations,
        storage = 25103,
        items = {
            { 2866, 1 },
            { 8029, 1 },
            { 3079, 1 },
            { 7365, 300 },
            { 237, 200 },
            { 3155, 100 },
            { 3161, 100 },
            { 60132, 2 },
			
            
        }
    },
		  -- sword club axe for knight 50
	  {
        level = 50,
        vocations = knightVocations,
        storage = 25103,
        items = {
            { 2866, 1 },
            { 7386, 1 },
            { 3370, 1 },
			{ 14040, 1 },
			{ 14250, 1 },
			{ 237, 200 },
			{ 236, 100 },
			{ 3415, 1 },
            { 60132, 2 },
            
        }
    },
	
     -- assassin 50
     {
        level = 50,
        vocations = assassinVocations,
        storage = 25103,
        items = {
            { 237, 200 },
			{ 236, 100 },
            { 3381, 1 },
            { 237, 200 },
			{ 236, 100 },

            
            
        }
    },
	
	
	 -- vortex for 80 sorc
	  {
        level = 80,
        vocations = sorcererVocations,
        storage = 25104,
        items = {
            { 238, 100 },
			 { 3043, 5 },

             { 8043, 1 },
             { 3079, 1 },
			 
            
        }
    },
		  -- snakebitye for 80 druid
	  {
        level = 80,
        vocations = druidVocations,
        storage = 25104,
        items = {
            { 238, 100 },
            { 3043, 5 },

            { 8043, 1 },
            { 3079, 1 },
			 
			  
            
        }
    },
	
	
				  -- bow quiver arrow for paladin 80
	  {
        level = 80,
        vocations = paladinVocations,
        storage = 25104,
        items = {
            { 238, 100 },
            { 3043, 5 },
            { 8063, 1 },
		
			
            
        }
    },
		  -- sword club axe for knight 80
	  {
        level = 80,
        vocations = knightVocations,
        storage = 25104,
        items = {
            { 239, 100 },
            { 237, 100 },
            { 3043, 5 },

            { 3369, 1 },
            { 3371, 1 },
		
            
        }
    },
        -- assassin 80
        {
            level = 80,
            vocations = assassinVocations,
            storage = 25104,
            items = {
                { 239, 100 },
                { 237, 100 },

                { 31973, 1 }, 
                { 5741, 1 }, 
    
                
                
            }
	},
	
	
	
	
		 -- vortex for 130 sorc
	  {
        level = 130,
        vocations = sorcererVocations,
        storage = 25105,
        items = {
           { 60826, 100 },
			 { 3043, 10 },
			 
            
        }
    },
		  -- snakebitye for 130 druid
	  {
        level = 130,
        vocations = druidVocations,
        storage = 25105,
        items = {
            { 22373, 100 },
            { 3043, 10 },
            { 60132, 2 },
			 
			  
            
        }
    },
	
	
				  -- bow quiver arrow for paladin 130
	  {
        level = 130,
        vocations = paladinVocations,
        storage = 25105,
        items = {
            { 22374, 100 },
            { 3043, 10 },

            { 8027, 1 },
            { 15793, 300 },
            { 60132, 2 },
		
			
            
        }
    },
		  -- sword club axe for knight 130
	  {
        level = 130,
        vocations = knightVocations,
        storage = 25105,
        items = {
            { 7643, 1100 },
            { 3043, 10 },

            {16160 , 1 },
            {14089 , 1 },
            {7421 , 1 },
            {3434 , 1 },
            { 60132, 2 },
		
            
        }
    },
	
            -- assassin 130
            {
                level = 130,
                vocations = assassinVocations,
                storage = 25105,
                items = {
                    { 239, 100 },
                    { 237, 100 },
    
                    { 31974, 1 }, 
                    { 10387, 1 }, 
                    { 60132, 2 },
        
                    
                    
                }
            },
	
    -- wand of inferno for 33 sorc
    {
        level = 12,
        vocations = sorcererVocations,
        storage = 25101,
        items = {
            { 3075, 1 },
        }
    },
}

local advanceReward = CreatureEvent("AdvanceReward")

function advanceReward.onAdvance(player, skill, oldLevel, newLevel)
    if skill ~= SKILL_LEVEL then
        return true
    end

    for i1, rewardConfig in pairs(rewardsConfig) do
        if newLevel >= rewardConfig.level then
            if table.contains(rewardConfig.vocations, player:getVocation():getId()) then
                if player:getStorageValue(rewardConfig.storage) < 1 then
                    player:setStorageValue(rewardConfig.storage, os.time())
                    for i2, item in pairs(rewardConfig.items) do
                        player:addItem(item[1], item[2])
                    end
                    player:getPosition():sendMagicEffect(CONST_ME_CRAPS)
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "You received reward for getting " .. rewardConfig.level .. " level.")
                end
            end
        end
    end

    return true
end

advanceReward:register()