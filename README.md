# aws-cloud-automation-meetup-cicd

## order of resource creation

1. create the lambda function & test lambda within AWS console
2. create the API gateway & test API within AWS Console
3. create DynamoDb & test
4. test Lambda all the way to dynamo db
5. create the front end & test

## live demo

[![youtube link to recorded live demo](https://img.youtube.com/vi/MAhucSzRq8o/0.jpg)](https://www.youtube.com/watch?v=MAhucSzRq8o)

## AWS cloud meetup group
https://www.meetup.com/AWS-Cloud-Automation-Group/events/272012997/



## use case

A simple web application with interacting with a small and simple API endpoint where

## high level architecture

* web application code repo: https://github.com/michel-lacle/aws-cloud-automation-meetup-cicd-application-code
* cicd pipeline
* webserver
* vpc
* notification

![logo](docs/cicd-architecture.png)


## code pipeline architecture

![logo](docs/cicd-pipeline-architecture.png)

## development tech stack

* IDE: PyCharm with Terraform Extensions(without this you will suffer)
* Terraform version 0.12
* Github for storing the terraform code
