# Jenkins 本地部署 MAC M1

## Jenkins network
```bash
    docker network create jenkins-net
```

## Jenkins master

### docker run
```bash
docker run -d \
    --name jenkins \
    --network jenkins-net \
    -p 8080:8080 \
    -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home  \
    jenkins/jenkins:lts-jdk17
```

## Jenkins agent

### docker build
```bash
docker build -t jenkins-docker-agent -f Dockerfile.agent .
```

### docker run
```bash
docker run -d \
  --name jenkins-docker-agent \
  --network jenkins-net \
  --user root \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e JENKINS_URL=http://jenkins:8080 \
  -e JENKINS_AGENT_NAME=docker-agent \
  -e JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
  -e JENKINS_SECRET=e7df6a2f86e750d8deaa08ec2728d1bf49d90f9160534bcff776c9052f91480b \
  jenkins-docker-agent
```