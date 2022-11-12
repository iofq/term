FROM docker.io/golang:bullseye
ENV GOPATH="/root/go"

ARG NVIM="/root/.local/bin/nvim"
ARG TREESITTER_INSTALL="go php bash yaml json javascript python dockerfile hcl"

WORKDIR /root
RUN mkdir $GOPATH

RUN cd && git clone https://github.com/iofq/term && \
  cd term && \
  ./install -f

# Install nightly neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
    tar xzvf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz && \
    ln -s /root/nvim-linux64/bin/nvim $NVIM

# Install go binaries
RUN go install github.com/junegunn/fzf@latest

# Install binaries from github
RUN curl -Lo rg.tgz https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz && \
    tar xzvf rg.tgz -C /tmp --strip-components 1 && \
    rm -rf rg.tgz && \
    mv /tmp/rg ~/.local/bin/


# Run PackerInstall & TSUpdate
RUN $NVIM --headless -c "autocmd User PackerComplete quitall"
# RUN $NVIM --headless -c ":TSInstallSync $TREESITTER_INSTALL | qall"
# RUN $NVIM --headless -c ":GoInstallBinaries" -c "qall"

# archive home directory for portability
RUN tar -cvzhf /tmp/term.tgz --exclude ~/.profile --exclude ~/.cache ~/ && mv /tmp/term.tgz ~/term.tgz

ENTRYPOINT ["bash"]
