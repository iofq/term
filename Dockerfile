FROM docker.io/debian:bullseye-slim

ARG TREESITTER_INSTALL="go php bash yaml json javascript python dockerfile hcl"
ARG GOPATH=/root/go
ENV NVIM=/root/.local/bin/nvim
ENV PATH="/root/go/bin:$PATH"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

RUN apt update && apt install -y curl g++ git

RUN curl -L https://github.com/iofq/term/tarball/master \
  | tar xz --strip-components 1

# Install nightly neovim
RUN .local/bin/update-nvim
# Install latest golang & golang packages
RUN .local/bin/update-go >/dev/null
# Install binaries
RUN bash .local/bin/update-binaries

# Run PackerInstall & TSUpdate
RUN $NVIM --headless -c "autocmd User PackerComplete quitall"
RUN $NVIM --headless -c ":TSInstallSync $TREESITTER_INSTALL | qall"
RUN $NVIM --headless -c ":GoInstallBinaries" -c "qall"

# archive home directory for portability
RUN tar cvhf /tmp/term.tgz \
    -I "gzip --best" \
    --sort='name' \
    --exclude .profile \
    --exclude .github \
    --exclude Dockerfile \
    --exclude README.md \
    --exclude .cache -C ~/ . > /dev/null && \
    mv /tmp/term.tgz ~/term.tgz

ENTRYPOINT ["bash"]
