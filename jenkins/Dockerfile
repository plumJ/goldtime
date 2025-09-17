FROM jenkins/jenkins:lts

USER root

# 安装 Docker 的依赖
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg

# 添加 Docker 官方 GPG 密钥
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# 添加 Docker APT 源
RUN echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
RUN apt-get update && \
    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

# 添加 jenkins 用户到 docker 组
RUN usermod -aG docker jenkins

USER jenkins