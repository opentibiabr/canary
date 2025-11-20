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
 * Class PagSeguroConnectionData
 */
class PagSeguroConnectionData
{

    /**
     * @var
     */
    private $serviceName;
    /**
     * @var PagSeguroCredentials
     */
    private $credentials;
    /**
     * @var
     */
    private $resources;
    /**
     * @var
     */
    private $environment;
    /**
     * @var
     */
    private $webserviceUrl;
    /**
     * @var
     */
    private $paymentUrl;
    /**
     * @var
     */
    private $servicePath;
    /**
     * @var
     */
    private $serviceTimeout;
    /**
     * @var
     */
    private $charset;

    /**
     * @param PagSeguroCredentials $credentials
     * @param $serviceName
     */
    public function __construct(PagSeguroCredentials $credentials, $serviceName)
    {

        $this->credentials = $credentials;
        $this->serviceName = $serviceName;

        $this->setEnvironment(PagSeguroConfig::getEnvironment());
        $this->setWebserviceUrl(PagSeguroResources::getWebserviceUrl($this->getEnvironment()));
        $this->setPaymentUrl(PagSeguroResources::getPaymentUrl($this->getEnvironment()));
        $this->setCharset(PagSeguroConfig::getApplicationCharset());

        $this->resources = PagSeguroResources::getData($this->serviceName);
        if (isset($this->resources['servicePath'])) {
            $this->setServicePath($this->resources['servicePath']);
        }
        if (isset($this->resources['serviceTimeout'])) {
            $this->setServiceTimeout($this->resources['serviceTimeout']);
        }

    }

    /**
     * @return PagSeguroCredentials
     */
    public function getCredentials()
    {
        return $this->credentials;
    }

    /**
     * @param PagSeguroCredentials $credentials
     */
    public function setCredentials(PagSeguroCredentials $credentials)
    {
        $this->credentials = $credentials;
    }

    /**
     * @return string
     */
    public function getCredentialsUrlQuery()
    {
        return http_build_query($this->credentials->getAttributesMap(), '', '&');
    }

    /**
     * @return mixed
     */
    public function getEnvironment()
    {
        return $this->environment;
    }

    /**
     * @param $environment
     */
    public function setEnvironment($environment)
    {
        $this->environment = $environment;
    }

    /**
     * @return mixed
     */
    public function getWebserviceUrl()
    {
        return $this->webserviceUrl;
    }

    /**
     * @param $webserviceUrl
     */
    public function setWebserviceUrl($webserviceUrl)
    {
        $this->webserviceUrl = $webserviceUrl;
    }

    /**
     * @return mixed
     */
    public function getPaymentUrl()
    {
        return $this->paymentUrl;
    }

    /**
     * @param $environment
     */
    public function setPaymentUrl($paymentUrl)
    {
        $this->paymentUrl = $paymentUrl;
    }

    /**
     * @return mixed
     */
    public function getServicePath()
    {
        return $this->servicePath;
    }

    /**
     * @param $servicePath
     */
    public function setServicePath($servicePath)
    {
        $this->servicePath = $servicePath;
    }

    /**
     * @return mixed
     */
    public function getServiceTimeout()
    {
        return $this->serviceTimeout;
    }

    /**
     * @param $serviceTimeout
     */
    public function setServiceTimeout($serviceTimeout)
    {
        $this->serviceTimeout = $serviceTimeout;
    }

    /**
     * @return string
     */
    public function getServiceUrl()
    {
        return $this->getWebserviceUrl() . $this->getServicePath();
    }

    /**
     * @param $resource
     * @return mixed
     */
    public function getResource($resource)
    {
        return $this->resources[$resource];
    }

    /**
     * @return mixed
     */
    public function getCharset()
    {
        return $this->charset;
    }

    /**
     * @param $charset
     */
    public function setCharset($charset)
    {
        $this->charset = $charset;
    }
}
