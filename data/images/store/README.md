# Game Store HTTP image deployment

The repository does not check in Store image binaries. Export the actual catalog
inventory and deploy available previews from the public Store image pack:

```sh
python -m pip install -r tools/store/requirements.txt
CANARY_STORE_IMAGE_LIST=/tmp/store-images.txt luajit tests/store/list_store_http_images.lua
python tools/store/fetch_missing_store_offer_icons.py /tmp/store-images.txt --deploy /var/www/html/images/store
```

The six new 15.25 bundles and the Voodoo, Sighting and Cyclops Steel beds do not
have previews in that public image pack. The installer reports these nine files
and deploys the other available catalog images. Native 15.25 clients render
their item appearances; legacy clients have no preview for those nine offers.
Other missing inventory entries remain errors so an incomplete image pack is
not silently treated as complete.

The installer verifies complete PNG structure and decoded pixels before writing
files. Images that are already deployed are preserved. Set `coinImagesURL` to
the HTTP root containing the resulting `13/` and `64/` directories.
