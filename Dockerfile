FROM jare/vim-bundle

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV TERM screen-256color
ENV HOME /home/developer

COPY sshd_config /etc/ssh/sshd_config
COPY init-vim.sh /tmp/init-vim.sh

ADD https://github.com/jaremko.keys /home/developer/.ssh/authorized_keys

RUN apk add --update tmux git curl bash fish docker mosh-server htop python py-pip openssh                 \
      --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community                     && \

    curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish                              && \ 
    echo "/usr/bin/fish" >> /etc/shells                                                                 && \
    sed -i 's/0:0:root:\/root:\/bin\/ash/0:0:root:\/home\/developer:\/usr\/bin\/fish/g' /etc/passwd     && \
    echo "alias ed='sh /usr/local/bin/run'" >> /home/developer/.config/fish/config.fish                 && \
    fish -c "omf theme bobthefish"                                                                      && \

    pip install git+git://github.com/Lokaltog/powerline                                                 && \
    echo "set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim/" >> /home/developer/.vimrc~ && \
    pip install tmuxp                                                                                   && \
    sh /tmp/init-vim.sh                                                                                 && \
    sh /util/ocd-clean / 

COPY tmux.conf /home/developer/.tmux.conf

RUN rc-update add sshd                                                                                  && \
    rc-status                                                                                           && \
    touch /run/openrc/softlevel                                                                         && \
    /etc/init.d/sshd start                                                                              && \
    /etc/init.d/sshd stop

#                 mosh
EXPOSE 80 8080 22 60001/udp

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
