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
            (current_dir_1, subdirs_1, files_1) = next(walker_1)
            for subdir_1 in subdirs_1:
                key = '\\f ' + subdir_1
                self.dictionary[key] = [["st", "noice", os.path.join(current_dir_1, subdir_1)]]

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

class TOP():
    def guess_id(name):
        script_directory = os.path.dirname(os.path.realpath(__file__))
        partners = json.load(open(os.path.join(script_directory, "partners.json")))
        partners = { v: k for k, v in partners.items() }
        if name in partners:
            return partners[name]
        else:
            close_matches = difflib.get_close_matches(name, partners, 1)
            if close_matches:
                return partners[close_matches[0]]
        return None


@attr.s
class Menu():
    web = sh.x_www_browser.bake("--new-window")
    top_prefixes = {
        '\\campman': "https://top.criteo.com/app/#/CampaignManager/partner/{partner_id}",
        '\\banman': "https://top.criteo.com/app/#/DynamicBannersManager/partner/{partner_id}",
        '\\trackman': "https://top.criteo.com/app/#/DynamicTsManager/partner/{partner_id}",
        '\\partnerinfo': "https://top.criteo.com/app/#/PartnerEdit/partner/{partner_id}",
        '\\taggen': "https://top.criteo.com/app/#/TagGenerator/partner/{partner_id}",
        '\\extradata': "https://top.criteo.com/app/#/ExtraSegmentation/partner/{partner_id}",
        '\\recoconfig': "https://top.criteo.com/app/#/RecoFilter/partner/{partner_id}",
        '\\eventlogs': "https://top.criteo.com/app/#/EventLogs/partner/{partner_id}",
        '\\catconf': "https://top.criteo.com/app/#/CatalogImport/partner/{partner_id}",
        '\\catmon': "https://top.criteo.com/app/#/CatalogMonitoring/partner/{partner_id}",
        '\\catov': "https://top.criteo.com/app/#/CatalogOverview/partner/{partner_id}",
        '\\customhtml': "https://top.criteo.com/app/#/CampaignCustomHtml/partner/{partner_id}",
        '\\abtest': "https://top.criteo.com/app/#/ABTests/partner/{partner_id}",
        "\\jira": "https://jira.criteois.com/browse/WCA-326?jql=text%20~%20%22{query}%22%20ORDER%20BY%20updated%20DESC",
        "\\tableau": [
                "https://tableau.criteois.com/#/site/americas/views?search={query}", 
                "https://tableau.criteois.com/#/site/global/views?search={query}",
        ],
        "\\confluence": "https://confluence.criteois.com/dosearchsite.action?queryString={query}",
    }
    def launch(self, dictionary):
        keys = dictionary.keys()
        stdin = "\n".join(keys).encode('utf-8')
        output = sh.dmenu("-i", "-f", "-fn", "Inconsolata-14", _in=stdin).stdout
        text = output.decode('utf-8').strip('\n')
        for prefix, url in self.top_prefixes.items():
            if text.startswith(prefix):
                name = text.replace(prefix+' ', '')
                if type(url) is list:
                    for u in url:
                        u = u.format(partner_id=TOP.guess_id(name), query=name)
                        self.web(u)
                else:
                    url = url.format(partner_id=TOP.guess_id(name), query=name)
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
