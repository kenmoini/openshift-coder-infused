FROM codercom/code-server:latest

USER root

ENV cacheBusta=510

LABEL io.k8s.display-name="Workshop IDE" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,coder,ide,vscode,workshop" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# Install OpenShift clients.

RUN curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v3/clients/3.10.176/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    mv /usr/local/bin/oc /usr/local/bin/oc-3.10 && \
    rm /tmp/oc.tar.gz && \
    curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v3/clients/3.11.153/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    mv /usr/local/bin/oc /usr/local/bin/oc-3.11 && \
    rm /tmp/oc.tar.gz && \
    curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v3/clients/4.0.22/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    mv /usr/local/bin/oc /usr/local/bin/oc-4.0 && \
    rm /tmp/oc.tar.gz && \
    curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.1/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    mv /usr/local/bin/oc /usr/local/bin/oc-4.1 && \
    ln -s /usr/local/bin/oc-4.1 /usr/local/bin/kubectl-1.13 && \
    rm /tmp/oc.tar.gz && \
    curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.2/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    mv /usr/local/bin/oc /usr/local/bin/oc-4.2 && \
    ln -s /usr/local/bin/oc-4.2 /usr/local/bin/kubectl-1.14 && \
    rm /tmp/oc.tar.gz && \
    curl -s -o /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.3/linux/oc.tar.gz && \
    tar -C /usr/local/bin -zxf /tmp/oc.tar.gz oc && \
    mv /usr/local/bin/oc /usr/local/bin/oc-4.3 && \
    ln -s /usr/local/bin/oc-4.3 /usr/local/bin/kubectl-1.16 && \
    rm /tmp/oc.tar.gz

RUN curl -sL -o /usr/local/bin/odo-0.0.16 https://github.com/openshift/odo/releases/download/v0.0.16/odo-linux-amd64 && \
    chmod +x /usr/local/bin/odo-0.0.16 && \
    curl -sL -o /usr/local/bin/odo-0.0.17 https://github.com/openshift/odo/releases/download/v0.0.17/odo-linux-amd64 && \
    chmod +x /usr/local/bin/odo-0.0.17 && \
    curl -sL -o /usr/local/bin/odo-0.0.18 https://github.com/openshift/odo/releases/download/v0.0.18/odo-linux-amd64 && \
    chmod +x /usr/local/bin/odo-0.0.18 && \
    curl -sL -o /usr/local/bin/odo-0.0.19 https://github.com/openshift/odo/releases/download/v0.0.19/odo-linux-amd64 && \
    chmod +x /usr/local/bin/odo-0.0.19 && \
    curl -sL -o /usr/local/bin/odo-0.0.20 https://github.com/openshift/odo/releases/download/v0.0.20/odo-linux-amd64 && \
    chmod +x /usr/local/bin/odo-0.0.20 && \
    curl -sL -o /tmp/odo.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/odo/v1.0.0/odo-linux-amd64.tar.gz && \
    tar -C /tmp -xf /tmp/odo.tar.gz && \
    mv /tmp/odo /usr/local/bin/odo-1.0 && \
    chmod +x /usr/local/bin/odo-1.0 && \
    rm /tmp/odo.tar.gz

# Install Kubernetes client.

RUN curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl && \
    mv /usr/local/bin/kubectl /usr/local/bin/kubectl-1.10 && \
    chmod +x /usr/local/bin/kubectl-1.10 && \
    curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl && \
    mv /usr/local/bin/kubectl /usr/local/bin/kubectl-1.11 && \
    chmod +x /usr/local/bin/kubectl-1.11 && \
    curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl && \
    mv /usr/local/bin/kubectl /usr/local/bin/kubectl-1.12 && \
    chmod +x /usr/local/bin/kubectl-1.12

ENV cacheBustaMid=1

RUN curl -O https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz && \
    tar -xvf go1.13.7.linux-amd64.tar.gz && \
    mv go /usr/local

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y jq tmux software-properties-common nano && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ansible python-pip python3-pip default-jre default-jdk maven build-essential python3-dev python-dev python3-winrm nodejs zsh gcc g++ make yarn zip unzip php-cli php-zip php-xml php-gd php-opcache php-mbstring && \
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
    mkdir /opt/home_skel

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

USER root

ENV cacheBustaLast=50

COPY run.sh /opt/run.sh

RUN chsh --shell $(which zsh) coder && chmod g+w /etc/passwd && chgrp -Rf root /home/coder && chmod -Rf g+w /home/coder && chmod +x /opt/run.sh

USER 1000

ENTRYPOINT ["/opt/run.sh"]