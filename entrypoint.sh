#!/bin/bash
set -e

# Start SSH service
service ssh start

# Keep container running
tail -f /dev/null
