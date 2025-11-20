<?php
/**
 * Automatic PagSeguro payment system gateway.
 *
 * @name      myaac-pagseguro
 * @author    Ivens Pontes <ivenscardoso@hotmail.com>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    Elson <elsongabriel@hotmail.com>
 * @author    OpenTibiaBR
 * @copyright 2024 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 * @version   2.0
 */

$config['pagSeguro'] = [
    'email'             => '', // your pagseguro e-mail
    'environment'       => 'production', // production, sandbox
    'token'             => [
        'production'    => '',
        'sandbox'       => '',
    ],
    'urlRedirect'       => '?subtopic=donate&action=final', // default should be good
    'productName'       => 'My Coins', // Your coins name, ex: Server Name, Coins, Premium Points, etc..
    'value'             => 0.10,
    'doubleCoins'       => false, // should coins be doubled? for example: for 5 coins donated you become 10.
    'doubleCoinsStart'  => 300, // if doubleCoins is activated, what is min value to activate double coins
    'donationType'      => 'coins_transferable', // what should be added to player account? coins/coins_transferable
    'donates'           => [ // value = value in reais / coins = amount of coins / extra = bonus
        '10'   => ['id' => '10',   'value'   => 10,   'coins' => 100,   'extra' => 0],
        '20'   => ['id' => '20',   'value'   => 20,   'coins' => 200,   'extra' => 0],
        '30'   => ['id' => '30',   'value'   => 30,   'coins' => 300,   'extra' => 30],
        '40'   => ['id' => '40',   'value'   => 40,   'coins' => 400,   'extra' => 40],
        '50'   => ['id' => '50',   'value'   => 50,   'coins' => 500,   'extra' => 50],
    ],
    'boxes' => [ // if you want to sell boxes in site
        'xxxxx' => [ // put canary box item id
            'id'          => 'xxxxx', // the same id
            'name'        => 'My Basic Box', // box name
            'value'       => 1.00, // value
            'image'       => 'box_basic.png', // your image
            'border'      => '#1fc939', // border color
            'description' => 'Com essa box, você economiza R$ xx,00', // some description
        ],
    ]
];
