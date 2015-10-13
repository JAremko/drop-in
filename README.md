##*Remote Development Environment*
`jare/drop-in:latest`   [![jare/drop-in:latest](https://badge.imagelayers.io/jare/drop-in:latest.svg)](https://imagelayers.io/?images=jare/drop-in:latest 'jare/drop-in:latest')  

![](http://i.imgur.com/RVTlBBO.png)

###What's in:
  - [`Alpine Linux`](http://www.alpinelinux.org/)
  - [`Vim`](http://www.vim.org/) + a ton of awesome plugins *see [`jare/vim-bundle`](https://hub.docker.com/r/jare/vim-bundle/)*
  - Good support of [`Golang`](https://golang.org/) and [`TypeScript`](http://www.typescriptlang.org/) development with [`jare/typescript`](https://hub.docker.com/r/jare/typescript/) and [`jare/go-tools`](https://hub.docker.com/r/jare/go-tools/) containers
  - [`tmux`](https://tmux.github.io/)
  - [`Fish`](http://fishshell.com/)
  - [`powerline`](https://github.com/powerline/powerline)
  - [`Mosh`](https://mosh.mit.edu/)
  - Docker client for doing stuff with `-v /var/run/docker.sock:/var/run/docker.sock`
  - Other stuff like OpenSSH, Bash etc.
  
*see [`jare/vim-bundle`](https://hub.docker.com/r/jare/vim-bundle/)*
How to run:  
  `docker run -v <stuff-to-work-with>:/home/developer/workspace -v <tmuxp.yaml>/home/developer/.tmuxp.yaml -v <keys>:/home/developer/.ssh/authorized_keys -v /var/run/docker.sock:/var/run/docker.sock -d -p 80:80 -p 8080:8080 -p 62222:62222 -p 60001:60001/udp --name drop-in jare/drop-in`  

how to connect:  
  `mosh --ssh="ssh -p 62222" root@<host> -- tmuxp load ~/.tmuxp.yaml`
