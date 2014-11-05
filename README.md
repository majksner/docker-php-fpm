# PHP-FPM image for Docker

PHP Version: 5.5.18

Running container:

```
$ docker run -d -p 9000:9000 --name php-fpm majksner/php-fpm
```

Running container with shared folder:

```
$ docker run -d -p 9000:9000 --name php-fpm -v $HOME/shared:/data majksner/php-fpm
```
