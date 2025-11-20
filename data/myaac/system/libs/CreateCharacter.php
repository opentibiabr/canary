<?php
/**
 * CreateCharacter
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */

class CreateCharacter
{
    /**
     * @param string $name
     * @param array $errors
     * @return bool
     */
    public function checkName($name, &$errors)
    {
        $minLength = config('character_name_min_length');
        $maxLength = config('character_name_max_length');

        if (empty($name)) {
            $errors['name'] = 'Please enter a name for your character!';
            return false;
        }

        $name_length = strlen($name);

        if ($name_length > $maxLength) {
            $errors['name'] = 'Name is too long. Max. length <b>' . $maxLength . '</b> letters.';
            return false;
        }

        if ($name_length < $minLength) {
            $errors['name'] = 'Name is too short. Min. length <b>' . $minLength . '</b> letters.';
            return false;
        }

        if (strspn($name, "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM- '") != $name_length) {
            $errors['name'] = 'This name contains invalid letters, words or format. Please use only a-Z, - , \' and space.';
            return false;
        }

        if (!preg_match("/[A-z ']/", $name)) {
            $errors['name'] = 'Your name contains illegal characters.';
            return false;
        }

        if (!admin() && !Validator::newCharacterName($name)) {
            $errors['name'] = Validator::getLastError();
            return false;
        }

        return empty($errors);
    }

    /**
     * @param string $name
     * @param int $sex
     * @param int $vocation
     * @param int $town
     * @param array $errors
     * @return bool
     */
    public function check($name, $sex, &$vocation, &$town, &$errors)
    {
        $this->checkName($name, $errors);

        if (empty($sex) && $sex != "0") {
            $errors['sex'] = 'Please select the sex for your character!';
        }

        if (count(config('character_samples')) > 1) {
            if (!isset($vocation))
                $errors['vocation'] = 'Please select a vocation for your character.';
        } else
            $vocation = config('character_samples')[0];

        if (count(config('character_towns')) > 1) {
            if (!isset($town)) {
                $errors['town'] = 'Please select a town for your character.';
            }
        } else {
            $town = config('character_towns')[0];
        }

        if (empty($errors)) {
            if (!isset(config('genders')[$sex]))
                $errors['sex'] = 'Sex is invalid.';
            if (!in_array($town, config('character_towns'), false))
                $errors['town'] = 'Please select valid town.';
            if (count(config('character_samples')) > 1) {
                $newchar_vocation_check = false;
                foreach ((array)config('character_samples') as $char_vocation_key => $sample_char)
                    if ($vocation === $char_vocation_key)
                        $newchar_vocation_check = true;
                if (!$newchar_vocation_check)
                    $errors['vocation'] = 'Unknown vocation. Please fill in form again.';
            } else
                $vocation = 0;
        }

        return empty($errors);
    }

    /**
     * @param string $name
     * @param int $sex
     * @param int $vocation
     * @param int $town
     * @param OTS_Account $account
     * @param array $errors
     * @return bool
     * @throws E_OTS_NotLoaded
     * @throws Twig_Error_Loader
     * @throws Twig_Error_Runtime
     * @throws Twig_Error_Syntax
     */
    public function doCreate($name, $sex, $vocation, $town, $account, &$errors)
    {
        if (!$this->check($name, $sex, $vocation, $town, $errors)) {
            return false;
        }

        if (empty($errors)) {
            $number_of_players_on_account = $account->getPlayersList()->count();
            if ($number_of_players_on_account >= config('characters_per_account'))
                $errors[] = 'You have too many characters on your account <b>(' . $number_of_players_on_account . '/' . config('characters_per_account') . ')</b>!';
        }

        if (empty($errors)) {
            $char_to_copy_name = config('character_samples')[$vocation];
            $char_to_copy = new OTS_Player();
            $char_to_copy->find($char_to_copy_name);
            if (!$char_to_copy->isLoaded())
                $errors[] = 'Wrong characters configuration. Try again or contact with admin. ADMIN: Edit file config.php and set valid characters to copy names. Character to copy: <b>' . $char_to_copy_name . '</b> doesn\'t exist.';
        }

        if (!empty($errors)) {
            return false;
        }

        global $db;

        if ($sex == "0")
            $char_to_copy->setLookType(136);

        $player = new OTS_Player();
        $player->setName($name);
        $player->setAccount($account);
        $player->setGroupId(1);
        $player->setSex($sex);
        $player->setVocation($char_to_copy->getVocation());
        if ($db->hasColumn('players', 'promotion'))
            $player->setPromotion($char_to_copy->getPromotion());

        if ($db->hasColumn('players', 'direction'))
            $player->setDirection($char_to_copy->getDirection());

        $player->setConditions($char_to_copy->getConditions());
        $rank = $char_to_copy->getRank();
        if ($rank->isLoaded()) {
            $player->setRank($char_to_copy->getRank());
        }

        if ($db->hasColumn('players', 'lookaddons'))
            $player->setLookAddons($char_to_copy->getLookAddons());

        $player->setTownId($town);
        $player->setExperience($char_to_copy->getExperience());
        $player->setLevel($char_to_copy->getLevel());
        $player->setMagLevel($char_to_copy->getMagLevel());
        $player->setHealth($char_to_copy->getHealth());
        $player->setHealthMax($char_to_copy->getHealthMax());
        $player->setMana($char_to_copy->getMana());
        $player->setManaMax($char_to_copy->getManaMax());
        $player->setManaSpent($char_to_copy->getManaSpent());
        $player->setSoul($char_to_copy->getSoul());

        for ($skill = POT::SKILL_FIRST; $skill <= POT::SKILL_LAST; $skill++) {
            $player->setSkill($skill,
                config('use_character_sample_skills') ? $char_to_copy->getSkill($skill) : 10);
        }

        $player->setLookBody($char_to_copy->getLookBody());
        $player->setLookFeet($char_to_copy->getLookFeet());
        $player->setLookHead($char_to_copy->getLookHead());
        $player->setLookLegs($char_to_copy->getLookLegs());
        $player->setLookType($char_to_copy->getLookType());
        $player->setCap($char_to_copy->getCap());
        $player->setBalance(0);
        $player->setPosX(0);
        $player->setPosY(0);
        $player->setPosZ(0);

        if ($db->hasColumn('players', 'stamina')) {
            $player->setStamina($char_to_copy->getStamina());
        }

        if ($db->hasColumn('players', 'loss_experience')) {
            $player->setLossExperience($char_to_copy->getLossExperience());
            $player->setLossMana($char_to_copy->getLossMana());
            $player->setLossSkills($char_to_copy->getLossSkills());
        }
        if ($db->hasColumn('players', 'loss_items')) {
            $player->setLossItems($char_to_copy->getLossItems());
            $player->setLossContainers($char_to_copy->getLossContainers());
        }
        if ($db->hasColumn('players', 'ismain')) {
            $player->setMain($number_of_players_on_account == 0);
        }

        $player->save();
        $player->setCustomField('created', time());

        $player = new OTS_Player();
        $player->find($name);

        if (!$player->isLoaded()) {
            error("Error. Can't create character. Probably problem with database. Please try again later or contact with admin.");
            return false;
        }

        if ($db->hasTable('player_skills')) {
            for ($i = 0; $i < 7; $i++) {
                $value = config('use_character_sample_skills') ? $char_to_copy->getSkill($i) : 10;
                $skillExists = $db->query('SELECT `skillid` FROM `player_skills` WHERE `player_id` = ' . $player->getId() . ' AND `skillid` = ' . $i);
                if ($skillExists->rowCount() <= 0) {
                    $db->query("INSERT INTO `player_skills` (`player_id`, `skillid`, `value`, `count`) VALUES ({$player->getId()}, {$i}, {$value}, 0)");
                }
            }
        }

        if ($db->hasTableAndColumns('player_items', ['pid', 'sid', 'itemtype'])) {
            $loaded_items_to_copy = $db->query("SELECT * FROM player_items WHERE player_id = {$char_to_copy->getId()}");
            foreach ($loaded_items_to_copy as $save_item) {
                $db->query("INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES ({$player->getId()}, {$db->quote($save_item['pid'])}, {$db->quote($save_item['sid'])}, {$db->quote($save_item['itemtype'])}, {$db->quote($save_item['count'])}, {$db->quote($save_item['attributes'])});");
            }
        }

        global $twig;
        $twig->display('success.html.twig', array(
            'title' => 'Character Created',
            'description' => 'The character <b>' . $name . '</b> has been created.<br/>
					Please select the outfit when you log in for the first time.<br/><br/>
					<b>See you on ' . configLua('serverName') . '!</b>'
        ));

        $account->logAction('Created character <b>' . $name . '</b>.');
        return true;
    }
}
