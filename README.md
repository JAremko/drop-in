## Remote Development Environment
`jare/drop-in:latest`

[![](http://i.imgur.com/RVTlBBO.png)](http://i.imgur.com/RVTlBBO.png)

#### [Based on the `jare/vim-bundle:latest`](https://hub.docker.com/r/jare/vim-bundle/)   
[![](http://i.imgur.com/G6KybVM.png)](http://i.imgur.com/G6KybVM.png) 

#### [Also you might want to look at Vim/Emacs hybrid `jare/spacemacs`](https://hub.docker.com/r/jare/spacemacs/)    [![](https://raw.githubusercontent.com/syl20bnr/spacemacs/master/doc/img/spacemacs-python.png)](https://raw.githubusercontent.com/syl20bnr/spacemacs/master/doc/img/spacemacs-python.png) 

#### What's inside:
  - [`Alpine Linux`](http://www.alpinelinux.org/)
  - [`Vim`](http://www.vim.org/) + a ton of awesome plugins *see [`jare/vim-bundle:latest`](https://hub.docker.com/r/jare/vim-bundle/)*
  - Good support of [`Golang`](https://golang.org/) development with [`jare/go-tools`](https://hub.docker.com/r/jare/go-tools/) container
  - [`tmux`](https://tmux.github.io/)
  - [`powerline`](https://powerline.readthedocs.io)
  - [`Mosh`](https://mosh.mit.edu/)
  - OpenSSH, Bash, OMF, Python, etc.

*The Tmux prefix is `C-q` other than that both Tmux and Vim binding are mostly default  [**tmux.conf**](https://github.com/JAremko/drop-in/blob/master/tmux.conf), [**.vimrc**](https://github.com/JAremko/alpine-vim/blob/master/.vimrc)*  
*Make sure to use "Solarized Dark" compatible theme or colors palette may look weird.*  
#### how to start the daemon(and all containers)
```sh
  docker create -v '/usr/lib/go' --name go-tools \
  'jare/go-tools' '/bin/true'

  docker run -v $('pwd'):/home/developer/workspace \
  --volumes-from go-tools \
  -v ~/.ssh/pub_rsa:/etc/ssh_keys:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -d -p 80:80 -p 8080:8080 -p 62222:62222 -p 60001:60001/udp \
  --name drop-in jare/drop-in
```
  *`-v /etc/localtime:/etc/localtime:ro` - makes tmux display local time*
#### how to connect:  
  `mosh --ssh="ssh -p 62222" -- developer@$<ip> tmux -u`
#### or without host identity check:  
  `mosh --ssh="ssh -o StrictHostKeyChecking=no -p 62222" -- developer@$<ip> tmux -u`
  
#### Useful Bash scripts
###### **Connect**
```bash
#!/bin/bash
ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' drop-in)
mosh --ssh="ssh -p 62222" -- developer@$ip tmux -u
```
###### **start the daemon(and all containers)**
```bash
#!/bin/bash
dtc_id=$(docker ps -a -q --filter 'name=vim-go-tools')
if [[ -z "${dtc_id}" ]]; then
 echo 'vim-go-tools container not found. Creating...'
 docker create -v '/usr/lib/go' --name 'vim-go-tools' \
   'jare/go-tools' '/bin/true'
 echo 'Done!'
fi
echo 'starting daemon...'
docker run -v $('pwd'):/home/developer/workspace \
  --volumes-from vim-go-tools \
  -v ~/.ssh/pub_rsa:/etc/ssh_keys:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -e "GEMAIL=<github email>" \
  -e "GNAME=<github name>" \
  -d -p 80:80 -p 8080:8080 -p 62222:62222 -p 60001:60001/udp \
  --name drop-in jare/drop-in
echo 'Done!'
```
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
  - *If you want to use publicly build image it's a good idea to use `mosh ... --ssh="ssh -o StrictHostKeyChecking=no ..." ...` to ignore server's identity.*
  - *If Vim or Powerline doesn't look right in the tmux try `tmux -2` and make sure that client's `TERM` variable set to support 256 colors*

 **Leave a comment if you found a bug or if you have a suggestion!**
