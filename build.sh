#!/bin/sh

cd /usr/local/src/mysql-4.0.27/
patch ./mysys/my_thr_init.c /usr/local/src/my_thr_init.c.patch
CC=/usr/bin/gcc34 CXX=/usr/bin/g++34 \
  ./configure --prefix=/usr/local/mysql --with-extra-charsets=complex --with-named-thread-libs="-lpthread" --localstatedir=/db
mkdir /usr/local/mysql \
      /usr/local/mysql/include \
      /usr/local/mysql/include/mysqlmkdir \
      /usr/local/mysql/lib \
      /usr/local/mysql/lib/mysql \
      /usr/local/mysql/share \
      /usr/local/mysql/man \
      /usr/local/mysql/mysql-test
make && make install

