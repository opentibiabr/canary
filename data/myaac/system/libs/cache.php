<?php
/**
 * Cache class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    Mark Samman (Talaturen) <marksamman@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

/**
 * Class Cache
 *
 * @method set($key, $var, $ttl = 0)
 * @method get($key)
 * @method fetch($key, &$var)
 * @method delete($key)
 */
class Cache
{
    static private $instance;

    /**
     * @return Cache
     */
    public static function getInstance()
    {
        if (!self::$instance) {
            return self::generateInstance(config('cache_engine'), config('cache_prefix'));
        }

        return self::$instance;
    }

    /**
     * @param string $engine
     * @param string $prefix
     * @return Cache
     */
    public static function generateInstance($engine = '', $prefix = '')
    {
        if (config('env') === 'dev') {
            self::$instance = new self();
            return self::$instance;
        }

        switch (strtolower($engine)) {
            case 'apc':
                require 'cache_apc.php';
                self::$instance = new Cache_APC($prefix);
                break;

            case 'apcu':
                require 'cache_apcu.php';
                self::$instance = new Cache_APCu($prefix);
                break;

            case 'eaccelerator':
                require 'cache_eaccelerator.php';
                self::$instance = new Cache_eAccelerator($prefix);
                break;

            case 'xcache':
                require 'cache_xcache.php';
                self::$instance = new Cache_XCache($prefix);
                break;

            case 'file':
                require 'cache_file.php';
                self::$instance = new Cache_File($prefix, CACHE);
                break;

            case 'php':
                require 'cache_php.php';
                self::$instance = new Cache_PHP($prefix, CACHE);
                break;

            case 'auto':
                self::$instance = self::generateInstance(self::detect(), $prefix);
                break;

            default:
                self::$instance = new self();
                break;
        }

        return self::$instance;
    }

    /**
     * @return string
     */
    public static function detect()
    {
        if (function_exists('apc_fetch'))
            return 'apc';
        else if (function_exists('apcu_fetch'))
            return 'apcu';
        else if (function_exists('eaccelerator_get'))
            return 'eaccelerator';
        else if (function_exists('xcache_get') && ini_get('xcache.var_size'))
            return 'xcache';

        return 'file';
    }

    /**
     * @return bool
     */
    public function enabled()
    {
        return false;
    }

    public static function remember($key, $ttl, $callback)
    {
        $cache = self::getInstance();
        if (!$cache->enabled()) {
            return $callback();
        }

        $value = null;
        if ($cache->fetch($key, $value)) {
            return unserialize($value);
        }

        $value = $callback();
        $cache->set($key, serialize($value), $ttl);
        return $value;
    }
}
