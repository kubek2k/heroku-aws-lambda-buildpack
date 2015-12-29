# AWS Java Lambda deploy heroku buildpack

## The problem

While being a wonderful idea AWS Lambda doesn't provide any mechanisms neither for continous delivery, nor for configuration externalisation. Current state of service causes users to perform manual deployment of lambdas representing same logic, but different environments (dev/stage/prod). Additionally, there is no notion of configuration attached to lambda instances, which induces either a need to keep (supposedly secret) configuration along with lambda code, or to build env specific artifacts.

## Idea

This is an attempt to make configuration and pipelines management of lambdas a little bit less painful.
The idea is to use Heroku dyno as a basis for lambda creation. 
Here is how the whole thing works:

  - The buildpack:
    - Uses maven to traditionally build .jar artifact
    - Installs AWS CLI 
    - Installs a `deploy` process type in `Procfile` 
  - To deploy lambda use `heroku run deploy`, that does:
    - Inject all available env variables to `env.properties` file
    - `env.properties` file is being added to lambda artifact (this file should be used in lambda code to retrieve configuration)
    - lambda artifact gets deployed to AWS 

## Usage

### Set the buildpack

```
$ heroku buildpacks:set https://github.com/kubek2k/heroku-aws-java-lambda-buildpack
```

### Set env variables

  * `_LAMBDA_FUNCTION_NAME` - the ARN of lambda that is going to be deployed to
  * `_LAMBDA_JAR_FILE` - path to .jar artifact that is a product of mvn invocation (normally it should be something like "target/lambda-with-dependencies.jar")
  * `_AWS_ACCESS_KEY_ID` - AWS access key id used for deployment
  * `_AWS_SECRET_ACCESS_KEY` - AWS secret key used for deployment
  * `_AWS_DEFAULT_REGION` - AWS region to be used

All env variables starting with `_` sign are not injected into `env.properties` file

**URGENT:** The user owning the AWS access key :point_up: should have permissions to update function code (`Action: ["lambda:UpdateFunctionCode"]`)

### Push the code

```
$ git push heroku master
```

### Deploy code with injected configuration to AWS

```
$ heroku run deploy
```

## Pipelines support

Pipelines should work out of the box, but after each `promote` you have to remember to invoke `heroku run deploy` on application that was promoted to, so that changes are reflected on AWS.

## Configuration value change

As well as promotion, configuration changes require `heroku run deploy` to be ran after.

## What could be done better

First of all - this solution shouldn't be treated as neither something permanent nor final. 
  * Ideally Amazon will someday address issues that this buildpack tries to solve, and I will be able to delete it :),
  * I can see a huge issue with a requirement of invoking `heroku run deploy` after each deploy/configuration change/promotion. This is something that is really hard to automate within heroku. One way to somehow deal with it is to scale deploy worker to 1 `Free` dyno - it will cause the deploy to be run multiple times within the day, but its `Free` so... ;)
