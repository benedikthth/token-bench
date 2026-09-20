FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive HOME=/tmp GOCACHE=/tmp/gocache GOPATH=/tmp/gopath
RUN echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/80retries \
    && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git build-essential \
    python3 nodejs ruby perl golang-go rustc default-jdk-headless ghc \
    sbcl guile-3.0 swi-prolog-nox gforth \
    && rm -rf /var/lib/apt/lists/*
COPY --from=oven/bun:1 /usr/local/bin/bun /usr/local/bin/bun
# CBQN
RUN git clone --depth 1 https://github.com/dzaima/CBQN /tmp/cbqn \
    && cd /tmp/cbqn && make o3 && cp BQN /usr/local/bin/bqn && rm -rf /tmp/cbqn
# ngn/k
RUN git clone --depth 1 https://codeberg.org/ngn/k /tmp/ngnk \
    && cd /tmp/ngnk && make && cp k /usr/local/bin/k && rm -rf /tmp/ngnk
# Zig 0.15.2, prebuilt
RUN curl -fsSL --retry 5 https://ziglang.org/download/0.15.2/zig-x86_64-linux-0.15.2.tar.xz -o /tmp/zig.tar.xz \
    && mkdir -p /opt/zig && tar -xJf /tmp/zig.tar.xz -C /opt/zig --strip-components=1 \
    && ln -s /opt/zig/zig /usr/local/bin/zig && rm /tmp/zig.tar.xz
# Erlang/OTP 27 from the official image, then Gleam 1.18.1 prebuilt
COPY --from=erlang:27-slim /usr/local/lib/erlang /usr/local/lib/erlang
RUN apt-get update && apt-get install -y --no-install-recommends libncurses6 libssl3 unzip \
    && rm -rf /var/lib/apt/lists/* \
    && for b in erl erlc escript; do ln -s /usr/local/lib/erlang/bin/$b /usr/local/bin/$b; done \
    && curl -fsSL --retry 5 https://github.com/gleam-lang/gleam/releases/download/v1.18.1/gleam-v1.18.1-x86_64-unknown-linux-musl.tar.gz \
       | tar -xz -C /usr/local/bin gleam
# A template Gleam project with stdlib and gleam_erlang already fetched, so runs need no network
RUN cd /opt && gleam new gleamproj --skip-git --skip-github && cd gleamproj \
    && gleam add gleam_erlang && gleam build && rm -f src/gleamproj.gleam
# Uiua lives in its own image (docker/Dockerfile.uiua): its binary needs a newer glibc than bookworm.
COPY run /usr/local/bin/run
RUN sed -i 's/\r$//' /usr/local/bin/run && chmod +x /usr/local/bin/run
WORKDIR /work
ENTRYPOINT []
CMD ["bash"]
