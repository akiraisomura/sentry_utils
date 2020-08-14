# Sentry util

Sentry util is a ruby script list for dealing with sentry trouble.


## Usage

```
1. Bundle install

2. make .env file with below elements
  - ORGANIZATION: your sentry organization
  - PLAN: your sentry plan(developer, team, business)
  - SLACK_URL: your slack webhook url
  - SLACK_CHANNEL: target slack channnel
  - SENTRY_USERNAME: your sentry login username
  - SENTRY_PASSWORD: your sentry login password

2. bundle exec ruby alert_error_limit.rb
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
