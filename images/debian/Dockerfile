FROM debian:12-slim AS build-cache

FROM build-cache AS minimal

FROM build-cache AS full
COPY --from=minimal /home/vscode /home/vscode
COPY --from=minimal /usr/local/bin /usr/local/bin
COPY --from=minimal /usr/local/libexec/git-core /usr/local/libexec/git-core