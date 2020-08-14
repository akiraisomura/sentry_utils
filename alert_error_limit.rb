# frozen_string_literal: true

require 'webdrivers/chromedriver'
require 'dotenv/load'
require 'yaml'
require 'slack-notifier'

def main
  error_count = fetch_latest_error_count
  return if error_count / error_limit.to_f * 100 < config['alert_threshold']

  message = format(config['error_message'], actual: error_count, limit: error_limit)
  post_message(message)
end

def fetch_latest_error_count
  login_sentry

  navigate_to_usage_history

  error_count = find_element_of_latest_error_count
  driver.quit
  error_count
end

def login_sentry
  driver.navigate.to(config['sentry_login_url'])
  sleep 1

  fill_form_value('username', ENV['SENTRY_USERNAME'])
  fill_form_value('password', ENV['SENTRY_PASSWORD'])
  driver.find_element(:xpath, "//button[@type='submit']").click
  sleep 1
end

def fill_form_value(name_key, value)
  driver.find_element(name: name_key).send_keys(value)
end

def navigate_to_usage_history
  usage_history_url = format(config['sentry_usage_history_url'], organization: ENV['ORGANIZATION'])
  driver.navigate.to(usage_history_url)
  sleep 2
end

def find_element_of_latest_error_count
  driver.find_element(:tag_name, 'table').find_element(:xpath, 'tbody/tr[1]/td[4]').text.gsub(',', '').to_i
end

def post_message(message)
  attachment = {
    text: message,
    color: 'warning'
  }

  slack_notifier.post(attachments: [attachment])
end

def driver
  @driver ||= Selenium::WebDriver.for :chrome, options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless])
end

def slack_notifier
  @slack_notifier ||= Slack::Notifier.new(
    ENV['SLACK_URL'],
    channel: ENV['SLACK_CHANNEL'],
    username: config['slack_alert_user_name']
  )
end

def config
  @config ||= YAML.load_file('config/setting.yml')
end

def error_limit
  config['plan'][ENV['PLAN']]['max_error']
end

main
