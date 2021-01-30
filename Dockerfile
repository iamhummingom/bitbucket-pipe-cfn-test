FROM python:3.8-slim-buster

RUN pip install --upgrade pip
RUN pip install envsubst taskcat

COPY pipe /
COPY README.md pipe.yml /
RUN chmod a+x /pipe.sh

ENTRYPOINT ["/pipe.sh"]
