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
 * Class PagSeguroPaymentParser
 */
class PagSeguroPaymentParser extends PagSeguroServiceParser
{

    /**
     * @param $payment PagSeguroPaymentRequest
     * @return mixed
     */
    public static function getData($payment)
    {

        $data = null;

        // reference
        if ($payment->getReference() != null) {
            $data["reference"] = $payment->getReference();
        }

        // sender
        if ($payment->getSender() != null) {

            if ($payment->getSender()->getName() != null) {
                $data['senderName'] = $payment->getSender()->getName();
            }
            if ($payment->getSender()->getEmail() != null) {
                $data['senderEmail'] = $payment->getSender()->getEmail();
            }

            // phone
            if ($payment->getSender()->getPhone() != null) {
                if ($payment->getSender()->getPhone()->getAreaCode() != null) {
                    $data['senderAreaCode'] = $payment->getSender()->getPhone()->getAreaCode();
                }
                if ($payment->getSender()->getPhone()->getNumber() != null) {
                    $data['senderPhone'] = $payment->getSender()->getPhone()->getNumber();
                }
            }

            // documents
            /** @var $document PagSeguroDocument */
            if ($payment->getSender()->getDocuments() != null) {
                $documents = $payment->getSender()->getDocuments();
                if (is_array($documents) && count($documents) == 1) {
                    foreach ($documents as $document) {
                        if (!is_null($document)) {
                            $data['senderCPF'] = $document->getValue();
                        }
                    }
                }
            }
        }

        // currency
        if ($payment->getCurrency() != null) {
            $data['currency'] = $payment->getCurrency();
        }

        // items
        $items = $payment->getItems();
        if (count($items) > 0) {

            $i = 0;

            foreach ($items as $key => $value) {
                $i++;
                if ($items[$key]->getId() != null) {
                    $data["itemId$i"] = $items[$key]->getId();
                }
                if ($items[$key]->getDescription() != null) {
                    $data["itemDescription$i"] = $items[$key]->getDescription();
                }
                if ($items[$key]->getQuantity() != null) {
                    $data["itemQuantity$i"] = $items[$key]->getQuantity();
                }
                if ($items[$key]->getAmount() != null) {
                    $amount = PagSeguroHelper::decimalFormat($items[$key]->getAmount());
                    $data["itemAmount$i"] = $amount;
                }
                if ($items[$key]->getWeight() != null) {
                    $data["itemWeight$i"] = $items[$key]->getWeight();
                }
                if ($items[$key]->getShippingCost() != null) {
                    $data["itemShippingCost$i"] = PagSeguroHelper::decimalFormat($items[$key]->getShippingCost());
                }
            }
        }

        // extraAmount
        if ($payment->getExtraAmount() != null) {
            $data['extraAmount'] = PagSeguroHelper::decimalFormat($payment->getExtraAmount());
        }

        // shipping
        if ($payment->getShipping() != null) {

            if ($payment->getShipping()->getType() != null && $payment->getShipping()->getType()->getValue() != null) {
                $data['shippingType'] = $payment->getShipping()->getType()->getValue();
            }

            if ($payment->getShipping()->getCost() != null && $payment->getShipping()->getCost() != null) {
                $data['shippingCost'] = PagSeguroHelper::decimalFormat($payment->getShipping()->getCost());
            }

            // address
            if ($payment->getShipping()->getAddress() != null) {
                if ($payment->getShipping()->getAddress()->getStreet() != null) {
                    $data['shippingAddressStreet'] = $payment->getShipping()->getAddress()->getStreet();
                }
                if ($payment->getShipping()->getAddress()->getNumber() != null) {
                    $data['shippingAddressNumber'] = $payment->getShipping()->getAddress()->getNumber();
                }
                if ($payment->getShipping()->getAddress()->getComplement() != null) {
                    $data['shippingAddressComplement'] = $payment->getShipping()->getAddress()->getComplement();
                }
                if ($payment->getShipping()->getAddress()->getCity() != null) {
                    $data['shippingAddressCity'] = $payment->getShipping()->getAddress()->getCity();
                }
                if ($payment->getShipping()->getAddress()->getState() != null) {
                    $data['shippingAddressState'] = $payment->getShipping()->getAddress()->getState();
                }
                if ($payment->getShipping()->getAddress()->getDistrict() != null) {
                    $data['shippingAddressDistrict'] = $payment->getShipping()->getAddress()->getDistrict();
                }
                if ($payment->getShipping()->getAddress()->getPostalCode() != null) {
                    $data['shippingAddressPostalCode'] = $payment->getShipping()->getAddress()->getPostalCode();
                }
                if ($payment->getShipping()->getAddress()->getCountry() != null) {
                    $data['shippingAddressCountry'] = $payment->getShipping()->getAddress()->getCountry();
                }
            }
        }

        // maxAge
        if ($payment->getMaxAge() != null) {
            $data['maxAge'] = $payment->getMaxAge();
        }
        // maxUses
        if ($payment->getMaxUses() != null) {
            $data['maxUses'] = $payment->getMaxUses();
        }

        // redirectURL
        if ($payment->getRedirectURL() != null) {
            $data['redirectURL'] = $payment->getRedirectURL();
        }

        // notificationURL
        if ($payment->getNotificationURL() != null) {
            $data['notificationURL'] = $payment->getNotificationURL();
        }

        // metadata
        if (count($payment->getMetaData()->getItems()) > 0) {
            $i = 0;
            foreach ($payment->getMetaData()->getItems() as $item) {
                if ($item instanceof PagSeguroMetaDataItem) {
                    if (!PagSeguroHelper::isEmpty($item->getKey()) && !PagSeguroHelper::isEmpty($item->getValue())) {
                        $i++;
                        $data['metadataItemKey' . $i] = $item->getKey();
                        $data['metadataItemValue' . $i] = $item->getValue();

                        if (!PagSeguroHelper::isEmpty($item->getGroup())) {
                            $data['metadataItemGroup' . $i] = $item->getGroup();
                        }
                    }
                }
            }
        }

        // parameter
        if (count($payment->getParameter()->getItems()) > 0) {
            foreach ($payment->getParameter()->getItems() as $item) {
                if ($item instanceof PagSeguroParameterItem) {
                    if (!PagSeguroHelper::isEmpty($item->getKey()) && !PagSeguroHelper::isEmpty($item->getValue())) {
                        if (!PagSeguroHelper::isEmpty($item->getGroup())) {
                            $data[$item->getKey() . '' . $item->getGroup()] = $item->getValue();
                        } else {
                            $data[$item->getKey()] = $item->getValue();
                        }
                    }
                }
            }
        }

        return $data;
    }

    /**
     * @param $str_xml
     * @return PagSeguroPaymentParserData
     */
    public static function readSuccessXml($str_xml)
    {
        $parser = new PagSeguroXmlParser($str_xml);
        $data = $parser->getResult('checkout');
        $PaymentParserData = new PagSeguroPaymentParserData();
        $PaymentParserData->setCode($data['code']);
        $PaymentParserData->setRegistrationDate($data['date']);
        return $PaymentParserData;
    }
}
