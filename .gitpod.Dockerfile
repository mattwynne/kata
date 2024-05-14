FROM gitpod/workspace-full:latest

RUN brew install erlang
RUN brew install elixir
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"