FROM jare/vim-bundle

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV TERM screen-256color
ENV HOME /home/developer

COPY sshd_config /etc/ssh/sshd_config
COPY init-vim.sh /tmp/init-vim.sh

ADD https://github.com/jaremko.keys /home/developer/.ssh/authorized_keys

RUN apk add --update libseccomp openrc                                                            \
      --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main                 && \
    apk add --update tmux git curl bash mosh-server htop python openssh                           \
      --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community            && \
    sed -i 's/0:0:root:\/root:\/bin\/ash/0:0:root:\/home\/developer:\/bin\/bash/g' /etc/passwd && \
    git clone https://github.com/erikw/tmux-powerline.git /usr/lib/tmux-powerline              && \
    git clone https://github.com/tmux-plugins/tmux-yank.git /home/developer/.tmux/tmux-yank    && \
    echo "set shell=/bin/bash" >> /home/developer/.vimrc~                                      && \
    sh /tmp/init-vim.sh

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
