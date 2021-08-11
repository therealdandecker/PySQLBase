FROM python:3.9-slim-buster

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y build-essential curl libssl-dev gnupg2 software-properties-common dirmngr apt-transport-https apt-utils lsb-release ca-certificates
RUN apt-get update -y && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev mssql-tools

RUN echo "[el2]\n\
driver = ODBC Driver 17 for SQL Server\n\
server = 192.168.1.249\n\
database = FinApp" >> /etc/odbc.ini

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

#EXPOSE 8000

CMD [ "python" ]