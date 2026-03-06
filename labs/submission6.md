# Lab 6 — Container Fundamentals with Docker
**Goal**: Master Docker fundamentals through hands-on container management, image operations, networking, and storage tasks.

## Task 1 — Container Lifecycle & Image Management 

> docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

> docker images ubuntu
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ubuntu       latest    bbdabce66f1b   3 weeks ago   78.1MB

Image size  is *78.1MB* and layer count is one

> docker save -o ubuntu_image.tar ubuntu:latest
ls -lh ubuntu_image.tar
-rwxrwxrwx 1 dhehehe dhehehe 77M Mar  5  2026 ubuntu_image.tar

Tar file size: 77 M

> docker rmi ubuntu:latest
Error response from daemon: conflict: unable to remove repository reference "ubuntu:latest" (must force) - container 4a4957fc0f3e is using its referenced image bbdabce66f1b

Docker не позволяет удалить образ, пока на него ссылается хотя бы один контейнер (даже остановленный). Они зависят от образов

*Образ* — это неизменяемый шаблон, состоящий из слоёв файловой системы и метаданных.

*Контейнер* — запущенный экземпляр образа, который добавляет поверх слоёв тонкий слой записи.

Команда `docker save -o ubuntu_image.tar ubuntu:latest` создаёт архив, который содержит полную копию образа, включая:

- Слои образа — каждый слой представлен отдельной директорией с именем его SHA-хеша. Внутри каждой директории:

`layer.tar` — архив с файловыми изменениями этого слоя.

`json` — метаданные слоя.

Файл манифеста `manifest.json` — описывает структуру образа: порядок слоёв, тег, имя конфигурационного файла.

Конфигурационный файл образа — содержит архитектуру, переменные окружения, команду по умолчанию, историю сборки и другие параметры.

## Task 2 — Custom Image Creation & Analysis

original welcome page
![alt text](image-2.png)

custom HTML content and verification via curl
![alt text](image-3.png)

output of `docker diff my_website_container`
![alt text](image-5.png)

Analysis: Explain the diff output

Команда `docker diff` показывает изменения в файловой системе контейнера относительно его базового образа. В выводе:

`C` означает, что файл или директория были изменены (Changed)

В списке отсутствуют `A` (Added) и `D` (Deleted)

`docker commit` позволяет быстро сохранить состояние

в `docker diff` для нового контейнера можно увидеть, что там не было моего файла — изменения уже внутри образа, и я не могу понять, как именно они были сделаны. Если бы я потеряла исходный index.html, я бы не смогла восстановить процесс.

Dockerfile лучше, потому что в нём всё описано явно: FROM, COPY. Его можно передать другому, и он точно соберёт такой же образ. Минус — нужно писать код и разбираться в инструкциях.

## Task 3 — Container Networking & Service Discovery

![alt text](image-4.png)

> $ docker run -dit --network lab_network --name container1 alpine ash
e390b4bb2b6d945d909fe7d9850f383bad992576e62cd43af9ac0b9a943f632c

> $ docker run -dit --network lab_network --name container2 alpine ash
09ffe68ce55c92d7226d358cf62b3f4ae29c541cdca4b85f8700a8df594f3449

![alt text](image-6.png)

> $ docker network inspect lab_network
[
    {
        "Name": "lab_network",
        "Id": "1d5b0a53a2d17c0f6ffa89a5d662d4889227efec88e5567832b9b05b7be0a310",
        "Created": "2026-03-06T11:30:53.490474095+03:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "09ffe68ce55c92d7226d358cf62b3f4ae29c541cdca4b85f8700a8df594f3449": {
                "Name": "container2",
                "EndpointID": "e960b825f2345ec318e6c0128512653bcf8bd021ef77a15d6f14d05d11a0eca0",
                "MacAddress": "92:83:a0:59:bd:50",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "e390b4bb2b6d945d909fe7d9850f383bad992576e62cd43af9ac0b9a943f632c": {
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "e390b4bb2b6d945d909fe7d9850f383bad992576e62cd43af9ac0b9a943f632c": {
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5                "IPv6Address": ""
            },
            "e390b4bb2b6d945d909fe7d9850f383bad992576e62cd43af9ac0b9a943f632c": {
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5            },
            "e390b4bb2b6d945d909fe7d9850f383bad992576e62cd43af9ac0b9a943f632c": {
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5            "e390b4bb2b6d945d909fe7d9850f383bad992576e62cd43af9ac0b9a943f632c": {
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5 {
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5e4b31c7ec473ea37",
                "MacAddress": "8e:c9:c1:e0:39:85",
                "Name": "container1",
                "EndpointID": "e3323b8c72d628034c74a115b1d26918bce1191c310172d5e4b31c7ec473ea37",
                "MacAddress": "8e:c9:c1:e0:39:85",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
e4b31c7ec473ea37",
                "MacAddress": "8e:c9:c1:e0:39:85",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
        },
        "Options": {},
        "Labels": {}
    }
]
        "Labels": {}
    }
]

> $ docker exec container1 nslookup container2
Server:         127.0.0.11
Address:        127.0.0.11:53

Non-authoritative answer:
Name:   container2
Address: 172.18.0.3

В пользовательских bridge-сетях Docker автоматически запускает встроенный DNS-сервер на адресе 127.0.0.11. Когда контейнер пытается обратиться к другому контейнеру по его имени (например, container2), запрос отправляется на этот DNS-сервер. Docker ведёт внутреннюю таблицу соответствия имён контейнеров их IP-адресам в данной сети. Таким образом, контейнеры могут общаться по именам, независимо от того, какие IP они получили при запуске. Это удобно и устраняет необходимость вручную отслеживать IP-адреса.

Пользовательские bridge-сети предоставляют встроенное разрешение имён, лучшую изоляцию и гибкость настройки, что делает их предпочтительными для большинства сценариев микросервисной архитектуры

## Task 4 — Data Persistence with Volumes


> $ docker volume create app_data
app_data

> $ docker volume ls
DRIVER    VOLUME NAME
local     app_data

> $ docker run -d -p 80:80 -v app_data:/usr/share/nginx/html --name web nginx
6c52d168a461...

$ echo '<html><body><h1>Persistent Data</h1></body></html>' > index.html

$ docker cp index.html web:/usr/share/nginx/html/
Successfully copied 2.05kB to web:/usr/share/nginx/html/

$ curl http://localhost
<html><body><h1>Persistent Data</h1></body></html>

$ docker stop web && docker rm web
web
web

$ docker run -d -p 80:80 -v app_data:/usr/share/nginx/html --name web_new nginx
3e7a1b8c9f0d...

$ curl http://localhost
<html><body><h1>Persistent Data</h1></body></html>

Данные сохранились после пересоздания контейнера.

> $ docker volume inspect app_data
[
    {
        "CreatedAt": "2026-03-06T11:53:17+03:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/app_data/_data",
        "Name": "app_data",
        "Options": null,
        "Scope": "local"
    }
]

**Why is data persistence important in containerized applications?**
при удалении контейнеров все внутренние данные теряются. Для приложений, которым нужно сохранять состояние (базы данных, пользовательский контент, логи), необходимы механизмы хранения вне жизненного цикла контейнера. Тома позволяют отделить данные от контейнера, обеспечивая их сохранность при обновлениях, сбоях или миграции.

Тома — предпочтительный способ для постоянных данных, bind mounts удобны для разработки, а внутреннее хранилище подходит только для эфемерной информации.


