function onUpdateDatabase()
	logger.info("Updating database to version 48 (House Auction)")

	db.query([[
		ALTER TABLE `houses`
		DROP `bid`,
		DROP `bid_end`,
		DROP `last_bid`,
		DROP `highest_bidder`
	]])

	db.query([[
		ALTER TABLE `houses`
		ADD `bidder` int(11) NOT NULL DEFAULT '0',
		ADD `bidder_name` varchar(255) NOT NULL DEFAULT '',
		ADD `highest_bid` int(11) NOT NULL DEFAULT '0',
		ADD `internal_bid` int(11) NOT NULL DEFAULT '0',
		ADD `bid_end_date` int(11) NOT NULL DEFAULT '0',
		ADD `state` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
		ADD `transfer_status` tinyint(1) DEFAULT '0'
	]])

	db.query([[
		ALTER TABLE `accounts`
		ADD `house_bid_id` int(11) NOT NULL DEFAULT '0'
	]])
end
