# docker-jenkins-slave

FROM 192.168.31.163:5000/jenkinsci/slave:3.20-1

# install SSHd
USER root
RUN rm -f /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt-get clean
RUN cd /var/lib/apt && \
    mv lists lists.old && \
    mkdir -p lists/partial && \
    apt-get clean
RUN apt-get update && \
    apt-get upgrade
RUN apt-get install -y openssh-client \
                       openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# copy public key
USER jenkins
RUN mkdir /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh

COPY jenkins_master_public_key /home/jenkins/.ssh/jenkins_master_public_key

RUN cat /home/jenkins/.ssh/jenkins_master_public_key > /home/jenkins/.ssh/authorized_keys && \
    chmod 600 /home/jenkins/.ssh/authorized_keys