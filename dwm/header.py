#!/usr/bin/python3
import sh
import time
import sched, time

s = sched.scheduler(time.time, time.sleep)

def render():
    try:
        header = "{} -- {}, checked {}s ago -- {}".format(
            datetime,
            connection,
            round(time.time() - connection_checked),
            battery)
        print('Refreshing header...')
        sh.xsetroot('-name', header)
    except NameError:
        pass

def update_connection():
    global connection
    global connection_checked
    connection_checked = time.time()
    try:
        sh.ping('8.8.8.8', c=1, W=1)
    except ErrorReturnCode:
        connection = "Disconnected"
    else:
        connection = "Connected"
    render()
    s.enter(9, 1, update_connection)

def update_battery():
    global battery
    battery = sh.acpi('-b')
    battery = battery.split(':', 1)[1]
    battery = battery.rsplit(',', 1)[0]
    battery = battery.strip()
    render()
    s.enter(0.1, 1, update_battery)

def update_datetime():
    global datetime
    datetime = time.strftime("%Y-%m-%d %H:%M, %A")
    render()
    s.enter(0.1, 1, update_datetime)

def update_git_reminder():
    global git_reminder
    walker_0 = os.walk('~/dev')
    (current_dir_0, subdirs_0, files_0) = next(walker_0)
    for subdir_0 in subdirs_0:
        sh.git.status(_cwd=subdir_0)
    render()
    s.enter(30, 1, update_datetime)
    

if __name__ == '__main__':
    update_connection()
    update_battery()
    update_datetime()
    update_git_reminder()
    s.run()
