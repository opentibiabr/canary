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
 * Class PagSeguroTransactionParser
 */
class PagSeguroTransactionParser extends PagSeguroServiceParser
{

    /**
     * @param $str_xml
     * @return PagSeguroTransactionSearchResult
     */
    public static function readSearchResult($str_xml)
    {

        $parser = new PagSeguroXmlParser($str_xml);
        $data = $parser->getResult('transactionSearchResult');

        $searchResutlt = new PagSeguroTransactionSearchResult();

        if (isset($data['totalPages'])) {
            $searchResutlt->setTotalPages($data['totalPages']);
        }

        if (isset($data['date'])) {
            $searchResutlt->setDate($data['date']);
        }

        if (isset($data['resultsInThisPage'])) {
            $searchResutlt->setResultsInThisPage($data['resultsInThisPage']);
        }

        if (isset($data['currentPage'])) {
            $searchResutlt->setCurrentPage($data['currentPage']);
        }

        if (isset($data['transactions']) && is_array($data['transactions'])) {
            $transactions = array();
            if (isset($data['transactions']['transaction'][0])) {
                $i = 0;
                foreach ($data['transactions']['transaction'] as $key => $value) {
                    $transactions[$i++] = self::parseTransactionSummary($value);
                }
            } else {
                $transactions[0] = self::parseTransactionSummary($data['transactions']['transaction']);
            }
            $searchResutlt->setTransactions($transactions);
        }

        return $searchResutlt;
    }

    /**
     * @param $str_xml
     * @return PagSeguroTransaction
     */
    public static function readTransaction($str_xml)
    {

        // Parser
        $parser = new PagSeguroXmlParser($str_xml);

        // <transaction>
        $data = $parser->getResult('transaction');

        $transaction = new PagSeguroTransaction();

        // <transaction> <lastEventDate>
        if (isset($data["lastEventDate"])) {
            $transaction->setLastEventDate($data["lastEventDate"]);
        }

        // <transaction> <date>
        if (isset($data["date"])) {
            $transaction->setDate($data["date"]);
        }

        // <transaction> <code>
        if (isset($data["code"])) {
            $transaction->setCode($data["code"]);
        }

        // <transaction> <reference>
        if (isset($data["reference"])) {
            $transaction->setReference($data["reference"]);
        }

        // <transaction> <type>
        if (isset($data["type"])) {
            $transaction->setType(new PagSeguroTransactionType($data["type"]));
        }

        // <transaction> <status>
        if (isset($data["status"])) {
            $transaction->setStatus(new PagSeguroTransactionStatus($data["status"]));
        }

        // <transaction> <cancellationSource>
        if (isset($data["cancellationSource"])) {
            $transaction->setCancellationSource(new PagSeguroTransactionCancellationSource($data["cancellationSource"]));
        }

        if (isset($data["paymentMethod"]) && is_array($data["paymentMethod"])) {

            // <transaction> <paymentMethod>
            $paymentMethod = new PagSeguroPaymentMethod();

            // <transaction> <paymentMethod> <type>
            if (isset($data["paymentMethod"]['type'])) {
                $paymentMethod->setType(new PagSeguroPaymentMethodType($data["paymentMethod"]['type']));
            }

            // <transaction> <paymentMethod> <code>
            if (isset($data["paymentMethod"]['code'])) {
                $paymentMethod->setCode(new PagSeguroPaymentMethodCode($data["paymentMethod"]['code']));
            }

            $transaction->setPaymentMethod($paymentMethod);
        }

        // <transaction> <grossAmount>
        if (isset($data["grossAmount"])) {
            $transaction->setGrossAmount($data["grossAmount"]);
        }

        // <transaction> <discountAmount>
        if (isset($data["discountAmount"])) {
            $transaction->setDiscountAmount($data["discountAmount"]);
        }

        // <transaction> <feeAmount>
        if (isset($data["feeAmount"])) {
            $transaction->setFeeAmount($data["feeAmount"]);
        }

        // <transaction> <netAmount>
        if (isset($data["netAmount"])) {
            $transaction->setNetAmount($data["netAmount"]);
        }

        // <transaction> <extraAmount>
        if (isset($data["extraAmount"])) {
            $transaction->setExtraAmount($data["extraAmount"]);
        }

        // <transaction> <installmentCount>
        if (isset($data["installmentCount"])) {
            $transaction->setInstallmentCount($data["installmentCount"]);
        }

        if (isset($data["items"]['item']) && is_array($data["items"]['item'])) {

            $items = array();
            $i = 0;

            if (isset($data["items"]['item'][0])) {
                foreach ($data["items"]['item'] as $key => $value) {
                    $item = self::parseTransactionItem($value);
                    $items[$i] = $item;
                    $i++;
                }
            } else {
                $items[0] = self::parseTransactionItem($data["items"]['item']);
            }

            // <transaction> <items>
            $transaction->setItems($items);
        }

        if (isset($data["sender"])) {

            // <transaction> <sender>
            $sender = new PagSeguroSender();

            // <transaction> <sender> <name>
            if (isset($data["sender"]["name"])) {
                $sender->setName($data["sender"]["name"]);
            }

            // <transaction> <sender> <email>
            if (isset($data["sender"]["email"])) {
                $sender->setEmail($data["sender"]["email"]);
            }

            if (isset($data["sender"]["phone"])) {

                // <transaction> <sender> <phone>
                $phone = new PagSeguroPhone();

                // <transaction> <sender> <phone> <areaCode>
                if (isset($data["sender"]["phone"]["areaCode"])) {
                    $phone->setAreaCode($data["sender"]["phone"]["areaCode"]);
                }

                // <transaction> <sender> <phone> <number>
                if (isset($data["sender"]["phone"]["number"])) {
                    $phone->setNumber($data["sender"]["phone"]["number"]);
                }

                $sender->setPhone($phone);
            }

            // <transaction><sender><documents>
            if (isset($data['sender']['documents']) && is_array($data['sender']['documents'])) {

                $documents = $data['sender']['documents'];
                if (count($documents) > 0) {
                    foreach ($documents as $document) {
                        $sender->addDocument($document['type'], $document['value']);
                    }
                }
            }

            $transaction->setSender($sender);
        }

        if (isset($data["shipping"]) && is_array($data["shipping"])) {

            // <transaction> <shipping>
            $shipping = new PagSeguroShipping();

            // <transaction> <shipping> <type>
            if (isset($data["shipping"]["type"])) {
                $shipping->setType(new PagSeguroShippingType($data["shipping"]["type"]));
            }

            // <transaction> <shipping> <cost>
            if (isset($data["shipping"]["cost"])) {
                $shipping->setCost($data["shipping"]["cost"]);
            }

            if (isset($data["shipping"]["address"]) && is_array($data["shipping"]["address"])) {

                // <transaction> <shipping> <address>
                $address = new PagSeguroAddress();

                // <transaction> <shipping> <address> <street>
                if (isset($data["shipping"]["address"]["street"])) {
                    $address->setStreet($data["shipping"]["address"]["street"]);
                }

                // <transaction> <shipping> <address> <number>
                if (isset($data["shipping"]["address"]["number"])) {
                    $address->setNumber($data["shipping"]["address"]["number"]);
                }

                // <transaction> <shipping> <address> <complement>
                if (isset($data["shipping"]["address"]["complement"])) {
                    $address->setComplement($data["shipping"]["address"]["complement"]);
                }

                // <transaction> <shipping> <address> <city>
                if (isset($data["shipping"]["address"]["city"])) {
                    $address->setCity($data["shipping"]["address"]["city"]);
                }

                // <transaction> <shipping> <address> <state>
                if (isset($data["shipping"]["address"]["state"])) {
                    $address->setState($data["shipping"]["address"]["state"]);
                }

                // <transaction> <shipping> <address> <district>
                if (isset($data["shipping"]["address"]["district"])) {
                    $address->setDistrict($data["shipping"]["address"]["district"]);
                }

                // <transaction> <shipping> <address> <postalCode>
                if (isset($data["shipping"]["address"]["postalCode"])) {
                    $address->setPostalCode($data["shipping"]["address"]["postalCode"]);
                }

                // <transaction> <shipping> <address> <country>
                if (isset($data["shipping"]["address"]["country"])) {
                    $address->setCountry($data["shipping"]["address"]["country"]);
                }

                $shipping->setAddress($address);
            }

            // <transaction> <shipping>
            $transaction->setShipping($shipping);
        }

        return $transaction;
    }

    /**
     * @param $data
     * @return PagSeguroItem
     */
    private static function parseTransactionItem($data)
    {

        // <transaction> <items> <item>
        $item = new PagSeguroItem();

        // <transaction> <items> <item> <id>
        if (isset($data["id"])) {
            $item->setId($data["id"]);
        }

        // <transaction> <items> <item> <description>
        if (isset($data["description"])) {
            $item->setDescription($data["description"]);
        }

        // <transaction> <items> <item> <quantity>
        if (isset($data["quantity"])) {
            $item->setQuantity($data["quantity"]);
        }

        // <transaction> <items> <item> <amount>
        if (isset($data["amount"])) {
            $item->setAmount($data["amount"]);
        }

        // <transaction> <items> <item> <weight>
        if (isset($data["weight"])) {
            $item->setWeight($data["weight"]);
        }

        return $item;
    }

    /**
     * @param $data
     * @return PagSeguroTransactionSummary
     */
    private static function parseTransactionSummary($data)
    {

        $transactionSummary = new PagSeguroTransactionSummary();

        if (isset($data['type'])) {
            $transactionSummary->setType(new PagSeguroTransactionType($data['type']));
        }
        if (isset($data['code'])) {
            $transactionSummary->setCode($data['code']);
        }
        if (isset($data['reference'])) {
            $transactionSummary->setReference($data['reference']);
        }
        if (isset($data['date'])) {
            $transactionSummary->setDate($data['date']);
        }
        if (isset($data['lastEventDate'])) {
            $transactionSummary->setLastEventDate($data['lastEventDate']);
        }
        if (isset($data['grossAmount'])) {
            $transactionSummary->setGrossAmount($data['grossAmount']);
        }
        if (isset($data['status'])) {
            $transactionSummary->setStatus(new PagSeguroTransactionStatus($data['status']));
        }
        if (isset($data["cancellationSource"])) {
            $transactionSummary->setCancellationSource(new PagSeguroTransactionCancellationSource($data["cancellationSource"]));
        }
        if (isset($data['netAmount'])) {
            $transactionSummary->setNetAmount($data['netAmount']);
        }
        if (isset($data['discountAmount'])) {
            $transactionSummary->setDiscountAmount($data['discountAmount']);
        }
        if (isset($data['feeAmount'])) {
            $transactionSummary->setFeeAmount($data['feeAmount']);
        }
        if (isset($data['extraAmount'])) {
            $transactionSummary->setExtraAmount($data['extraAmount']);
        }
        if (isset($data['lastEvent'])) {
            $transactionSummary->setLastEventDate($data['lastEvent']);
        }
        if (isset($data['paymentMethod'])) {
            $paymentMethod = new PagSeguroPaymentMethod();
            if (isset($data['paymentMethod']['type'])) {
                $paymentMethod->setType(new PagSeguroPaymentMethodType($data['paymentMethod']['type']));
            }
            if (isset($data['paymentMethod']['code'])) {
                $paymentMethod->setCode(new PagSeguroPaymentMethodCode($data['paymentMethod']['code']));
            }
            $transactionSummary->setPaymentMethod($paymentMethod);
        }

        if (isset($data["recoveryCode"])) {
            $transactionSummary->setRecoveryCode($data["recoveryCode"]);
        }
        
        return $transactionSummary;
    }
}
