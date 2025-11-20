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
 * Represents a PagSeguro web service error
 * @see PagSeguroServiceException
 */
class PagSeguroError
{

    /**
     * Error code
     */
    private $code;

    /**
     * Error description
     */
    private $message;

    /**
     * Initializes a new instance of the PagSeguroError class
     *
     * @param String $code
     * @param String $message
     */
    public function __construct($code, $message)
    {
        $this->code = $code;
        $this->message = $message;
    }

    /**
     * @return integer|string the code
     */
    public function getCode()
    {
        return $this->code;
    }

    /**
     * Sets the code
     * @param String $code
     */
    public function setCode($code)
    {
        $this->code = $code;
    }

    /**
     * @return String the error description
     */
    public function getMessage()
    {
        return $this->message;
    }

    /**
     * Sets the error description
     * @param String $message
     */
    public function setMessage($message)
    {
        $this->message = $message;
    }
}
