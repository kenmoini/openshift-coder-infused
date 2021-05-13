FROM codercom/code-server:latest

USER root

ENV cacheBusta=42

LABEL io.k8s.display-name="Workshop IDE" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,coder,ide,vscode,workshop" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# Install OpenShift clients.

RUN curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz kubectl && \
    rm /tmp/oc.tar.gz

RUN curl -sL -o /tmp/odo.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/odo/v1.2.6/odo-linux-amd64.tar.gz && \
    tar -C /usr/local/bin -xf /tmp/odo.tar.gz && \
    chmod +x /usr/local/bin/odo && \
    rm /tmp/odo.tar.gz

ENV cacheBustaMid=2

RUN curl -O https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz && \
    tar -xvf go1.13.7.linux-amd64.tar.gz && \
    mv go /usr/local

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y jq tmux software-properties-common nano && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip python3-pip default-jre default-jdk maven build-essential python3-dev python-dev python3-winrm nodejs zsh gcc g++ make yarn zip unzip php-cli php-zip php-xml php-gd php-opcache php-mbstring && \
    DEBIAN_FRONTEND=noninteractive python -m pip install ansible && \
    DEBIAN_FRONTEND=noninteractive python -m pip install paramiko && \
    rm -rf /var/lib/apt/lists/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# Install fonts for root user
RUN git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts/ && \
    pip3 install thefuck && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    mkdir /opt/home_skel && chmod 777 /opt/home_skel

ENV LC_ALL=en_US.UTF-8 \
	SHELL=/bin/zsh

USER coder

ENV LC_ALL=en_US.UTF-8 \
	SHELL=/bin/zsh \
    HOME=/home/coder

RUN git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts/ && \
    pip3 install thefuck && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    cp -R /home/coder/.local /opt/home_skel && \
    cp -R /home/coder/.oh-my-zsh /opt/home_skel && \
    cp /home/coder/.bashrc /opt/home_skel

COPY config/zshrc /home/coder/.zshrc
COPY config/zshrc /opt/home_skel/.zshrc
COPY config/bash_profile /home/coder/.bash_profile
COPY config/bash_profile /opt/home_skel/.bash_profile
COPY user-root/ /home/coder/
COPY user-root/ /opt/home_skel/

USER root

ENV cacheBustaLast=5

COPY container-root/ /
COPY run.sh /opt/run.sh

RUN chsh --shell $(which zsh) coder && chmod g+w /etc/passwd && chgrp -Rf root /home/coder && chmod -Rf g+w /home/coder && chmod +x /opt/run.sh

USER 1000

ENTRYPOINT ["/opt/run.sh"]
