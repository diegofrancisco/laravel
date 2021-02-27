# usa a imagem do php alpine como base
FROM php:7.3.6-fpm-alpine3.9

#instala o shadow para permitir o uso do comando usermod
RUN apk add --no-cache shadow bash mysql-client openssl
RUN docker-php-ext-install pdo pdo_mysql

# intala dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

#Define diretório padrão dentro do container
WORKDIR /var/www

#Apaga os arquivos da imagem original da pasta /var/www/html
RUN rm -rf /var/www/html 

#Copia os arquivos do diretório local (laravel foi instalado localmente nessa pasta) e os copia para a pasta var/www/ do container
COPY . /var/www

#Atribuir a arquivos e pastas que a propriedade é do usuário www-data
#RUN chown -R www-data:www-data /var/www

#Cria um link simbólico (atalho) para que o diretório html aponte para a pasta public (onde está o index.php do laravel)
RUN ln -s public html

#Atribuição do grupo 1000 ao usuário www-data
#RUN usermod -u 1000 www-data

#Atribuição do usuário www-data como usuário padrão em vez do root
#USER www-data

#Expõe a porta 9000
EXPOSE 9000

#Comando a ser rodado quando um container criado a partir dessa imagem rodas=e
ENTRYPOINT ["php-fpm"]
