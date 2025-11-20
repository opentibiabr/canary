<?php
/**
 * Events system
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$i = 0;
define('HOOK_STARTUP', ++$i);
define('HOOK_BEFORE_PAGE', ++$i);
define('HOOK_AFTER_PAGE', ++$i);
define('HOOK_FINISH', ++$i);
define('HOOK_TIBIACOM_ARTICLE', ++$i);
define('HOOK_TIBIACOM_BORDER_3', ++$i);
define('HOOK_CHARACTERS_BEFORE_INFORMATIONS', ++$i);
define('HOOK_CHARACTERS_AFTER_INFORMATIONS', ++$i);
define('HOOK_CHARACTERS_BEFORE_SKILLS', ++$i);
define('HOOK_CHARACTERS_AFTER_SKILLS', ++$i);
define('HOOK_CHARACTERS_AFTER_QUESTS', ++$i);
define('HOOK_CHARACTERS_AFTER_EQUIPMENT', ++$i);
define('HOOK_CHARACTERS_BEFORE_DEATHS', ++$i);
define('HOOK_CHARACTERS_BEFORE_SIGNATURE', ++$i);
define('HOOK_CHARACTERS_AFTER_SIGNATURE', ++$i);
define('HOOK_CHARACTERS_AFTER_ACCOUNT', ++$i);
define('HOOK_CHARACTERS_AFTER_CHARACTERS', ++$i);
define('HOOK_LOGIN', ++$i);
define('HOOK_LOGIN_ATTEMPT', ++$i);
define('HOOK_LOGOUT', ++$i);
define('HOOK_ACCOUNT_CREATE_BEFORE_FORM', ++$i);
define('HOOK_ACCOUNT_CREATE_BEFORE_BOXES', ++$i);
define('HOOK_ACCOUNT_CREATE_BETWEEN_BOXES_1', ++$i);
define('HOOK_ACCOUNT_CREATE_BETWEEN_BOXES_2', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_BOXES', ++$i);
define('HOOK_ACCOUNT_CREATE_BEFORE_ACCOUNT', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_ACCOUNT', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_EMAIL', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_COUNTRY', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_PASSWORDS', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_RECAPTCHA', ++$i);
define('HOOK_ACCOUNT_CREATE_BEFORE_CHARACTER_NAME', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_CHARACTER_NAME', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_SEX', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_VOCATION', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_TOWNS', ++$i);
define('HOOK_ACCOUNT_CREATE_BEFORE_SUBMIT_BUTTON', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_FORM', ++$i);
define('HOOK_ACCOUNT_CREATE_AFTER_SUBMIT', ++$i);
define('HOOK_EMAIL_CONFIRMED', ++$i);
define('HOOK_FIRST', HOOK_STARTUP);
define('HOOK_LAST', HOOK_EMAIL_CONFIRMED);

require_once LIBS . 'plugins.php';

class Hook
{
  private $_name, $_type, $_file;

  public function __construct($name, $type, $file)
  {
    $this->_name = $name;
    $this->_type = $type;
    $this->_file = $file;
  }

  public function execute($params)
  {
    extract($params);
    /*if(is_callable($this->_callback))
        {
            $tmp = $this->_callback;
            $ret = $tmp($params);
        }*/

    global $db, $config, $template_path, $ots, $content, $twig;
    $ret = include BASE . $this->_file;

    return !isset($ret) || $ret == 1 || $ret;
  }

  public function name()
  {
    return $this->_name;
  }

  public function type()
  {
    return $this->_type;
  }
}

class Hooks
{
  private static $_hooks = [];

  public function register($hook, $type = '', $file = null)
  {
    if (!($hook instanceof Hook)) {
      $hook = new Hook($hook, $type, $file);
    }

    self::$_hooks[$hook->type()][] = $hook;
  }

  public function trigger($type, $params = [])
  {
    $ret = true;
    if (isset(self::$_hooks[$type])) {
      foreach (self::$_hooks[$type] as $name => $hook) {
        /** @var $hook Hook */
        if (!$hook->execute($params)) {
          $ret = false;
        }
      }
    }

    return $ret;
  }

  public function exist($type)
  {
    return isset(self::$_hooks[$type]);
  }

  public function load()
  {
    foreach (Plugins::getHooks() as $hook) {
      $this->register($hook['name'], $hook['type'], $hook['file']);
    }
  }
}
