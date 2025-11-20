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
 * Represents a payment request
 */
class PagSeguroPaymentRequest
{

    /**
     * Party that will be sending the money
     * @var PagSeguroSender
     */
    private $sender;

    /**
     * Payment currency
     */
    private $currency;

    /**
     * Products/items in this payment request
     */
    private $items;

    /**
     * Uri to where the PagSeguro payment page should redirect the user after the payment information is processed.
     * Typically this is a confirmation page on your web site.
     * @var String
     */
    private $redirectURL;

    /**
     * Extra amount to be added to the transaction total
     *
     * This value can be used to add an extra charge to the transaction
     * or provide a discount in the case ExtraAmount is a negative value.
     * @var float
     */
    private $extraAmount;

    /**
     * Reference code
     *
     * Optional. You can use the reference code to store an identifier so you can
     * associate the PagSeguro transaction to a transaction in your system.
     */
    private $reference;

    /**
     * Shipping information associated with this payment request
     */
    private $shipping;

    /**
     * How long this payment request will remain valid, in seconds.
     *
     * Optional. After this payment request is submitted, the payment code returned
     * will remain valid for the period specified here.
     */
    private $maxAge;

    /**
     * How many times the payment redirect uri returned by the payment web service can be accessed.
     *
     * Optional. After this payment request is submitted, the payment redirect uri returned by
     * the payment web service will remain valid for the number of uses specified here.
     */
    private $maxUses;

    /**
     * Determines for which url PagSeguro will send the order related notifications codes.
     *
     * Optional. Any change happens in the transaction status, a new notification request will be send
     * to this url. You can use that for update the related order.
     */
    private $notificationURL;

    /**
     * Extra parameters that user can add to a PagSeguro checkout request
     *
     * Optional.
     * @var PagSeguroMetaData
     */
    private $metadata;

    /**
     * Extra parameters that user can add to a PagSeguro checkout request
     *
     * Optional
     * @var PagSeguroParameter
     */
    private $parameter;

    /**
     * @return PagSeguroSender the sender
     *
     * Party that will be sending the Uri to where the PagSeguro payment page should redirect the
     * user after the payment information is processed.
     */
    public function getSender()
    {
        return $this->sender;
    }

    /**
     * Sets the Sender, party that will be sending the money
     * @param String $name
     * @param String $email
     * @param String $areaCode
     * @param String $number
     * @param String $documentType
     * @param String $documentValue
     */
    public function setSender(
        $name,
        $email = null,
        $areaCode = null,
        $number = null,
        $documentType = null,
        $documentValue = null
    ) {
        $param = $name;
        if (is_array($param)) {
            $this->sender = new PagSeguroSender($param);
        } elseif ($param instanceof PagSeguroSender) {
            $this->sender = $param;
        } else {
            $sender = new PagSeguroSender();
            $sender->setName($param);
            $sender->setEmail($email);
            $sender->setPhone(new PagSeguroPhone($areaCode, $number));
            $sender->addDocument($documentType, $documentValue);
            $this->sender = $sender;
        }
    }

    /**
     * Sets the name of the sender, party that will be sending the money
     * @param String $senderName
     */
    public function setSenderName($senderName)
    {
        if ($this->sender == null) {
            $this->sender = new PagSeguroSender();
        }
        $this->sender->setName($senderName);
    }

    /**
     * Sets the name of the sender, party that will be sending the money
     * @param String $senderEmail
     */
    public function setSenderEmail($senderEmail)
    {
        if ($this->sender == null) {
            $this->sender = new PagSeguroSender();
        }
        $this->sender->setEmail($senderEmail);
    }

    /**
     * Sets the Sender phone number, phone of the party that will be sending the money
     *
     * @param areaCode
     * @param number
     */
    public function setSenderPhone($areaCode, $number = null)
    {
        $param = $areaCode;
        if ($this->sender == null) {
            $this->sender = new PagSeguroSender();
        }
        if ($param instanceof PagSeguroPhone) {
            $this->sender->setPhone($param);
        } else {
            $this->sender->setPhone(new PagSeguroPhone($param, $number));
        }
    }

    /**
     * @return String the currency
     * Example: BRL
     */
    public function getCurrency()
    {
        return $this->currency;
    }

    /**
     * Sets the currency
     * @param String $currency
     */
    public function setCurrency($currency)
    {
        $this->currency = $currency;
    }

    /**
     * @return array the items/products list in this payment request
     */
    public function getItems()
    {
        return $this->items;
    }

    /**
     * Sets the items/products list in this payment request
     * @param array $items
     */
    public function setItems(array $items)
    {
        if (is_array($items)) {
            $i = array();
            foreach ($items as $key => $item) {
                if ($item instanceof PagSeguroItem) {
                    $i[$key] = $item;
                } else {
                    if (is_array($item)) {
                        $i[$key] = new PagSeguroItem($item);
                    }
                }
            }
            $this->items = $i;
        }
    }

    /**
     * Adds a new product/item in this payment request
     *
     * @param String $id
     * @param String $description
     * @param String $quantity
     * @param String $amount
     * @param String $weight
     * @param String $shippingCost
     */
    public function addItem(
        $id,
        $description = null,
        $quantity = null,
        $amount = null,
        $weight = null,
        $shippingCost = null
    ) {
        $param = $id;
        if ($this->items == null) {
            $this->items = array();
        }
        if (is_array($param)) {
            array_push($this->items, new PagSeguroItem($param));
        } else {
            if ($param instanceof PagSeguroItem) {
                array_push($this->items, $param);
            } else {
                $item = new PagSeguroItem();
                $item->setId($param);
                $item->setDescription($description);
                $item->setQuantity($quantity);
                $item->setAmount($amount);
                $item->setWeight($weight);
                $item->setShippingCost($shippingCost);
                array_push($this->items, $item);
            }
        }
    }

    public function addSenderDocument($type, $value)
    {
        if ($this->getSender() instanceof PagSeguroSender) {
            $this->getSender()->addDocument($type, $value);
        }
    }

    /**
     * URI to where the PagSeguro payment page should redirect the user after the payment information is processed.
     * Typically this is a confirmation page on your web site.
     *
     * @return String the redirectURL
     */
    public function getRedirectURL()
    {
        return $this->redirectURL;
    }

    /**
     * Sets the redirect URL
     *
     * Uri to where the PagSeguro payment page should redirect the user after the payment information is processed.
     * Typically this is a confirmation page on your web site.
     *
     * @param String $redirectURL
     */
    public function setRedirectURL($redirectURL)
    {
        $this->redirectURL = $this->verifyURLTest($redirectURL);
    }

    /**
     * This value can be used to add an extra charge to the transaction
     * or provide a discount in the case ExtraAmount is a negative value.
     *
     * @return float the extra amount
     */
    public function getExtraAmount()
    {
        return $this->extraAmount;
    }

    /**
     * Sets the extra amount
     * This value can be used to add an extra charge to the transaction
     * or provide a discount in the case <b>extraAmount</b> is a negative value.
     *
     * @param extraAmount
     */
    public function setExtraAmount($extraAmount)
    {
        $this->extraAmount = $extraAmount;
    }

    /**
     * @return mixed the reference of this payment request
     */
    public function getReference()
    {
        return $this->reference;
    }

    /**
     * Sets the reference of this payment request
     * @param reference
     */
    public function setReference($reference)
    {
        $this->reference = $reference;
    }

    /**
     * @return PagSeguroShipping the shipping information for this payment request
     * @see PagSeguroShipping
     */
    public function getShipping()
    {
        return $this->shipping;
    }

    /**
     * Sets the shipping information for this payment request
     * @param PagSeguroShipping $address
     * @param PagSeguroShippingType $type
     */
    public function setShipping($address, $type = null)
    {
        $param = $address;
        if ($param instanceof PagSeguroShipping) {
            $this->shipping = $param;
        } else {
            $shipping = new PagSeguroShipping();
            if (is_array($param)) {
                $shipping->setAddress(new PagSeguroAddress($param));
            } else {
                if ($param instanceof PagSeguroAddress) {
                    $shipping->setAddress($param);
                }
            }
            if ($type) {
                if ($type instanceof PagSeguroShippingType) {
                    $shipping->setType($type);
                } else {
                    $shipping->setType(new PagSeguroShippingType($type));
                }
            }
            $this->shipping = $shipping;
        }
    }

    /**
     * Sets the shipping address for this payment request
     * @param String $postalCode
     * @param String $street
     * @param String $number
     * @param String $complement
     * @param String $district
     * @param String $city
     * @param String $state
     * @param String $country
     */
    public function setShippingAddress(
        $postalCode = null,
        $street = null,
        $number = null,
        $complement = null,
        $district = null,
        $city = null,
        $state = null,
        $country = null
    ) {
        $param = $postalCode;
        if ($this->shipping == null) {
            $this->shipping = new PagSeguroShipping();
        }
        if (is_array($param)) {
            $this->shipping->setAddress(new PagSeguroAddress($param));
        } elseif ($param instanceof PagSeguroAddress) {
            $this->shipping->setAddress($param);
        } else {
            $address = new PagSeguroAddress();
            $address->setPostalCode($postalCode);
            $address->setStreet($street);
            $address->setNumber($number);
            $address->setComplement($complement);
            $address->setDistrict($district);
            $address->setCity($city);
            $address->setState($state);
            $address->setCountry($country);
            $this->shipping->setAddress($address);
        }
    }

    /**
     * Sets the shipping type for this payment request
     * @param PagSeguroShippingType $type
     */
    public function setShippingType($type)
    {
        $param = $type;
        if ($this->shipping == null) {
            $this->shipping = new PagSeguroShipping();
        }
        if ($param instanceof PagSeguroShippingType) {
            $this->shipping->setType($param);
        } else {
            $this->shipping->setType(new PagSeguroShippingType($param));
        }
    }

    /**
     * Sets the shipping cost for this payment request
     * @param float $shippingCost
     */
    public function setShippingCost($shippingCost)
    {
        $param = $shippingCost;
        if ($this->shipping == null) {
            $this->shipping = new PagSeguroShipping();
        }

        $this->shipping->setCost($param);
    }

    /**
     * @return integer the max age of this payment request
     *
     * After this payment request is submitted, the payment code returned
     * will remain valid for the period specified.
     */
    public function getMaxAge()
    {
        return $this->maxAge;
    }

    /**
     * Sets the max age of this payment request
     * After this payment request is submitted, the payment code returned
     * will remain valid for the period specified here.
     *
     * @param maxAge
     */
    public function setMaxAge($maxAge)
    {
        $this->maxAge = $maxAge;
    }

    /**
     * After this payment request is submitted, the payment redirect uri returned by
     * the payment web service will remain valid for the number of uses specified here.
     *
     * @return integer the max uses configured for this payment request
     */
    public function getMaxUses()
    {
        return $this->maxUses;
    }

    /**
     * Sets the max uses of this payment request
     *
     * After this payment request is submitted, the payment redirect uri returned by
     * the payment web service will remain valid for the number of uses specified here.
     *
     * @param maxUses
     */
    public function setMaxUses($maxUses)
    {
        $this->maxUses = $maxUses;
    }

    /**
     * Get the notification status url
     *
     * @return String
     */
    public function getNotificationURL()
    {
        return $this->notificationURL;
    }

    /**
     * Sets the url that PagSeguro will send the new notifications statuses
     *
     * @param String $notificationURL
     */
    public function setNotificationURL($notificationURL)
    {
        $this->notificationURL = $this->verifyURLTest($notificationURL);
    }

    /**
     * Sets metadata for PagSeguro checkout requests
     *
     * @param PagSeguroMetaData $metaData
     */
    public function setMetaData($metaData)
    {
        $this->metadata = $metaData;
    }

    /**
     * Gets metadata for PagSeguro checkout requests
     *
     * @return PagSeguroMetaData $metaData
     */
    public function getMetaData()
    {

        if ($this->metadata == null) {
            $this->metadata = new PagSeguroMetaData();
        }
        return $this->metadata;
    }

    /**
     * add a parameter for PagSeguro metadata checkout request
     *
     * @param PagSeguroMetaDataItem $itemKey key
     * @param PagSeguroMetaDataItem $itemValue value
     * @param PagSeguroMetaDataItem $itemGroup group
     */
    public function addMetaData($itemKey, $itemValue, $itemGroup = null)
    {
        $this->getMetaData()->addItem(new PagSeguroMetaDataItem($itemKey, $itemValue, $itemGroup));
    }

    /**
     * Sets parameter for PagSeguro checkout requests
     *
     * @param PagSeguroParameter $parameter
     */
    public function setParameter($parameter)
    {
        $this->parameter = $parameter;
    }

    /**
     * Gets parameter for PagSeguro checkout requests
     *
     * @return PagSeguroParameter
     */
    public function getParameter()
    {
        if ($this->parameter == null) {
            $this->parameter = new PagSeguroParameter();
        }
        return $this->parameter;
    }

    /**
     * add a parameter for PagSeguro checkout request
     *
     * @param PagSeguroParameterItem $parameterName key
     * @param PagSeguroParameterItem $parameterValue value
     */
    public function addParameter($parameterName, $parameterValue)
    {
        $this->getParameter()->addItem(new PagSeguroParameterItem($parameterName, $parameterValue));
    }

    /**
     * add a parameter for PagSeguro checkout request
     *
     * @param PagSeguroParameterItem $parameterName key
     * @param PagSeguroParameterItem $parameterValue value
     * @param PagSeguroParameterItem $parameterIndex group
     */
    public function addIndexedParameter($parameterName, $parameterValue, $parameterIndex)
    {
        $this->getParameter()->addItem(new PagSeguroParameterItem($parameterName, $parameterValue, $parameterIndex));
    }

    /**
     * Calls the PagSeguro web service and register this request for payment
     *
     * @param PagSeguroCredentials $credentials, lighbox
     * @return String The URL to where the user needs to be redirected to in order to complete the payment process or
     * the CODE when use lightbox
     */
    public function register(PagSeguroCredentials $credentials, $onlyCheckoutCode = false)
    {
        return PagSeguroPaymentService::createCheckoutRequest($credentials, $this, $onlyCheckoutCode);
    }

    /**
     * @return String a string that represents the current object
     */
    public function toString()
    {
        $email = $this->sender ? $this->sender->getEmail() : "null";

        $request = array();
        $request['Reference'] = $this->reference;
        $request['SenderEmail'] = $email;

        return "PagSeguroPaymentRequest: " . var_export($request, true);
    }

    /**
     * Verify if the adress of NotificationURL or RedirectURL is for tests and return empty
     * @param type $url
     * @return type
     */
    public function verifyURLTest($url)
    {
        $adress = array(
            'localhost',
            '127.0.0.1',
            '::1'
        );

        $urlReturn;
        foreach ($adress as $item) {
            $find = strpos($url, $item);

            if ($find) {
                $urlReturn = '';
                break;
            } else {
                $urlReturn = $url;
            }
        }

        return $urlReturn;
    }
}
