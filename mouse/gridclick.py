#!/usr/bin/env python3

import Xlib
from Xlib import display, X # X is also needed
import sh
import json
from collections import Counter
from multiprocessing import Process
import re
import time
import click
import yaml
from os.path import expanduser
from itertools import combinations



columns = 41
letters = 4
separator = ' '
size = 12
left_margin = 1
command_file_path = '/tmp/gridclick_last_command'
text_file_path = '/tmp/gridclick_last_grid'

def get_mouse_location():
    pattern = r"x:(?P<x>[0-9]*) y:(?P<y>[0-9]*) screen:(?P<screen>[0-9]*) window:(?P<window>[0-9]*)"
    output =  str(sh.xdotool.getmouselocation())
    matches = re.match(pattern, output)
    return float(matches.group('x')), float(matches.group('y'))

def draw_it(window, gc, display, text, x_offset=0, y_offset=0):
    height = size
    for line in text.split('\n'):
        window.draw_text(gc, left_margin+x_offset, height+y_offset, line.encode('utf-8'))
        height = height + size*2
    display.flush()

def draw_outline(window, gc, display, text, offset=0):
    height = size
    for line in text.split('\n'):
        for x in range(-offset, offset+1):
            for y in range(-offset, offset+1):
                if x or y:
                    window.draw_text(gc, left_margin+x, height+y, line.encode('utf-8'))
        height = height + size*2
    display.flush()

def show(text):
    display = Xlib.display.Display()
    screen = display.screen()
    root = screen.root
    ov = root.composite_get_overlay_window().overlay_window
    ov.change_attributes(event_mask=X.ExposureMask)  # "adds" this event mask
    gc = ov.create_gc(background = screen.white_pixel,
                      foreground = screen.black_pixel)
    colormap = screen.default_colormap
    # (r,g,b) blue = (0,0,65535)
    color = colormap.alloc_color(0, 0, 65535)
    color2 = colormap.alloc_color(0, 65535, 0)
    # Xor it because we'll draw with X.GXxor function
    xor_color = color.pixel ^ 0xffffff
    xor_color2 = color.pixel ^ 0xffffff
    gc = ov.create_gc(
            line_width = 4,
            line_style = X.LineSolid,
            fill_style = X.FillOpaqueStippled,
            fill_rule  = X.WindingRule,
            #cap_style  = X.CapButt,
            #join_style = X.JoinMiter,
            foreground = screen.white_pixel,
            background = screen.black_pixel,
            #function = X.GXxor,
            #graphics_exposures = False,
            #subwindow_mode = X.IncludeInferiors,
            )
    gc2 = ov.create_gc(
            line_width = 4,
            line_style = X.LineSolid,
            fill_style = X.FillOpaqueStippled,
            fill_rule  = X.WindingRule,
            #cap_style  = X.CapButt,
            #join_style = X.JoinMiter,
            foreground = screen.black_pixel,
            background = screen.white_pixel,
            #function = X.GXxor,
            #graphics_exposures = False,
            #subwindow_mode = X.IncludeInferiors,
            )
    # See values here: https://tronche.com/gui/x/xlib/GC/manipulating.html#XGCValues
    draw_outline(ov, gc2, display, text, offset=2)
    draw_it(ov, gc, display, text)
    while True:
        if display.pending_events() != 0:  # check to safely apply next_event
            event = display.next_event()
            if event.type == X.Expose and event.count == 0:
                draw_outline(ov, gc2, display, text, offset=1)
                draw_it(ov, gc, display, text)

def show_grid(text):
    text = '\n'.join(text.split('\n'))
    try:
        show(text)
    except sh.SignalException_SIGTERM as e:
        pass

def show_lines(lines):
    show('\n'.join(str(x) for x in range(1,lines+1)))

def show_columns(columns):
    show(separator.join(f"{x:04d}" for x in range(1,columns+1)))

def show_cursor(lines, columns):
    text = '\n'*(lines-1)+'     '*(columns-1)+' >< '
    try:
        show(text)
    except sh.SignalException_SIGTERM as e:
        pass

def find_coordinates(keys, text, line_spacing, column_spacing, char_distance):
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


@click.command()
#@click.option('--click-mode', type=click.Choice(['single', 'multiple'], case_sensitive=False), default='single')
@click.option('--setup', is_flag=True)
def main(setup):
    if setup:
        click.prompt("Let's take note of the last fully visible line number on the screen", default='Enter', prompt_suffix='', show_default=True)
        p = Process(target=show_lines, args=(100,))
        p.start()
        try:
            command = str(sh.dmenu(sh.echo())).strip()
        except sh.ErrorReturnCode_1 as e:
            command = ''
        p.terminate()
        lines = click.prompt("Provide the last fully visible number", type=int)

        click.prompt("Let's take note of the last fully visible column number on the screen", default='Enter', prompt_suffix='', show_default=True)
        p = Process(target=show_columns, args=(100,))
        p.start()
        try:
            command = str(sh.dmenu(sh.echo())).strip()
        except sh.ErrorReturnCode_1 as e:
            command = ''
        p.terminate()
        columns = click.prompt("Provide the last fully visible number", type=int)

        click.prompt("Let's place the mouse cursor on the x at the bottom right", default='Enter', prompt_suffix='', show_default=True)
        p = Process(target=show_cursor, args=(lines, columns,))
        p.start()
        try:
            command = str(sh.dmenu(sh.echo())).strip()
        except sh.ErrorReturnCode_1 as e:
            command = ''
        p.terminate()
        last_word_mouse_location = get_mouse_location()

        click.prompt("Let's place the mouse cursor on the x at the top left", default='Enter', prompt_suffix='', show_default=True)
        p = Process(target=show_cursor, args=(0, 0,))
        p.start()
        try:
            command = str(sh.dmenu(sh.echo())).strip()
        except sh.ErrorReturnCode_1 as e:
            command = ''
        p.terminate()
        first_word_mouse_location = get_mouse_location()
        with open(expanduser('~/.config/gridclick'), 'w') as conf_file:
            conf_file.write(
                yaml.dump({
                    'lines': lines,
                    'columns': columns,
                    'first_word_mouse_location': first_word_mouse_location,
                    'last_word_mouse_location': last_word_mouse_location,
                })
            )
        return
    configuration = yaml.full_load(open(expanduser('~/.config/gridclick'), 'r'))
    last_word_mouse_location = configuration['last_word_mouse_location']
    first_word_mouse_location = configuration['first_word_mouse_location']
    lines = configuration['lines']
    columns = configuration['columns']
    line_spacing = (last_word_mouse_location[1] - first_word_mouse_location[1])/(lines - 1)
    column_spacing = (last_word_mouse_location[0] - first_word_mouse_location[0])/(columns - 1)
    char_distance = column_spacing/(letters+len(separator))

    #words = json.load(open('/home/ANT.AMAZON.COM/frapil/linux-tweaks/mouse/words_dictionary.json', 'r'))
    #short_words = set()
    #for word in words:
    #    if len(word) == letters and all(x == 1 for x in Counter(word).values()):
    #        short_words.add(word)
    characters = 'ashtgyneoicldrwfup'
    short_words = set(''.join(x) for x in combinations(list(characters), letters))
    text = "\n".join(separator.join(short_words.pop() for _ in range(configuration['columns'])) for _ in range(configuration['lines']))
    p = Process(target=show_grid, args=(text,))
    p.start()
    try:
        command = str(sh.dmenu(sh.echo())).strip()
    except sh.ErrorReturnCode_1 as e:
        command = ''
    p.terminate()
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
                column_number, line_number, x_offset, y_offset = find_coordinates(keys, text, line_spacing, column_spacing, char_distance)
            except TypeError:
                print(keys, 'no found')
                continue
            x_coordinate = first_word_mouse_location[0] + column_number*column_spacing
            y_coordinate = first_word_mouse_location[1] + line_number*line_spacing
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
