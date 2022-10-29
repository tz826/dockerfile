FROM docker.io/noi1031/sshd:debian-11

ENV VSCODE_COMMIT_ID "4af164ea3a06f701fe3e89a2bcbb421d2026b68f"

ADD vscode* /root/.vscode-server/bin/

RUN set -eux; \
            \
        apt-get update; \
        apt-get install -y curl; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*; \
            \
        cd /root/.vscode-server/bin/; \
        mv vscode-server-linux-x64 ${VSCODE_COMMIT_ID}
