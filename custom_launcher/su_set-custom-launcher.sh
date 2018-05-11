#!/bin/bash

apt-get install python3-pip
pip3 install -r ../tools/requirements.txt
touch /usr/bin/customlauncher
cat >/usr/bin/customlauncher <<EOL
#!/bin/bash
python3 $(pwd)/../tools/customlauncher.py
EOL
chmod a+x /usr/bin/customlauncher
