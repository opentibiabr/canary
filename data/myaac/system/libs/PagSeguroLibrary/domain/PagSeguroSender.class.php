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
 * Represents the party on the transaction that is sending the money
 */
class PagSeguroSender
{

    /** Sender name */
    private $name;

    /** Sender email */
    private $email;

    /** Sender phone */
    private $phone;

    /** Sender documents */
    private $documents;

    /**
     * Initializes a new instance of the Sender class
     *
     * @param array $data
     */
    public function __construct(array $data = null)
    {
        if ($data) {
            if (isset($data['name'])) {
                $this->name = $data['name'];
            }
            if (isset($data['email'])) {
                $this->email = $data['email'];
            }
            if (isset($data['phone']) && $data['phone'] instanceof PagSeguroPhone) {
                $this->phone = $data['phone'];
            } else {
                if (isset($data['areaCode']) && isset($data['number'])) {
                    $phone = new PagSeguroPhone($data['areaCode'], $data['number']);
                    $this->phone = $phone;
                }
            }
            if (isset($data['documents']) && is_array($data['documents'])) {
                $this->setDocuments($data['documents']);
            }
        }
    }

    /**
     * Sets the sender name
     * @param String $name
     */
    public function setName($name)
    {
        $this->name = PagSeguroHelper::formatString($name, 50, '');
    }

    /**
     * @return String the sender name
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Sets the Sender e-mail
     * @param email
     */
    public function setEmail($email)
    {
        $this->email = $email;
    }

    /**
     * @return String the sender e-mail
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * Sets the sender phone
     * @param String $areaCode
     * @param String $number
     */
    public function setPhone($areaCode, $number = null)
    {
        $param = $areaCode;
        if ($param instanceof PagSeguroPhone) {
            $this->phone = $param;
        } elseif ($number) {
            $phone = new PagSeguroPhone();
            $phone->setAreaCode($areaCode);
            $phone->setNumber($number);
            $this->phone = $phone;
        }
    }

    /**
     * @return PagSeguroPhone the sender phone
     * @see PagSeguroPhone
     */
    public function getPhone()
    {
        return $this->phone;
    }

    /**
     * Get Sender documents
     * @return array PagSeguroDocument List of PagSeguroDocument
     * @see PagSeguroDocument
     */
    public function getDocuments()
    {
        return $this->documents;
    }

    /**
     * Set PagSeguro documents
     * @param array $documents
     * @see PagSeguroDocument
     */
    public function setDocuments(array $documents)
    {
        if (count($documents) > 0) {
            foreach ($documents as $document) {
                if ($document instanceof PagSeguroSenderDocument) {
                    $this->documents[] = $document;
                } else {
                    if (is_array($document)) {
                        $this->addDocument($document['type'], $document['value']);
                    }
                }
            }
        }
    }

    /**
     * Add a document for Sender object
     * @param String $type
     * @param String $value
     */
    public function addDocument($type, $value)
    {
        if ($type && $value) {
            if (count($this->documents) == 0) {
                $document = new PagSeguroSenderDocument($type, $value);
                $this->documents[] = $document;
            }
        }
    }
}
