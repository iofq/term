FROM docker.io/golang:bullseye

ARG TREESITTER_INSTALL="go php bash yaml json javascript python dockerfile hcl"
ARG GOROOT=/root/go
ARG GOPATH=/root/go

WORKDIR /root

RUN git clone https://github.com/iofq/term && \
  cd term && \
  bash ./install -f

# Install nightly neovim
RUN bash .local/bin/update-nvim
# Install latest golang & golang packages
RUN bash .local/bin/update-go
# Install binaries
RUN bash .local/bin/update-binaries

# Run PackerInstall & TSUpdate
RUN $NVIM --headless -c "autocmd User PackerComplete quitall"
RUN $NVIM --headless -c ":TSInstallSync $TREESITTER_INSTALL | qall"
RUN $NVIM --headless -c ":GoInstallBinaries" -c "qall"

# archive home directory for portability
RUN tar -cvzhf /tmp/term.tgz \
    --exclude ~/.profile \
    --exclude ~/.cache ~/ && \
    mv /tmp/term.tgz ~/term.tgz

ENTRYPOINT ["bash"]
