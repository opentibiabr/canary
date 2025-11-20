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
 * Represents available documents for Sender use in checkout transactions
 */
class PagSeguroDocuments
{

    /**
     * List of available documents for Sender use in PagSeguro transactions
     * @var array
     */
    private static $availableDocumentList = array(
        'CPF' => 'Cadastro de Pessoa Física'
    );

    /**
     * Get available document list for Sender use in PagSeguro transactions
     * @return array
     */
    public static function getAvailableDocumentList()
    {
        return self::$availableDocumentList;
    }

    /**
     * Check if document type is available for PagSeguro
     * @param string $documentType
     * @return boolean
     */
    public static function isDocumentTypeAvailable($documentType)
    {
        $documentType = strtoupper($documentType);
        return (isset(self::$availableDocumentList[$documentType]));
    }

    /**
     * Gets document description by type
     * @param string
     * @return string
     */
    public static function getDocumentByType($documentType)
    {
        $documentType = strtoupper($documentType);
        if (isset(self::$availableDocumentList[$documentType])) {
            return self::$availableDocumentList[$documentType];
        } else {
            return false;
        }
    }

    /**
     * Gets document type by description
     * @param string $documentDescription
     * @return string
     */
    public static function getDocumentByDescription($documentDescription)
    {
        return array_search(strtolower($documentDescription), array_map('strtolower', self::$availableDocumentList));
    }
}
