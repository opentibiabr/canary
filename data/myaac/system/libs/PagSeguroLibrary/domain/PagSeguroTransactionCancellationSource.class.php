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
 * Defines a list of known transaction cancellation source.
 * This class is not an enum to enable the introduction of new cancellation source.
 * without breaking this version of the library.
 */
class PagSeguroTransactionCancellationSource
{

    /**
     * @var array
     */
    private static $sourceList = array(
        'PAGSEGURO' => "INTERNAL",
        'FINANCEIRA' => "EXTERNAL"        
    );

    /**
     * the value of the transaction cancellation source
     * Example: EXTERNAL
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
        if (isset(self::$sourceList[$type])) {
            $this->value = self::$sourceList[$type];
        } else {
            throw new Exception("undefined index $type");
        }
    }

    /**
     * @return string the status value.
     */
    public function getValue()
    {
        return $this->value;
    }

    /**
     * @param value
     * @return String the transaction cancellation source corresponding to the informed source value
     */
    public function getTypeFromValue($value = null)
    {
        $value = ($value == null ? $this->value : $value);
        return array_search($this->value, self::$sourceList);
    }

    /**
     * Get status list
     * @return array
     */
    public static function getSourceList()
    {
        return self::$sourceList;
    }
}
