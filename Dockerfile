FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV PIP_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cu121
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt update -y && apt install -y \
    sudo \
    build-essential \
    curl \
    git \
    libcairo2-dev \
    libgl1-mesa-glx \
    software-properties-common \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set up Python
RUN ln -sf /usr/bin/python3.11 /usr/local/bin/python && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    python -m pip install --upgrade pip

# Install Python packages as root (before switching user)
WORKDIR /code
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN python -c "from nbdev.quarto import install_quarto; install_quarto()"
# RUN nbdev_install_quarto

# Create user
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chsh ${USERNAME} -s /bin/bash

RUN echo "export PROMPT_COMMAND='history -a' && export HISTFILE=~/.bash_history" >> "/home/${USERNAME}/.bashrc"

# Switch to user
USER ${USERNAME}
RUN git config --global credential.helper store

COPY . .
