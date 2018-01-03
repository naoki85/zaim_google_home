# README

## Prepare
1 Clone this repository  
2 [Install Docker](https://docs.docker.com/engine/installation/)
3 Create .env file  

```
$ touch .env
```

```
CONSUMER_KEY="YOUR_CONSUMER_KEY"
CONSUMER_SECRET="YOUR_CONSUMER_SECRET"
```
4 Start docker

```
$ docker-compose build
$ docker-compose up -d
```
5 Setup Database

```
$ docker-compose run ruby rake db:create
$ docker-compose run ruby rake db:migrate
```
6 Access  
[http://localhost:3000](http://localhost:3000)

## Check API Response
After authenticate `POST /api/index.json` with below params will return response.

```
# Require Params
{
  result: {
    parameters: {
      uid: 'test',
      password: '1111'
    }
  }
}
```

```
# Return Example
{
  'speech':'昨日は100円使いました',
  'displayText':'昨日は100円使いました',
}
```
## Stop Docker

```
$ docker-compose stop
```