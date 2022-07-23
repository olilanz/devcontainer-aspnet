FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    coreutils \
    curl \
    gnupg \
    unzip \
    iputils-ping \
    lsb-release \
    software-properties-common

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    git \
    docker.io

# [Choice] Node.js version: none, lts/*, 18, 16, 14
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

COPY ./scripts /scripts/
WORKDIR /scripts

# Install SQL Tools: SQLPackage and sqlcmd
RUN bash ./mssql/installSQLtools.sh \
     && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

ENV TARGETARCH=linux-x64

WORKDIR /repos
