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
 * Encapsulates web service calls to search for PagSeguro transactions
 */
class PagSeguroTransactionSearchService
{

    const SERVICE_NAME = 'transactionSearchService';

    private static function buildSearchUrlByCode(PagSeguroConnectionData $connectionData, $transactionCode)
    {
        $url = $connectionData->getServiceUrl();
        return "{$url}/{$transactionCode}/?" . $connectionData->getCredentialsUrlQuery();
    }

    private static function buildSearchUrlByDate(PagSeguroConnectionData $connectionData, array $searchParams)
    {
        $url = $connectionData->getServiceUrl();
        $initialDate = $searchParams['initialDate'] != null ? $searchParams['initialDate'] : "";
        $finalDate = $searchParams['finalDate'] != null ? ("&finalDate=" . $searchParams['finalDate']) : "";
        if ($searchParams['pageNumber'] != null) {
            $page = "&page=" . $searchParams['pageNumber'];
        }
        if ($searchParams['maxPageResults'] != null) {
            $maxPageResults = "&maxPageResults=" . $searchParams['maxPageResults'];
        }
        return "{$url}/?" . $connectionData->getCredentialsUrlQuery() .
            "&initialDate={$initialDate}{$finalDate}{$page}{$maxPageResults}";
    }

    private static function buildSearchUrlAbandoned(PagSeguroConnectionData $connectionData, array $searchParams)
    {
        $url = $connectionData->getServiceUrl();
        $initialDate = $searchParams['initialDate'] != null ? $searchParams['initialDate'] : "";
        $finalDate = $searchParams['finalDate'] != null ? ("&finalDate=" . $searchParams['finalDate']) : "";
        if ($searchParams['pageNumber'] != null) {
            $page = "&page=" . $searchParams['pageNumber'];
        }
        if ($searchParams['maxPageResults'] != null) {
            $maxPageResults = "&maxPageResults=" . $searchParams['maxPageResults'];
        }
        return "{$url}/abandoned/?" . $connectionData->getCredentialsUrlQuery() .
            "&initialDate={$initialDate}&finalDate={$finalDate}{$page}{$maxPageResults}";
    }

    /**
     * Finds a transaction with a matching transaction code
     *
     * @param PagSeguroCredentials $credentials
     * @param String $transactionCode
     * @return PagSeguroTransaction a transaction object
     * @see PagSeguroTransaction
     * @throws PagSeguroServiceException
     * @throws Exception
     */
    public static function searchByCode(PagSeguroCredentials $credentials, $transactionCode)
    {

        LogPagSeguro::info("PagSeguroTransactionSearchService.SearchByCode($transactionCode) - begin");

        $connectionData = new PagSeguroConnectionData($credentials, self::SERVICE_NAME);

        try {

            $connection = new PagSeguroHttpConnection();
            $connection->get(
                self::buildSearchUrlByCode($connectionData, $transactionCode),
                $connectionData->getServiceTimeout(),
                $connectionData->getCharset()
            );
            $httpStatus = new PagSeguroHttpStatus($connection->getStatus());

            switch ($httpStatus->getType()) {

                case 'OK':
                    $transaction = PagSeguroTransactionParser::readTransaction($connection->getResponse());
                    LogPagSeguro::info(
                        "PagSeguroTransactionSearchService.SearchByCode(transactionCode=$transactionCode) - end " .
                        $transaction->toString()
                    );
                    break;

                case 'BAD_REQUEST':
                    $errors = PagSeguroTransactionParser::readErrors($connection->getResponse());
                    $e = new PagSeguroServiceException($httpStatus, $errors);
                    LogPagSeguro::error(
                        "PagSeguroTransactionSearchService.SearchByCode(transactionCode=$transactionCode) - error " .
                        $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

                default:
                    $e = new PagSeguroServiceException($httpStatus);
                    LogPagSeguro::error(
                        "PagSeguroTransactionSearchService.SearchByCode(transactionCode=$transactionCode) - error " .
                        $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

            }

            return isset($transaction) ? $transaction : false;

        } catch (PagSeguroServiceException $e) {
            throw $e;
        }
        catch (Exception $e) {
            LogPagSeguro::error("Exception: " . $e->getMessage());
            throw $e;
        }

    }

    /**
     * Search transactions associated with this set of credentials within a date range
     *
     * @param PagSeguroCredentials $credentials
     * @param integer $pageNumber
     * @param integer $maxPageResults
     * @param String $initialDate
     * @param String $finalDate
     * @return a object of PagSeguroTransactionSerachResult class
     * @see PagSeguroTransactionSearchResult
     * @throws PagSeguroServiceException
     * @throws Exception
     */
    public static function searchByDate(
        PagSeguroCredentials $credentials,
        $pageNumber,
        $maxPageResults,
        $initialDate,
        $finalDate = null
    ) {

        LogPagSeguro::info(
            "PagSeguroTransactionSearchService.SearchByDate(initialDate=" . PagSeguroHelper::formatDate($initialDate) .
            ", finalDate=" . PagSeguroHelper::formatDate($finalDate) . ") - begin"
        );

        $connectionData = new PagSeguroConnectionData($credentials, self::SERVICE_NAME);

        $searchParams = array(
            'initialDate' => PagSeguroHelper::formatDate($initialDate),
            'pageNumber' => $pageNumber,
            'maxPageResults' => $maxPageResults
        );

        $searchParams['finalDate'] = $finalDate ? PagSeguroHelper::formatDate($finalDate) : null;

        try {

            $connection = new PagSeguroHttpConnection();
            $connection->get(
                self::buildSearchUrlByDate($connectionData, $searchParams),
                $connectionData->getServiceTimeout(),
                $connectionData->getCharset()
            );

            $httpStatus = new PagSeguroHttpStatus($connection->getStatus());

            switch ($httpStatus->getType()) {

                case 'OK':
                    $searchResult = PagSeguroTransactionParser::readSearchResult($connection->getResponse());
                    LogPagSeguro::info(
                        "PagSeguroTransactionSearchService.SearchByDate(initialDate=" .
                        PagSeguroHelper::formatDate($initialDate) .
                        ", finalDate=" . PagSeguroHelper::formatDate($finalDate) .
                        ") - end " . $searchResult->toString()
                    );
                    break;

                case 'BAD_REQUEST':
                    $errors = PagSeguroTransactionParser::readErrors($connection->getResponse());
                    $e = new PagSeguroServiceException($httpStatus, $errors);
                    LogPagSeguro::error(
                        "PagSeguroTransactionSearchService.SearchByDate(initialDate=" .
                        PagSeguroHelper::formatDate($initialDate) .
                        ", finalDate=" . PagSeguroHelper::formatDate($finalDate) .
                        ") - end " . $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

                default:
                    $e = new PagSeguroServiceException($httpStatus);
                    LogPagSeguro::error(
                        "PagSeguroTransactionSearchService.SearchByDate(initialDate=" .
                        PagSeguroHelper::formatDate($initialDate) . ", finalDate=" .
                        PagSeguroHelper::formatDate($finalDate) . ") - end " .
                        $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

            }

            return isset($searchResult) ? $searchResult : false;

        } catch (PagSeguroServiceException $e) {
            throw $e;
        }
        catch (Exception $e) {
            LogPagSeguro::error("Exception: " . $e->getMessage());
            throw $e;
        }

    }

    /**
     * Search transactions abandoned associated with this set of credentials within a date range
     *
     * @param PagSeguroCredentials $credentials
     * @param String $initialDate
     * @param String $finalDate
     * @param integer $pageNumber
     * @param integer $maxPageResults
     * @return PagSeguroTransactionSearchResult a object of PagSeguroTransactionSearchResult class
     * @see PagSeguroTransactionSearchResult
     * @throws PagSeguroServiceException
     * @throws Exception
     */
    public static function searchAbandoned(
        PagSeguroCredentials $credentials,
        $pageNumber,
        $maxPageResults,
        $initialDate,
        $finalDate = null
    ) {

        LogPagSeguro::info(
            "PagSeguroTransactionSearchService.searchAbandoned(initialDate=" .
            PagSeguroHelper::formatDate($initialDate) . ", finalDate=" .
            PagSeguroHelper::formatDate($finalDate) . ") - begin"
        );

        $connectionData = new PagSeguroConnectionData($credentials, self::SERVICE_NAME);

        $searchParams = array(
            'initialDate' => PagSeguroHelper::formatDate($initialDate),
            'pageNumber' => $pageNumber,
            'maxPageResults' => $maxPageResults
        );

        $searchParams['finalDate'] = $finalDate ? PagSeguroHelper::formatDate($finalDate) : null;

        try {

            $connection = new PagSeguroHttpConnection();
            $connection->get(
                self::buildSearchUrlAbandoned($connectionData, $searchParams),
                $connectionData->getServiceTimeout(),
                $connectionData->getCharset()
            );

            $httpStatus = new PagSeguroHttpStatus($connection->getStatus());

            switch ($httpStatus->getType()) {

                case 'OK':
                    $searchResult = PagSeguroTransactionParser::readSearchResult($connection->getResponse());
                    LogPagSeguro::info(
                        "PagSeguroTransactionSearchService.searchAbandoned(initialDate=" .
                        PagSeguroHelper::formatDate($initialDate) . ", finalDate=" .
                        PagSeguroHelper::formatDate($finalDate) . ") - end " . $searchResult->toString()
                    );
                    break;

                case 'BAD_REQUEST':
                    $errors = PagSeguroTransactionParser::readErrors($connection->getResponse());
                    $e = new PagSeguroServiceException($httpStatus, $errors);
                    LogPagSeguro::error(
                        "PagSeguroTransactionSearchService.searchAbandoned(initialDate=" .
                        PagSeguroHelper::formatDate($initialDate) . ", finalDate=" .
                        PagSeguroHelper::formatDate($finalDate) . ") - end " . $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

                default:
                    $e = new PagSeguroServiceException($httpStatus);
                    LogPagSeguro::error(
                        "PagSeguroTransactionSearchService.searchAbandoned(initialDate=" .
                        PagSeguroHelper::formatDate($initialDate) . ", finalDate=" .
                        PagSeguroHelper::formatDate($finalDate) . ") - end " . $e->getOneLineMessage()
                    );
                    throw $e;
                    break;

            }

            return isset($searchResult) ? $searchResult : false;

        } catch (PagSeguroServiceException $e) {
            throw $e;
        }
        catch (Exception $e) {
            LogPagSeguro::error("Exception: " . $e->getMessage());
            throw $e;
        }

    }
}
