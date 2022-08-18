 #!/bin/bash 
 sudo apt-key adv --recv-keys --keyserver \
      keyserver.ubuntu.com 0xcbcb082a1bb943db
 apt-get update
 sudo apt-get -y install mariadb-client \
      mariadb-galera-server \
      galera
