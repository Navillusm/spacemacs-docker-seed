FROM spacemacs/emacs25:develop

# Has to be secified before `RUN install-deps`
ENV UNAME="spacemacser"
ENV UID="1000"

# Ubuntu Xenial
RUN apt-get update \
    && apt-get install \
    dstat \
    clang \
    silversearcher-ag \
    ca-certificates \
    curl \
    apt-transport-https \
    software-properties-common \
    firefox \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update && apt-get install docker-ce

COPY .spacemacs "${UHOME}/.spacemacs"
COPY private "${UHOME}/.emacs.d/private"

RUN usermod -a -G docker spacemacser

RUN touch /var/run/docker.sock
RUN chown root:docker /var/run/docker.sock

# Install layers dependencies and initialize the user
RUN install-deps

RUN ln -s /mnt/workspace/.ssh /home/emacs/.ssh
RUN rm -rf /home/emacs/.gitconfig && ln -s /mnt/workspace/.gitconfig /home/emacs/.gitconfig
RUN rm -rf /home/emacs/.emacs.d/.cache && ln -s /mnt/workspace/.spacemacs.cache /home/emacs/.emacs.d/.cache
