# House Store catalog for 15.25

The house additions module registers 11 beds, 135 standalone furniture/decoration
products and 33 four-piece furniture sets. All 25 referenced beds are now offered.
The nine functional upgrades were already present; podiums remain in Decorations.
Existing offer IDs are retained; additions use explicit 78001-78011, 78101-78235
and 78401-78433 IDs. The three Exercise Wraps durations each have one offer.

## References and identity

- [Store and furniture sets](https://www.tibiawiki.com.br/wiki/Store)
- [Public Store table](https://exetares.wiki/Store)
- [Official products manual](https://www.tibia.com/gameguides/?section=products&subtopic=manual)
- [Sighting collection announcement](https://www.tibia.com/news/?id=8507&subtopic=newsarchive)
- [Floor and Divider collection announcement](https://www.tibia.com/news/?id=8706&subtopic=newsarchive)

Prices are public regular prices, without temporary discounts. Item IDs are
matched against the installed 15.25 appearance catalog and server XML. The public
Sickbay Table metadata mistakenly repeats the cabinet IDs; the offer uses native
table IDs 50172-50175 instead. Witchcraft Table includes its three native visual
states, and the Store kits deliver the empty bed halves rather than sleepers.

## Delivery and behavior

House deliveries reserve the full number of decoration-kit slots, bind kits to
the buyer and remove prepared kits if delivery or payment fails. Set summaries
record each component after payment. Bed definitions connect both sexes, both
orientations and both halves; occupied states derive their wake-up target from
the free state's native ItemParse references. Lamps preserve orientation when
toggled, and new rolled floors can be unfolded and folded.

For containers without a published volume, the new definitions follow the
project's 18-slot chest / 8-slot cabinet convention. These capacities have not
been measured against CipSoft. This catalog addition does not claim reproduction
of every pet sound, timed animation or interaction in the original game.

## Validation status

The XML/native appearance IDs were checked locally. This PR does not include
image binaries or test scripts. An actual client purchase, house placement,
sleep/wake cycle, rotations and item use still require gameplay validation after
the server loads the updated data. HTTP preview assets must be provisioned
separately for `coinImagesURL`; three new beds are absent from the public image
pack and have no tile preview on any client version.
