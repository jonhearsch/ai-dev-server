FROM node:20-jammy

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone
ENV TZ=America/New_York

# Create user and set up environment
ARG USER_NAME=jon
ARG USER_UID=1000
ARG USER_GID=1000

# Install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    mosh \
    sudo \
    git \
    vim \
    nano \
    tmux \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install AI CLI tools
RUN npm install -g @anthropic-ai/claude-code@latest \
    && npm install -g @google/gemini-cli@latest

# Create user with sudo privileges
RUN groupadd -g ${USER_GID} ${USER_NAME} \
    && useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USER_NAME} \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure SSH
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Set up SSH directory for user
RUN mkdir -p /home/${USER_NAME}/.ssh \
    && chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.ssh \
    && chmod 700 /home/${USER_NAME}/.ssh

# Switch to user for workspace setup
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# Create workspace directory
RUN mkdir -p /home/${USER_NAME}/workspace

# Copy setup script for first-run
COPY --chown=${USER_NAME}:${USER_NAME} setup-ai-tools.sh /home/${USER_NAME}/setup-ai-tools.sh
RUN chmod +x /home/${USER_NAME}/setup-ai-tools.sh

# Add local bin to PATH for Claude Code
ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"

# Switch back to root for startup
USER root

# Expose SSH port
EXPOSE 22

# Expose Mosh UDP ports
EXPOSE 60000-60010/udp

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
