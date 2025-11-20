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
 * Represent a parameter
 */
class PagSeguroParameter
{

    private $items;

    public function __construct(array $items = null)
    {
        if (!is_null($items) && count($items) > 0) {
            $this->setItems($items);
        }
    }

    public function addItem(PagSeguroParameterItem $parameterItem)
    {

        if (!PagSeguroHelper::isEmpty($parameterItem->getKey())) {
            if (!PagSeguroHelper::isEmpty($parameterItem->getValue())) {
                $this->items[] = $parameterItem;
            } else {
                die('requered parameterValue.');
            }
        } else {
            die('requered parameterKey.');
        }
    }

    public function setItems(array $items)
    {
        $this->items = $items;
    }

    public function getItems()
    {
        if ($this->items == null) {
            $this->items = array();
        }
        return $this->items;
    }
}
