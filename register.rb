# coding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'mastodon'
require 'readline'

require "oauth2"
require 'json'

module Register
  APP_NAME = "Name Change Detecter"
  DEFAULT_CONFIG = {
    "host" => "mstdn-workers.com",
    "scopes" => "read write",
  }
  TOKEN_FILE_NAME = '.access_token'
  DEFAULT_CONFIG_FILE_NAME = 'config.json'

  def init_app
    base_url = 'https://' + config["host"]
    Mastodon::REST::Client.new(base_url: base_url,
                               bearer_token: access_token)
  end

  def config
    if File.exist? DEFAULT_CONFIG_FILE_NAME
      JSON.parse(File.read(DEFAULT_CONFIG_FILE_NAME))
    else
      save_config(DEFAULT_CONFIG)
      DEFAULT_CONFIG
    end
  end

  def access_token
    if File.exist? TOKEN_FILE_NAME
      load_access_token
    else
      base_url = 'https://' + config["host"]
      scopes = config["scopes"]
      client = Mastodon::REST::Client.new base_url: base_url
      app = client.create_app(APP_NAME, "urn:ietf:wg:oauth:2.0:oob", scopes)
      client = OAuth2::Client.new(app.client_id, app.client_secret, site: base_url)
      client.password.get_token(user_email, user_password, scope: scopes).token.tap { |t| save_access_token t }
    end
  end

  private

  def save_config(config)
    File.write(DEFAULT_CONFIG_FILE_NAME, JSON.dump(config))
  end

  def load_access_token
    File.read(TOKEN_FILE_NAME).chomp
  end

  def save_access_token(token)
    File.write(TOKEN_FILE_NAME, token)
  end
end
