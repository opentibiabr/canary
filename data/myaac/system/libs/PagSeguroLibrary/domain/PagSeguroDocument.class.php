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
 * Represents document
 */
class PagSeguroDocument
{

    private static $availableDocumentList = array(
        1 => 'CPF'
    );

    /**
     * The type of document
     * @var string
     */
    private $type;

    /**
     * The value of document
     * @var string
     */
    private $value;

    public function __construct(array $data = null)
    {
        if ($data) {
            if (isset($data['type']) && isset($data['value'])) {
                $this->setType($data['type']);
                $this->setValue(PagSeguroHelper::getOnlyNumbers($data['value']));
            }
        }
    }

    /**
     * Get document type
     * @return String
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Set document type
     * @param String $type
     */
    public function setType($type)
    {
        $this->type = strtoupper($type);
    }

    /**
     * Get document value
     * @return String
     */
    public function getValue()
    {
        return $this->value;
    }

    /**
     * Set document value
     * @param String $value
     */
    public function setValue($value)
    {
        $this->value = $value;
    }

    /**
     * Check if document type is available for PagSeguro
     * @param string $documentType
     * @return array|boolean
     */
    public static function isDocumentTypeAvailable($documentType)
    {
        return (array_search(strtoupper($documentType), self::$availableDocumentList));
    }
}
