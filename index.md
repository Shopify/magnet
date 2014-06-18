---
layout: index
---

[![Build Status](https://secure.travis-ci.org/samuelkadolph/magnet.png?branch=master)](http://travis-ci.org/samuelkadolph/magnet)

# magnet

magnet is a library for decoding the track data on magnetic stripe cards.

## Description

magnet lets you parse track data from magnetic stripe cards. Currently supports tracks 1 & 2 from bank cards.

## Installation

Add this line to your application's Gemfile:

    gem "magnet"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install magnet

## Usage

```ruby
require "magnet"

card = Magnet::Card.parse("%B5452300551227189^HOGAN/PAUL      ^08043210000000725000000?")
card.expiration_month # => 04
card.expiration_year # => 08
card.format # => :bank
card.first_name # => "PAUL"
card.last_name # => "HOGAN"
card.number # => 5452300551227189
card.no_service_restrictions? # => true
card.process_by_issuer? # => true
```

## Contributing

Fork, branch & pull request.

## Sources

* [Track format of magnetic stripe cards](http://www.gae.ucm.es/~padilla/extrawork/tracks.html)
* [ISO 7813](http://en.wikipedia.org/wiki/ISO/IEC_7813)