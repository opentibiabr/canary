<?php
/**
 * Logs
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Logs Viewer';

$files = array();
$aac_path_logs = BASE . 'system/logs/';
foreach (scandir($aac_path_logs, SCANDIR_SORT_ASCENDING) as $f) {
    if ($f[0] === '.' || is_dir($aac_path_logs . $f)) {
	    continue;
    }

    $files[] = array($f, $aac_path_logs);
}

$server_path_logs = $config['server_path'] . 'logs/';
if (!file_exists($server_path_logs)) {
    $server_path_logs = $config['data_path'] . 'logs/';
}

if (file_exists($server_path_logs)) {
    foreach (scandir($server_path_logs, SCANDIR_SORT_ASCENDING) as $f) {
        if ($f[0] === '.') {
	        continue;
        }

        if (is_dir($server_path_logs . $f)) {
            foreach (scandir($server_path_logs . $f, SCANDIR_SORT_ASCENDING) as $f2) {
                if ($f2[0] === '.') {
	                continue;
                }

                $files[] = array($f . '/' . $f2, $server_path_logs);
            }

            continue;
        }

        $files[] = array($f, $server_path_logs);
    }
}

foreach ($files as &$f) {
    $f['mtime'] = filemtime($f[1] . $f[0]);
    $f['name'] = $f[0];
}
unset($f);

$twig->display('admin.logs.html.twig', array('files' => $files));

define('EXIST_NONE', 0);
define('EXIST_SERVER_LOG', 1);
define('EXIST_AAC_LOG', 2);

$exist = EXIST_NONE;
$file = isset($_GET['file']) ? $_GET['file'] : null;
if (!empty($file)) {
	if (!preg_match('/[^A-z0-9\' _\/\-\.]/', $file)) {
		if (file_exists($aac_path_logs . $file)) {
			$exist = EXIST_AAC_LOG;
		} else if (file_exists($server_path_logs . $file)) {
			$exist = EXIST_SERVER_LOG;
		} else {
			echo 'Specified file does not exist.';
		}

		if ($exist !== EXIST_NONE) {
			$content = nl2br(file_get_contents(($exist === EXIST_SERVER_LOG ? $server_path_logs : $aac_path_logs) . $file));
			$twig->display('admin.logs.view.html.twig', array('file' => $file, 'content' => $content));
		}
	} else {
		echo 'Invalid file name specified.';
	}
}
