# Game Store HTTP images

Deploy `13/` and `64/` under the HTTP base configured by `coinImagesURL`.
For example, `https://example.org/images/store/` must serve category icons at
`/images/store/13/` and static offer previews at `/images/store/64/`.
Copying files into Canary's data directory alone does not publish them to clients.
No server URL or administrator-specific web directory is configured by this PR.

The contribution includes all 91 images referenced by the isolated Store catalog:
26 category icons and 65 static offer previews. Item, mount and outfit appearances
rendered directly from client assets do not need their optional HTTP filenames.
Source URLs and hashes are recorded in the adjacent JSON manifests. Original
artwork belongs to CipSoft.

## Refreshing missing images

Export the actual catalog inventory:

```sh
CANARY_STORE_IMAGE_LIST=/tmp/store-images.txt luajit tests/store/list_store_http_images.lua
python tools/store/fetch_store_category_icons.py --deploy /var/www/html/images/store
python tools/store/fetch_missing_store_offer_icons.py /tmp/store-images.txt --deploy /var/www/html/images/store
```

The fetchers validate PNG signatures/dimensions and retain existing images.
The offer pack is the public Store archive linked by OTClient:
https://dl.dropboxusercontent.com/s/5b00ubu1erapu9q/store.zip.
One legacy Hireling Dragon file contains GIF bytes; converting that entry uses
the Windows image codec. Already checked-in PNGs can be deployed on any platform.

## Bundle previews

Each transparent 64x64 preview shows the outfit, mount and decoration together.
Two previews are official PNGs; four are decoded from the first frame of the
existing composite GIF artwork. No sprites are redrawn or invented. The selected
offer displays individual component names and native appearances separately.
Versioned filenames avoid cached outfit-only previews.

| Local PNG | Source |
| --- | --- |
| Bundle_Rotten_Blood_1525.png | https://www.tibiawiki.com.br/images/a/aa/Rotten_Blood_Bundle.gif |
| Bundle_Sweet_Honey_1525.png | https://www.tibiawiki.com.br/images/1/11/Sweet_Honey_Bundle.gif |
| Bundle_Field_Surgeon_1525.png | https://static.tibia.com/images/store/64/Dez2024_FieldSurgeonBundle.png |
| Bundle_Martial_Artist_1525.png | https://www.tibiawiki.com.br/images/e/e0/Martial_Artist_Bundle.gif |
| Bundle_Shadow_Vengeance_1525.png | https://www.tibiawiki.com.br/images/6/6b/Shadow_Vengeance_Bundle.gif |
| Bundle_Burning_Ash_1525.png | https://static.tibia.com/images/store/64/Product_December2025_Bundle.png |

## Additional 15.25 beds

`bed-icons-1525.json` records eleven additional previews, native appearance IDs
and SHA-256 hashes. Empty pillow and blanket sprites are combined in their real
positions, trimmed and fitted into transparent 64x64 PNGs extracted from the
installed 15.25 CipSoft sprite sheets. No generated artwork is used.
