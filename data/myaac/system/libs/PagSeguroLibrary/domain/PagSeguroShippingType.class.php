<?php

/*
 ************************************************************************
 Copyright [2011] [PagSeguro Internet Ltda.]

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ************************************************************************
 */

/**
 * Defines a list of known shipping types.
 * this class is not an enum to enable the introduction of new shipping types
 * without breaking this version of the library.
 */
class PagSeguroShippingType
{

    /**
     * @var array
     */
    private static $typeList = array(
        'PAC' => 1,
        'SEDEX' => 2,
        'NOT_SPECIFIED' => 3
    );

    /**
     * the shipping type value
     * Example: 1
     */
    private $value;

    /**
     * @param null $value
     */
    public function __construct($value = null)
    {
        if ($value) {
            $this->value = $value;
        }
    }

    /**
     * @param $value
     */
    public function setValue($value)
    {
        $this->value = $value;
    }

    /**
     * @param $type
     * @throws Exception
     */
    public function setByType($type)
    {
        if (isset(self::$typeList[$type])) {
            $this->value = self::$typeList[$type];
        } else {
            throw new Exception("undefined index $type");
        }
    }

    /**
     * @return int the value of the shipping type
     */
    public function getValue()
    {
        return $this->value;
    }

    /**
     * @param value
     * @return PagSeguroShippingType the PagSeguroShippingType corresponding to the informed value
     */
    public function getTypeFromValue($value = null)
    {
        $value = ($value === null ? $this->value : $value);
        return array_search($value, self::$typeList);
    }

    /**
     * @param string
     * @return integer the code corresponding to the informed shipping type
     */
    public static function getCodeByType($type)
    {
        if (isset(self::$typeList[$type])) {
            return self::$typeList[$type];
        } else {
            return false;
        }
    }

    /**
     * @param string $type
     * @return PagSeguroShippingType a PagSeguroShippingType object corresponding to the informed type
     */
    public static function createByType($type)
    {
        $ShippingType = new PagSeguroShippingType();
        $ShippingType->setByType($type);
        return $ShippingType;
    }
}
