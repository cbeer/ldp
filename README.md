# Ldp.rb

Code:
[![Build Status](https://circleci.com/gh/samvera/ldp.svg?style=svg)](https://circleci.com/gh/samvera/ldp)
[![Version](https://badge.fury.io/rb/ldp.png)](http://badge.fury.io/rb/ldp)
[![Coverage Status](https://coveralls.io/repos/github/samvera/ldp/badge.svg?branch=master)](https://coveralls.io/github/samvera/ldp?branch=master)

Docs:
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE.txt)

Jump In: [![Slack Status](http://slack.samvera.org/badge.svg)](http://slack.samvera.org/)

# What is ldp?

Linked Data Platform client library for Ruby

## Product Owner & Maintenance

**ldp** is a Core Component of the Samvera community. The documentation for
what this means can be found
[here](http://samvera.github.io/core_components.html#requirements-for-a-core-component).

### Product Owner

[randalldfloyd](https://github.com/randalldfloyd)

# Help

The Samvera community is here to help. Please see our [support guide](./SUPPORT.md).

## Installation

Add this line to your application's Gemfile:

    gem 'ldp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ldp

## Usage

```ruby
host = 'http://localhost:8080'
client = Ldp::Client.new(host)
resource = Ldp::Resource.new(client, host + '/rest/node/to/update')
orm = Ldp::Orm.new(resource)

# view the current title(s)
orm.orm.value(RDF::DC11.title)

# update the title
orm.graph.delete([orm.resource.subject_uri, RDF::DC11.title, nil])
orm.graph.insert([orm.resource.subject_uri, RDF::DC11.title, 'a new title'])

# save changes
orm.save
```
## Testing:

- Set Rails version you want to test against. For example:

  - `export RAILS_VERSION=5.1.4`

- Ensure that the correct version of Rails is installed: `bundle update`

- And run tests: `bundle exec rake rspec`

## Releasing

1. `bundle install`
2. Increase the version number in `lib/ldp/version.rb`
3. Increase the same version number in `.github_changelog_generator`
4. Update `CHANGELOG.md` by running this command:
  ```
  github_changelog_generator --user samvera --project ldp --token YOUR_GITHUB_TOKEN_HERE
  ```
5. Commit these changes to the master branch
6. Run `rake release`

# Acknowledgments
This software has been developed by and is brought to you by the Samvera community.  Learn more at the
[Samvera website](http://samvera.org)

![Samvera Logo](https://wiki.duraspace.org/download/thumbnails/87459292/samvera-fall-font2-200w.png?version=1&modificationDate=1498550535816&api=v2)
