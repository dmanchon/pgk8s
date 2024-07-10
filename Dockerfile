FROM postgres

RUN apt update; \
    apt install -y postgresql-contrib postgresql-plpython3-16 python3-requests python3-kubernetes
