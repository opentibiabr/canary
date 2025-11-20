<?php
/**
 * Players editor
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$title = 'Player editor';
$base = BASE_URL . 'admin/?p=players';

function echo_success($message)
{
	echo '<p class="success">' . $message . '</p>';
}

function echo_error($message)
{
	global $error;
	echo '<p class="error">' . $message . '</p>';
	$error = true;
}

function verify_number($number, $name, $max_length)
{
	if (!Validator::number($number))
		echo_error($name . ' can contain only numbers.');

	$number_length = strlen($number);
	if ($number_length <= 0 || $number_length > $max_length)
		echo_error($name . ' cannot be longer than ' . $max_length . ' digits.');
}

$skills = array(
	POT::SKILL_FIST => array('Fist fighting', 'fist'),
	POT::SKILL_CLUB => array('Club fighting', 'club'),
	POT::SKILL_SWORD => array('Sword fighting', 'sword'),
	POT::SKILL_AXE => array('Axe fighting', 'axe'),
	POT::SKILL_DIST => array('Distance fighting', 'dist'),
	POT::SKILL_SHIELD => array('Shielding', 'shield'),
	POT::SKILL_FISH => array('Fishing', 'fish')
);


$hasBlessingsColumn = $db->hasColumn('players', 'blessings');
$hasBlessingColumn = $db->hasColumn('players', 'blessings1');
$hasLookAddons = $db->hasColumn('players', 'lookaddons');
?>

<link rel="stylesheet" type="text/css" href="<?php echo BASE_URL; ?>tools/css/jquery.datetimepicker.css"/ >
<script src="<?php echo BASE_URL; ?>tools/js/jquery.datetimepicker.js"></script>

<?php
$id = 0;
if (isset($_REQUEST['id']))
	$id = (int)$_REQUEST['id'];
else if (isset($_REQUEST['search_name'])) {
	if (strlen($_REQUEST['search_name']) < 3 && !Validator::number($_REQUEST['search_name'])) {
		echo 'Player name is too short.';
	} else {
		if (Validator::number($_REQUEST['search_name']))
			$id = $_REQUEST['search_name'];
		else {
			$query = $db->query('SELECT `id` FROM `players` WHERE `name` = ' . $db->quote($_REQUEST['search_name']));
			if ($query->rowCount() == 1) {
				$query = $query->fetch();
				$id = $query['id'];
			} else {
				$query = $db->query('SELECT `id`, `name` FROM `players` WHERE `name` LIKE ' . $db->quote('%' . $_REQUEST['search_name'] . '%'));
				if ($query->rowCount() > 0 && $query->rowCount() <= 10) {
					echo 'Do you mean?<ul>';
					foreach ($query as $row)
						echo '<li><a href="' . $base . '&id=' . $row['id'] . '">' . $row['name'] . '</a></li>';
					echo '</ul>';
				} else if ($query->rowCount() > 10)
					echo 'Specified name resulted with too many players.';
			}
		}
	}
}

$groups = new OTS_Groups_List();
if ($id > 0) {
	$player = new OTS_Player();
	$player->load($id);

	if (isset($player) && $player->isLoaded() && isset($_POST['save'])) {// we want to save
		$error = false;

		if ($player->isOnline())
			echo_error('This player is actually online. You can\'t edit online players.');

		$name = $_POST['name'];
		$_error = '';
		if (!Validator::characterName($name))
			echo_error(Validator::getLastError());

		//if(!Validator::newCharacterName($name)
		//	echo_error(Validator::getLastError());

		$player_db = new OTS_Player();
		$player_db->find($name);
		if ($player_db->isLoaded() && $player->getName() != $name)
			echo_error('This name is already used. Please choose another name!');

		$account_id = $_POST['account_id'];
		verify_number($account_id, 'Account id', 11);

		$account_db = new OTS_Account();
		$account_db->load($account_id);
		if (!$account_db->isLoaded())
			echo_error('Account with this id doesn\'t exist.');

		$group = $_POST['group'];
		if ($groups->getGroup($group) == false)
			echo_error('Group with this id doesn\'t exist');

		$level = $_POST['level'];
		verify_number($level, 'Level', 11);

		$experience = $_POST['experience'];
		verify_number($experience, 'Experience', 20);

		$vocation = $_POST['vocation'];
		verify_number($vocation, 'Vocation id', 11);

		if (!isset($config['vocations'][$vocation])) {
			echo_error("Vocation with this id doesn't exist.");
		}

		// health
		$health = $_POST['health'];
		verify_number($health, 'Health', 11);
		$health_max = $_POST['health_max'];
		verify_number($health_max, 'Health max', 11);

		// mana
		$magic_level = $_POST['magic_level'];
		verify_number($magic_level, 'Magic_level', 11);
		$mana = $_POST['mana'];
		verify_number($mana, 'Mana', 11);
		$mana_max = $_POST['mana_max'];
		verify_number($mana_max, 'Mana max', 11);
		$mana_spent = $_POST['mana_spent'];
		verify_number($mana_spent, 'Mana spent', 11);

		// look
		$look_body = $_POST['look_body'];
		verify_number($look_body, 'Look body', 11);
		$look_feet = $_POST['look_feet'];
		verify_number($look_feet, 'Look feet', 11);
		$look_head = $_POST['look_head'];
		verify_number($look_head, 'Look head', 11);
		$look_legs = $_POST['look_legs'];
		verify_number($look_legs, 'Look legs', 11);
		$look_type = $_POST['look_type'];
		verify_number($look_type, 'Look type', 11);
		if ($hasLookAddons) {
			$look_addons = $_POST['look_addons'];
			verify_number($look_addons, 'Look addons', 11);
		}

		// pos
		$pos_x = $_POST['pos_x'];
		verify_number($pos_x, 'Position x', 11);
		$pos_y = $_POST['pos_y'];
		verify_number($pos_y, 'Position y', 11);
		$pos_z = $_POST['pos_z'];
		verify_number($pos_z, 'Position z', 11);

		$soul = $_POST['soul'];
		verify_number($soul, 'Soul', 10);
		$town = $_POST['town'];
		verify_number($town, 'Town', 11);

		$capacity = $_POST['capacity'];
		verify_number($capacity, 'Capacity', 11);
		$sex = $_POST['sex'];
		verify_number($sex, 'Sex', 1);

		$lastlogin = $_POST['lastlogin'];
		verify_number($lastlogin, 'Last login', 20);
		$lastlogout = $_POST['lastlogout'];
		verify_number($lastlogout, 'Last logout', 20);

		$skull = $_POST['skull'];
		verify_number($skull, 'Skull', 1);
		$skull_time = $_POST['skull_time'];
		verify_number($skull_time, 'Skull time', 11);

		if ($db->hasColumn('players', 'loss_experience')) {
			$loss_experience = $_POST['loss_experience'];
			verify_number($loss_experience, 'Loss experience', 11);
			$loss_mana = $_POST['loss_mana'];
			verify_number($loss_mana, 'Loss mana', 11);
			$loss_skills = $_POST['loss_skills'];
			verify_number($loss_skills, 'Loss skills', 11);
			$loss_containers = $_POST['loss_containers'];
			verify_number($loss_containers, 'Loss loss_containers', 11);
			$loss_items = $_POST['loss_items'];
			verify_number($loss_items, 'Loss items', 11);
		}
		if ($db->hasColumn('players', 'offlinetraining_time')) {
			$offlinetraining = $_POST['offlinetraining'];
			verify_number($offlinetraining, 'Offline Training time', 11);
		}

		if ($hasBlessingsColumn) {
			$blessings = $_POST['blessings'];
			verify_number($blessings, 'Blessings', 2);
		}

		$balance = $_POST['balance'];
		verify_number($balance, 'Balance', 20);
		if ($db->hasColumn('players', 'stamina')) {
			$stamina = $_POST['stamina'];
			verify_number($stamina, 'Stamina', 20);
		}

		$deleted = (isset($_POST['deleted']) && $_POST['deleted'] == 'true');
		$hidden = (isset($_POST['hidden']) && $_POST['hidden'] == 'true');

		$created = $_POST['created'];
		verify_number($created, 'Created', 11);

		$comment = isset($_POST['comment']) ? htmlspecialchars(stripslashes(substr($_POST['comment'], 0, 2000))) : NULL;

		foreach ($_POST['skills'] as $skill => $value)
			verify_number($value, $skills[$skill][0], 10);
		foreach ($_POST['skills_tries'] as $skill => $value)
			verify_number($value, $skills[$skill][0] . ' tries', 10);

		if ($hasBlessingColumn) {
		$bless_count = $_POST['blesscount'];
			for ($i = 1; $i <= $bless_count; $i++) {
				$a = 'blessing' . $i;
				${'blessing' . $i} = (isset($_POST[$a]) && $_POST[$a] == 'true');
			}
		}

		if (!$error) {
			$player->setName($name);
			$player->setAccount($account_db);
			$player->setGroup($groups->getGroup($group));
			$player->setLevel($level);
			$player->setExperience($experience);
			$player->setVocation($vocation);
			$player->setHealth($health);
			$player->setHealthMax($health_max);
			$player->setMagLevel($magic_level);
			$player->setMana($mana);
			$player->setManaMax($mana_max);
			$player->setManaSpent($mana_spent);
			$player->setLookBody($look_body);
			$player->setLookFeet($look_feet);
			$player->setLookHead($look_head);
			$player->setLookLegs($look_legs);
			$player->setLookType($look_type);
			if ($hasLookAddons)
				$player->setLookAddons($look_addons);
			if ($db->hasColumn('players', 'offlinetraining_time'))
				$player->setCustomField('offlinetraining_time', $offlinetraining);
			$player->setPosX($pos_x);
			$player->setPosY($pos_y);
			$player->setPosZ($pos_z);
			$player->setSoul($soul);
			$player->setTownId($town);
			$player->setCap($capacity);
			$player->setSex($sex);
			$player->setLastLogin($lastlogin);
			$player->setLastLogout($lastlogout);
			//$player->setLastIP(ip2long($lastip));
			$player->setSkull($skull);
			$player->setSkullTime($skull_time);
			if ($db->hasColumn('players', 'loss_experience')) {
				$player->setLossExperience($loss_experience);
				$player->setLossMana($loss_mana);
				$player->setLossSkills($loss_skills);
				$player->setLossContainers($loss_containers);
				$player->setLossItems($loss_items);
			}
			if ($db->hasColumn('players', 'blessings'))
				$player->setBlessings($blessings);

			if ($hasBlessingColumn) {
				for ($i = 1; $i <= $bless_count; $i++) {
					$a = 'blessing' . $i;
					$player->setCustomField('blessings' . $i, ${'blessing' . $i} ? '1' : '0');
				}
			}
			$player->setBalance($balance);
			if ($db->hasColumn('players', 'stamina'))
				$player->setStamina($stamina);
			if ($db->hasColumn('players', 'deletion'))
				$player->setCustomField('deletion', $deleted ? '1' : '0');
			else
				$player->setCustomField('deleted', $deleted ? '1' : '0');
			$player->setCustomField('hidden', $hidden ? '1' : '0');
			$player->setCustomField('created', $created);
			if (isset($comment))
				$player->setCustomField('comment', $comment);

			foreach ($_POST['skills'] as $skill => $value) {
				$player->setSkill($skill, $value);
			}
			foreach ($_POST['skills_tries'] as $skill => $value) {
				$player->setSkillTries($skill, $value);
			}
			$player->save();
			echo_success('Player saved at: ' . date('G:i'));
		}
	}
}

$search_name = '';
if (isset($_REQUEST['search_name']))
	$search_name = $_REQUEST['search_name'];
else if ($id > 0 && isset($player) && $player->isLoaded())
	$search_name = $player->getName();

?>
<div class="row">

	<?php
	if (isset($player) && $player->isLoaded()) {
		$account = $player->getAccount();
		?>
		<form action="<?php echo $base . ((isset($id) && $id > 0) ? '&id=' . $id : ''); ?>" method="post" class="form-horizontal col-8">
			<div class="">
				<div class="box box-primary">
					<div class="box-body">



							<nav>
								<div class="nav nav-tabs" id="nav-tab" role="tablist">
									<button class="nav-link active" id="nav-player-tab" data-bs-toggle="tab" data-bs-target="#nav-player" type="button" role="tab" aria-controls="nav-player" aria-selected="true">Player</button>
									<button class="nav-link" id="nav-stats-tab" data-bs-toggle="tab" data-bs-target="#nav-stats" type="button" role="tab" aria-controls="nav-stats" aria-selected="false">Stats</button>
									<button class="nav-link" id="nav-skills-tab" data-bs-toggle="tab" data-bs-target="#nav-skills" type="button" role="tab" aria-controls="nav-skills" aria-selected="false">Skills</button>
									<button class="nav-link" id="nav-poslook-tab" data-bs-toggle="tab" data-bs-target="#nav-poslook" type="button" role="tab" aria-controls="nav-poslook" aria-selected="false">Pos/Look</button>
									<button class="nav-link" id="nav-misc-tab" data-bs-toggle="tab" data-bs-target="#nav-misc" type="button" role="tab" aria-controls="nav-misc" aria-selected="false">Misc</button>

								</div>
							</nav>
							<div class="tab-content" id="nav-tabContent">
								<div class="tab-pane fade show active" id="nav-player" role="tabpanel" aria-labelledby="nav-player-tab">
									<div class="row">
										<div class="col-6">
											<label for="name" class="control-label">Name</label>
											<input type="text" class="form-control" id="name" name="name"
												   autocomplete="off" style="cursor: auto;"
												   value="<?php echo $player->getName(); ?>"/>
										</div>
										<div class="col-6">
											<label for="account_id" class="control-label">Account id:</label>
											<input type="text" class="form-control" id="account_id" name="account_id"
												   autocomplete="off" style="cursor: auto;" size="8" maxlength="11"
												   value="<?php echo $account->getId(); ?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="group" class="control-label">Group:</label>
											<select name="group" id="group" class="form-control">
												<?php foreach ($groups->getGroups() as $id => $group): ?>
													<option value="<?php echo $id; ?>" <?php echo($player->getGroup()->getId() == $id ? 'selected' : ''); ?>><?php echo $group->getName(); ?></option>
												<?php endforeach; ?>
											</select>
										</div>
										<div class="col-6">
											<label for="vocation" class="control-label">Vocation</label>
											<select name="vocation" id="vocation" class="form-control">
												<?php
												foreach ($config['vocations'] as $id => $name) {
													echo '<option value=' . $id . ($id == $player->getVocation() ? ' selected' : '') . '>' . $name . '</option>';
												}
												?>
											</select>
										</div>
									</div>

									<div class="row">
										<div class="col-6">
											<label for="sex" class="control-label">Sex:</label>
											<select name="sex" id="sex" class="form-control">>
												<?php foreach ($config['genders'] as $id => $sex): ?>
													<option value="<?php echo $id; ?>" <?php echo($player->getSex() == $id ? 'selected' : ''); ?>><?php echo strtolower($sex); ?></option>
												<?php endforeach; ?>
											</select>
										</div>
										<div class="col-6">
											<label for="town" class="control-label">Town:</label>
											<select name="town" id="town" class="form-control">
												<?php foreach ($config['towns'] as $id => $town): ?>
													<option value="<?php echo $id; ?>" <?php echo($player->getTownId() == $id ? 'selected' : ''); ?>><?php echo $town; ?></option>
												<?php endforeach; ?>
											</select>
										</div>
									</div>

									<div class="row">
										<div class="col-6">
											<label for="skull" class="control-label">Skull:</label>
											<select name="skull" id="skull" class="form-control">
												<?php
												$skull_type = array("None", "Yellow", "Green", "White", "Red", "Black", "Orange");
												foreach ($skull_type as $id => $s_name) {
													echo '<option value=' . $id . ($id == $player->getSkull() ? ' selected' : '') . '>' . $s_name . '</option>';
												}
												?>
											</select>
										</div>
										<div class="col-6">
											<label for="skull_time" class="control-label">Skull time:</label>
											<input type="text" class="form-control" id="skull_time" name="skull_time"
												   autocomplete="off" maxlength="11"
												   value="<?php echo $player->getSkullTime(); ?>"/>
										</div>
									</div>
									<div class="row">
										<?php if ($hasBlessingColumn):
											$blesscount = $player->countBlessings();
											$bless = $player->checkBlessings($blesscount);
											?>
											<input type="hidden" name="blesscount" value="<?php echo $blesscount; ?>"/>
											<div class="col-6">
												<label for="blessings" class="control-label">Blessings:</label>
												<div class="checkbox">
													<?php
													for ($i = 1; $i <= $blesscount; $i++) {
														echo '<label style="margin-left: 5px;"><input type="checkbox" name="blessing' . $i . '" id="blessing' . $i . '"
																  value="true" ' . (($bless[$i - 1] == 1) ? ' checked' : '') . '/> ' . $i . '</label>';
													}
													?>
												</div>
											</div>
										<?php endif; ?>
										<?php if ($hasBlessingsColumn): ?>
											<div class="col-6">
												<label for="blessings" class="control-label">Blessings:</label>
												<input type="text" class="form-control" id="blessings" name="blessings"
													   autocomplete="off" maxlength="11"
													   value="<?php echo $player->getBlessings(); ?>"/>
											</div>
										<?php endif; ?>

										<div class="col-6">
											<label for="balance" class="control-label">Bank Balance:</label>
											<input type="text" class="form-control" id="balance" name="balance"
												   autocomplete="off" maxlength="20"
												   value="<?php echo $player->getBalance(); ?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="deleted" class="control-label">Deleted:</label>
											<input type="checkbox" name="deleted" id="deleted"
												   value="true" <?php echo($player->getCustomField($db->hasColumn('players', 'deletion') ? 'deletion' : 'deleted') == '1' ? ' checked' : ''); ?>/>
										</div>
										<div class="col-6">
											<label for="hidden" class="control-label">Hidden:</label>
											<input type="checkbox" name="hidden" id="hidden"
												   value="true" <?php echo($player->isHidden() ? ' checked' : ''); ?>/>
										</div>

									</div>
								</div>
								<div class="tab-pane fade" id="nav-stats" role="tabpanel" aria-labelledby="nav-stats-tab">
									<div class="row">
										<div class="col-6">
											<label for="level" class="control-label">Level:</label>

											<input type="text" class="form-control" id="level" name="level"
												   autocomplete="off"
												   style="cursor: auto;" value="<?php echo $player->getLevel(); ?>"/>
										</div>
										<div class="col-6">
											<label for="magic_level" class="control-label">Magic level:</label>
											<input type="text" class="form-control" id="magic_level" name="magic_level"
												   autocomplete="off" size="8" maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getMagLevel(); ?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="experience" class="control-label">Experience:</label>
											<input type="text" class="form-control" id="experience" name="experience"
												   autocomplete="off"
												   style="cursor: auto;"
												   value="<?php echo $player->getExperience(); ?>"/>
										</div>
										<div class="col-6">
											<label for="mana_spent" class="control-label">Mana spent:</label>
											<input type="text" class="form-control" id="mana_spent" name="mana_spent"
												   autocomplete="off"
												   size="3" maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getManaSpent(); ?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="health" class="control-label">Health:</label>
											<input type="text" class="form-control" id="health" name="health"
												   autocomplete="off"
												   size="5" maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getHealth(); ?>"/>
										</div>
										<div class="col-6">
											<label for="health_max" class="control-label">Health max:</label>
											<input type="text" class="form-control" id="health_max" name="health_max"
												   autocomplete="off"
												   size="5" maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getHealthMax(); ?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="mana" class="control-label">Mana:</label>
											<input type="text" class="form-control" id="mana" name="mana"
												   autocomplete="off" size="3"
												   maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getMana(); ?>"/>
										</div>
										<div class="col-6">
											<label for="mana_max" class="control-label">Mana max:</label>
											<input type="text" class="form-control" id="mana_max" name="mana_max"
												   autocomplete="off"
												   size="3" maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getManaMax(); ?>"/>
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="capacity" class="control-label">Capacity:</label>
											<input type="text" class="form-control" id="capacity" name="capacity"
												   autocomplete="off"
												   size="3" maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getCap(); ?>"/>
										</div>
										<div class="col-6">
											<label for="soul" class="control-label">Soul:</label>
											<input type="text" class="form-control" id="soul" name="soul"
												   autocomplete="off" size="3"
												   maxlength="10" style="cursor: auto;"
												   value="<?php echo $player->getSoul(); ?>"/>
										</div>
										<?php if ($db->hasColumn('players', 'stamina')): ?>
											<div class="col-6">
												<label for="stamina" class="control-label">Stamina:</label>
												<input type="text" class="form-control" id="stamina" name="stamina"
													   autocomplete="off"
													   maxlength="20" style="cursor: auto;"
													   value="<?php echo $player->getStamina(); ?>"/>

											</div>
										<?php endif; ?>
										<?php if ($db->hasColumn('players', 'offlinetraining_time')): ?>
											<div class="col-6">
												<label for="offlinetraining" class="control-label">Offline Training
													Time:</label>
												<input type="text" class="form-control" id="offlinetraining"
													   name="offlinetraining" autocomplete="off"
													   maxlength="11"
													   value="<?php echo $player->getCustomField('offlinetraining_time'); ?>"/>
											</div>
										<?php endif; ?>
									</div>
								</div>
								<div class="tab-pane fade" id="nav-skills" role="tabpanel" aria-labelledby="nav-skills-tab">
									<?php
									$i = 0;
				echo '<div class="row">';
									foreach ($skills as $id => $info) {
										if ($i == 0 || $i++ == 2) {
											$i = 0;
										}
										echo '
                    <div class="col-3">
                        <label for="skills[' . $id . ']" class="control-label">' . $info[0] . '</label>
                        <input type="text" class="form-control" id="skills[' . $id . ']" name="skills[' . $id . ']" maxlength="10" autocomplete="off" style="cursor: auto;" value="' . $player->getSkill($id) . '"/>
                    </div>
                    <div class="col-3">
                      <label for="skills_tries[' . $id . ']" class="control-label">' . $info[0] . ' tries</label>
                        <input type="text" class="form-control" id="skills_tries[' . $id . ']" name="skills_tries[' . $id . ']" maxlength="10" autocomplete="off" style="cursor: auto;" value="' . $player->getSkillTries($id) . '"/>
                    </div>';
										if ($i == 0)
											echo '';
									}
				echo '</div>';
									?>
								</div>
								<div class="tab-pane fade" id="nav-poslook" role="tabpanel" aria-labelledby="nav-poslook-tab">
									<?php $outfit = $config['outfit_images_url'] . '?id=' . $player->getLookType() . ($hasLookAddons ? '&addons=' . $player->getLookAddons() : '') . '&head=' . $player->getLookHead() . '&body=' . $player->getLookBody() . '&legs=' . $player->getLookLegs() . '&feet=' . $player->getLookFeet(); ?>
									<div id="imgchar"
										 style="width:64px;height:64px;position:absolute; top:30px; right:30px"><img id="player_outfit"
												style="margin-left:0;margin-top:0px;width:64px;height:64px;"
												src="<?php echo $outfit; ?>"
												alt="player outfit"/></div>
									<?php ?>
									<td>Position:</td>
									<div class="row">
										<div class="col-4">
											<label for="pos_x" class="control-label">X:</label>
											<input type="text" class="form-control" id="pos_x" name="pos_x"
												   autocomplete="off"
												   maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getPosX(); ?>"/>
										</div>
										<div class="col-4">
											<label for="pos_y" class="control-label">Y:</label>
											<input type="text" class="form-control" id="pos_y" name="pos_y"
												   autocomplete="off"
												   maxlength="11" value="<?php echo $player->getPosY(); ?>"/>
										</div>
										<div class="col-4">
											<label for="pos_z" class="control-label">Z:</label>
											<input type="text" class="form-control" id="pos_z" name="pos_z"
												   autocomplete="off"
												   maxlength="11" value="<?php echo $player->getPosZ(); ?>"/>
										</div>
									</div>
									<td>Look:</td>
									<div class="row">
										<div class="col-3">
											<label for="look_head" class="control-label">Head: <span
														id="look_head_val"></span></label>
											<input type="range" min="0" max="132"
												   value="<?php echo $player->getLookHead(); ?>"
												   class="slider form-control" id="look_head" name="look_head">
										</div>
										<div class="col-3">
											<label for="look_body" class="control-label">Body: <span
														id="look_body_val"></span></label>
											<input type="range" min="0" max="132"
												   value="<?php echo $player->getLookBody(); ?>"
												   class="slider form-control" id="look_body" name="look_body">
										</div>
										<div class="col-3">
											<label for="look_legs" class="control-label">Legs: <span
														id="look_legs_val"></span></label>
											<input type="range" min="0" max="132"
												   value="<?php echo $player->getLookLegs(); ?>"
												   class="slider form-control" id="look_legs" name="look_legs">
										</div>
										<div class="col-3">
											<label for="look_feet" class="control-label">Feet: <span
														id="look_feet_val"></span></label>
											<input type="range" min="0" max="132"
												   value="<?php echo $player->getLookFeet(); ?>"
												   class="slider form-control" id="look_feet" name="look_feet">
										</div>
									</div>
									<div class="row">
										<div class="col-6">
											<label for="look_type" class="control-label">Type:</label>
											<input type="text" class="form-control" id="look_type" name="look_type"
												   autocomplete="off"
												   maxlength="11" style="cursor: auto;"
												   value="<?php echo $player->getLookType(); ?>"/>
										</div>
										<?php if ($hasLookAddons): ?>
											<div class="col-6">
												<label for="look_addons" class="control-label">Addons:</label>
												<input type="text" class="form-control" id="look_addons"
													   name="look_addons" autocomplete="off"
													   maxlength="11" value="<?php echo $player->getLookAddons(); ?>"/>
											</div>
										<?php endif; ?>
									</div>
								</div>
								<div class="tab-pane fade" id="nav-misc" role="tabpanel" aria-labelledby="nav-misc-tab">
									<div class="row">
										<div class="col-6">
											<label for="created" class="control-label">Created:</label>
											<input type="text" class="form-control" id="created" name="created"
												   autocomplete="off"
												   maxlength="10"
												   value="<?php echo $player->getCustomField('created'); ?>"/>
										</div>
										<div class="col-6">
											<label for="lastlogin" class="control-label">Last login:</label>
											<input type="text" class="form-control" id="lastlogin" name="lastlogin"
												   autocomplete="off"
												   maxlength="20" value="<?php echo $player->getLastLogin(); ?>"/>
										</div>
										<div class="col-6">
											<label for="lastlogout" class="control-label">Last logout:</label>
											<input type="text" class="form-control" id="lastlogout" name="lastlogout"
												   autocomplete="off"
												   maxlength="20" value="<?php echo $player->getLastLogout(); ?>"/>
										</div>
										<div class="col-6">
											<label for="lastip" class="control-label">Last IP:</label>
                                            <input type="text" class="form-control" id="lastip" name="lastip"
                                                   autocomplete="off"
                                                   maxlength="10"
                                                   value="<?= (strlen($player->getLastIP()) > 11) ? inet_ntop($player->getLastIP()) : longToIp($player->getLastIP()); ?>"
                                                   readonly/>
                                        </div>
									</div>
									<?php if ($db->hasColumn('players', 'loss_experience')): ?>
										<div class="row">
											<div class="col-6">
												<label for="loss_experience" class="control-label">Experience
													Loss:</label>
												<input type="text" class="form-control" id="loss_experience"
													   name="loss_experience" autocomplete="off"
													   maxlength="11"
													   value="<?php echo $player->getLossExperience(); ?>"/>
											</div>
											<div class="col-6">
												<label for="loss_mana" class="control-label">Mana Loss:</label>
												<input type="text" class="form-control" id="loss_mana"
													   name="loss_mana" autocomplete="off"
													   maxlength="11" value="<?php echo $player->getLossMana(); ?>"/>
											</div>
											<div class="col-6">
												<label for="loss_skills" class="control-label">Skills Loss:</label>
												<input type="text" class="form-control" id="loss_skills"
													   name="loss_skills" autocomplete="off"
													   maxlength="11" value="<?php echo $player->getLossSkills(); ?>"/>
											</div>
											<div class="col-6">
												<label for="loss_containers" class="control-label">Containers
													Loss:</label>
												<input type="text" class="form-control" id="loss_containers"
													   name="loss_containers" autocomplete="off"
													   maxlength="11"
													   value="<?php echo $player->getLossContainers(); ?>"/>
											</div>
											<div class="col-6">
												<label for="loss_items" class="control-label">Items Loss:</label>
												<input type="text" class="form-control" id="loss_items"
													   name="loss_items" autocomplete="off"
													   maxlength="11" value="<?php echo $player->getLossItems(); ?>"/>
											</div>
										</div>
									<?php endif; ?>
									<div class="row">
										<div class="col-12">
											<label for="comment" class="control-label">Comment:</label>
											<textarea class="form-control" name="comment" rows="10" cols="50"
													  wrap="virtual"><?php echo $player->getCustomField("comment"); ?></textarea>
											<small>[max.
												length: 2000 chars, 50 lines (ENTERs)]
											</small>
										</div>
									</div>
								</div>
							</div>
					</div>
					<input type="hidden" name="save" value="yes"/>
					<div class="box-footer">
						<a href="<?php echo ADMIN_URL; ?>?p=players"><span class="btn btn-danger"><i class="fa fa-remove"></i> Cancel</span></a>
						<div class="pull-right">
							<input type="submit" class="btn btn-success" value="Update">
						</div>
					</div>
				</div>
			</div>
		</form>
	<?php } ?>
	<div class="col-4">
		<div class="box box-primary">
			<div class="box-header with-border">
				<h3 class="box-title">Search Player:</h3>
				<div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
					</button>
				</div>
			</div>

			<div class="box-body">
				<form action="<?php echo $base; ?>" method="post">
					<div class="input-group input-group-sm">
						<input type="text" class="form-control" name="search_name" value="<?= escapeHtml($search_name) ?>"
							   maxlength="32" size="32">
						<span class="input-group-btn">
                          <button type="submit" type="button" class="btn btn-success"><i class="fa fa-search"></i> Search</button>
                        </span>
					</div>
				</form>
			</div>
		</div>
		<?php
		if (isset($account) && $account->isLoaded()) {
			$account_players = array();
			$query = $db->query('SELECT `name`,`level`,`vocation`  FROM `players` WHERE `account_id` = ' . $account->getId() . ' ORDER BY `name`')->fetchAll();
			if (isset($query)) {
				?>
				<div class="box">
					<div class="box-header">
						<h3 class="box-title">Character List:</h3>
					</div>
					<div class="box-body no-padding">
						<table class="table table-striped">
							<tbody>
							<tr>
								<th style="width: 10px">#</th>
								<th>Name</th>
								<th>Level</th>
								<th style="width: 40px">Edit</th>
							</tr>
							<?php
							$i = 1;
							foreach ($query as $p) {
								$account_players[] = $p;
								echo '<tr>
                            <td>' . $i . '.</td>
                            <td>' . $p['name'] . '</td>
                            <td>' . $p['level'] . '</td>
                            <td><a href="?p=players&search_name=' . $p['name'] . '"><span class="btn btn-success btn-sm edit btn-flat"><i class="fa fa-edit"></i></span></a></span></td>
                        </tr>';
								$i++;
							} ?>
							</tbody>
						</table>
					</div>
				</div>
				<?php
			};
		};
		?>
	</div>


	<script type="text/javascript">
		$('#lastlogin').datetimepicker({
			format: 'unixtime'
		});
		$('#lastlogout').datetimepicker({
			format: 'unixtime'
		});
		$('#created').datetimepicker({
			format: 'unixtime'
		});

		var slider_head = document.getElementById("look_head");
		var output_head = document.getElementById("look_head_val");

		var slider_body = document.getElementById("look_body");
		var output_body = document.getElementById("look_body_val");

		var slider_legs = document.getElementById("look_legs");
		var output_legs = document.getElementById("look_legs_val");

		var slider_feet = document.getElementById("look_feet");
		var output_feet = document.getElementById("look_feet_val");
		output_head.innerHTML = slider_head.value;
		output_body.innerHTML = slider_body.value;
		output_legs.innerHTML = slider_legs.value;
		output_feet.innerHTML = slider_feet.value;

		slider_head.oninput = function () {
			output_head.innerHTML = this.value;
		}
		slider_body.oninput = function () {
			output_body.innerHTML = this.value;
		}
		slider_legs.oninput = function () {
			output_legs.innerHTML = this.value;
		}
		slider_feet.oninput = function () {
			output_feet.innerHTML = this.value;
		}

        $('#look_head').change(function() {updateOutfit()});
        $('#look_body').change(function() {updateOutfit()});
        $('#look_legs').change(function() {updateOutfit()});
        $('#look_feet').change(function() {updateOutfit()});
        $('#look_type').change(function() {updateOutfit()});
		<?php if($hasLookAddons): ?>
        $('#look_addons').change(function() {updateOutfit()});
		<?php endif; ?>

        function updateOutfit()
        {
            var look_head = $('#look_head').val();
            var look_body = $('#look_body').val();
            var look_legs = $('#look_legs').val();
            var look_feet = $('#look_feet').val();
            var look_type = $('#look_type').val();

            var look_addons = '';
            <?php if($hasLookAddons): ?>
                look_addons = '&addons=' + $('#look_addons').val();
	        <?php endif; ?>

            new_outfit = '<?= $config['outfit_images_url']; ?>?id=' + look_type + look_addons + '&head=' + look_head + '&body=' + look_body + '&legs=' + look_legs + '&feet=' + look_feet;
            $("#player_outfit").attr("src", new_outfit);
            console.log(new_outfit);
        }
	</script>
