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

/*
 * Represents a exception behavior
 * */
/**
 * Class PagSeguroServiceException
 */
class PagSeguroServiceException extends Exception
{

    /**
     * @var PagSeguroHttpStatus
     */
    private $httpStatus;
    /**
     * @var
     */
    private $httpMessage;
    /**
     * @var array
     */
    private $errors = array();

    /**
     * @param PagSeguroHttpStatus $httpStatus
     * @param array $errors
     */
    public function __construct(PagSeguroHttpStatus $httpStatus, array $errors = null)
    {
        $this->httpStatus = $httpStatus;
        if ($errors) {
            $this->errors = $errors;
        }
        //$this->httpMessage = $this->getFormattedMessage();
        parent::__construct($this->getOneLineMessage());
    }

    /**
     * @return array
     */
    public function getErrors()
    {
        return $this->errors;
    }

    /**
     * @param array $errors
     */
    public function setErrors(array $errors)
    {
        $this->errors = $errors;
    }

    /**
     * @return PagSeguroHttpStatus
     */
    public function getHttpStatus()
    {
        return $this->httpStatus;
    }

    /**
     * @param PagSeguroHttpStatus $httpStatus
     */
    public function setHttpStatus(PagSeguroHttpStatus $httpStatus)
    {
        $this->httpStatus = $httpStatus;
    }

    /**
     * @return string
     */
    private function getHttpMessage()
    {

        switch ($type = $this->httpStatus->getType()) {

            case 'BAD_REQUEST':
            case 'UNAUTHORIZED':
            case 'FORBIDDEN':
            case 'NOT_FOUND':
            case 'INTERNAL_SERVER_ERROR':
            case 'BAD_GATEWAY':
                $message = $type;
                break;

            default:
                $message = "UNDEFINED";
                break;

        }
        return $message;
    }

    /**
     * @return string
     */
    public function getFormattedMessage()
    {
        $message = "";
        $message .= "[HTTP " . $this->httpStatus->getStatus() . "] - " . $this->getHttpMessage() . "\n";
        foreach ($this->errors as $key => $value) {
            if ($value instanceof PagSeguroError) {
                $message .= "$key [" . $value->getCode() . "] - " . $value->getMessage();
            }
        }
        return $message;
    }

    /**
     * @return mixed
     */
    public function getOneLineMessage()
    {
        return str_replace("\n", " ", $this->getFormattedMessage());
    }
}
