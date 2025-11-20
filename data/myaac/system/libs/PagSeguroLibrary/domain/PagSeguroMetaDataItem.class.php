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
 * Represent a metadata item
 */
class PagSeguroMetaDataItem
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
     * Used for grouping values of metadata items
     * @var mixed
     */
    private $group;

    public function __construct($key = null, $value = null, $group = null)
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
     * Gets the metadata item key
     * @return string
     */
    public function getKey()
    {
        return $this->key;
    }

    /**
     * Sets the metadata item key
     *
     * @param string $key
     */
    public function setKey($key)
    {
        $this->key = $key;
    }

    /**
     * Gets metadata item value
     * @return string
     */
    public function getValue()
    {
        return $this->value;
    }

    /**
     * Sets metadata item value
     *
     * @param string $value
     */
    public function setValue($value)
    {
        $this->value = $this->normalizeParameter($value);
    }

    /**
     * Gets metadata item group
     *
     * @return int
     */
    public function getGroup()
    {
        return $this->group;
    }

    /**
     * Sets metadata item group
     *
     * @param int $group
     */
    public function setGroup($group)
    {
        $this->group = (int) $group;
    }

    /**
     * Normalize metadata item value
     * @param string $parameterValue
     * @return string
     */
    private function normalizeParameter($parameterValue)
    {

        $parameterValue = PagSeguroHelper::formatString($parameterValue, 100, '');

        switch ($this->getKey()) {
            case PagSeguroMetaDataItemKeys::getItemKeyByDescription('CPF do passageiro'):
                $parameterValue = PagSeguroHelper::getOnlyNumbers($parameterValue);
                break;
            case PagSeguroMetaDataItemKeys::getItemKeyByDescription('Tempo no jogo em dias'):
                $parameterValue = PagSeguroHelper::getOnlyNumbers($parameterValue);
                break;
            case PagSeguroMetaDataItemKeys::getItemKeyByDescription('Celular de recarga'):
                break;
            default:
                break;
        }
        return $parameterValue;
    }
}
