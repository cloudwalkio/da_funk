# DaFunk, happiness modularity

DaFunk is a Embedded System Framework optimized for programmer happiness and sustainable productivity. It encourages modulatiry by adapter pattern an beautiful code by favoring convention over configuration.

## What do I have here?

This repository contains a set of files and folder that compose the
**DaFunk API**. The structure goes as follows:

- The `guides` directory, which contains a group of files that are intended to instruct how to use our framework.
- An `imgs` directory, containing a picture that references the creative origins of this project.
- A `lib` directory, which holds the main source code of our Framework API.
- An `out`directory, which has a previous generated binary of this project. All builds target this directory.
- A `test` directory with example test cases. Tests are divided by _integration_ tests and _unit_ tests.

## How do I use DaFunk?

### Embedded Projects

DaFunk is a gem to be used in MRuby environment, to provide the environment we created a CLI that is able to create, compile, run and test DaFunk Apps. You can check [here](http://github.com/da-funk/funky-cli)

Project creation flow in Ruby environment:

```
funky-cli new project
cd project
bundle install
bundle exec rake test:unit
```

### CRuby Projects

For more advanced users only wanting to use the `iso8583` module, here's how you require it:

```ruby
require 'da_funk/iso8583'
```

## I would like to contribute

Please follow the instructions:

1. Fork it under your github account!
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Added some feature'`
4. Push to the branch `git push origin my-new-feature`
5. Create a new Pull Request!

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT).

---

![DaFunk](https://raw.githubusercontent.com/cloudwalkio/da_funk/master/imgs/daft-punk-da-funk.jpg)
