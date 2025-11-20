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
 * Represents a phone number
 */
class PagSeguroPhone
{

    /**
     * Area code
     */
    private $areaCode;

    /**
     * Phone number
     */
    private $number;

    /**
     * Initializes a new instance of the PagSeguroPhone class
     *
     * @param String $areaCode
     * @param String $number
     * @return PagSeguroPhone
     */
    public function __construct($areaCode = null, $number = null)
    {
        $this->areaCode = ($areaCode == null ? null : $areaCode);
        $this->number = ($number == null ? null : $number);
        return $this;
    }

    /**
     * @return int the area code
     */
    public function getAreaCode()
    {
        return $this->areaCode;
    }

    /**
     * @return int the number
     */
    public function getNumber()
    {
        return $this->number;
    }

    /**
     * Sets the area code
     * @param String $areaCode
     * @return PagSeguroPhone
     */
    public function setAreaCode($areaCode)
    {
        $this->areaCode = $areaCode;
        return $this;
    }

    /**
     * Sets the number
     * @param String $number
     * @return PagSeguroPhone
     */
    public function setNumber($number)
    {
        $this->number = $number;
        return $this;
    }

    /**
     * Sets the number from a formatted string
     *
     * @param $number String formatted string like <code>(099) [9]9999-9999</code>
     * @return $this
     */
    public function setFullPhone($number)
    {
        /* We clean the string that is coming. Can be formatted or not */

        $number = preg_replace("/[^0-9]/", '', $number);
        $number = $number[0] == 0 ? substr($number, 1) : $number;

        $number = str_split($number, 1);
        $areaCode = array_shift($number) . array_shift($number);
        $phone = implode('', $number);

        $this->setAreaCode($areaCode);
        $this->setNumber($phone);

        return $this->areaCode . $this->number;
    }
}
