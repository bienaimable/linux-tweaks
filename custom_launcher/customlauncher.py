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
        self.update_bookmarks()
        self.update_commands()
        self.update_folders()
        self.update_templates()
        self.save()

    def update_bookmarks(self):
        # Prepare the list of bookmarks
        script_directory = os.path.dirname(os.path.realpath(__file__))
        bookmarks = yaml.load(open(os.path.join(script_directory, self.bookmarks)))
        for name in bookmarks:
            key = '\\b ' + name
            self.dictionary[key] = [["x-www-browser", "--new-window", bookmarks[name]]]

    def update_commands(self):
        # Prepare the list of commands
        compgen = subprocess.Popen( ["compgen -c"], executable='/bin/bash', shell=True, stdout=subprocess.PIPE)
        output, errors = compgen.communicate()
        commands = output.decode('utf8').splitlines()
        for command in commands:
            key = '\\s ' + command
            self.dictionary[key] = [[command]]

    def update_templates(self):
        # Prepare the list of templates
        templates = {
            'gdpr2': "window.__tcfapi('getTCData', 2, (tcData, success) => { if(success) { prompt('TC Data:', tcData.tcString); console.log('TC Data:', tcData) } else { prompt('Error:', tcData.tcString); console.log('Error:', tcData) } });",
            'debug': "&amzn_debug_mode=1",
            'token': "&testToken=7snvCunWohswq2jh",
            'gdpr': "window.__cmp('getConsentData',null,function(data){prompt('Consent String : ',data.consentData)})",
            'fetchbids': """apstag.fetchBids({ slots: [ { slotID: "div-gpt-123", sizes: [[300,250], [300,600]] }, { slotID: "div-gpt-234", sizes: [[160, 600]] }, { slotID: "videoSlot", mediaType: 'video' } ], timeout: 2e3 }, bids => console.log(bids)); """,
            'googleconsole': "googletag.openConsole()",
            'getconsent': """window.__cmp('getVendorConsents', null, function(result) { console.log(JSON.stringify(result, null, 2)); });""",
            'ooo message': """==========
When notifying your coworkers of your absence:
- Add both your first name (or full name if confusion is possible) and the type of event as the title of the invite
- Add only relevant teams and people as attendees
- Check your End date (it is inclusive in Outlook)
- Set Duration: All day so the invite shows up as a header in the calendar
- Set Reminder: None
- Set Show As: Free to avoid blocking your colleague's calendar
- Uncheck Request responses
- Paste this message in the body of your invite for others to use""",
        }
        for keyword, snippet in templates.items():
            key = '\\t ' + keyword
            self.dictionary[key] = [['xdotool', 'type', snippet]]

    #def update_folders(self):
    #    # Prepare the list of folders
    #    folders = [x[0] for x in os.walk(self.home_folder)]
    #    for folder in folder_names:
    #        key = '\\f ' + folder.split('/')[-1]
    #        self.dictionary[key] = [["xfe", folder]]
    def update_folders(self):
        # Prepare the list of folders
        key = '\\f ' + self.home_folder
        self.dictionary[key] = [["st", "noice", self.home_folder]]
        walker_0 = os.walk(self.home_folder)
        (current_dir_0, subdirs_0, files_0) = next(walker_0)
        for subdir_0 in subdirs_0:
            key = '\\f ' + subdir_0
            self.dictionary[key] = [["st", "noice", os.path.join(current_dir_0, subdir_0)]]
            walker_1 = os.walk(os.path.join(current_dir_0, subdir_0))
            try:
                (current_dir_1, subdirs_1, files_1) = next(walker_1)
                for subdir_1 in subdirs_1:
                    key = '\\f ' + subdir_1
                    self.dictionary[key] = [["st", "noice", os.path.join(current_dir_1, subdir_1)]]
            except StopIteration:
                pass

    #def update_multiscreen(self):
    #    key = '\\m multiscreen'
    #    command = [
    #        ["/home/user/criteo/dev/dwm_tools/setdate.sh"],
    #        ["xrandr", "--output", "VGA-0", "--auto", "--left-of", "VGA-1"],
    #        ["xrandr", "--output", "VGA-2", "--auto", "--right-of", "VGA-1"],
    #        ["feh", "--bg-fill", "/home/user/criteo/images/wallpaper.jpg"],
    #    ]
    #    self.dictionary[key] = command

    def reorder(self, key):
        self.dictionary.move_to_end(key, last=False)
        self.save()

@attr.s
class Menu():
    web = sh.x_www_browser.bake("--new-window")
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
                        self.web(u)
                else:
                    url = url.format(query=name)
                    self.web(url)
                break
        else:
            if text.startswith("\\update"):
                dictionary.update()
            elif text.startswith('\\') and not text.startswith('\\g'):
                commands = dictionary.commands(text)
                for command in commands:
                    dictionary.reorder(text)
                    subprocess.call(command)
            elif '\\g' not in text and (text.startswith("www") or text.startswith("http") or text.endswith('.com')):
                self.web(text)
            elif text:
                self.web("https://www.google.com/search?q="+text.replace('\\g ', ''))

def main():
    home_folder = str(Path.home())
    dictionary_filepath = home_folder+'/.customlauncher_dictionary.pickle'
    bookmarks_filepath = home_folder+'/mybookmarks/bookmarks.yml'
    dictionary = Dictionary(dictionary_filepath, bookmarks_filepath, home_folder=home_folder)
    menu = Menu()
    menu.launch(dictionary)

main()
