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
    fish -c "omf install bobthefish"                                                                    && \

    rm -rf /home/developer/bundle/vim-airline                                                           && \
    pip install git+git://github.com/Lokaltog/powerline                                                 && \
    echo "set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim/" >> /home/developer/.vimrc~ && \
    pip install tmuxp                                                                                   && \
    echo "set shell=/bin/bash" >> /home/developer/.vimrc~                                               && \
    sh /tmp/init-vim.sh                                                                                 && \
    sh /util/ocd-clean / 

COPY tmux.conf /home/developer/.tmux.conf

RUN rc-update add sshd                        && \
    rc-status                                 && \
    touch /run/openrc/softlevel               && \
    /etc/init.d/sshd start > /dev/null 2>&1   && \
    /etc/init.d/sshd stop > /dev/null 2>&1

RUN echo "export GOPATH=/home/developer/workspace" >> /home/developer/.profile        && \
    echo "export GOROOT=/usr/lib/go" >> /home/developer/.profile                      && \
    echo "export GOBIN=$GOROOT/bin" >> /home/developer/.profile                       && \
    echo "export NODEBIN=/usr/lib/node_modules/bin" >> /home/developer/.profile       && \
    echo "export PATH=$PATH:$GOBIN:$GOPATH/bin:$NODEBIN" >> /home/developer/.profile  && \
    echo "source /home/developer/.profile" >> /home/developer/.bashrc                 && \
    . /home/developer/.bashrc 

RUN echo "set -x HOME /home/developer" >> /home/developer/.config/fish/config.fish              && \
    echo "set -x GOPATH /home/developer/workspace" >> /home/developer/.config/fish/config.fish  && \
    echo "set -x GOROOT /usr/lib/go" >> /home/developer/.config/fish/config.fish                && \
    echo "set -x GOBIN $GOROOT/bin" >> /home/developer/.config/fish/config.fish                 && \
    echo "set -x NODEBIN /usr/lib/node_modules/bin" >> /home/developer/.config/fish/config.fish && \
    echo "set --universal fish_user_paths $fish_user_paths $GOBIN $GOPATH/bin $NODEBIN"            \
      >> /home/developer/.config/fish/config.fish                                               && \
    fish -c source /home/developer/.config/fish/config.fish

#              ssh   mosh
EXPOSE 80 8080 62222 60001/udp

ENV GOPATH /home/developer/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin
ENV NODEBIN /usr/lib/node_modules/bin
ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN
ENV HOME /home/developer

COPY start.bash /usr/local/bin/start.bash
ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
