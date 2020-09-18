#!/usr/bin/python3
import sh
import json
from collections import Counter
from multiprocessing import Process


lines = 56
columns = 41
letters = 4
separator = ' '
outline = 1
shadow = 1
color = 'white'
outline_color = 'black'
delay = 30
size = 12
font = f"-*-*-bold-*-*-*-{size}-120-*-*-*-*-*-*"
# xdotool getmouselocation
last_word_mouse_location = {"x":1425, "y":889}
first_word_mouse_location = {"x":24, "y":8}
line_spacing = (last_word_mouse_location['y'] - first_word_mouse_location['y'])/(lines-1)
column_spacing = (last_word_mouse_location['x'] - first_word_mouse_location['x'])/(columns-1)
char_distance = column_spacing/(letters+len(separator))
command_file_path = '/tmp/gridclick_last_command'
text_file_path = '/tmp/gridclick_last_grid'


def show(text, delay):
    osd_cat = sh.osd_cat.bake(lines=lines, color=color, outline=outline,
        outlinecolour=outline_color,
        shadow=shadow, delay=delay, wait=False, font=font)
    osd_cat(sh.echo(text))

import asyncio

def show_grid(text, delay):
    text = '\n'+'\n'.join(text.split('\n')[1:])
    try:
        show(text, delay)
    except sh.SignalException_SIGTERM as e:
        pass

def show_lines(delay):
    show('\n'.join(str(x) for x in range(1,lines+1)), delay)

def show_columns(delay):
    show(separator.join(f"{x:04d}" for x in range(1,columns+1)), delay)

def find_coordinates(keys, text):
    for line_number, line in enumerate(text.split('\n')):
        for column_number, word in enumerate(line.split()):
            if word in keys:
                x_offset = 0
                y_offset = 0
                if len(keys) >= 5:
                    # 5th element specifies the letter
                    specified_letter = word.find(keys[4])
                    if specified_letter == 0:
                        x_offset = -1.5*char_distance
                    elif specified_letter == 1:
                        x_offset = -0.5*char_distance
                    elif specified_letter == 2:
                        x_offset = 0.5*char_distance
                    elif specified_letter == 3:
                        x_offset = 1.5*char_distance
                for i in range(5, len(keys)):
                    mod = keys[i]
                    if mod == 't':
                        # top
                        y_offset = -line_spacing/2
                    elif mod == 'b':
                        # bottom
                        y_offset = line_spacing/2
                    elif mod == 'r':
                        # right
                        x_offset += char_distance
                    elif mod == 'l':
                        # left
                        x_offset -= char_distance
                    elif mod == 'n':
                        # next:
                        # click location is in the empty space
                        # next to the end or start letter of the word
                        if specified_letter == 0:
                            # start letter > left
                            x_offset -= char_distance
                        if specified_letter == 3:
                            # end letter > right
                            x_offset += char_distance
                return column_number, line_number, x_offset, y_offset

import click
import time

@click.command()
@click.option('--click-mode', type=click.Choice(['single', 'multiple'], case_sensitive=False), default='single')
def main(click_mode):
    words = json.load(open('/home/ANT.AMAZON.COM/frapil/linux-tweaks/mouse/words_dictionary.json', 'r'))
    short_words = set()
    for word in words:
        if len(word) == letters and all(x == 1 for x in Counter(word).values()):
            short_words.add(word)
    text = "\n".join(separator.join(short_words.pop() for _ in range(columns)) for _ in range(lines))
    p = Process(target=show_grid, args=(text, delay,))
    p.start()
    if click_mode == 'single':
        try:
            command = str(sh.dmenu(sh.echo())).strip()
        except sh.ErrorReturnCode_1 as e:
            command = ''
        p.terminate()
        try:
            sh.killall('osd_cat')
        except sh.ErrorReturnCode_1 as e:
            pass
        if command:
            if command == '.':
                with open(command_file_path, 'r') as command_file:
                    command = command_file.read()
                with open(text_file_path, 'r') as text_file:
                    text = text_file.read()
            for keys in command.split():
                if keys == 'r': #reload
                    main()
                    return
                print('Looking for', keys)
                action = "click"
                if ',' in keys:
                    # Hold
                    action = "mousedown"
                if '.' in keys:
                    # Release
                    action = "mouseup"
                button_id = 1
                if ']' in keys and '[' in keys:
                    # Middle click
                    button_id = 2
                elif ']' in keys:
                    # Right click
                    button_id = 3
                elif '{' in keys:
                    # Wheel up
                    button_id = 4
                elif '}' in keys:
                    # Wheel down
                    button_id = 5
                keys = keys.replace(',', '')
                keys = keys.replace('.', '')
                keys = keys.replace('[', '')
                keys = keys.replace(']', '')
                keys = keys.replace('{', '')
                keys = keys.replace('}', '')
                try:
                    column_number, line_number, x_offset, y_offset = find_coordinates(keys, text)
                except TypeError:
                    print(keys, 'no found')
                    continue
                x_coordinate = first_word_mouse_location['x'] + column_number*column_spacing
                y_coordinate = first_word_mouse_location['y'] + line_number*line_spacing
                x_coordinate += x_offset
                y_coordinate += y_offset
                digits = list(filter(str.isdigit, keys))
                if digits:
                    number = int(''.join(digits))
                else:
                    number = 1
                print('Clicking', 'x:', x_coordinate, 'y:', y_coordinate, 'times:', number)
                for _ in range(number):
                    sh.xdotool("mousemove", x_coordinate, y_coordinate, action, button_id)
                    time.sleep(0.1)
            with open(command_file_path, 'w') as command_file:
                command_file.write(command)
            with open(text_file_path, 'w') as text_file:
                text_file.write(text)


if __name__ == '__main__':
    main()
