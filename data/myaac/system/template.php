<?php
/**
 * Template parsing engine.
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

// template
$template_name = $config['template'];
if ($config['template_allow_change']) {
  if (isset($_GET['template'])) {
    if (!preg_match('/[^A-z0-9_\-]/', $template_name)) {
      // validate template
      //setcookie('template', $template_name, 0, BASE_DIR . '/', $_SERVER["SERVER_NAME"]);
      $template_name = $_GET['template'];

      $cache = Cache::getInstance();
      if ($cache->enabled()) {
        $cache->delete('template_menus');
      }

      setSession('template', $template_name);

      $newLocation = $lastUri = getSession('last_uri');
      if ($lastUri === $_SERVER['REQUEST_URI']) {
        // avoid ERR_TOO_MANY_REDIRECTS error in browsers
        $newLocation = SERVER_URL;
      }

      header('Location:' . $newLocation);
    }
  } else {
    $template_session = getSession('template');
    if ($template_session !== false) {
      if (!preg_match('/[^A-z0-9_\-]/', $template_session)) {
        $template_name = $template_session;
      }
    }
  }
}
$template_path = 'templates/' . $template_name;

if (file_exists(BASE . $template_path . '/index.php')) {
  $template_index = 'index.php';
} elseif (file_exists(BASE . $template_path . '/template.php')) {
  $template_index = 'template.php';
} elseif ($config['backward_support'] && file_exists(BASE . $template_path . '/layout.php')) {
  $template_index = 'layout.php';
} else {
  $template_name = 'kathrine';
  $template_path = 'templates/' . $template_name;
  $template_index = 'template.php';
  if (!file_exists(BASE . $template_path . '/' . $template_index)) {
    throw new RuntimeException(
      'Cannot load any template. Please ensure your templates directory is not empty, and you set correct name for template in configuration.'
    );
  }
}

if (file_exists(BASE . $template_path . '/config.php')) {
  require BASE . $template_path . '/config.php';
}

$tmp = '';
if ($cache->enabled() && $cache->fetch('template_ini_' . $template_name, $tmp)) {
  $template_ini = unserialize($tmp);
} else {
  $file = BASE . $template_path . '/config.ini';
  $exists = file_exists($file);
  if (
    $exists ||
    ($config['backward_support'] && file_exists(BASE . $template_path . '/layout_config.ini'))
  ) {
    if (!$exists) {
      $file = BASE . $template_path . '/layout_config.ini';
    }

    $template_ini = parse_ini_file($file);
    unset($file);

    if ($cache->enabled()) {
      $cache->set('template_ini_' . $template_name, serialize($template_ini));
    }
  }
}

if (isset($template_ini)) {
  foreach ($template_ini as $key => $value) {
    $config[$key] = $value;
  }
}

$template = [];
$template['link_account_manage'] = getLink('account/manage');
$template['link_account_create'] = getLink('account/create');
$template['link_account_lost'] = getLink('account/lost');
$template['link_account_logout'] = getLink('account/logout');

$template['link_news_archive'] = getLink('news/archive');

$links = [
  'news',
  'changelog',
  'rules',
  'downloads',
  'characters',
  'online',
  'highscores',
  'powergamers',
  'lastkills',
  'houses',
  'guilds',
  'wars',
  'polls',
  'bans',
  'team',
  'creatures',
  'spells',
  'commands',
  'experienceStages',
  'freeHouses',
  'serverInfo',
  'experienceTable',
  'faq',
  'points',
  'gifts',
  'bugtracker',
  'gallery',
];
foreach ($links as $link) {
  $template['link_' . $link] = getLink($link);
}

$template['link_screenshots'] = getLink('gallery');
$template['link_movies'] = getLink('videos');

$template['link_gifts_history'] = getLink('gifts', 'history');
if ($config['forum'] != '') {
  if (strtolower($config['forum']) == 'site') {
    $template['link_forum'] = "<a href='" . getLink('forum') . "'>";
  } else {
    $template['link_forum'] = "<a href='" . $config['forum'] . "' target='_blank'>";
  }
}

$twig->addGlobal('template_path', $template_path);
if ($twig_loader) {
  $twig_loader->prependPath(BASE . $template_path);
}

function get_template_menus()
{
  global $db, $template_name;

  $cache = Cache::getInstance();
  if ($cache->enabled()) {
    $tmp = '';
    if ($cache->fetch('template_menus', $tmp)) {
      $result = unserialize($tmp);
    }
  }

  if (!isset($result)) {
    $query = $db->query(
      'SELECT `name`, `link`, `blank`, `color`, `category` FROM `' .
        TABLE_PREFIX .
        'menu` WHERE `template` = ' .
        $db->quote($template_name) .
        ' ORDER BY `category`, `ordering` ASC'
    );
    $result = $query->fetchAll();

    if ($cache->enabled()) {
      $cache->set('template_menus', serialize($result), 600);
    }
  }

  $menus = [];
  foreach ($result as $menu) {
    $link_full = strpos(trim($menu['link']), 'http') === 0 ? $menu['link'] : getLink($menu['link']);
    $menus[$menu['category']][] = [
      'name' => $menu['name'],
      'link' => $menu['link'],
      'link_full' => $link_full,
      'blank' => $menu['blank'] == 1,
      'color' => $menu['color'],
    ];
  }

  $new_menus = [];
  /**
   * @var array $configMenuCategories
   * @var int $id
   * @var array $options
   */
  $configMenuCategories = config('menu_categories');
  if ($configMenuCategories === null) {
    return [];
  }

  foreach ($configMenuCategories as $id => $options) {
    if (isset($menus[$id])) {
      $new_menus[$id] = $menus[$id];
    }
  }

  return $new_menus;
}
