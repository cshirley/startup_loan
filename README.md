[![Circle CI](https://circleci.com/gh/cshirley/startup_loan.svg?style=svg)](https://circleci.com/gh/cshirley/startup_loan)
[![Coverage Status](https://coveralls.io/repos/cshirley/startup_loan/badge.svg?branch=master)](https://coveralls.io/r/cshirley/startup_loan?branch=master)
[![Code Climate](https://codeclimate.com/github/cshirley/startup_loan/badges/gpa.svg)](https://codeclimate.com/github/cshirley/startup_loan)
# Startup Loans

API wrapper for http://www.startuploans.com leveraging Faraday.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'startup_loan', git: 'https://github.com/cshirley/startup_loan.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startup_loan

## Usage

Create Client:

```ruby
client = StartupLoan::Client.new({ base_uri: "http://....",
                                  api_key: "super_secret_squirrel"})
)
```
De-dupe check
```ruby
query_options = { emailaddress:"email_address",
                  postcode:"post_code",
                  phone_number:"phonenumber" }

true_or_false = StartupLoan::Applicant.duplicates?(client, query_options)
```


## Contributing

1. Fork it ( https://github.com/cshirley/startup_loan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
