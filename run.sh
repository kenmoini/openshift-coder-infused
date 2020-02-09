#!/bin/bash

if [ `id -u` -ge 10000 ]; then
    echo "fixing passwd file..."
    #cat /etc/passwd | sed -e "s/^coder:/builder:/" > /tmp/passwd
    #cat /etc/passwd | sed -e "s/^coder:/#oldcoder:/" > /tmp/passwd
    #echo "coder:x:`id -u`:`id -g`:,,,:/home/coder:/usr/bin/zsh" >> /tmp/passwd
    cat /etc/passwd | sed -e "s;^coder:x:1000:1000:;coder:x:`id -u`:`id -g`:;" > /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
    cp -R /opt/home_skel/.local /home/coder
    cp -R /opt/home_skel/.oh-my-zsh /home/coder
    cp /opt/home_skel/.bashrc /home/coder
    cp /opt/home_skel/.bash_profile /home/coder
    cp /opt/home_skel/.zshrc /home/coder
    chown -R coder /home/coder
    export HOME="/home/coder"
fi
echo "starting code server..."
dumb-init code-server --host 0.0.0.0