# Filethis Ruby Bindings
[![CircleCI](https://circleci.com/gh/himaxwell/filethis-ruby/tree/master.svg?style=svg&circle-token=504daabdceb5219040794459a40abb5689d13fc1)](https://circleci.com/gh/himaxwell/filethis-ruby/tree/master)

The Filethis Ruby bindings provide a small SDK for convenient access to the Filethis API from applications written in the Ruby language. It provides a pre-defined set of classes for API resources that initialize themselves dynamically from API responses which allows the bindings to tolerate a number of different versions of the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filethis-ruby', git: 'git://github.com/himaxwell/filethis-ruby.git'
```

And then execute:

    $ bundle

## Usage

To execute API calls in irb you can run the following command from the project root, loading in the filethis gem

```ruby
  irb -r ./lib/filethis.rb
```

#### TODO : Create Initializer Generator

Create a `filethis` initializer in `config/initializers` directory and add the following:

```ruby
  require 'filethis'

  Filethis::Client.api_key = Rails.application.secrets.filethis_api_key
  Filethis::Client.api_secret = Rails.application.secrets.filethis_api_secret
```

To set credentials for Filethis, you'll need an `API_KEY` and an `API_SECRET`. To obtain these credentials, contact the folks at Filethis or obtain them from the `FileThisPartnerConsole`.

In your `secrets.yml` file add the following entries

```yaml
  filethis_api_key: 'some_api_key'
  fileethis_api_secret: 'some_api_secret'
```

### Available methods

There are A LOT of methods available. This wrapper makes use of `method_missing` and uses the method call to generate a path and request method (get, post, put, delete) for the resource.

The class you use doesn't really matter, as method missing is used on the `Base` class. The defined classes are more for seeing which endpoints are available without looking up the API docs. You could theoretically do the following:

```ruby
  Filethis::Help.accounts
```

The method call and supplied params generate the path, not the class.

### Params

There are two hashes of parameters you can pass to the method calls.

The first hash will be used to generate the path with the help of the method call. The order of the url params does matter as the values are zipped into the formatted method call.

```ruby
  Filethis::Account.accounts_connections({ accountId: '1234', connectionId: '1234' })
  # this generates a get request to /accounts/1234/connections/1234
  Filethis::Account.account_connection({ accountId: '1234', connectionId: '1234' })
  # Note: this is not a valid endpoint but it will generate the correct url if the endpoint is singular
  # this generates a get request to /account/1234/connection/1234
```

The second hash is a set of request parameters

```ruby
  url_params = { accountId: '1234' }
  request_params = { username: 'jappleseed', password: 'password', sourceId: '27' }
  Filethis::Account.create_accounts_connections(url_params, request_params)
```

To fetch a resource, there is no request method prefixed to the method call.

```ruby
  Module::Class.resources(params)
```

To create a resource, append create to the method call. Unfortunately, as it stand the wrapper expects the method to be plural. `_resources vs _resource`

```ruby
  Module::Class.create_resources(params)
```

To update a resource, append update to the method call. Unfortunately, as it stand the wrapper expects the method to be plural. `_resources vs _resource`

```ruby
  Module::Class.update_resources(params)
```

To delete a resource, append destroy to the method call. Unfortunately, as it stand the wrapper expects the method to be plural. `_resources vs _resource`

```ruby
  Module::Class.destroy_resources(params)
```

#### Accounts

```ruby
  Filethis::Account.accounts
  Filethis::Account.accounts
  Filethis::Account.create_accounts(url_params, request_params)
  Filethis::Account.update_accounts(url_params, request_params)
  Filethis::Account.destroy_accounts(url_params)
```

#### Account Connections

```ruby
  Filethis::AccountConnection.account_connections({ account_id: '' })
  Filethis::AccountConnection.account_connections({ account_id: '', connection_id: '' })

  Filethis::AccountConnection.create_account_connections(url_params, request_params)
  Filethis::AccountConnection.update_account_connections(url_params, request_params)
  Filethis::AccountConnection.destroy_account_connections(url_params)
```

#### Account Connection Interaction

```ruby
  Filethis::Interaction.account_connection_interactions({ account_id: '', connection_id: '' })
  Filethis::Interaction.account_connection_interactions(
    { account_id: '', connection_id: '', interaction_id: '' }
  )

  Filethis::Interaction.create_account_connection_interactions(
    { account_id: '', connection_id: '', interaction_id: '' }
  )
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/filethis-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

