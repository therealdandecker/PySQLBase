FROM python:3.12-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Base dependencies and timezone config
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
 && dpkg-reconfigure --frontend noninteractive tzdata

# Microsoft repo setup for Debian 11 (Bullseye)
RUN mkdir -p /etc/apt/keyrings && \
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    ARCH=$(dpkg --print-architecture) && \
    echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/11/prod bullseye main" \
    > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update -y && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev mssql-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy files into the container's /app folder
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY run_init_sql.py .
COPY .env .
COPY init.sql .   # optional — script handles if it exists

EXPOSE 8000

CMD ["python", "/app/run_init_sql.py"]
