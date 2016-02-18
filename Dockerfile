FROM snoyberg/stackage:nightly

RUN curl http://downloads.haskell.org/~ghc/8.0.1-rc2/ghc-8.0.0.20160204-x86_64-deb8-linux.tar.xz > ghc.tar.xz && \
    tar xf ghc.tar.xz && \
    rm ghc.tar.xz && \
    cd ghc-* && \
    ./configure --prefix=/opt/ghc && \
    make install && \
    cd .. && \
    rm -rf ghc-* && \
    mv /opt/ghc/share/doc/ghc-* /opt/ghc/share/doc/ghc && \
    curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C /usr/bin '*/stack' && \
    curl https://s3.amazonaws.com/stackage-travis/stackage-curator/stackage-curator.bz2 | bunzip2 > /usr/bin/stackage-curator && \
    chmod +x /usr/bin/stackage-curator

ENV PATH=/opt/ghc/bin:$PATH

ADD build.sh /stackage/build.sh
