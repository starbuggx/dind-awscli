FROM docker:24.0.3

ENV GLIBC_VER=2.34-r0 \
    LANGUAGE="en_NZ.UTF-8" \
    LANG="en_NZ.UTF-8" \
    TERM="xterm" \
    TZ=Pacific/Auckland

WORKDIR /root/
# install glibc compatibility for alpine
RUN apk --update-cache add \
        binutils \
        curl \
        groff \
        bash \
        bash-completion \
        jq \
        tzdata \
        tcpdump \
        nmap \
        zip \
        vim \
        htop \
        iftop \
        net-tools \
        python3 \
        less \
        iproute2 \
    && sed -i 's/ash/bash/g' /etc/passwd \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk del libc6-compat \
    && apk add \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        # /usr/local/aws-cli/v2/*/dist/aws_completer \
        # /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        # /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
        # curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/* \
    && docker --version \
    && aws --version \
    && echo "alias ll='ls -hAlF'" > ~/.bashrc \
    && echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc
