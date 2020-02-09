#!/bin/bash

if [ `id -u` -ge 10000 ]; then
    echo "fixing passwd file..."
    cat /etc/passwd | sed -e "s/^coder:/builder:/" > /tmp/passwd
    echo "coder:x:`id -u`:`id -g`:,,,:/home/coder:/usr/bin/zsh" >> /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi
echo "starting code server..."
dumb-init code-server --host 0.0.0.0