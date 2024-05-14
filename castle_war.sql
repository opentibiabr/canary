CREATE TABLE `castle_war` (
  `id` int NOT NULL DEFAULT '0',
  `guild_id` int NOT NULL,
  `guild_name` varchar(64) NOT NULL,
  `timestamp` int NOT NULL,
  `throne_points` bigint NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
