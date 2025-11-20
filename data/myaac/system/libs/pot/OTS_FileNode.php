<?php

/**#@+
 * @version 0.0.6
 * @since 0.0.6
 */

/**
 * Code in this file bases on oryginal OTServ binary format loading C++ code (fileloader.h, fileloader.cpp).
 * 
 * @package POT
 * @version 0.1.2
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * OTServ binary file node representation.
 * 
 * <p>
 * This file extends {@link OTS_Buffer OTS_Buffer class} for nodes tree logic with siblings and childs.
 * </p>
 * 
 * @package POT
 * @version 0.1.2
 * @property OTS_FileNode $next Next sibling node.
 * @property OTS_FileNode $child First child node.
 * @property int $type Node type.
 */
class OTS_FileNode extends OTS_Buffer
{
/**
 * Next sibling node.
 * 
 * @var OTS_FileNode
 */
    private $next;
/**
 * First child node.
 * 
 * @var OTS_FileNode
 */
    private $child;
/**
 * Node type.
 * 
 * @var int
 */
    private $type;

/**
 * Creates clone of object.
 * 
 * <p>
 * Creates complete tree copy by copying sibling and child nodes.
 * </p>
 */
    public function __clone()
    {
        // clones conencted nodes
        if( isset($this->child) )
        {
            $this->child = clone $this->child;
        }

        if( isset($this->next) )
        {
            $this->next = clone $this->next;
        }
    }

/**
 * Returs next sibling.
 * 
 * @return OTS_FileNode Sibling node.
 */
    public function getNext()
    {
        return $this->next;
    }

/**
 * Sets next sibling.
 * 
 * @param OTS_FileNode Sibling node.
 */
    public function setNext(OTS_FileNode $next)
    {
        $this->next = $next;
    }

/**
 * Returs first child.
 * 
 * @return OTS_FileNode Child node.
 */
    public function getChild()
    {
        return $this->child;
    }

/**
 * Sets first child.
 * 
 * @param OTS_FileNode Child node.
 */
    public function setChild(OTS_FileNode $child)
    {
        $this->child = $child;
    }

/**
 * Returs node type.
 * 
 * @return int Node type.
 */
    public function getType()
    {
        return $this->type;
    }

/**
 * Sets node type.
 * 
 * @param int Node type.
 */
    public function setType($type)
    {
        $this->type = $type;
    }

/**
 * Magic PHP5 method.
 * 
 * @version 0.1.2
 * @since 0.1.0
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws E_OTS_OutOfBuffer When there is read attemp after end of stream.
 */
    public function __get($name)
    {
        switch($name)
        {
            // simple properties
            case 'next':
            case 'child':
            case 'type':
                return $this->$name;

            default:
                return parent::__get($name);
        }
    }

/**
 * Magic PHP5 method.
 * 
 * @version 0.1.2
 * @since 0.1.0
 * @param string $name Property name.
 * @param mixed $value Property value.
 * @throws OutOfBoundsException For non-supported properties.
 */
    public function __set($name, $value)
    {
        switch($name)
        {
            // simple properties
            case 'next':
            case 'child':
            case 'type':
                $this->$name = $value;
                break;

            default:
                parent::__set($name, $value);
        }
    }
}

/**#@-*/

?>
