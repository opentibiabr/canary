function onUpdateDatabase()
	Spdlog.info("Updating database to version 13 (Boosted Creature Outfit)")
    db.query("ALTER TABLE boosted_creature ADD `looktype` int(11) NOT NULL DEFAULT 136;")
    db.query("ALTER TABLE boosted_creature ADD `lookfeet` int(11) NOT NULL DEFAULT 0;")
    db.query("ALTER TABLE boosted_creature ADD `looklegs` int(11) NOT NULL DEFAULT 0;")
    db.query("ALTER TABLE boosted_creature ADD `lookhead` int(11) NOT NULL DEFAULT 0;")
    db.query("ALTER TABLE boosted_creature ADD `lookbody` int(11) NOT NULL DEFAULT 0;")
    db.query("ALTER TABLE boosted_creature ADD `lookaddons` int(11) NOT NULL DEFAULT 0;")
    db.query("ALTER TABLE boosted_creature ADD `lookmount` int(11) DEFAULT 0;")
	return true
end
