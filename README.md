# SHLE (Sinfin Heavily Light Establisher)

Application generator inspired by Suspenders and based on Rails generators.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shle

## Usage

Add credentials to your .profile.

```
export DIGITAL_OCEAN_TOKEN=TODO
export STAGING_AWS_KEY_ID=TODO
export STAGING_AWS_SECRET_ACCESS_KEY=TODO
export SHLE_DEFAULT_PASSWORD=TODO
```

Generate new `blog` application by

```
shle blog --domain www.blog.com --port 3020
```

## Advanced Usage

Shle is building on top of a normal Rails generator so you can supply
any valid Rails app template to it. For example this one

`build :ember_admin`

will give you a basi Ember admin skeleton. Use it by invoking:

```
shle blog --domain www.blog.com --port 3020 -m ./my_template.rb
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/shle/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
