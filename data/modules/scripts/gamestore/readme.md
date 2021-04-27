## Module : Premium Shop - Game Store
---

> Notify! Please put the images in folder called "64".

### Faq

##### 1. How to make a category?
```lua
--- Method 1 ---
GameStore.Categories = {
	{	name = "mounts",
		...
	},
	{	name = "outfits",
		...
	}
}
--- Method 2 ---
GameStore.Categories = {
	mounts = {
		name = "mounts"
	},
	outfits = {....}
}
--- Method 3 ---
mounts = {....}
GameStore.Categories = {
	mounts,
	...
}
```

##### 2. How to add offers to category
```lua
--- Method 1 ---
GameStore.Categories = {
	mounts = {
		offers = {

		}
	}
}
--- Method 2 ---
mounts = { name = "mounts", icons = {"Category_Mounts.png"}}
mounts.offers = {
	{name = "fafa", thingId = ....}
}
GameStore.Categories = {
	mounts = { name = "mounts",
		offers = {
			{name = "fafa", thingId = ....}
		}
	}
}
```

### Category Options
| Method      | Type                  | Usage                        | Default                     |
|-------------|-----------------------|------------------------------|-----------------------------|
| name*       | string                | the category name            | nil                         |
| description | string                | the category description     | ""                          |
| state       | GameStore.States(int) | the category highlight state | GameStore.States.STATE_NONE |
| icons*      | table[string(s)]      | the icons for the category   | nil                         |
| offers(*)   | table[offer(s)]       | the category offers          | nil                         |

#### Example :
```lua
mounts = {
	name = "Mounts",
	description = "Have a mount and become an important-look person!",
	state = GameStore.States.STATE_NEW,
	icons = {"Category_Mounts.png"},
	offers = {....}
}
```

### Offer Options
| Method         | Type                      | Usage                                                                  | Default                              |
|----------------|---------------------------|------------------------------------------------------------------------|--------------------------------------|
| name*          | string                    | the offer name                                                         | nil                                  |
| description    | string                    | the offer descrioption                                                 | ""                                   |
| thingId*       | int                       | the id of the choosed type ( itemId or mountId or outfitLookType, ....)| nil                                  |
| type*          | GameStore.OfferTypes(int) | the type of the offer, item or mount or outfit or ...                  | GameStore.OfferTypes.OFFER_TYPE_NONE |
| price*         | int                       | the offer price                                                        | nil                                  |
| state          | GameStore.States(int)     | the offer highlight state                                              | GameStore.States.STATE_NONE          |
| icons*         | table[string(s)]          | the icons for the category                                             | nil                                  |
| disabled       | bool                      | dynamically disable the offer                                          | false                                |
| disabledReason | string                    | reason for being disabled ( use when disabled is true )                | nil                                  |

#### Example :
```lua
mounts.offers = {
	{	name = "Titanica",
		description = "Looking for nice mount? Titanica is the one you are looking for, she is beautiful, smart and running quickly.",
		thingId = 4, -- here we use mount id.
		type = GameStore.OfferTypes.OFFER_TYPE_MOUNT,
		price = 500,
		state = GameStore.States.STATE_SALE,
		icons = {"Product_Titanica1", "Product_Titanica2"}
		--[[Dynamicly used variables
		disabled = (true|false),
		disbabledReason = (string)
		]]
	}
}
```

### Offer types and States.

| OfferTypes              | States      |
|-------------------------|-------------|
| `OFFER_TYPE_ITEM`         | `STATE_NEW`   |
| `OFFER_TYPE_OUTFIT`       | `STATE_SALE`  |
| `OFFER_TYPE_OUTFIT_ADDON` | `STATE_TIMED` |
| `OFFER_TYPE_MOUNT`        |               |
| `OFFER_TYPE_NAMECHANGE`   |               |
| `OFFER_TYPE_SEXCHANGE`    |               |
| `OFFER_TYPE_PROMOTION`    |               |
