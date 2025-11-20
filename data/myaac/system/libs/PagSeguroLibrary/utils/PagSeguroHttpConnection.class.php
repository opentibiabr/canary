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
 * HTTP Connection Class - used in API calls (cURL library is required)
 */
class PagSeguroHttpConnection
{

    private $status;
    private $response;

    public function __construct()
    {
        if (!function_exists('curl_init')) {
            throw new Exception('PagSeguroLibrary: cURL library is required.');
        }
    }

    public function getStatus()
    {
        return $this->status;
    }

    public function setStatus($status)
    {
        $this->status = $status;
    }

    public function getResponse()
    {
        return $this->response;
    }

    public function setResponse($response)
    {
        $this->response = $response;
    }

    public function post($url, array $data, $timeout = 20, $charset = 'ISO-8859-1')
    {
        return $this->curlConnection('POST', $url, $timeout, $charset, $data);
    }

    public function get($url, $timeout = 20, $charset = 'ISO-8859-1')
    {
        return $this->curlConnection('GET', $url, $timeout, $charset, null);
    }

    private function curlConnection($method, $url, $timeout, $charset, array $data = null)
    {

        if (strtoupper($method) === 'POST') {
            $postFields = ($data ? http_build_query($data, '', '&') : "");
            $contentLength = "Content-length: " . strlen($postFields);
            $methodOptions = array(
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => $postFields,
            );
        } else {
            $contentLength = null;
            $methodOptions = array(
                CURLOPT_HTTPGET => true
            );
        }


        $options = array(
            CURLOPT_HTTPHEADER => array(
                "Content-Type: application/x-www-form-urlencoded; charset=" . $charset,
                $contentLength,
                'lib-description: php:' . PagSeguroLibrary::getVersion(),
                'language-engine-description: php:' . PagSeguroLibrary::getPHPVersion()
            ),
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HEADER => false,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_CONNECTTIMEOUT => $timeout,
            //CURLOPT_TIMEOUT => $timeout
            );

        if (!is_null(PagSeguroLibrary::getModuleVersion())) {
            array_push($options[CURLOPT_HTTPHEADER], 'module-description: ' . PagSeguroLibrary::getModuleVersion());
        }

        if (!is_null(PagSeguroLibrary::getCMSVersion())) {
            array_push($options[CURLOPT_HTTPHEADER], 'cms-description: ' . PagSeguroLibrary::getCMSVersion());
        }
        
        $options = ($options + $methodOptions);

        $curl = curl_init();
        curl_setopt_array($curl, $options);
        $resp = curl_exec($curl);
        $info = curl_getinfo($curl);
        $error = curl_errno($curl);
        $errorMessage = curl_error($curl);
        curl_close($curl);
        $this->setStatus((int) $info['http_code']);
        $this->setResponse((String) $resp);
        if ($error) {
            throw new Exception("CURL can't connect: $errorMessage");
        } else {
            return true;
        }
    }
}
