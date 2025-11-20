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
 * Encapsulates web service calls regarding PagSeguro notifications
 */
class PagSeguroNotificationService
{

    /**
     *
     */
    const SERVICE_NAME = 'notificationService';

    /**
     * @param PagSeguroConnectionData $connectionData
     * @param $notificationCode
     * @return string
     */
    private static function buildTransactionNotificationUrl(PagSeguroConnectionData $connectionData, $notificationCode)
    {
        $url = $connectionData->getServiceUrl();
        return "{$url}/{$notificationCode}/?" . $connectionData->getCredentialsUrlQuery();
    }

    /**
     * Returns a transaction from a notification code
     *
     * @param PagSeguroCredentials $credentials
     * @param String $notificationCode
     * @throws PagSeguroServiceException
     * @throws Exception
     * @return PagSeguroTransaction
     * @see PagSeguroTransaction
     */
    public static function checkTransaction(PagSeguroCredentials $credentials, $notificationCode)
    {

        LogPagSeguro::info("PagSeguroNotificationService.CheckTransaction(notificationCode=$notificationCode) - begin");
        $connectionData = new PagSeguroConnectionData($credentials, self::SERVICE_NAME);

        try {

            $connection = new PagSeguroHttpConnection();
            $connection->get(
                self::buildTransactionNotificationUrl($connectionData, $notificationCode),
                $connectionData->getServiceTimeout(),
                $connectionData->getCharset()
            );

            $httpStatus = new PagSeguroHttpStatus($connection->getStatus());

            switch ($httpStatus->getType()) {

                case 'OK':
                    // parses the transaction
                    $transaction = PagSeguroTransactionParser::readTransaction($connection->getResponse());
                    LogPagSeguro::info(
                        "PagSeguroNotificationService.CheckTransaction(notificationCode=$notificationCode) - end " .
                        $transaction->toString() . ")"
                    );
                    break;

                case 'BAD_REQUEST':
                    $errors = PagSeguroTransactionParser::readErrors($connection->getResponse());
                    $e = new PagSeguroServiceException($httpStatus, $errors);
                    LogPagSeguro::info(
                        "PagSeguroNotificationService.CheckTransaction(notificationCode=$notificationCode) - error " .
                        $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

                default:
                    $e = new PagSeguroServiceException($httpStatus);
                    LogPagSeguro::info(
                        "PagSeguroNotificationService.CheckTransaction(notificationCode=$notificationCode) - error " .
                        $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

            }

            return isset($transaction) ? $transaction : null;

        } catch (PagSeguroServiceException $e) {
            throw $e;
        }
        catch (Exception $e) {
            LogPagSeguro::error("Exception: " . $e->getMessage());
            throw $e;
        }

    }
}
