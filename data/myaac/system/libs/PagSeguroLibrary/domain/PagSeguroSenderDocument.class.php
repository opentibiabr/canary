<?php

/**
 * Class that represents a Sender Document
 */
class PagSeguroSenderDocument
{

    /**
     * The type of document
     * @var string
     */
    private $type;

    /**
     * The value of document
     * @var string
     */
    private $value;

    /**
     * @param $type
     * @param $value
     */
    public function __construct($type, $value)
    {
        if ($type && $value) {
            $this->setType($type);
            $this->setValue($value);
        }
    }

    /**
     * Get document type
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Set document type
     * @param string $type
     */
    public function setType($type)
    {
        $this->type = strtoupper($type);
    }

    /**
     * Get document value
     * @return string
     */
    public function getValue()
    {
        return $this->value;
    }

    /**
     * Set document value
     * @param string $value
     */
    public function setValue($value)
    {
        $this->value = PagSeguroHelper::getOnlyNumbers($value);
    }

    /**
     * Gets toString class
     * @return string
     */
    public function toString()
    {
        $document = array();
        $document['type'] = $this->type;
        $document['value'] = $this->value;

        return "PagSeguroSenderDocument: " . var_export($document, true);
    }
}
