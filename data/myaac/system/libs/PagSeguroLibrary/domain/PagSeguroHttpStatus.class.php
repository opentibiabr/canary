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
 * HTTP status that PagSeguro web services can return.
 */
class PagSeguroHttpStatus
{

    /**
     * @var array
     */
    private $typeList = array(
        200 => 'OK',
        400 => 'BAD_REQUEST',
        401 => 'UNAUTHORIZED',
        403 => 'FORBIDDEN',
        404 => 'NOT_FOUND',
        500 => 'INTERNAL_SERVER_ERROR',
        502 => 'BAD_GATEWAY'
    );
    /**
     * @var int
     */
    private $status;
    /**
     * @var bool
     */
    private $type;

    /**
     * @param $status
     */
    public function __construct($status)
    {
        if ($status) {
            $this->status = (int) $status;
            $this->type = $this->getTypeByStatus($this->status);
        }
    }

    /**
     * @return bool
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @return int
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * @param $status
     * @return bool
     */
    private function getTypeByStatus($status)
    {
        if (isset($this->typeList[(int) $status])) {
            return $this->typeList[(int) $status];
        } else {
            return false;
        }
    }
}
