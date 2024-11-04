# To go from drain to idle
sudo scontrol update nodename=dgxa40master state=resume

# To check all nodes info
scontrol show nodes

# To check status of all
sinfo

# To check if master node down
scontrol ping

