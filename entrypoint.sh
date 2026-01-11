#!/bin/bash
set -e

# Ensure SSH directory exists with correct permissions
mkdir -p /home/jon/.ssh
chmod 700 /home/jon/.ssh

# Copy authorized_keys from staging location (allows proper permissions)
if [ -f /tmp/authorized_keys ]; then
    cp /tmp/authorized_keys /home/jon/.ssh/authorized_keys
    chmod 600 /home/jon/.ssh/authorized_keys
fi

# Ensure correct ownership
chown -R jon:jon /home/jon/.ssh

# Start SSH service
/usr/sbin/sshd -D &

# Keep container running
tail -f /dev/null
