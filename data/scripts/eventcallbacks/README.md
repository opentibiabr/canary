# Event Callback Usage Guide

The `EventCallback` system is a way to dynamically bind C++ functions to be triggered by specific events within the game. It's an elegant and flexible way to add custom behavior to various parts of your application.

## Event Callback Types

Event callbacks are available for several categories of game entities, such as `Creature`, `Player`, `Party`, and `Monster`.

### In the above list, each function is prefixed with `(bool)` or `(void)`. This annotation indicates the expected return type of the function:

- `(bool)`: The function should return a boolean value (`true` or `false`). The return value can affect the program flow on the C++ side. For example, if the function returns `false`, the execution of the associated function on the C++ side is immediately stopped.
- `(void)`: The function does not return any value. It just performs an action and then terminates.

### These are the functions available to use

- `(bool)` `creatureOnChangeOutfit`
- `(ReturnValue)` `creatureOnAreaCombat`
- `(ReturnValue)` `creatureOnTargetCombat`
- `(void)` `creatureOnDrainHealth`
- `(void)` `creatureOnCombat`
- `(bool)` `partyOnJoin`
- `(bool)` `partyOnLeave`
- `(bool)` `partyOnDisband`
- `(void)` `partyOnShareExperience`
- `(bool)` `playerOnBrowseField`
- `(void)` `playerOnLook`
- `(void)` `playerOnLookInBattleList`
- `(void)` `playerOnLookInTrade`
- `(bool)` `playerOnLookInShop`
- `(bool)` `playerOnMoveItem`
- `(void)` `playerOnItemMoved`
- `(void)` `playerOnChangeZone`
- `(void)` `playerOnChangeHazard`
- `(bool)` `playerOnMoveCreature`
- `(void)` `playerOnReportRuleViolation`
- `(void)` `playerOnReportBug`
- `(bool)` `playerOnTurn`
- `(bool)` `playerOnTradeRequest`
- `(bool)` `playerOnTradeAccept`
- `(void)` `playerOnGainExperience`
- `(void)` `playerOnLoseExperience`
- `(void)` `playerOnGainSkillTries`
- `(void)` `playerOnRemoveCount`
- `(void)` `playerOnRequestQuestLog`
- `(void)` `playerOnRequestQuestLine`
- `(void)` `playerOnStorageUpdate`
- `(void)` `playerOnCombat`
- `(void)` `playerOnInventoryUpdate`
- `(bool)` `playerOnRotateItem`
- `(void)` `playerOnWalk`
- `(void)` `monsterOnDropLoot`
- `(void)` `monsterPostDropLoot`

## Event Callback Usage

To use the `EventCallback` system, you first need to create an instance of `EventCallback`, then define the functions you want to trigger on specific events. Once done, register your callback to make it active.

Below are examples for each category of game entities:

### Creature Callback

```lua
local callback = EventCallback("UniqueCallbackName")

function callback.creatureOnAreaCombat(creature, tile, isAggressive)
	-- custom behavior when a creature enters combat area
	return RETURNVALUE_NOERROR
end

callback:register()
```

### Player Callback

```lua
local callback = EventCallback("UniqueCallbackName")

function callback.playerOnLook(player, position, thing, stackpos, lookDistance)
	-- custom behavior when a player looks at something
end

callback:register()
```

### Party Callback

```lua
local callback = EventCallback("UniqueCallbackName")

function callback.partyOnJoin(party, player)
	-- custom behavior when a player joins a party
end

callback:register()
```

### Monster Callback

```lua
local callback = EventCallback("UniqueCallbackName")

function callback.monsterOnDropLoot(monster, corpse)
	logger.info("Monster {} has corpse {}", monster:getName(), corpse:getName());
end

callback:register()
```

## Boolean Event Callbacks

Some event callbacks are expected to return a boolean value. The return value plays a crucial role in determining the flow of the program on the C++ side.

If the callback returns `false`, the execution of the associated function on the C++ side is stopped immediately. This allows you to use Lua scripting to introduce custom conditions for the execution of C++ functions.

Here is an example of a boolean event callback:

```lua
local callback = EventCallback("UniqueCallbackName")

function callback.playerOnMoveItem(player, item, count, fromPos, toPos, fromCylinder, toCylinder)
	if item:getId() == ITEM_PARCEL then
		--Custom behavior when the player moves a parcel.
		return false
	end
	return true
end

callback:register()
```

### In this example, when a player moves an item, the function checks if the item is a parcel and apply a custom behaviour, returning false making it impossible to move, stopping the associated function on the C++ side.

## ReturnValue Event Callbacks

Some event callbacks are expected to return a enum value, in this case, the enum ReturnValue. If the return is different of RETURNVALUE_NOERROR, it will stop the execution of the next callbacks.

Here is an example of a ReturnValue event callback:

```lua
local callback = EventCallback()

function callback.creatureOnAreaCombat(creature, tile, isAggressive)
	-- if the creature is not aggressive, stop the execution of the C++ function
	if not isAggressive then
		return RETURNVALUE_NOTPOSSIBLE
	end

	-- custom behavior when an aggressive creature enters a combat area
	return RETURNVALUE_NOERROR
end

callback:register()
```

### In this example, when a non-aggressive creature enters a combat area, the creatureOnAreaCombat function returns false, stopping the associated function on the C++ side.


## Multiple Callbacks for the Same Event

You can define multiple callbacks for the same event type. This allows you to encapsulate different behaviors in separate callbacks, making your code more modular and easier to manage.

It also allows you to use the same callback in different parts of your Lua scripts. All the registered callbacks for a specific event are triggered when that event occurs.

Here is an example of defining multiple callbacks for the creatureOnAreaCombat event:

#### Example 1

```lua
local example1 = EventCallback("UniqueCallbackName")

function example1.creatureOnAreaCombat(creature, tile, isAggressive)
	-- custom behavior 1 when a creature enters combat area
end

example1:register()
```

#### Example 2

```lua
local example2 = EventCallback("UniqueCallbackName")

function example2.creatureOnAreaCombat(creature, tile, isAggressive)
	-- custom behavior 2 when a creature enters combat area
end

example2:register()
```
