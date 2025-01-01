FROM haskell:9.8.4-bullseye

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME 
RUN apt-get update && apt-get install -y sudo 
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME 

USER $USERNAME

ENV PATH="${PATH}:/home/$USERNAME/.ghcup/bin:/home/$USERNAME/.cabal/bin:/home/$USERNAME/.ghc/bin"
ENV GHCUP_INSTALL_BASE_PREFIX="/home/$USERNAME"
ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
RUN ghcup install ghc 9.8.2
RUN ghcup install hls 2.9.0.0

RUN cabal update 
RUN cabal install hlint