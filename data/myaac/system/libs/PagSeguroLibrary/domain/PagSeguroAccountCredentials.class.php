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
 * Identifies a PagSeguro account
 * /
 */
class PagSeguroAccountCredentials extends PagSeguroCredentials
{

    /**
     * Primary email associated with this account
     */
    private $email;

    /**
     * PagSeguro token
     */
    private $token;

    /**
     * Initializes a new instance of PagSeguroAccountCredentials class
     *
     * @throws Exception when credentials aren't provided.
     *
     * @param string $email
     * @param string $token
     */
    public function __construct($email, $token)
    {
        if ($email !== null && $token !== null) {
            $this->email = $email;
            $this->token = $token;
        } else {
            throw new Exception("Credentials not set.");
        }
    }

    /**
     * @return string the e-mail from this account credential object
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * Sets the e-mail from this account credential object
     */
    public function setEmail($email)
    {
        $this->email = $email;
    }

    /**
     * @return string the token from this account credential object
     */
    public function getToken()
    {
        return $this->token;
    }

    /**
     * Sets the token in this account credential object
     */
    public function setToken($token)
    {
        $this->token = $token;
    }

    /**
     * @return array a map of name value pairs that compose this set of credentials
     */
    public function getAttributesMap()
    {
        return array(
            'email' => $this->email,
            'token' => $this->token
        );
    }

    /**
     * @return string a string that represents the current object
     */
    public function toString()
    {
        $credentials = array();
        $credentials['E-mail'] = $this->email;
        $credentials['Token'] = $this->token;
        return implode(' - ', $credentials);
    }
}
