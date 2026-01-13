# Game Store Refactor

This module has been completely refactored to separate responsibilities and make the store catalog easier to maintain. Below are the main concepts to understand the new architecture and how to work with it.

## Overview

- **Module loading**: `data/modules/scripts/gamestore/init.lua` registers helper modules in `data/libs/gamestore` (constants, helpers, store, senders, purchases, parsers, and player) and exposes their functions through the global `GameStore` table.
- **Modular catalog**: the store content is located in `data/modules/scripts/gamestore/catalog/`. Each file returns a Lua table describing a category. The final catalog is built by `gamestore.lua`, which uses `catalog_loader.lua` to validate and normalize entries before populating `GameStore.Categories`.
- **Automatic validations**: `catalog_loader.lua` ensures that required fields exist (name, icons, rookgaard flag, offers, or subclasses) and applies `GameStore.normalizeOffer` / `GameStore.resolveState`, preventing runtime errors.

## Catalog structure

1. `catalog/init.lua` defines the order of categories. The list may contain:
   - *Strings* pointing to files in `catalog/` (for example, `"premium_time"`).
   - *Inline tables* with the complete category definition.
   - *Objects* in the format `{ module = "file_name", source = "label" }` to register a category using another source name.
2. `catalog/parent_categories.lua` contains "parent" categories that group subclasses. Use this table when you only want to reference existing subcategories.
3. Files such as `catalog/premium_time.lua` or `catalog/cosmetics_mounts.lua` describe categories with their offers.

Each category accepts the fields below (all validated by the *loader*):

| Field            | Type                 | Required | Description                                                                    |
|------------------|----------------------|-----------|--------------------------------------------------------------------------------|
| `name`           | `string`             | Yes       | Display name in the client.                                                   |
| `icons`          | `table<string>`      | Yes       | List of icons (images must exist in `modules/game_store/images/64`).          |
| `rookgaard`      | `boolean`            | Yes       | Defines whether the category appears for rookgaard accounts.                  |
| `offers`         | `table<table>`       | Optional¹ | List of offers. Required when `subclasses` is not provided.                   |
| `subclasses`     | `table<string>`      | Optional¹ | List of subcategory names when the category acts only as a group.             |
| `state`          | `GameStore.States`   | Optional  | Visual highlight (e.g., `GameStore.States.STATE_NEW`).                        |
| `parent`         | `string`             | Optional  | Name of the parent category (if this is a subcategory).                       |

¹ **At least one** between `offers` or `subclasses` must exist.

## How to add a new category

1. **Create the category file** (e.g., `catalog/my_new_category.lua`):

   ```lua
   return {
           icons = { "Category_MyNewCategory.png" },
           name = "My New Category",
           rookgaard = false,
           parent = "Extras", -- optional, use when it is a subcategory
           offers = {
                   {
                           icons = { "Product_Sample.png" },
                           name = "Sample Offer",
                           price = 250,
                           description = "Optional description in Tibia HTML.",
                           id = 60001,
                           type = GameStore.OfferTypes.OFFER_TYPE_ITEM,
                           coinType = GameStore.CoinType.Transferable,
                           state = GameStore.States.STATE_NONE,
                   },
           },
   }
   ```

2. **Register it in the catalog** by adding `"my_new_category"` to the `modules` table in `catalog/init.lua` in the desired position.
3. (Optional) **Add its name to a group** in `catalog/parent_categories.lua` if the category belongs to an existing section.
4. `gamestore.lua` will automatically assign default IDs and types for offers missing `id`, `type`, or `coinType`.

## How to create new parent categories

1. Edit `catalog/parent_categories.lua` and include a new entry:

   ```lua
   return {
           new_parent = {
                   icons = { "Category_NewParent.png" },
                   name = "New Parent",
                   rookgaard = true,
                   subclasses = { "Child A", "Child B" },
           },
   }
   ```

2. Add `"new_parent"` to the list in `catalog/init.lua` so the group appears in the store.

3. Make sure the mentioned subcategories have individual files (or inline entries) with the field `parent = "New Parent"`.

## How to add offers to an existing category

1. Open the category file (for example, `catalog/cosmetics_mounts.lua`).
2. Insert a new table inside the `offers` key. Automatically validated fields:

   - `icons` (list of strings) – required.
   - `name` (string) – required.
   - `price` (number) – required.
   - `description`, `id`, `type`, `coinType`, `state`, `disabled`, `disabledReason`, `validUntil`, `count` – optional.
3. You do not need to fill `id`, `type`, or `coinType` if you follow the defaults: the *loader* will assign safe values during initialization.

## Offer types and States.

| OfferTypes              | States      |
|-------------------------|-------------|
| `OFFER_TYPE_ITEM`         | `STATE_NEW`   |
| `OFFER_TYPE_OUTFIT`       | `STATE_SALE`  |
| `OFFER_TYPE_OUTFIT_ADDON` | `STATE_TIMED` |
| `OFFER_TYPE_MOUNT`        |               |
| `OFFER_TYPE_NAMECHANGE`   |               |
| `OFFER_TYPE_SEXCHANGE`    |               |
| `OFFER_TYPE_PROMOTION`    |               |

## Additional tips

- The helper `useOfferConfigure` remains globally available to manipulate offers dynamically.
- Use `GameStore.resolveState` if you need to define states conditionally before registering the category.
- When removing or renaming files, remember to update the list in `catalog/init.lua` and any references in `parent_categories.lua`.

With these steps, you can safely expand the Game Store while maintaining consistency in the new refactor.
