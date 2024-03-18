FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bzip2 make gcc bubblewrap rsync patch curl unzip

# Install opam
RUN curl -fsSL -o /usr/local/bin/opam https://github.com/ocaml/opam/releases/download/2.0.9/opam-2.0.9-x86_64-linux && \
    chmod +x /usr/local/bin/opam

# Set up non-root user
ARG USERNAME=ocamluser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
       aspcud m4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME

# Initialize opam
RUN opam init -y --disable-sandboxing && \
    eval $(opam env)

# Install opam packages (replace with your project dependencies)
RUN opam install -y dune merlin ocaml-lsp-server odoc ocamlformat utop
