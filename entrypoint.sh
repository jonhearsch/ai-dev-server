#!/bin/bash
set -e

# Fix home directory permissions (SSH requires this)
chmod 755 /home/jon
chown jon:jon /home/jon

# Ensure SSH directory exists with correct permissions
mkdir -p /home/jon/.ssh
chmod 700 /home/jon/.ssh

# Copy authorized_keys from staging location (allows proper permissions)
if [ -f /tmp/authorized_keys ]; then
    cp /tmp/authorized_keys /home/jon/.ssh/authorized_keys
    chmod 600 /home/jon/.ssh/authorized_keys
    echo "Copied authorized_keys from /tmp/authorized_keys"
else
    echo "WARNING: /tmp/authorized_keys not found!"
fi

# Ensure correct ownership
chown -R jon:jon /home/jon/.ssh

# Debug: show SSH setup
echo "SSH directory contents:"
ls -la /home/jon/.ssh/
echo "authorized_keys content:"
cat /home/jon/.ssh/authorized_keys 2>/dev/null || echo "No authorized_keys file"

# Start SSH service with debug logging
echo "Starting SSH daemon..."
/usr/sbin/sshd -D -e &

# Keep container running
tail -f /dev/null
