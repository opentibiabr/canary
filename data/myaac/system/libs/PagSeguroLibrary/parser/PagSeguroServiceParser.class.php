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
 * Class PagSeguroServiceParser
 */
class PagSeguroServiceParser
{

    /**
     * @param $str_xml
     * @return array
     */
    public static function readErrors($str_xml)
    {
        $parser = new PagSeguroXmlParser($str_xml);
        $data = $parser->getResult('errors');
        $errors = array();
        if (isset($data['error']) && is_array($data['error'])) {
            if (isset($data['error']['code']) && isset($data['error']['message'])) {
                array_push($errors, new PagSeguroError($data['error']['code'], $data['error']['message']));
            } else {
                foreach ($data['error'] as $key => $value) {
                    if (isset($value['code']) && isset($value['message'])) {
                        array_push($errors, new PagSeguroError($value['code'], $value['message']));
                    }
                }
            }
        }
        return $errors;
    }
}
