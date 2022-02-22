#!/usr/bin/python3
import subprocess
import os
import pickle
import collections
import json
import difflib
import sh
import attr
import yaml
#from ruamel import yaml
from pathlib import Path

from prefixes import prefixes


class Dictionary():
    def __init__(self, filepath, bookmarks, home_folder='~'):
        self.filepath = filepath
        self.home_folder = home_folder
        self.dictionary = collections.OrderedDict()
        self.bookmarks = bookmarks
        self.load()

    def keys(self):
        keys = [x for x in self.dictionary]
        return keys

    def commands(self, key):
        commands = self.dictionary[key]
        return commands

    def load(self):
        try:
            with open(self.filepath, 'rb') as f:
                self.dictionary = pickle.load(f)
        except FileNotFoundError:
            self.update()

    def save(self):
        with open(self.filepath, 'wb') as f:
            pickle.dump(self.dictionary, f)

    def update(self):
        self.dictionary = collections.OrderedDict()
        # self.update_bookmarks()
        self.update_commands()
        # self.update_folders()
        self.update_templates()
        self.save()

    def update_bookmarks(self):
        # Prepare the list of bookmarks
        script_directory = os.path.dirname(os.path.realpath(__file__))
        bookmarks = yaml.safe_load(open(os.path.join(script_directory, self.bookmarks)))
        for name in bookmarks:
            key = '\\bookmark ' + name
            self.dictionary[key] = [["x-www-browser", "--app="+bookmarks[name]]]

    def update_commands(self):
        # Prepare the list of commands
        compgen = subprocess.Popen( ["compgen -c"], executable='/bin/bash', shell=True, stdout=subprocess.PIPE)
        output, errors = compgen.communicate()
        commands = output.decode('utf8').splitlines()
        for command in commands:
            key = '\\exec ' + command
            self.dictionary[key] = [[command]]

    def update_templates(self):
        # Prepare the list of templates
        script_directory = os.path.dirname(os.path.realpath(__file__))
        templates = yaml.safe_load(open(os.path.join(script_directory, 'templates.yml')))
        for keyword, snippet in templates.items():
            key = '\\template ' + keyword
            self.dictionary[key] = [['xdotool', 'type', snippet]]

    #def update_folders(self):
    #    # Prepare the list of folders
    #    folders = [x[0] for x in os.walk(self.home_folder)]
    #    for folder in folder_names:
    #        key = '\\f ' + folder.split('/')[-1]
    #        self.dictionary[key] = [["xfe", folder]]
    def update_folders(self):
        # Prepare the list of folders
        key = '\\folder ' + self.home_folder
        self.dictionary[key] = [["st", "noice", self.home_folder]]
        walker_0 = os.walk(self.home_folder)
        (current_dir_0, subdirs_0, files_0) = next(walker_0)
        for subdir_0 in subdirs_0:
            key = '\\folder ' + subdir_0
            self.dictionary[key] = [["st", "noice", os.path.join(current_dir_0, subdir_0)]]
            walker_1 = os.walk(os.path.join(current_dir_0, subdir_0))
            try:
                (current_dir_1, subdirs_1, files_1) = next(walker_1)
                for subdir_1 in subdirs_1:
                    key = '\\folder ' + subdir_1
                    self.dictionary[key] = [["st", "noice", os.path.join(current_dir_1, subdir_1)]]
            except StopIteration:
                pass

    def reorder(self, key):
        self.dictionary.move_to_end(key, last=False)
        self.save()

@attr.s
class Menu():
    def web(self, text):
        sh.x_www_browser.bake("--new-window", text, _bg=True)
    def web_app_mode(self, text):
        sh.x_www_browser(app=text, _bg=True)
    def web_app_mode_mitm(self, text):
        sh.x_www_browser(
            "--auto-open-devtools-for-tabs",
            text,
            proxy_server="localhost:8080",
            user_data_dir=str(Path.home())+"/.config/google-chrome-mitm",
            _bg=True)
    prefixes = prefixes
    def launch(self, dictionary):
        keys = dictionary.keys()
        stdin = "\n".join(keys).encode('utf-8')
        output = sh.dmenu("-i", "-f", "-fn", "Inconsolata-14", _in=stdin).stdout
        text = output.decode('utf-8').strip('\n')
        for prefix, url in self.prefixes.items():
            if text.startswith(prefix):
                if len(text) <= len(prefix) + 1:
                    name = sh.xclip('-o')
                else:
                    name = text.replace(prefix+' ', '')
                if type(url) is list:
                    for u in url:
                        u = u.format(query=name)
                        self.web_app_mode(u)
                else:
                    url = url.format(query=name)
                    self.web_app_mode(url)
                break
        else:
            if text.startswith("\\update"):
                dictionary.update()
            elif text.startswith('\\') and not text.startswith('\\g') and not text.startswith('\\m'):
                commands = dictionary.commands(text)
                for command in commands:
                    dictionary.reorder(text)
                    subprocess.call(command)
            elif text.startswith("\\m http"):
                self.web_app_mode_mitm(text.replace('\\m ', ''))
            elif text.startswith('\\m'):
                self.web_app_mode_mitm("https://www.google.com/search?q="+text.replace('\\m ', ''))
            elif '\\g' not in text and text.startswith("http"):
                self.web_app_mode(text)
            #elif text:
            #    self.web_app_mode("https://www.google.com/search?q="+text.replace('\\g ', ''))


def main():
    home_folder = str(Path.home())
    dictionary_filepath = home_folder+'/.customlauncher_dictionary.pickle'
    bookmarks_filepath = home_folder+'/mybookmarks/bookmarks.yml'
    dictionary = Dictionary(dictionary_filepath, bookmarks_filepath, home_folder=home_folder)
    menu = Menu()
    menu.launch(dictionary)

main()
