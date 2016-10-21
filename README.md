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

There are a few ways to set the credentials for Filethis...

You'll need a **ticket**

The filethis ticket can be found after logging into your account with the supplied partner credentials and looking for the ticket url param in the url.

Initialize a new client by setting `filethis_ticket` in `secrets.yml`.
Initialize a new client by setting `ENV['FILETHIS_TICKET']`
Initialize a new client by passing the ticket into each request as a parameter.

### Available methods

There are A LOT of methods available. This wrapper makes use of `method_missing` and uses the method call to generate a path and request method (get, post, put, delete) for the resource.

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
  Filethis::Account.accounts('36')
  Filethis::Account.create_accounts({})
  Filethis::Account.update_accounts({})
  Filethis::Account.destroy_accounts({})
```

#### Account Connections

```ruby
  Filethis::AccountConnection.account_connections({ account_id: '' })
  Filethis::AccountConnection.account_connections({ account_id: '', connection_id: '' })

  Filethis::AccountConnection.create_account_connections({})
  Filethis::AccountConnection.update_account_connections({})
  Filethis::AccountConnection.destroy_account_connections({})
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

# TODO : Finish Documentation


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/filethis-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

