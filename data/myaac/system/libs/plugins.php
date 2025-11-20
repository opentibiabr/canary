<?php
/**
 * Plugins class
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

function is_sub_dir($path = NULL, $parent_folder = SITE_PATH) {

	//Get directory path minus last folder
	$dir = dirname($path);
	$folder = substr($path, strlen($dir));

	//Check the the base dir is valid
	$dir = realpath($dir);

	//Only allow valid filename characters
	$folder = preg_replace('/[^a-z0-9\.\-_]/i', '', $folder);

	//If this is a bad path or a bad end folder name
	if( !$dir OR !$folder OR $folder === '.') {
		return FALSE;
	}

	//Rebuild path
	$path = $dir. '/' . $folder;

	//If this path is higher than the parent folder
	if( strcasecmp($path, $parent_folder) > 0 ) {
		return $path;
	}

	return FALSE;
}

use Composer\Semver\Semver;

class Plugins {
	private static $warnings = array();
	private static $error = null;
	private static $plugin_json = array();

	public static function getHooks()
	{
		$cache = Cache::getInstance();
		if ($cache->enabled()) {
			$tmp = '';
			if ($cache->fetch('hooks', $tmp)) {
				return unserialize($tmp);
			}
		}

		$hooks = [];
		foreach(get_plugins() as $filename) {
			$string = file_get_contents(PLUGINS . $filename . '.json');
			$string = self::removeComments($string);
			$plugin = json_decode($string, true);
			self::$plugin_json = $plugin;
			if ($plugin == null) {
				self::$warnings[] = 'Cannot load ' . $filename . '.json. File might be not a valid json code.';
				continue;
			}

            if (isset($plugin['enabled']) && !getBoolean($plugin['enabled'])) {
                self::$warnings[] = 'Skipping ' . $filename . '... The plugin is disabled.';
                continue;
            }

			if (isset($plugin['hooks'])) {
				foreach ($plugin['hooks'] as $_name => $info) {
					if (defined('HOOK_'. $info['type'])) {
                        // todo enable with php8+
                        /*if (str_contains($info['type'], 'HOOK_')) {
                            $info['type'] = str_replace('HOOK_', '', $info['type']);
                        }*/
						$hook = constant('HOOK_'. $info['type']);
						$hooks[] = ['name' => $_name, 'type' => $hook, 'file' => $info['file']];
					} else {
						self::$warnings[] = 'Plugin: ' . $filename . '. Unknown event type: ' . $info['type'];
					}
				}
			}
		}

		if ($cache->enabled()) {
			$cache->set('hooks', serialize($hooks), 600);
		}

		return $hooks;
	}

	public static function install($file) {
		global $db;

		if(!\class_exists('ZipArchive')) {
			throw new RuntimeException('Please install PHP zip extension. Plugins upload disabled until then.');
		}

		$zip = new ZipArchive();
		if($zip->open($file) !== true) {
			self::$error = 'There was a problem with opening zip archive.';
			return false;
		}

		for ($i = 0; $i < $zip->numFiles; $i++) {
			$tmp = $zip->getNameIndex($i);
			if(pathinfo($tmp, PATHINFO_DIRNAME) == 'plugins' && pathinfo($tmp, PATHINFO_EXTENSION) == 'json')
				$json_file = $tmp;
		}

		if(!isset($json_file)) {
			self::$error = 'Cannot find plugin info .json file. Installation is discontinued.';
			return false;
		}

		$plugin_temp_dir = CACHE . 'plugins/' . str_replace('.zip', '', basename($file)) . '/';
		if(!$zip->extractTo($plugin_temp_dir)) { // place in cache dir
			self::$error = 'There was a problem with extracting zip archive to cache directory.';
			$zip->close();
			return false;
		}

		self::$error = 'There was a problem with extracting zip archive.';
		$file_name = $plugin_temp_dir . $json_file;
		if(!file_exists($file_name)) {
			self::$error = "Cannot load " . $file_name . ". File doesn't exist.";
			$zip->close();
			return false;
		}

		$string = file_get_contents($file_name);
		$string = self::removeComments($string);
		$plugin_json = json_decode($string, true);
		self::$plugin_json = $plugin_json;
		if ($plugin_json == null) {
			self::$warnings[] = 'Cannot load ' . $file_name . '. File might be not a valid json code.';
		}
		else {
			$continue = true;

			if(!isset($plugin_json['name']) || empty(trim($plugin_json['name']))) {
				self::$warnings[] = 'Plugin "name" tag is not set.';
			}
			if(!isset($plugin_json['description']) || empty(trim($plugin_json['description']))) {
				self::$warnings[] = 'Plugin "description" tag is not set.';
			}
			if(!isset($plugin_json['version']) || empty(trim($plugin_json['version']))) {
				self::$warnings[] = 'Plugin "version" tag is not set.';
			}
			if(!isset($plugin_json['author']) || empty(trim($plugin_json['author']))) {
				self::$warnings[] = 'Plugin "author" tag is not set.';
			}
			if(!isset($plugin_json['contact']) || empty(trim($plugin_json['contact']))) {
				self::$warnings[] = 'Plugin "contact" tag is not set.';
			}

			if(isset($plugin_json['require'])) {
				$require = $plugin_json['require'];

				$myaac_satified = true;
				if(isset($require['myaac_'])) {
					$require_myaac = $require['myaac_'];
					if(!Semver::satisfies(MYAAC_VERSION, $require_myaac)) {
						$myaac_satified = false;
					}
				}
				else if(isset($require['myaac'])) {
					$require_myaac = $require['myaac'];
					if(version_compare(MYAAC_VERSION, $require_myaac, '<')) {
						$myaac_satified = false;
					}
				}

				if(!$myaac_satified) {
					self::$error = "Your AAC version doesn't meet the requirement of this plugin. Required version is: " . $require_myaac . ", and you're using version " . MYAAC_VERSION . ".";
					return false;
				}

				$php_satisfied = true;
				if(isset($require['php_'])) {
					$require_php = $require['php_'];
					if(!Semver::satisfies(phpversion(), $require_php)) {
						$php_satisfied = false;
					}
				}
				else if(isset($require['php'])) {
					$require_php = $require['php'];
					if(version_compare(phpversion(), $require_php, '<')) {
						$php_satisfied = false;
					}
				}

				if(!$php_satisfied) {
					self::$error = "Your PHP version doesn't meet the requirement of this plugin. Required version is: " . $require_php . ", and you're using version " . phpversion() . ".";
					$continue = false;
				}

				$database_satisfied = true;
				if(isset($require['database_'])) {
					$require_database = $require['database_'];
					if(!Semver::satisfies(DATABASE_VERSION, $require_database)) {
						$database_satisfied = false;
					}
				}
				else if(isset($require['database'])) {
					$require_database = $require['database'];
					if(version_compare(DATABASE_VERSION, $require_database, '<')) {
						$database_satisfied = false;
					}
				}

				if(!$database_satisfied) {
					self::$error = "Your database version doesn't meet the requirement of this plugin. Required version is: " . $require_database . ", and you're using version " . DATABASE_VERSION . ".";
					$continue = false;
				}

				if($continue) {
					foreach($require as $req => $version) {
						$req = strtolower(trim($req));
						$version = trim($version);

						if(in_array($req, array('myaac', 'myaac_', 'php', 'php_', 'database', 'database_'))) {
							continue;
						}

						if(in_array($req, array('php-ext', 'php-extension'))) { // require php extension
							if(!extension_loaded($version)) {
								self::$error = "This plugin requires php extension: " . $version . " to be installed.";
								$continue = false;
								break;
							}
						}
						else if($req == 'table') {
							if(!$db->hasTable($version)) {
								self::$error = "This plugin requires table: " . $version . " to exist in the database.";
								$continue = false;
								break;
							}
						}
						else if($req == 'column') {
							$tmp = explode('.', $version);
							if(count($tmp) == 2) {
								if(!$db->hasColumn($tmp[0], $tmp[1])) {
									self::$error = "This plugin requires database column: " . $tmp[0] . "." . $tmp[1] . " to exist in database.";
									$continue = false;
									break;
								}
							}
						}
						else if(strpos($req, 'ext-') !== false) {
							$tmp = explode('-', $req);
							if(count($tmp) == 2) {
								if(!extension_loaded($tmp[1]) || !Semver::satisfies(phpversion($tmp[1]), $version)) {
									self::$error = "This plugin requires php extension: " . $tmp[1] . ", version " . $version . " to be installed.";
									$continue = false;
									break;
								}
							}
						}
						else if(!self::is_installed($req, $version)) {
							self::$error = "This plugin requires another plugin to run correctly. The another plugin is: " . $req . ", with version " . $version . ".";
							$continue = false;
							break;
						}
					}
				}
			}

			if($continue) {
				if(!$zip->extractTo(BASE)) { // "Real" Install
					self::$error = 'There was a problem with extracting zip archive to base directory.';
					$zip->close();
					return false;
				}

				if (isset($plugin_json['install'])) {
					if (file_exists(BASE . $plugin_json['install'])) {
						$db->revalidateCache();
						require BASE . $plugin_json['install'];
						$db->revalidateCache();
					}
					else
						self::$warnings[] = 'Cannot load install script. Your plugin might be not working correctly.';
				}

				$cache = Cache::getInstance();
				if($cache->enabled()) {
					$cache->delete('templates');
					$cache->delete('hooks');
					$cache->delete('template_menus');
				}

				return true;
			}
		}

		return false;
	}

	public static function uninstall($plugin_name)
	{
		$filename = BASE . 'plugins/' . $plugin_name . '.json';
		if(!file_exists($filename)) {
			self::$error = 'Plugin ' . $plugin_name . ' does not exist.';
			return false;
		}
		$string = file_get_contents($filename);
		$string = self::removeComments($string);
		$plugin_info = json_decode($string, true);
		if($plugin_info == false) {
			self::$error = 'Cannot load plugin info ' . $plugin_name . '.json';
			return false;
		}

		if(!isset($plugin_info['uninstall'])) {
			self::$error = "Plugin doesn't have uninstall options defined. Skipping...";
			return false;
		}

		$success = true;
		foreach($plugin_info['uninstall'] as $file) {
			if(strpos($file, '/') === 0) {
				$success = false;
				self::$error = "You cannot use absolute paths (starting with slash - '/'): " . $file;
				break;
			}

			$file = str_replace('\\', '/', BASE . $file);
			$realpath = str_replace('\\', '/', realpath(dirname($file)));
			if(!is_sub_dir($file, BASE) || $realpath != dirname($file)) {
				$success = false;
				self::$error = "You don't have rights to delete: " . $file;
				break;
			}
		}

		if($success) {
			foreach($plugin_info['uninstall'] as $file) {
				if(!deleteDirectory(BASE . $file)) {
					self::$warnings[] = 'Cannot delete: ' . $file;
				}
			}

			$cache = Cache::getInstance();
			if($cache->enabled()) {
				$cache->delete('templates');
				$cache->delete('hooks');
				$cache->delete('template_menus');
			}

			return true;
		}

		return false;
	}

	public static function is_installed($plugin_name, $version) {
		$filename = BASE . 'plugins/' . $plugin_name . '.json';
		if(!file_exists($filename)) {
			return false;
		}

		$string = file_get_contents($filename);
		$plugin_info = json_decode($string, true);
		if($plugin_info == false) {
			return false;
		}

		if(!isset($plugin_info['version'])) {
			return false;
		}

		return Semver::satisfies($plugin_info['version'], $version);
	}

	public static function getWarnings() {
		return self::$warnings;
	}

	public static function getError() {
		return self::$error;
	}

	public static function getPluginJson() {
		return self::$plugin_json;
	}

	public static function removeComments($string) {
		$string = preg_replace('!/\*.*?\*/!s', '', $string);
		$string = preg_replace('/\n\s*\n/', "\n", $string);
		//  Removes multi-line comments and does not create
		//  a blank line, also treats white spaces/tabs
		$string = preg_replace('!^[ \t]*/\*.*?\*/[ \t]*[\r\n]!s', '', $string);

		//  Removes single line '//' comments, treats blank characters
		$string = preg_replace('![ \t]*//.*[ \t]*[\r\n]!', '', $string);

		//  Strip blank lines
		$string = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $string);

		return $string;
	}
}
