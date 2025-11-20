<?php

/*
 * ***********************************************************************
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
 * ***********************************************************************
 */

/**
 * Represent a parameter item
 */
class PagSeguroParameterItem
{

    /**
     * Allow add extra information to order
     *
     * @var string
     */
    private $key;

    /**
     * Value of corresponding key
     *
     * @var mixed
     */
    private $value;

    /**
     * Used for grouping values of parameter items
     * @var mixed
     */
    private $group;

    public function __construct($key, $value, $group = null)
    {
        if (isset($key) && !PagSeguroHelper::isEmpty($key)) {
            $this->setKey($key);
        }
        if (isset($value) && !PagSeguroHelper::isEmpty($value)) {
            $this->setValue($value);
        }
        if (isset($group) && !PagSeguroHelper::isEmpty($group)) {
            $this->setGroup($group);
        }
    }

    /**
     * Gets the parameter item key
     * @return string
     */
    public function getKey()
    {
        return $this->key;
    }

    /**
     * Sets the parameter item key
     *
     * @param string $key
     */
    public function setKey($key)
    {
        $this->key = $key;
    }

    /**
     * Gets parameter item value
     * @return string
     */
    public function getValue()
    {
        return $this->value;
    }

    /**
     * Sets parameter item value
     *
     * @param string $value
     */
    public function setValue($value)
    {
        $this->value = $value;
    }

    /**
     * Gets parameter item group
     *
     * @return int
     */
    public function getGroup()
    {
        return $this->group;
    }

    /**
     * Sets parameter item group
     *
     * @param int $group
     */
    public function setGroup($group)
    {
        $this->group = (int) $group;
    }
}
