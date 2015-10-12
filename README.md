WIP  
===

How to run:  
  `docker run -v <stuff-to-work-with>:/home/developer/workspace -v <tmuxp.yaml>/home/developer/.tmuxp.yaml -v <keys>:/home/developer/.ssh/authorized_keys -v /var/run/docker.sock:/var/run/docker.sock -d -p 80:80 -p 8080:8080 -p 62222:62222 -p 60001:60001/udp --name drop-in jare/drop-in`  

how to connect:  
  `mosh --ssh="ssh -p 62222" root@<host> -- tmuxp load ~/.tmuxp.yaml`
