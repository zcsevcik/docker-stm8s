FROM frolvlad/alpine-glibc:latest
MAINTAINER Radek Ševčík <zcsevcik@gmail.com>

RUN apk --update --no-cache upgrade && \
    apk --update --no-cache add make boost && \
    apk --update --no-cache add --virtual build-dependencies \
    build-base flex bison boost-dev texinfo unzip openssl ca-certificates

ADD stsw-stm8069.zip /tmp/stsw-stm8069.zip
RUN unzip /tmp/stsw-stm8069.zip -d /opt && \
    wget -O /tmp/STM8_SPL_v2.2.0_SDCC.patch "https://github.com/gicking/SPL_2.2.0_SDCC_patch/raw/master/STM8_SPL_v2.2.0_SDCC.patch" && \
    cd /opt/STM8S_StdPeriph_Lib && \
    patch -p1 </tmp/STM8_SPL_v2.2.0_SDCC.patch && \
    rm -fr /tmp/stsw-stm8069.zip /tmp/STM8_SPL_v2.2.0_SDCC.patch

RUN wget -O /tmp/stx-btree-0.9.tar.bz2 "http://panthema.net/2007/stx-btree/stx-btree-0.9.tar.bz2" && \
    tar xvf /tmp/stx-btree-0.9.tar.bz2 -C /tmp && \
    cd /tmp/stx-btree-0.9 && \
    ./configure && \
    make -j && \
    make install-strip && \
    rm -fr /tmp/stx-btree-0.9.tar.bz2 /tmp/stx-btree-0.9

RUN wget -O /tmp/sdcc-3.6.0.tar.bz2 "https://sourceforge.net/projects/sdcc/files/sdcc/3.6.0/sdcc-src-3.6.0.tar.bz2/download" && \
    tar xvf /tmp/sdcc-3.6.0.tar.bz2 -C /tmp && \
    cd /tmp/sdcc-3.6.0 && \
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
    rm -fr /tmp/sdcc-3.6.0 /tmp/sdcc-3.6.0.tar.bz2

RUN apk del build-dependencies
