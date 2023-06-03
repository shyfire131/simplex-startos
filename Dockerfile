FROM shyfire131/smp-server

# Open app listening port
EXPOSE 5223

# simplexmq requires using SIGINT to correctly preserve undelivered messages and restore them on restart
STOPSIGNAL SIGINT

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh