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
 * Represents a page of transactions returned by the transaction search service
 */
class PagSeguroTransactionSearchResult
{

    /**
     * Date/time when this search was executed
     */
    private $date;

    /**
     * Transactions in the current page
     */
    private $resultsInThisPage;

    /**
     * Total number of pages
     */
    private $totalPages;

    /**
     * Current page.
     */
    private $currentPage;

    /**
     * Transaction summaries in this page
     */
    private $transactions;

    /**
     * @return the current page number
     */
    public function getCurrentPage()
    {
        return $this->currentPage;
    }

    /**
     * Sets the current page number
     * @param integer $currentPage
     */
    public function setCurrentPage($currentPage)
    {
        $this->currentPage = $currentPage;
    }

    /**
     * @return the date/time when this search was executed
     */
    public function getDate()
    {
        return $this->date;
    }

    /**
     * Set the date/time when this search was executed
     * @param date
     */
    public function setDate($date)
    {
        $this->date = $date;
    }

    /**
     * @return the number of transactions summaries in the current page
     */
    public function getResultsInThisPage()
    {
        return $this->resultsInThisPage;
    }

    /**
     * Sets the number of transaction summaries in the current page
     *
     * @param resultsInThisPage
     */
    public function setResultsInThisPage($resultsInThisPage)
    {
        $this->resultsInThisPage = $resultsInThisPage;
    }

    /**
     * @return the total number of pages
     */
    public function getTotalPages()
    {
        return $this->totalPages;
    }

    /**
     * Sets the total number of pages
     *
     * @param totalPages
     */
    public function setTotalPages($totalPages)
    {
        $this->totalPages = $totalPages;
    }

    /**
     * @return PagSeguroTransactionSummary the transaction summaries in this page
     * @see PagSeguroTransactionSummary
     */
    public function getTransactions()
    {
        return $this->transactions;
    }

    /**
     * Sets the transaction summaries in this page
     *
     * @param array $transactions
     */
    public function setTransactions(array $transactions)
    {
        $this->transactions = $transactions;
    }

    /**
     * @return String a string that represents the current object
     */
    public function toString()
    {
        $transaction = array();

        $transaction['Date'] = $this->date;
        $transaction['CurrentPage'] = $this->currentPage;
        $transaction['TotalPages'] = $this->totalPages;
        $transaction['Transactions in this page'] = $this->resultsInThisPage;

        return "PagSeguroTransactionSearchResult: " . var_export($transaction, true);

    }
}
