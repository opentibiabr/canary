<style>
#PantheonEventAllLocationsTable .AdditionalTableShadow, #ExperienceTable .AdditionalTableShadow {
    border: 1px solid #5f4d41;
    box-shadow: 3px 3px 2px #875f3e;
    margin-right: 5px;
    margin-bottom: 5px;
}
.AdditionalTableHeadline {
    background-color: #d5c0a1;
}
.AdditionalTableHeadline td {
    border: 1px solid #faf0d7;
}
</style>
<?php
/**
 * Experience table
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Experience Table';

$experience = array();
$columns = $config['experiencetable_columns'];
for($i = 0; $i < $columns; $i++) {
	for($level = $i * $config['experiencetable_rows'] + 1; $level < $i * $config['experiencetable_rows'] + ($config['experiencetable_rows'] + 1); $level++) {
		$experience[$level] = OTS_Toolbox::experienceForLevel($level);
		$experience[$level] = number_format($experience[$level], 0, ',', ',');
	}
}

$twig->display('experience_table.html.twig', array(
	'experience' => $experience
));
