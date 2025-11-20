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
 * Shipping information
 */
class PagSeguroShipping
{

    /**
     * Shipping address
     * @see PagSeguroAddress
     */
    private $address;

    /**
     * Shipping type. See the PagSeguroShippingType class for a list of known shipping types.
     * @see PagSeguroShippingType
     */
    private $type;

    /**
     * shipping cost.
     */
    private $cost;

    /**
     * Initializes a new instance of the PagSeguroShipping class
     * @param array $data
     */
    public function __construct(array $data = null)
    {
        if ($data) {
            if (isset($data['address']) && $data['address'] instanceof PagSeguroAddress) {
                $this->address = $data['address'];
            }
            if (isset($data['type']) && $data['type'] instanceof PagSeguroShippingType) {
                $this->type = $data['type'];
            }
            if (isset($data['cost'])) {
                $this->cost = $data['cost'];
            }
        }
    }

    /**
     * Sets the shipping address
     * @see PagSeguroAddress
     * @param PagSeguroAddress $address
     */
    public function setAddress(PagSeguroAddress $address)
    {
        $this->address = $address;
    }

    /**
     * @return PagSeguroAddress the shipping Address
     * @see PagSeguroAddress
     */
    public function getAddress()
    {
        return $this->address;
    }

    /**
     * Sets the shipping type
     * @param PagSeguroShippingType $type
     * @see PagSeguroShippingType
     */
    public function setType(PagSeguroShippingType $type)
    {
        $this->type = $type;
    }

    /**
     * @return PagSeguroShippingType the shipping type
     * @see PagSeguroShippingType
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @param $cost float
     */
    public function setCost($cost)
    {
        $this->cost = $cost;
    }

    /**
     * @return float the shipping cost
     */
    public function getCost()
    {
        return $this->cost;
    }
}
