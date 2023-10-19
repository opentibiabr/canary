local zone = SpawnZone("spawn.issavi-south")

zone:setMonstersPerCluster(6, 7)
zone:setClusterRadius(3, 4)
zone:setClusterSpacing(9, 14)
zone:setOutlierChance(0.5)
zone:setPeriod("40s")

zone:configureMonster("Adult Goanna", 28)
zone:configureMonster("Young Goanna", 30)
zone:configureMonster("Feral Sphinx", 26)
zone:configureMonster("Manticore", 11)
zone:configureMonster("Scorpion", 2)
zone:configureMonster("Hyaena", 1)
zone:configureMonster("Cobra", 2)

zone:register()
