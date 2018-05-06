# docker-jenkins-slave

FROM 192.168.31.163:5000/jenkinsci/slave:3.20-1

RUN mkdir /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh

COPY jenkins_master_public_key /home/jenkins/.ssh/jenkins_master_public_key

RUN echo /home/jenkins/.ssh/jenkins_master_public_key > /home/jenkins/.ssh/authorized_keys && \
    chmod 600 /home/jenkins/.ssh/authorized_keys

EXPOSE 22