#!/bin/bash
# Modify in 2015.0608
# Update PHP to 5.5.25

#cur_dir=$(cd "$(dirname "$0")"; pwd)
MYPATH=$(cd `dirname $0`;pwd)

groupadd www
useradd -s /sbin/nologin -g www www
yum install mysql libcurl libcurl-devel mysql-devel mysql-server libxml2 libxml2-devel libmcrypt libmcrypt-devel mysql-libs libjpeg-turbo-devel libpng-devel  freetype-develgd  gcc bison bison-devel zlib-devel libmcrypt-devel mcrypt mhash-devel openssl-devel libxml2-devel libcurl-devel bzip2-devel readline-devel libedit-devel sqlite-devel  freetype freetype-devel php-devel -y

yum install php-pear -y
cd $MYPATH
tar -xf php-5.5.25.tar.gz

SRC=./php-5.5.25

PREFIX=/usr/local/php-5.5
test -d $PREFIX && {
	echo "$PREFIX exits"
	exit 1
}

test -d $SRC && cd $SRC
./configure  --prefix=$PREFIX --with-fpm-user=www --with-fpm-group=www --with-config-file-path=$PREFIX/etc --with-bz2 --enable-calendar --enable-dba=shared --enable-sockets --enable-fpm --enable-opcache -with-iconv-dir=/usr/local/lib --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-debug --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --with-mcrypt --enable-ftp --with-gd  --with-sqlite=shared --with-pdo-sqlite=shared --enable-sqlite-utf8 --with-openssl --enable-soap --enable-pdo  
 
if [ "$?" != "0" ];then
	echo 'configure error'
	exit 1
fi
make -j8 && make install
test $? != 0 && {
	echo 'make error' 
	exit 2
}

cp php.ini-development $PREFIX/etc/php.ini
cp -v $PREFIX/etc/{php-fpm.conf.default,php-fpm.conf}

cp sapi/fpm/php-fpm $PREFIX/bin/ -v
cd ../

##需要着重提醒的是，如果文件不存在，则阻止 Nginx 将请求发送到后端的 PHP-FPM 模块， 以避免遭受恶意脚本注入的攻击
###redis
cd $MYPATH
tar -xf redis-2.2.4.tgz || exit 1
cd ./redis-2.2.4
$PREFIX/bin/phpize 
./configure --with-php-config=$PREFIX/bin/php-config 
egrep  '[^;]extension=redis.so' $PREFIX/etc/php.ini || echo 'extension=redis.so' >> $PREFIX/etc/php.ini
make && make install


cd ../

###memcache
cd $MYPATH
tar -xf memcache-2.2.7.tgz || exit 1
cd ./memcache-2.2.7
#(2.2.4报错。。)
$PREFIX/bin/phpize 
./configure --enable-memcache -with-php-config=$PREFIX/bin/php-config 
egrep '[^;]extension=memcache.so' $PREFIX/etc/php.ini || echo 'extension=memcache.so' >> $PREFIX/etc/php.ini
make && make install
cd ../


###dba
cd $SRC/ext/dba 
$PREFIX/bin/phpize 
./configure --enable-dba  --with-php-config=$PREFIX/bin/php-config
make && make install
egrep '[^;]extension=dba.so' $PREFIX/etc/php.ini || echo 'extension=dba.so' >> $PREFIX/etc/php.ini



###SQLite
cd $MYPATH
unzip sqlite.zip || exit 1
cd sqlite/
$PREFIX/bin/phpize
./configure --with-php-config=$PREFIX/bin/php-config
make && make install
egrep '[^;]extension=sqlite.so' $PREFIX/etc/php.ini || echo 'extension=sqlite.so' >> $PREFIX/etc/php.ini


sed -i.bak 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' $PREFIX/etc/php.ini
pro_num=`netstat -lntp | awk  '$4 ~ /^127.0.0.1:9004$/' | wc -l`
test "$pro_num" != "0" && {
	echo 'process exit'
	netstat -lntp | awk  '$4 ~ /^127.0.0.1:9004$/' 
	exit 1
}

sed -i.bak -re 's/((\s+|)listen(\s+|)=(\s+|)127.0.0.1(\s+|):).*/\19004/' $PREFIX/etc/php-fpm.conf
$PREFIX/sbin/php-fpm 

netstat -lntp | awk  '$4 ~ /^127.0.0.1:9004$/'  || {
	echo 'process start error'
	exit 1
}

