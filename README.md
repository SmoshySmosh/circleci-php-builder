# CircleCI PHP Builder
This docker container will allow you to build PHP packages that you can install via your `circle.yml`.


## Usage
You may either build this package locally or pull it from docker hub.

To build and use the container, simply run the following commands:
```bash
$ docker build -t circleci-php-builder .
$ docker run -e "PHP_VERSION=7.1.0" --rm -v $(pwd):/home/ubuntu/build circleci-php-builder
```

To use the docker hub version simply download the container from docker hub and run it using the following commands:
```bash
$ docker pull smoshysmosh/circleci-php-builder
$ docker run -e "PHP_VERSION=7.1.0" --rm -v $(pwd):/home/ubuntu/build smoshysmosh/circleci-php-builder
```

Running these commands should output the following file for you to upload to your web server:
`circleci-phpenv-php-7.1.0-amd64.deb`

## Notes
* If you dont pass a `PHP_VERSION`, the container will default to `7.1.0`.
* You will need to host the file on a public web server.
* Only versions of PHP that [phpenv](https://github.com/phpenv/phpenv) supports may be built.
* Currently only works for CircleCI 14.04 Build Containers.


## CircleCI Setup
After you have the package that is generated from the command above and have uploaded it to a public web server, installation is pretty simple. Simply add this to your `circle.yml` file:

```yaml
machine:
    pre:
        - curl -sSL -O https://<web-host>/circleci-phpenv-php-7.1.0-amd64.deb && sudo dpkg -i circleci-phpenv-php-7.1.0-amd64.deb
    php:
        version: 7.1.0
```

## Support
If you come across any issues or you have any questions, please file a github issue.
