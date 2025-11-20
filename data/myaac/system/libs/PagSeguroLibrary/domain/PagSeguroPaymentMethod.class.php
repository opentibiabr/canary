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
 * Payment method
 *
 */
class PagSeguroPaymentMethod
{

    /**
     * Payment method type
     */
    private $type;

    /**
     * Payment method code
     */
    private $code;

    /**
     * Initializes a new instance of the PaymentMethod class
     *
     * @param PagSeguroPaymentMethodType $type
     * @param PagSeguroPaymentMethodCode $code
     */
    public function __construct($type = null, $code = null)
    {
        if ($type) {
            $this->setType($type);
        }
        if ($code) {
            $this->setCode($code);
        }
    }

    /**
     * @return the payment method type
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Sets the payment method type
     * @param PagSeguroPaymentMethodType $type
     */
    public function setType($type)
    {
        if ($type instanceof PagSeguroPaymentMethodType) {
            $this->type = $type;
        } else {
            $this->type = new PagSeguroPaymentMethodType($type);
        }
    }

    /**
     * @return the code
     */
    public function getCode()
    {
        return $this->code;
    }

    /**
     * Sets the payment method code
     * @param PagSeguroPaymentMethodCode $code
     */
    public function setCode($code)
    {
        if ($code instanceof PagSeguroPaymentMethodCode) {
            $this->code = $code;
        } else {
            $this->code = new PagSeguroPaymentMethodCode($code);
        }
    }
}
