FROM ubuntu AS img

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y openssh-server wget openmpi-common openmpi-bin build-essential make mpi-default-dev && \
    mkdir /var/run/sshd

# SSH server configuration.
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH client configuration.
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
RUN wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5-1.tar.gz
RUN tar -xf osu-micro-benchmarks-7.5-1.tar.gz && cd osu-micro-benchmarks-7.5-1 && ./configure --prefix=/ CC=$(which mpicc) CXX=$(which mpicxx) && make -j && make install


COPY keys /root/.ssh/
COPY hostfile /hostfile
COPY keys/docker_id_rsa.pub /root/.ssh/authorized_keys
COPY ssh-config /root/.ssh/config
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

COPY setup.sh .
RUN chmod +x /setup.sh

CMD ["/usr/sbin/sshd", "-D"]

