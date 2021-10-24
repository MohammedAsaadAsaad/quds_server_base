# How to install
to initialize redis:
* Be sure that the current file is in the root folder:
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
run this command
`$ docker-compose up`


# To deploy
https://www.youtube.com/watch?v=mLHP_DHgBa4
In ternmial 
```bash
$ gcloud builds submit --tag gcr.io/quds-server-test/test_server_app
```