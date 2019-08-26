# -*- coding: utf-8 -*-

import json
import os
import sys


DEFAULT_LOG_PATH = '.local/share/godot/app_userdata/pongasaservice/logs/log.txt'
STATISTICS = {}
ACTIVE_PLAYERS = 0


def set_min(player, ping):
    if ping < STATISTICS[player]['min']:
        STATISTICS[player]['min'] = ping


def set_mean(player, ping):
    STATISTICS[player]['mean_count'] += 1
    STATISTICS[player]['mean_sum'] += ping


def set_max(player, ping):
    if ping > STATISTICS[player]['max']:
        STATISTICS[player]['max'] = ping


def analyze_line(line):
    global ACTIVE_PLAYERS
    if 'PCONN' in line:
        p_id = line.split('-')[2].strip()
        STATISTICS[p_id] = {
            'min': 999999999,
            'mean_sum': 0,
            'mean_count': 0,
            'mean': None,
            'max': 0,
            'active': True
        }
        ACTIVE_PLAYERS += 1

    elif 'PDCONN' in line:
        p_id = line.split('-')[2].strip()
        player = STATISTICS.get(p_id, None)
        if player and player['active']:
                STATISTICS[p_id]['active'] = False
                ACTIVE_PLAYERS -= 1

    if ACTIVE_PLAYERS >= 2:
        if 'STAT' in line:
            ping = None
            player = None
            line_parts = line.split(':')
            try:
                ping = int(line_parts[-1].rstrip('\n'))
                player = line_parts[-3].strip()
            except ex:
                pass
            if ping and player:
                set_min(player, ping)
                set_mean(player, ping)
                set_max(player, ping)


def _adjust_mean(player):
    if STATISTICS[player]['mean_count'] > 0:
        STATISTICS[player]['mean'] = STATISTICS[player]['mean_sum'] / STATISTICS[player]['mean_count']


def get_log_statistics(filepath):
    with open(filepath, 'r') as log_file:
        for line in log_file:
            analyze_line(line)
    for player in STATISTICS.keys():
        _adjust_mean(player)


if __name__ == '__main__':
    try:
        filepath = sys.argv[1]
    except IndexError:
        print('No file path. Using default...')
        home = os.path.expanduser('~')
        filepath = '/'.join([home, DEFAULT_LOG_PATH])
        print('Default path: {}'.format(filepath))
    except Exception as ex:
        print(ex)
        raise

    if not os.path.exists(filepath):
        print('No file under the file path: {}'.format(filepath))
    else:
        print('File found. Analyzing...')
        get_log_statistics(filepath)
        print('\nStatistics:\n{}'.format(json.dumps(STATISTICS, indent=4, sort_keys=True)))

