#!/bin/bash

echo "* Setting up cluster."
arp -s 10.1.101.1 04:f8:f8:dd:23:58
sleep 4
ssh -i ~/.ssh/docker_id_rsa root@container2 'echo "- Running code on container2! $(hostname)"'
ssh -i ~/.ssh/docker_id_rsa root@container3 'echo "- Running code on container3! $(hostname)"'
ssh -i ~/.ssh/docker_id_rsa root@container4 'echo "- Running code on container4! $(hostname)"'
ssh -i ~/.ssh/docker_id_rsa root@container5 'echo "- Running code on container5! $(hostname)"'
ssh -i ~/.ssh/docker_id_rsa root@container6 'echo "- Running code on container6! $(hostname)"'
ssh -i ~/.ssh/docker_id_rsa root@container7 'echo "- Running code on container7! $(hostname)"'
ssh -i ~/.ssh/docker_id_rsa root@container8 'echo "- Running code on container8! $(hostname)"'

echo "* Done!"
echo "====="
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
mpirun -hostfile /hostfile --mca routed direct -np 8 \
	/libexec/osu-micro-benchmarks/mpi/collective/osu_alltoall -f -x 1000 -i 1000000 -z
