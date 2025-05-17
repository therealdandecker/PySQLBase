FROM python:3.12-slim-bookworm

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y build-essential curl libssl-dev gnupg2 software-properties-common dirmngr apt-transport-https apt-utils lsb-release ca-certificates
RUN apt-get update -y && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev mssql-tools

ENV ODBC_DSN=el2 \
    DB_SERVER=192.168.1.249 \
    DB_DATABASE=FinApp

RUN echo "[${ODBC_DSN}]\n\
driver = ODBC Driver 18 for SQL Server\n\
server = ${DB_SERVER}\n\
database = ${DB_DATABASE}" > /etc/odbc.ini

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

ENV CONNECTION_STRING=""
COPY entrypoint.py /app/entrypoint.py

#EXPOSE 8000

CMD [ "python", "/app/entrypoint.py" ]
