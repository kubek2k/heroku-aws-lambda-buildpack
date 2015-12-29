# AWS Java Lambda deploy heroku buildpack

## The problem

## Idea

This is an attempt to make configuration and pipelines management of lambdas a little bit less painful.
The idea is to use Heroku dyno as a basis for lambda creation. 
Here is how the whole thing works:

  - The buildpack:
    - Uses maven to traditionally build .jar artifact
    - Installs AWS CLI 
    - Installs a `deploy` process type in `Procfile` 
  - To deploy lambda use: `heroku run deploy`, that does:
    - Inject all available env variables to `env.properties` file
    - `env.properties` file is being added to lambda artifact (this file should be used in lambda code to retrieve configuration)
    - lambda artifact gets deployed to AWS 

## Usage

### Use the buildpack
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
heroku run deploy
```
