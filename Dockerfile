FROM jare/vim-bundle

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV TERM screen-256color
ENV HOME /home/developer

COPY sshd_config /etc/ssh/sshd_config
COPY init-vim.sh /tmp/init-vim.sh
COPY .main.yaml  /home/developer/.main.yaml

ADD https://github.com/jaremko.keys /home/developer/.ssh/authorized_keys

RUN apk add --update tmux git curl fish docker bash mosh-server htop python py-pip openssh python-tests    \
      --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community                     && \

    sed -i 's/0:0:root:\/root:\/bin\/ash/0:0:root:\/home\/developer:\/usr\/bin\/fish/g' /etc/passwd     && \

    curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish                              && \ 
    echo "/usr/bin/fish" >> /etc/shells                                                                 && \
    echo "alias ed='sh /usr/local/bin/run'" >> /home/developer/.config/fish/config.fish                 && \
    fish -c "omf theme bobthefish"                                                                      && \

    pip install git+git://github.com/Lokaltog/powerline                                                 && \
    echo "set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim/" >> /home/developer/.vimrc~ && \
    pip install tmuxp                                                                                   && \
    sh /tmp/init-vim.sh                                                                                 && \
    sh /util/ocd-clean / 

COPY tmux.conf /home/developer/.tmux.conf

RUN rc-update add sshd                        && \
    rc-status                                 && \
    touch /run/openrc/softlevel               && \
    /etc/init.d/sshd start > /dev/null 2>&1   && \
    /etc/init.d/sshd stop > /dev/null 2>&1

RUN echo "set shell=/bin/bash" >> /home/developer/.vimrc~                     && \
    echo "GOPATH=/home/developer/workspace" >> /home/developer/.bashrc        && \
    echo "GOROOT=/usr/lib/go" >> /home/developer/.bashrc                      && \
    echo "GOBIN=$GOROOT/bin" >> /home/developer/.bashrc                       && \
    echo "NODEBIN=/usr/lib/node_modules/bin" >> /home/developer/.bashrc       && \
    echo "PATH=$PATH:$GOBIN:$GOPATH/bin:$NODEBIN" >> /home/developer/.bashrc 

#              ssh   mosh
EXPOSE 80 8080 62222 60001/udp

ENTRYPOINT ["/usr/sbin/sshd", "-De"]
