## *Remote Development Environment*
`jare/drop-in:latest`   
[![jare/drop-in:latest](https://badge.imagelayers.io/jare/drop-in:latest.svg)](https://imagelayers.io/?images=jare/drop-in:latest 'jare/drop-in:latest')  *- uncompressed size*

[![](http://i.imgur.com/RVTlBBO.png)](http://i.imgur.com/RVTlBBO.png)

#### What's inside:
  - [`Alpine Linux`](http://www.alpinelinux.org/)
  - [`Vim`](http://www.vim.org/) + a ton of awesome plugins *see [`jare/vim-bundle:latest`](https://hub.docker.com/r/jare/vim-bundle/)*
  - Good support of [`Golang`](https://golang.org/) and [`TypeScript`](http://www.typescriptlang.org/) development with [`jare/typescript`](https://hub.docker.com/r/jare/typescript/) and [`jare/go-tools`](https://hub.docker.com/r/jare/go-tools/) containers
  - [`tmux`](https://tmux.github.io/)
  - [`Fish`](http://fishshell.com/)
  - [`powerline`](https://github.com/powerline/powerline)
  - [`Mosh`](https://mosh.mit.edu/)
  - Docker client for doing stuff with `-v /var/run/docker.sock:/var/run/docker.sock`
  - OpenSSH, Bash, OMF, Python, etc.
  
#### how to start the daemon*(and all containers)*
```sh
  docker create -v '/usr/lib/go' --name go-tools \
  'jare/go-tools' '/bin/true'
  
  docker create -v '/usr/lib/node_modules' \
  --name typescript 'jare/typescript' '/bin/true'
   
  docker run -v $('pwd'):/home/developer/workspace \
  --volumes-from go-tools --volumes-from typescript \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -d -p 80:80 -p 8080:8080 -p 62222:62222 -p 60001:60001/udp \
  --name drop-in jare/drop-in
```
#### how to connect:  
  `mosh --ssh="ssh -p 62222" -- root@$<ip>`  
  
###### Then you can start [`main`](https://github.com/JAremko/drop-in/blob/master/.main.yaml) tmuxp session like this `tmuxp load .main.yaml` - [*tmuxp* examples](http://tmuxp.readthedocs.org/en/latest/examples.html)

#### Useful Bash scripts
###### **Connect**
```bash
#!/bin/bash
ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' drop-in)
mosh --ssh="ssh -p 62222" -- root@$ip
```  
###### **start the daemon(and all containers)**
```bash
#!/bin/bash
dtc_id=$(docker ps -a -q --filter 'name=vim-go-tools')
ts_id=$(docker ps -a -q --filter 'name=vim-typescript')
if [[ -z "${dtc_id}" ]]; then
 echo 'vim-go-tools container not found. Creating...'
 docker create -v '/usr/lib/go' --name 'vim-go-tools' \
   'jare/go-tools' '/bin/true'
 echo 'Done!'
fi
if [[ -z "${ts_id}" ]]; then
 echo 'vim-typescript container not found. Creating...'
 docker create -v '/usr/lib/node_modules' \
   --name 'vim-typescript' 'jare/typescript' '/bin/true'
 echo 'Done!'
fi
echo 'starting daemon...'
docker run -v $('pwd'):/home/developer/workspace \
  --volumes-from vim-go-tools --volumes-from vim-typescript \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -d -p 80:80 -p 8080:8080 -p 62222:62222 -p 60001:60001/udp \
  --name drop-in jare/drop-in
echo 'Done!'
```    
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*Don't forget to replace `ADD https://github.com/jaremko.keys /home/developer/.ssh/authorized_keys` in the [Dockerfile](https://hub.docker.com/r/jare/drop-in/~/dockerfile/) with your key or mount it `-v <your-key>:/home/developer/.ssh/authorized_keys`*
