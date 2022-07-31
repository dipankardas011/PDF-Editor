FROM redis:7.0.4-alpine as db-prod

COPY redis.conf /etc/redis/

VOLUME [ "/data" ]

CMD [ "redis-server", "/etc/redis/redis.conf" ]
EXPOSE 6379