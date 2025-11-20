<?php
// few things we'll need
require '../common.php';

define('ADMIN_PANEL', true);
define('MYAAC_ADMIN', true);

if (file_exists(BASE . 'config.local.php')) {
  require_once BASE . 'config.local.php';
}

if (file_exists(BASE . 'install') && (!isset($config['installed']) || !$config['installed'])) {
  header('Location: ' . BASE_URL . 'install/');
  throw new RuntimeException(
    'Setup detected that <b>install/</b> directory exists. Please visit <a href="' .
      BASE_URL .
      'install">this</a> url to start MyAAC Installation.<br/>Delete <b>install/</b> directory if you already installed MyAAC.<br/>Remember to REFRESH this page when you\'re done!'
  );
}

$content = '';

// validate page
$page = $_GET['p'] ?? '';
if (empty($page) || preg_match('/[^a-zA-Z0-9_\-]/', $page)) {
  $page = 'dashboard';
}

$page = strtolower($page);
define('PAGE', $page);

require SYSTEM . 'functions.php';
require SYSTEM . 'init.php';

if (config('env') === 'dev') {
  ini_set('display_errors', 1);
  ini_set('display_startup_errors', 1);
  error_reporting(E_ALL);
}

// event system
require_once SYSTEM . 'hooks.php';
$hooks = new Hooks();
$hooks->load();

require SYSTEM . 'status.php';
require SYSTEM . 'login.php';
require SYSTEM . 'migrate.php';
require ADMIN . 'includes/functions.php';

$twig->addGlobal('config', $config);
$twig->addGlobal('status', $status);

// if we're not logged in - show login box
if (!$logged || !admin()) {
  $page = 'login';
}

// include our page
$file = ADMIN . 'pages/' . $page . '.php';
if (!@file_exists($file)) {
  $page = '404';
  $file = SYSTEM . 'pages/404.php';
}

ob_start();
include $file;

$content .= ob_get_contents();
ob_end_clean();

// template
$template_path = 'template/';
require ADMIN . $template_path . 'template.php';
?>

<?php if ($config['pace_load']) { ?>
    <script src="../admin/bootstrap/pace/pace.js"></script>
    <link href="../admin/bootstrap/pace/themes/white/pace-theme-flash.css" rel="stylesheet"/>
<?php } ?>
