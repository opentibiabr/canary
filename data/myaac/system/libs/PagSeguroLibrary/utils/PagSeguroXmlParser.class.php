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

class PagSeguroXmlParser
{

    private $dom;

    public function __construct($xml)
    {
		$xml = mb_convert_encoding($xml, "UTF-8", "UTF-8,ISO-8859-1");
        $parser = xml_parser_create();
        if (!xml_parse($parser, $xml)) {
            throw new Exception(
                "PagSeguroLibrary XML parsing error: (" . xml_get_error_code($parser) .
                ") " . xml_error_string(xml_get_error_code($parser))
            );
        } else {
            $this->dom = new DOMDocument();
            $this->dom->loadXml($xml);
        }
    }

    public function getResult($node = null)
    {
        $result = $this->toArray($this->dom);
        if ($node) {
            if (isset($result[$node])) {
                return $result[$node];
            } else {
                throw new Exception("PagSeguroLibrary XML parsing error: undefined index [$node]");
            }
        } else {
            return $result;
        }
    }

    private function toArray($node)
    {
        $occurrence = array();
        $result = null;
        /** @var $node DOMNode */
        if ($node->hasChildNodes()) {
            foreach ($node->childNodes as $child) {
                if (!isset($occurrence[$child->nodeName])) {
                    $occurrence[$child->nodeName] = null;
                }
                $occurrence[$child->nodeName]++;
            }
        }
        if (isset($child)) {
            if ($child->nodeName == '#text') {
                $result = html_entity_decode(
                    htmlentities($node->nodeValue, ENT_COMPAT, 'UTF-8'),
                    ENT_COMPAT,
                    'ISO-8859-15'
                );
            } else {
                if ($node->hasChildNodes()) {
                    $children = $node->childNodes;
                    for ($i = 0; $i < $children->length; $i++) {
                        $child = $children->item($i);
                        if ($child->nodeName != '#text') {
                            if ($occurrence[$child->nodeName] > 1) {
                                $result[$child->nodeName][] = $this->toArray($child);
                            } else {
                                $result[$child->nodeName] = $this->toArray($child);
                            }
                        } else {
                            if ($child->nodeName == '0') {
                                $text = $this->toArray($child);
                                if (trim($text) != '') {
                                    $result[$child->nodeName] = $this->toArray($child);
                                }
                            }
                        }
                    }
                }
                if ($node->hasAttributes()) {
                    $attributes = $node->attributes;
                    if (!is_null($attributes)) {
                        foreach ($attributes as $key => $attr) {
                            $result["@" . $attr->name] = $attr->value;
                        }
                    }
                }
            }
            return $result;
        } else {
            return null;
        }
    }
}
