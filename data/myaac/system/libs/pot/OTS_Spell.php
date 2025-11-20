<?php

/**#@+
 * @version 0.0.7
 * @since 0.0.7
 */

/**
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Wrapper for spell info.
 * 
 * @package POT
 * @version 0.1.3
 * @property-read int $type Spell type.
 * @property-read string $name Spell name.
 * @property-read int $id Spell ID.
 * @property-read string $words Spell formula.
 * @property-read bool $agressive Does spell marks action as an attack.
 * @property-read int $charges Rune charges count.
 * @property-read int $level Required level.
 * @property-read int $magicLevel Required magic level.
 * @property-read int $mana Mana usage.
 * @property-read int $soul Soul points usage.
 * @property-read bool $hasParams Does spell has any arguments.
 * @property-read bool $enabled Is spell enabled.
 * @property-read bool $farUseAllowed Can the spell be used from distance.
 * @property-read bool $premium Does spell requires PACC.
 * @property-read bool $learnNeeded Does the spell needs to be learned.
 * @property-read OTS_ItemType|null $conjure Conjure item type.
 * @property-read OTS_ItemType|null $reagent Item required to cast this spell.
 * @property-read int $conjuresCount Amount of items created with conjure cast.
 * @property-read array $vocations List of vocations allowed to use.
 */
class OTS_Spell
{
/**
 * Spell type.
 * 
 * @var int
 */
    private $type;

/**
 * Spell info resource.
 * 
 * @var DOMElement
 */
    private $element;

/**
 * Sets spell info.
 * 
 * @param int $type Spell type.
 * @param DOMElement $spell Spell info.
 */
    public function __construct($type, DOMElement $spell)
    {
        $this->type = $type;
        $this->element = $spell;
    }

/**
 * Returns spell type.
 * 
 * @return int Spell type.
 */
    public function getType()
    {
        return $this->type;
    }

/**
 * Returns spell name.
 * 
 * @return string Name.
 * @throws DOMException On DOM operation error.
 */
    public function getName()
    {
        return $this->element->getAttribute('name');
    }

/**
 * Returns rune item id.
 * 
 * @return int Rune item ID.
 * @throws DOMException On DOM operation error.
 */
    public function getID()
    {
        return (int) $this->element->getAttribute('id');
    }

/**
 * Returns spell formula.
 * 
 * @return string Formula.
 * @throws DOMException On DOM operation error.
 */
    public function getWords()
    {
        return $this->element->getAttribute('words');
    }

/**
 * Checks if spell is threated as unfriendly by other creatures.
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @return bool Is spell aggressive.
 * @throws DOMException On DOM operation error.
 */
    public function isAggressive()
    {
        return $this->element->getAttribute('aggressive') != '0';
    }

/**
 * @version 0.1.0
 * @return bool Is spell aggressive.
 * @deprecated 0.1.0 Use isAggressive().
 */
    public function isAggresive()
    {
        return $this->isAggressive();
    }

/**
 * Number of rune charges.
 * 
 * @return int Rune charges.
 * @throws DOMException On DOM operation error.
 */
    public function getCharges()
    {
        return (int) $this->element->getAttribute('charges');
    }

/**
 * Level required for use.
 * 
 * @return int Required level.
 * @throws DOMException On DOM operation error.
 */
    public function getLevel()
    {
        return (int) $this->element->getAttribute('lvl');
    }

/**
 * Magic level required to cast.
 * 
 * @return int Required magic level.
 * @throws DOMException On DOM operation error.
 */
    public function getMagicLevel()
    {
        return (int) $this->element->getAttribute('maglv');
    }

/**
 * Mana cost.
 * 
 * @return int Mana usage.
 * @throws DOMException On DOM operation error.
 */
    public function getMana()
    {
        return (int) $this->element->getAttribute('mana');
    }

/**
 * Soul points cost.
 * 
 * @return int Soul points usage.
 * @throws DOMException On DOM operation error.
 */
    public function getSoul()
    {
        return (int) $this->element->getAttribute('soul');
    }

/**
 * Checks if spell has parameter.
 * 
 * @return bool True if spell takes a parameter.
 * @throws DOMException On DOM operation error.
 */
    public function hasParams()
    {
        return $this->element->getAttribute('params') == '1';
    }

/**
 * Checks if spell is enabled.
 * 
 * @return bool Is spell enabled.
 * @throws DOMException On DOM operation error.
 */
    public function isEnabled()
    {
        return $this->element->getAttribute('enabled') != '0';
    }

/**
 * Checks if distance use allowed.
 * 
 * @return bool Is it possible to use this spell from distance.
 * @throws DOMException On DOM operation error.
 */
    public function isFarUseAllowed()
    {
        return $this->element->getAttribute('allowfaruse') == '1';
    }

/**
 * Checks if spell requires PACC.
 * 
 * @return bool Is spell only for Premium Account.
 * @throws DOMException On DOM operation error.
 */
    public function isPremium()
    {
        return $this->element->getAttribute('prem') == '1';
    }

/**
 * Checks if spell needs to be learned.
 * 
 * @return bool Does this spell need to be learned.
 * @throws DOMException On DOM operation error.
 */
    public function isLearnNeeded()
    {
        return $this->element->getAttribute('needlearn') == '1';
    }

/**
 * @return int Item ID.
 * @deprecated 0.1.0 Use getConjure()->getId().
 */
    public function getConjureId()
    {
        return (int) $this->element->getAttribute('conjureId');
    }

/**
 * Returns item type of conjured item.
 * 
 * <p>
 * Note: You need to have global items list resource loaded in order to use this method.
 * </p>
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @return OTS_ItemType|null Returns item type of conjure item (null if not exists).
 * @throws E_OTS_NotLoaded When there is no global items list available.
 * @throws DOMException On DOM operation error.
 */
    public function getConjure()
    {
        return POT::getInstance()->getItemsList()->getItemType( (int) $this->element->getAttribute('conjureId') );
    }

/**
 * @return int Reagent ID.
 * @deprecated 0.1.0 Use getReagent()->getId().
 */
    public function getReagentId()
    {
        return (int) $this->element->getAttribute('reagentId');
    }

/**
 * Returns item type of reagent item.
 * 
 * <p>
 * Note: You need to have global items list resource loaded in order to use this method.
 * </p>
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @return OTS_ItemType|null Returns item type of reagent item (null if not exists).
 * @throws E_OTS_NotLoaded When there is no global items list available.
 * @throws DOMException On DOM operation error.
 */
    public function getReagent()
    {
        return POT::getInstance()->getItemsList()->getItemType( (int) $this->element->getAttribute('reagentId') );
    }

/**
 * Returns amount of items conjured by this spell.
 * 
 * @return int Items count.
 * @throws DOMException On DOM operation error.
 */
    public function getConjureCount()
    {
        return (int) $this->element->getAttribute('conjureCount');
    }

/**
 * Returns list of vocations that are allowed to learn this spell.
 * 
 * @return array List of vocation names.
 * @throws DOMException On DOM operation error.
 */
    public function getVocations()
    {
	    global $config;
	    if(!isset($config['vocation_ids']))
		    $config['vocations_ids'] = array_flip($config['vocations']);
	
	    $vocations = array();

        foreach( $this->element->getElementsByTagName('vocation') as $vocation)
        {
	        if($vocation->getAttribute('id') != NULL) {
		        $voc_id = $vocation->getAttribute('id');
	        }
	        else {
		        $voc_id = $config['vocations_ids'][$vocation->getAttribute('name')];
	        }
	
	        $vocations[] = $voc_id;
        }

        return $vocations;
    }
	
	public function getVocationsFull()
	{
	    global $config;
	    if(!isset($config['vocation_ids']))
	        $config['vocations_ids'] = array_flip($config['vocations']);
	    
		$vocations = array();
		
		foreach( $this->element->getElementsByTagName('vocation') as $vocation)
		{
		    $show = $vocation->getAttribute('showInDescription');
            if($vocation->getAttribute('id') != NULL) {
	            $voc_id = $vocation->getAttribute('id');
            }
            else {
                $voc_id = $config['vocations_ids'][$vocation->getAttribute('name')];
            }
		    
		    $vocations[$voc_id] = strlen($show) == 0 || $show != '0';
		}
		
		return $vocations;
	}
/**
 * Creates conjure item.
 * 
 * <p>
 * Note: You need to have global items list resource loaded in order to use this method.
 * </p>
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @return OTS_Item Conjured item.
 * @throws E_OTS_NotLoaded When there is no global items list available.
 * @throws DOMException On DOM operation error.
 */
    public function createConjure()
    {
        $item = $this->getConjure()->createItem();
        $item->setCount( $this->getConjureCount() );
        return $item;
    }

/**
 * Magic PHP5 method.
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws E_OTS_NotLoaded When there is no global items list available.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws DOMException On DOM operation error.
 */
    public function __get($name)
    {
        switch($name)
        {
            case 'type':
                return $this->getType();

            case 'name':
                return $this->getName();

            case 'id':
                return $this->getId();

            case 'words':
                return $this->getWords();

            case 'aggressive':
                return $this->isAggressive();

            case 'charges':
                return $this->getCharges();

            case 'level':
                return $this->getLevel();

            case 'magicLevel':
                return $this->getMagicLevel();

            case 'mana':
                return $this->getMana();

            case 'soul':
                return $this->getSoul();

            case 'hasParams':
                return $this->hasParams();

            case 'enabled':
                return $this->isEnabled();

            case 'farUseAllowed':
                return $this->isFarUseAllowed();

            case 'premium':
                return $this->isPremium();

            case 'learnNeeded':
                return $this->isLearnNeeded();

            case 'conjure':
                return $this->getConjure();

            case 'reagent':
                return $this->getReagent();

            case 'conjuresCount':
                return $this->getConjuresCount();

            case 'vocations':
                return $this->getVocations();

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of XML.
 * 
 * <p>
 * If any display driver is currently loaded then it uses it's method. Otherwise just returns spell XML format.
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
        if( $ots->isDataDisplayDriverLoaded() )
        {
            return $ots->getDataDisplayDriver()->displaySpell($this);
        }

        return $this->element->ownerDocument->saveXML($this->element);
    }
}

/**#@-*/

?>
