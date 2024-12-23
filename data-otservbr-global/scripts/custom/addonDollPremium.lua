local outfits = {
    ["citizen"] = {136, 128},
    ["hunter"] = {137, 129},
    ["knight"] = {139, 131},
    ["noblewoman"] = {140, 132},
    ["summoner"] = {141, 133},
    ["warrior"] = {142, 134},
    ["barbarian"] = {147, 143},
    ["druid"] = {148, 144}
}

local storage = 32943

local addonDollCoin = Action()
function addonDollCoin.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
    if player:getStorageValue(storage) > 0 then
        player:sendCancelMessage("You already have the basic addons.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    for a, b in pairs(outfits) do
        player:addOutfitAddon(b[1], 3)
        player:addOutfitAddon(b[2], 3)
    end
    
	player:addOutfitAddon(130, 1)
	player:addOutfitAddon(138, 1)
    player:sendCancelMessage("You received all the basic addons.")
    player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	player:setStorageValue(storage, 1)
	item:remove(1)
    return true
end

addonDollCoin:id(9177)
addonDollCoin:register()