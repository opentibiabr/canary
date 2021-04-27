#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
This is python script to simulate the login functions used by the Tibia client +11!
"""

from flask import Flask
from flask import jsonify
from flask import request
import mysql.connector as mariadb
from mysql.connector import Error
import time
import os

app = Flask(__name__)

def do_login(data):

    try:
        connection = mariadb.connect(host=os.getenv('DB_IP', 'mysql'),
                                database=os.getenv('DB_DATABASE', 'otserver'),
                                user=os.getenv('DB_USER', 'otserver'),
                                password=os.getenv('DB_PASSWORD', 'otserver'))

        sql_select_Query = "SELECT id, premdays, lastday FROM accounts WHERE name = '" + data['email'].replace('@','') + "'"

        print("Loading account information!")
        cursor = connection.cursor()
        cursor.execute(sql_select_Query)
        records = cursor.fetchall()
        for row in records:
            print("Id = ", row[0])
        account_id = row[0]
        account_premdays = row[1]
        account_lastday = row[2]

        session = {
            'sessionkey': data['email'] + '\n' + data['password'],
            'lastlogintime': 0,
            'ispremium': True if account_premdays > 0 else False,
            'premiumuntil': 0 if account_premdays == 0 else int(time.time()) + (account_premdays * 86400),
            'status': 'active',
            'returnernotification': False,
            'showrewardnews': True,
            'isreturner': True,
            'fpstracking': False,
            'optiontracking': False,
            'tournamentticketpurchasestate': 0,
            'emailcoderequest': False
        };
        print(session)

        sql_select_Query = "SELECT name, level, sex, vocation, looktype, lookhead, lookbody, looklegs, lookfeet, lookaddons, lastlogin from players where account_id = '" + str(account_id) + "'"

        cursor = connection.cursor()
        cursor.execute(sql_select_Query)
        records = cursor.fetchall()
        print(records)

        players = []
        vocations = ['None', 'Sorcerer', 'Druid', 'Paladin', 'Knight', 'Master Sorcerer', 'Elder Druid', 'Royal Paladin', 'Elite Knight', 'Sorcerer Dawnport', 'Druid Dawnport', 'Paladin Dawnport', 'Knight Dawnport']
        print("Loading account players information!")
        for (name, level, sex, vocation, looktype, lookhead, lookbody, looklegs, lookfeet, lookaddons, lastlogin) in records:
            player = {
                    'worldid': 0,
                    'name': name,
                    'level': level,
                    'ismale': True if sex == 1 else False,
                    'vocation': vocations[vocation],
                    'outfitid': looktype,
                    'headcolor': lookhead,
                    'torsocolor': lookbody,
                    'legscolor': looklegs,
                    'detailcolor': lookfeet,
                    'addonsflags': lookaddons,
                    'tutorial': False, # True will make the client crash as it will try to auto connect
                    'ishidden': False,
                    'istournamentparticipant': False,
                    'remainingdailytournamentplaytime': 0
            }
            players.append(player)
        print(players)

        playdata = {
            'worlds': [
                {
                    'id': 0,
                    'name': os.getenv('SERVER_NAME', 'OTServBR-Global'),
                    'externaladdressprotected': os.getenv('PROXY_IP', '127.0.0.1'),
                    'externalportprotected': int(os.getenv('SERVER_GAME_PORT', 7172)),
                    'externaladdressunprotected': os.getenv('PROXY_IP', '127.0.0.1'),
                    'externalportunprotected': int(os.getenv('SERVER_GAME_PORT', 7172)),
                    'previewstate': 0,
                    'location': 'BRA',
                    'anticheatprotection': False,
                    'pvptype': 'pvp',
                    'istournamentworld': False,
                    'restrictedstore': False,
                    'currenttournamentphase': 2
                }
            ],
            "characters": players
        }

        answer = {'session': session, 'playdata': playdata}
        print(answer)
        return jsonify(answer)

    except Error as e:
        print("Error reading data from MySQL table", e)

    finally:
        if (connection.is_connected()):
            connection.close()
            cursor.close()
        print("MySQL connection is closed")


def news(data):

    answer = []

    return jsonify(answer)


@app.route('/login.php',  methods=['GET', 'POST', 'PUT'])
def action():

    data = request.get_json()
    print(data)

    if(data['type'] == 'cacheinfo'):
        return jsonify({
                'playersonline': 5,
                'twitchstreams': 0,
                'twitchviewer': 0,
                'gamingyoutubestreams': 0,
                'gamingyoutubeviewer': 0
        })
    if(data['type'] == 'news'):
        return jsonify({})

    # The client has a cache of the events on it so it will ask for the events only when it see that last sync was made some time X ago
    if(data['type'] == 'eventschedule'):
        return jsonify({
            'lastupdatetimestamp': time.time(),
            'eventlist': [
                {
                    'startdate': int(time.time()),
                    'enddate': int(time.time()) + 36600 * 20,
                    'colorlight': '#64162b',
                    'colordark': '#7a1b34',
                    'name': 'First Event',
                    'description': 'Canary Event 1',
                    'isseasonal': False
                },
                {
                    'startdate': int(time.time()),
                    'enddate': int(time.time()) + 36600 * 20,
                    'colorlight': '#8B6D05',
                    'colordark': '#735D10',
                    'name': 'Second Event',
                    'description': 'Canary Event 2',
                    'isseasonal': False
                }
            ]
        })

    if(data['type'] == 'boostedcreature'):
        return jsonify({
                'boostedcreature': True,
                'raceid': 39
        })

    if(data['type'] == 'login'):
        return do_login(data)


    if(data['type'] == 'news'):
        return news(data)

app.run(debug=True, host='0.0.0.0', port=8080)
