<?php
/**
 * Reports
 *
 * @package   MyAAC
 * @author    Lee
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Report Viewer';

$files = array();
$server_path_reports = $config['data_path'] . 'reports/';

if (file_exists($server_path_reports)) {
    foreach (scandir($server_path_reports, SCANDIR_SORT_ASCENDING) as $f) {
        if ($f[0] === '.') {
	        continue;
        }

        if (is_dir($server_path_reports . $f)) {
            foreach (scandir($server_path_reports . $f, SCANDIR_SORT_ASCENDING) as $f2) {
                if ($f2[0] === '.') {
	                continue;
                }

                $files[] = array($f . '/' . $f2, $server_path_reports);
            }

            continue;
        }

        $files[] = array($f, $server_path_reports);
    }
}

foreach ($files as &$f) {
	$f['mtime'] = filemtime($f[1] . $f[0]);
	$f['name'] = $f[0];
}

unset($f);

$twig->display('admin.reports.html.twig', array('files' => $files));


$file = isset($_GET['file']) ? $_GET['file'] : NULL;
if (!empty($file)) {
	if (!preg_match('/[^A-z0-9\' _\/\-\.]/', $file)) {
		if (file_exists($server_path_reports . $file)) {
			$content = nl2br(file_get_contents($server_path_reports . $file));

			$twig->display('admin.logs.view.html.twig', array('file' => $file, 'content' => $content));
		} else {
			echo 'Specified file does not exist.';
		}
	} else {
		echo 'Invalid file name specified.';
	}
}
