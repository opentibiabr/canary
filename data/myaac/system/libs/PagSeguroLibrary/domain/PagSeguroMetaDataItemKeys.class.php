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
 * Represent available metadata item keys
 */
class PagSeguroMetaDataItemKeys
{

    private static $availableItemKeysList = array(
        'PASSENGER_CPF' => 'CPF do passageiro',
        'PASSENGER_PASSPORT' => 'Passaporte do passageiro',
        'ORIGIN_CITY' => 'Cidade de origem',
        'DESTINATION_CITY' => 'Cidade de destino',
        'ORIGIN_AIRPORT_CODE' => 'Código do aeroporto de origem',
        'DESTINATION_AIRPORT_CODE' => 'Código do aeroporto de destino',
        'GAME_NAME' => 'Nome do jogo',
        'PLAYER_ID' => 'Id do jogador',
        'TIME_IN_GAME_DAYS' => 'Tempo no jogo em dias',
        'MOBILE_NUMBER' => 'Celular de recarga',
        'PASSENGER_NAME' => 'Nome do passageiro'
    );

    /**
     * Get available item key list for metadata use in PagSeguro transactions
     * @return array
     */
    public static function getAvailableItemKeysList()
    {
        return self::$availableItemKeysList;
    }

    /**
     * Check if item key is available for PagSeguro
     * @param string $itemKey
     * @return boolean
     */
    public static function isItemKeyAvailable($itemKey)
    {
        $itemKey = strtoupper($itemKey);
        return (isset(self::$availableItemKeysList[$itemKey]));
    }

    /**
     * Gets item description by key
     * @param string $itemKey
     * @return string
     */
    public static function getItemDescriptionByKey($itemKey)
    {
        $itemKey = strtoupper($itemKey);
        if (isset(self::$availableItemKeysList[$itemKey])) {
            return self::$availableItemKeysList[$itemKey];
        } else {
            return false;
        }
    }

    /**
     * Gets item key type by description
     * @param string $itemDescription
     * @return string
     */
    public static function getItemKeyByDescription($itemDescription)
    {
        return array_search(strtolower($itemDescription), array_map('strtolower', self::$availableItemKeysList));
    }
}
