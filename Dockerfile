FROM frolvlad/alpine-glibc:latest
LABEL maintainer "zcsevcik@gmail.com"

RUN apk --update --no-cache upgrade && \
    apk --update --no-cache add make boost && \
    apk --update --no-cache add --virtual build-dependencies \
    build-base flex bison boost-dev texinfo unzip openssl ca-certificates tar && \

    wget -O /tmp/stsw-stm8069.zip "https://github.com/zcsevcik/docker-stm8s/raw/master/stsw-stm8069.zip" && \
    wget -O /tmp/SPL_2.2.0_SDCC_patch.zip "https://github.com/zcsevcik/docker-stm8s/raw/master/SPL_2.2.0_SDCC_patch-master.zip" && \
    unzip /tmp/stsw-stm8069.zip -d /opt && \
    rm -fr /tmp/stsw-stm8069.zip && \
    unzip /tmp/SPL_2.2.0_SDCC_patch.zip -d /opt && \
    rm -fr /tmp/SPL_2.2.0_SDCC_patch.zip && \
    cd /opt/STM8S_StdPeriph_Lib && \
    patch -p1 </opt/SPL_2.2.0_SDCC_patch-master/STM8_SPL_v2.2.0_SDCC.patch && \
    rm -fr /opt/SPL_2.2.0_SDCC_patch-master && \

    wget -O /tmp/stx-btree-0.9.tar.bz2 "http://panthema.net/2007/stx-btree/stx-btree-0.9.tar.bz2" && \
    tar xvf /tmp/stx-btree-0.9.tar.bz2 -C /tmp && \
    rm -fr /tmp/stx-btree-0.9.tar.bz2 && \
    cd /tmp/stx-btree-0.9 && \
    ./configure && \
    make -j && \
    make install-strip && \
    rm -fr /tmp/stx-btree-0.9 && \

    wget -O /tmp/sdcc-3.7.0.tar.bz2 "https://sourceforge.net/projects/sdcc/files/sdcc/3.7.0/sdcc-src-3.7.0.tar.bz2/download" && \
    tar xvf /tmp/sdcc-3.7.0.tar.bz2 -C /tmp && \
    rm -fr /tmp/sdcc-3.7.0.tar.bz2 && \
    cd /tmp/sdcc && \
    ./configure \
      --disable-mcs51-port \
      --disable-z80-port \
      --disable-z180-port \
      --disable-r2k-port \
      --disable-r3ka-port \
      --disable-gbz80-port \
      --disable-tlcs90-port \
      --disable-ds390-port \
      --disable-ds400-port \
      --disable-pic14-port \
      --disable-pic16-port \
      --disable-hc08-port \
      --disable-s08-port && \
    make -j && \
    make install && \
    rm -fr /tmp/sdcc && \

    apk del build-dependencies
