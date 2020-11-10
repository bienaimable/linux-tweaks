#!/usr/bin/python3
import sh
import time
import sched
import os
from datetime import datetime

s = sched.scheduler(time.time, time.sleep)

def render():
    try:
        last_checked = round((time.time() - connection_checked +1)/5)
        dots = "."*(last_checked)+" "*(3-last_checked)
        header = f"{git_reminder} [{connection}{dots}] [{battery}] {timedate}"
        sh.xsetroot('-name', header)
    except NameError:
        pass

def update_connection():
    global connection
    global connection_checked
    connection_checked = time.time()
    try:
        sh.ping('8.8.8.8', c=1, W=1)
    except sh.ErrorReturnCode:
        connection = "Disconnected"
    else:
        connection = "Connected"
    s.enter(15, 1, update_connection)

def update_battery():
    global battery
    battery = sh.acpi('-b')
    battery = battery.split(':', 1)[1]
    battery = battery.rsplit(',', 1)[0]
    battery = battery.strip()
    s.enter(5, 1, update_battery)

def update_datetime():
    global timedate
    now = datetime.now()
    timedate = now.strftime("[%A, %Y-%m-%d] [%H:%M] ")
    s.enter(2, 1, update_datetime)

def update_git_reminder():
    global git_reminder
    git_reminder = ""
    folders = ['~/dev', '~/linux-tweaks', '~/mybookmarks', '~/vimwiki']
    for folder in folders:
        folder = os.path.expanduser(folder)
        walker_0 = os.walk(folder)
        (current_dir_0, subdirs_0, files_0) = next(walker_0)
        for subdir_0 in subdirs_0:
            if subdir_0.startswith('.') or "_nosave" in subdir_0:
                continue
            workdir = os.path.join(folder, subdir_0)
            try:
                status = sh.git.status(_cwd=workdir)
            except sh.ErrorReturnCode:
                git_reminder = "[{} not saved]".format(subdir_0)
                break
            if "Changes not staged" in status \
            or "Changes to be committed" in status \
            or "Untracked files" in status \
            or "Your branch is ahead" in status:
                git_reminder = "[{} not saved]".format(subdir_0)
                break
    s.enter(30, 1, update_git_reminder)

def update_ntp_time():
    """
    This requires adding the following line at the bottom of the sudoers file
    by using the 'sudo visudo' command:
    yourusername ALL=(root) NOPASSWD: /usr/sbin/ntpdate
    """
    try:
        sh.sudo.ntpdate("-u", "1.ro.pool.ntp.org")
    except:
        pass
    s.enter(60, 1, update_ntp_time)


def loop():
    render()
    s.enter(2, 1, loop)


if __name__ == '__main__':
    update_connection()
    update_battery()
    update_datetime()
    update_git_reminder()
    update_ntp_time()
    loop()
    s.run()
