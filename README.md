# girls-meets-engineers

## Setup

```sh
$ cd /path/to/girls-meets-engineers
$ npm install
$ php composer.phar install
```

### For APIServer Developers

```sh
$ cd api_server
$ bundle install --path vendor/bundle
$ bundle exec rake db:migrate
```

## Development

```sh
$ gulp
$ php -S 127.0.0.1:8080 -t public/
```

Let's access [here](http://127.0.0.1:8080).

### For APIServer Developers

```sh
$ bundle exec rackup
```

## Requirements

* Node.js

  * Gulp

```sh
$ brew install nodejs
$ npm install -g gulp
```

* SQLite

```sh
$ brew install sqlite
```
