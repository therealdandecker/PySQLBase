FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
    build-essential \
    curl \
    libssl-dev \
    gnupg2 \
    software-properties-common \
    dirmngr \
    apt-transport-https \
    apt-utils \
    lsb-release \
    ca-certificates \
    tzdata \
 && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update -y \
 && ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev mssql-tools \
 && apt-get clean

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.py /app/entrypoint.py
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
