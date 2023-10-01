local magmaBubble = CreatureEvent("MagmaBubbleFireFighterOutfit")

local bossDeath = "Magma Bubble"

function magmaBubble.onKill(player, monster, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)   
    local maleOutfitId = 1568
    local femaleOutfitId = 1569
    if monster:getName() == bossDeath then
        local outfitId = player:getSex() == PLAYERSEX_FEMALE and femaleOutfitId or maleOutfitId        
    if not player:hasOutfit(outfitId) then
         player:addOutfit(outfitId)
         player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received the Fire Fighter Outfit as a reward for defeating Magma Bubble!")
      else
         player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already received the Fire Fighter Outfit for defeating Magma Bubble.")
      end
    end
    return true
end


magmaBubble:register()
