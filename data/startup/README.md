Reserved action/unique for tables:

Door level:
The defined range is from 1000/1999
Since the three numbers after 1 determine the level
Example:
Level 10 = 1010
Level 100 = 1100

Chest (action) = 5000/12000
Chest (unique) = 5000/12000
Chests custom (action) 12001/15000
Chests custom (unique) 12001/15000
Reward keys = 5000/6000

TeleportItem (action) = 15001/20000 (this is teleport items, not magic forcefield)
TeleportItem (unique) = 15001/20000 (this is teleport items, not magic forcefield)

Corpse (action )= 20000/25000
Corpse (unique) = 20000/22000

DoorStorage (action) = It is not defined, because it uses storages as action
DoorStorage (unique) = 22001/25000

Tile (action) = 25001/29000
Tile (unique) = 25001/29000
Tile remove/create item (action) = 29001/30000
Tile remove/create item (unique) = 29001/30000

Lever (action) = 30001/35000
Lever (unique) = 30001/35000

Teleport (action) = 35001/40000 (this is magic forcefield items)
Teleport (unique) = 35001/40000 (this is magic forcefield items)

Item (action) = 40001/42000
Item (unique) = 40001/42000

This folder was created exclusively for tables and functions that are loaded at startup or that cannot be reloaded, thus maintaining greater organization in the files.

Action IDS
	Use actionID only if you need to create a function that is called multiple times in different locations.
	The action is also used as storage, "x" storage is added in the player,
	and the same action number gives access to a door, for example.

	Reserved player action storage key ranges (const.h at the source)
	[10000000 - 20000000]
	[1000 - 1500]
	[2001 - 2011]

	Others reserved player action/storages
	[100] = unmoveable/untrade/unusable items
	[101] = use pick floor
	[102] = down floor action
	[103] = key 0010
	[103-120] = keys action
	[104] = Parchment of the parchment room quest
	[303] = key 0303
	[1000] = level door. Here 1 must be used followed by the level. Example: 1010 = level 10, 1100 = level 100]
	[3001-3008] = key 3001/3008
	[3012] = key 3012
	[3033] = key 3033
	[3100] = key 3100
	[3142] = key 3142
	[3200] = key 3200
	[3301] = key 3301
	[3302] = key 3302
	[3303] = key 3303
	[3304] = key 3304
	[3350] = key 3350
	[3520] = key 3520
	[3600] = key 3600
	[3610] = key 3610
	[3620] = key 3620
	[3650] = key 3650
	[3666] = key 3666
	[3667] = key 3667
	[3700] = key 3700
	[3701/3703] = key 3701/3703
	[3800/3802] = key 3800/3802
	[3899] = key 3899
	[3900] = key 3900
	[3909/3917] = key 3909/3917
	[3923] = key 3923
	[3925] = key 3925
	[3930] = key 3930
	[3932] = key 3932
	[3934] = key 3934
	[3935] = key 3935
	[3936] = key 3936
	[3938] = key 3938
	[3940] = key 3940
	[3950] = key 3950
	[3960] = key 3960
	[3980] = key 3980
	[3988] = key 3988
	[4001] = key 4001
	[4009] = key 4009
	[4022] = key 4022
	[4023] = key 4023
	[4033] = key 4033
	[4037] = key 4037
	[4055] = key 4055
	[4210] = key 4210
	[4501] = key 4501
	[4502] = key 4502
	[4503] = key 4503
	[4600] = key 4600
	[4601] = key 4601
	[4603] = key 4603
	[5000] = key 5000
	[5002] = key 5002
	[5010] = key 5010
	[5050] = key 5050
	[6010] = key 6010
