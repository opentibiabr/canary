# Account-wide quests

The account-wide quest layer separates three independent concepts:

1. Character progress remains in normal player storages and can be reset.
2. Access can be shared by every character on the account.
3. Rewards can be claimed either once per account or once per character.

## Configuration

Edit:

```text
data-otservbr-global/account_quests.lua
```

Main options:

```lua
return {
    enabled = true,
    shareAccess = true,
    defaultRewardMode = "oncePerAccount",
    allowSelfReset = false,
    quests = {
        ["example-quest"] = {
            rewardMode = "oncePerAccount",
            progressStorages = { 10001, 10002, 10003 },
        },
    },
}
```

Supported reward modes:

- `oncePerAccount`: one final reward for the whole account.
- `oncePerCharacter`: every character can claim its own final reward.

Restart the server after editing the configuration.

## Completing a quest

Keep ordinary quest stages in player storages. When the character earns permanent access:

```lua
player:unlockAccountQuestAccess("example-quest")
```

When checking a door, teleport, NPC route or hunting area:

```lua
local hasCharacterAccess = player:getStorageValue(Storage.ExampleQuest.Access) >= 1
local hasAccountAccess = player:hasAccountQuestAccess("example-quest")

if not hasCharacterAccess and not hasAccountAccess then
    player:sendCancelMessage("You do not have access to this area.")
    return true
end
```

This preserves compatibility when the account-wide system is disabled or when old characters already have only the original character storage.

## Giving the final reward

Check and record the claim before adding the reward:

```lua
if not player:canClaimAccountQuestReward("example-quest") then
    player:sendCancelMessage("This reward has already been claimed.")
    return true
end

if not player:claimAccountQuestReward("example-quest") then
    player:sendCancelMessage("The reward could not be reserved. Try again.")
    return true
end

player:addItem(2160, 10)
```

For an item that every character needs, configure that quest with:

```lua
rewardMode = "oncePerCharacter"
```

## Resetting a character's progress

Administrator command:

```text
/questreset Player Name, example-quest
```

Optional player command, disabled by default:

```text
!questreset example-quest
```

The reset removes only the registered `progressStorages` from the selected character. It deliberately preserves:

- account access;
- account reward history;
- character reward history;
- items already obtained;
- progress of other characters.

For quests with temporary quest items, add their storage keys to `progressStorages`. Item cleanup should remain quest-specific because automatically deleting items can destroy legitimate duplicates or traded items.

## Lua API

```lua
player:hasAccountQuestAccess(questId)
player:unlockAccountQuestAccess(questId)
player:canClaimAccountQuestReward(questId)
player:claimAccountQuestReward(questId)
player:resetAccountQuestProgress(questId)
AccountQuest.reload()
```

## Database

At startup the system creates:

- `account_quest_access`;
- `account_quest_rewards`.

Both tables are linked to `accounts` and are removed automatically when the owning account is deleted.
