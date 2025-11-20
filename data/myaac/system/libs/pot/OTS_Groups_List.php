<?php

/**
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * List of groups.
 *
 * @package POT
 * @version 0.1.3
 */
class OTS_Groups_List implements IteratorAggregate, Countable
{
/**
 * Groups.
 *
 * @var array
 */
    private $groups = array();

/**
 * Loads group list.
 *
 * @param string $file Groups file name.
 * @throws DOMException On DOM operation error.
 */
    public function __construct($file = '')
    {
		global $db;
		if($db->hasTable('groups')) { // read groups from database
			foreach($db->query('SELECT `id`, `name`, `access` FROM `groups`;') as $group)
			{
				$info = array();
				$info['id'] = $group['id'];
				$info['name'] = $group['name'];
				$info['access'] = $group['name'];
				$this->groups[$group['id']] = new OTS_Group($info);
			}

			return;
		}

		if(!isset($file[0]))
		{
			global $config;
			$file = $config['data_path'] . 'XML/groups.xml';
		}

		if(!@file_exists($file)) {
			error('Error: Cannot load groups.xml. More info in system/logs/error.log file.');
			log_append('error.log', '[OTS_Groups_List.php] Fatal error: Cannot load groups.xml (' . $file . '). It doesnt exist.');
			return;
		}

		$cache = Cache::getInstance();

		$data = array();
		if($cache->enabled())
		{
			$tmp = '';
			if($cache->fetch('groups', $tmp))
				$data = unserialize($tmp);
			else
			{
				$groups = new DOMDocument();
				if(!@$groups->load($file)) {
					error('Error: Cannot load groups.xml. More info in system/logs/error.log file.');
					log_append('error.log', '[OTS_Groups_List.php] Fatal error: Cannot load groups.xml (' . $file . '). Error: ' . print_r(error_get_last(), true));
					return;
				}

				// loads groups
				foreach( $groups->getElementsByTagName('group') as $group)
				{
					$data[$group->getAttribute('id')] = array(
						'id' => $group->getAttribute('id'),
						'name' => $group->getAttribute('name'),
						'access' => $group->getAttribute('access')
					);
				}

				$cache->set('groups', serialize($data), 120);
			}

			foreach($data as $id => $info)
				$this->groups[ $id ] = new OTS_Group($info);
		}
		else
		{
			// loads DOM document
			$groups = new DOMDocument();
			if(!@$groups->load($file)) {
				error('Error: Cannot load groups.xml. More info in system/logs/error.log file.');
				log_append('error.log', '[OTS_Groups_List.php] Fatal error: Cannot load groups.xml (' . $file . '). Error: ' . print_r(error_get_last(), true));
				return;
			}

			// loads groups
			foreach($groups->getElementsByTagName('group') as $group)
			{
				$data[$group->getAttribute('id')] = array(
					'id' => $group->getAttribute('id'),
					'name' => $group->getAttribute('name'),
					'access' => $group->getAttribute('access')
				);

				$this->groups[ $group->getAttribute('id') ] = new OTS_Group($data[$group->getAttribute('id')]);
				//echo $this->getGroup(1)->getName();
			}
		}
	}

/**
 * Returns given group.
 *
 * @version 0.1.3
 * @param int $id Group id.
 * @return OTS_Group group wrapper.
 * @throws OutOfBoundsException If group does not exist.
 */
    public function getGroup($id)
    {
        if( isset($this->groups[$id]) )
        {
            return $this->groups[$id];
        }

        return false;
    }

/**
 * Returns all groups.
 *
 * @version 0.1.3
 * @return array with OTS_Group group wrappers.
 * @throws OutOfBoundsException If group does not exist.
 */
    public function getGroups()
    {
        if( isset($this->groups) )
        {
            return $this->groups;
        }

        throw new OutOfBoundsException();
    }

	public function getHighestId()
	{
		$group_id = 0;
		foreach($this->groups as $id => $group) {
			if($id > $group_id)
				$group_id = $id;
		}

		return $group_id;
	}

/**
 * Returns string representation of object.
 *
 * <p>
 * If any display driver is currently loaded then it uses it's method.
 * </p>
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return string String representation of object.
 */
    public function __toString()
    {
        $ots = POT::getInstance();

        // checks if display driver is loaded
        if( $ots->isDisplayDriverLoaded() )
        {
            return $ots->getDisplayDriver()->displayGroupsList($this);
        }

        return (string) $this->count();
    }

/**
 * Iterator for all groups.
 *
 * <p>
 * Returned object will continousely iterate through all kind of groups.
 * </p>
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return AppendIterator Iterator for all groups.
 */
    #[\ReturnTypeWillChange]
    public function getIterator()
    {
        $iterator = new AppendIterator();
        $iterator->append( new ArrayIterator($this->groups) );
        return $iterator;
    }

/**
 * Number of all loaded groups.
 *
 * @version 0.1.5
 * @since 0.1.5
 * @return int Amount of all groups.
 */
    public function count(): int
    {
        return count($this->groups);
    }
}
?>
