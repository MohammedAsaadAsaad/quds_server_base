# Quds Server Base
This project is a simple project to be cloned to use `Quds Server` to make fast dart server app.

* This project sample uses `Quds Server` as its core.
https://pub.dev/packages/quds_server
* For data repositories, it uses `Quds MySql`
https://pub.dev/packages/quds_mysql
* It contains some initial some `routers` & `controllers` & `middlewares` & `database repositories`.
* In addition it uses `JWT` to initialize the authorization servce, which depents on `Redis` for storing.
---
## To initialize `Redis`:
 Be sure that the current file is in the root folder:

`docker-compose.yml`

with content like:
```yaml
version: "3.9"
services:
  redis:
    image: "redis:alpine"
    ports:
      - "6379:6379"
```
Then run this command
```shell
$ docker-compose up
```

---
## To deploy dart server app:
https://www.youtube.com/watch?v=mLHP_DHgBa4

In ternmial 
```shell
$ gcloud builds submit --tag gcr.io/your_project/your_server_app
```