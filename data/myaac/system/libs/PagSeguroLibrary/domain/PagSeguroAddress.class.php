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
 * Represents an address location, typically for shipping or charging purposes.
 * @see PagSeguroShipping
 */
class PagSeguroAddress
{

    private $postalCode;

    /**
     * Street name
     */
    private $street;

    /**
     * Number
     */
    private $number;

    /**
     * Apartment, suite number or any other qualifier after the street/number pair.
     * Example: Apt 274, building A.
     */
    private $complement;

    /**
     * District, county or neighborhood, if applicable
     */
    private $district;

    /**
     * City
     */
    private $city;

    /**
     * State or province
     */
    private $state;

    /**
     * Country
     */
    private $country;

    /**
     * acronyms and states brazilian
     * @var type
     */
    private static $acronyms = array('acre' => 'AC',
        'alagoas' => 'AL',
        'amapa' => 'AP',
        'amazonas' => 'AM',
        'bahia' => 'BA',
        'ceara' => 'CE',
        'espiritosanto' => 'ES',
        'goias' => 'GO',
        'maranhao' => 'MA',
        'matogrosso' => 'MT',
        'matogrossodosul' => 'MS',
        'matogrossosul' => 'MS',
        'minasgerais' => 'MG',
        'para' => 'PA',
        'paraiba' => 'PB',
        'parana' => 'PR',
        'pernambuco' => 'PE',
        'piaui' => 'PI',
        'riodejaneiro' => 'RJ',
        'riojaneiro' => 'RJ',
        'riograndedonorte' => 'RN',
        'riograndenorte' => 'RN',
        'riograndedosul' => 'RS',
        'riograndesul' => 'RS',
        'rondonia' => 'RO',
        'roraima' => 'RR',
        'santacatarina' => 'SC',
        'saopaulo' => 'SP',
        'sergipe' => 'SE',
        'tocantins' => 'TO',
        'distritofederal' => 'DF');

    /**
     * Initializes a new instance of the Address class
     * @param array $data
     */
    public function __construct(array $data = null)
    {
        if (isset($data['postalCode'])) {
            $this->postalCode = $data['postalCode'];
        }
        if (isset($data['street'])) {
            $this->street = $data['street'];
        }
        if (isset($data['number'])) {
            $this->number = $data['number'];
        }
        if (isset($data['complement'])) {
            $this->complement = $data['complement'];
        }
        if (isset($data['district'])) {
            $this->district = $data['district'];
        }
        if (isset($data['city'])) {
            $this->city = $data['city'];
        }
        if (isset($data['state'])) {
            $this->state = $data['state'];
        }
        if (isset($data['country'])) {
            $this->country = $data['country'];
        }
    }

    /**
     * @return string the street
     */
    public function getStreet()
    {
        return $this->street;
    }

    /**
     * @return string the number
     */
    public function getNumber()
    {
        return $this->number;
    }

    /**
     * @return string the complement
     */
    public function getComplement()
    {
        return $this->complement;
    }

    /**
     * @return string the distrcit
     */
    public function getDistrict()
    {
        return $this->district;
    }

    /**
     * @return string the city
     */
    public function getCity()
    {
        return $this->city;
    }

    /**
     * @return string the state
     */
    public function getState()
    {
        return $this->state;
    }

    /**
     * @return string the postal code
     */
    public function getPostalCode()
    {
        return $this->postalCode;
    }

    /**
     * @return string the country
     */
    public function getCountry()
    {
        return $this->country;
    }

    /**
     * Sets the country
     * @param String $country
     */
    public function setCountry($country)
    {
        $this->country = $country;
    }

    /**
     * Sets the street
     * @param String $street
     */
    public function setStreet($street)
    {
        $this->street = $street;
    }

    /**
     * sets the numbetr
     * @param String $number
     */
    public function setNumber($number)
    {
        $this->number = $number;
    }

    /**
     * Sets the complement
     * @param String $complement
     */
    public function setComplement($complement)
    {
        $this->complement = $complement;
    }

    /**
     * sets the district
     * @param String $district
     */
    public function setDistrict($district)
    {
        $this->district = $district;
    }

    /**
     * Sets the city
     * @param String $city
     */
    public function setCity($city)
    {
        $this->city = $city;
    }

    /**
     * Sets the state
     * @param String $state
     */
    public function setState($state)
    {
        $this->state = $this->treatState($state);
    }

    /**
     * Sets the postal code
     * @param String $postalCode
     */
    public function setPostalCode($postalCode)
    {
        $this->postalCode = $postalCode;
    }

    /**
     * Handle the state to pass in format expected in PagSeguro
     * @param type $defaultState
     * @return string
     */
    private function treatState($defaultState)
    {

        if (strlen($defaultState) == 2) {
            foreach (self::$acronyms as $key => $val) {
                if ($val == strtoupper($defaultState)) {
                    return strtoupper($defaultState);
                }
            }
            return '';
        }

        $state = utf8_decode($defaultState);
        $state = strtolower($state);

        // Code ASCII of the vowel
        $ascii['a'] = range(224, 230);
        $ascii['e'] = range(232, 235);
        $ascii['i'] = range(236, 239);
        $ascii['o'] = array_merge(range(242, 246), array(240, 248));
        $ascii['u'] = range(249, 252);

        // Code ASCII of the others character
        $ascii['b'] = array(223);
        $ascii['c'] = array(231);
        $ascii['d'] = array(208);
        $ascii['n'] = array(241);
        $ascii['y'] = array(253, 255);

        foreach ($ascii as $key => $item) {
            $accents = '';
            foreach ($item as $code) {
                $accents .= chr($code);
            }
            $change[$key] = '/[' . $accents . ']/i';
        }

        $state = preg_replace(array_values($change), array_keys($change), $state);

        $state = preg_replace("/\s/", "", $state);

        foreach (self::$acronyms as $key => $val) {
            if ($key == $state) {
                $acronym = $val;
                return $acronym;
            }
        }

        return '';
    }
}
