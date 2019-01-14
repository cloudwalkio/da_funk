# DaFunk, happiness modularity

DaFunk is a Embedded System Framework optimized for programmer happiness and sustainable productivity. It encourages modulatiry by adapter pattern an beautiful code by favoring convention over configuration.

This project was created to run on top of [mruby runtime](https://github.com/mruby/mruby), and it's part of bigger ecosystem created by CloudWalk to help embedded delopers, to undertand better why CloudWalk creat it, check the [DaFunk Ecosystem session](https://github.com/cloudwalkio/da_funk#dafunk-ecosystem).

## How do I use DaFunk?

### Embedded Devices Engine

DaFunk is a gem to be used in MRuby environment, to provide the environment we created a CLI that is able to create, compile, run and test DaFunk Apps. You can check [CloudWalk Runtime Setup Page](https://docs.cloudwalk.io/pt-BR/cli/setup)

Project creation flow in Ruby environment:

```
cloudwalk new project
cd project
bundle install
bundle exec rake test:unit
```

### CRuby Projects

For more advanced users only wanting to use the `iso8583` module, here's how you require it:

```ruby
require 'da_funk/iso8583'
```

## DaFunk Ecosystem

Using mruby we have created some projects that are the basis of the CloudWalk ecosystem of developing payment applications for POS terminals.

### DaFunk API Architecture

![DaFunkMap](https://github.com/cloudwalkio/around_the_world/blob/master/imgs/apps.jpg?raw=true)


### Platform

[mruby-cloudwalk-platform](https://github.com/cloudwalkio/mruby-cloudwalk-platform) is the project responsible for the homologation/support of new devices, using mruby's toolkit this repository provides support for cross-compilation of new platforms, and the minimal and modular API between the device (in C) and the da_funk framework (in Ruby).

For more informations check the mruby-cloudwalk-platform [wiki page](https://github.com/cloudwalkio/mruby-cloudwalk-platform/wiki) and [mruby page](https://github.com/mruby/mruby).

### DaFunk

[da_funk] (https://github.com/cloudwalkio/da_funk) is an embedded system framework optimized for programmer happiness and productivity in a sustainable environment, it encourages, modularity using Adapter Pattern, and a beautiful code using convention on configuration.

### Apps

[cloudwalk cli](https://github.com/cloudwalkio/cloudwalk) is the project responsible to create, execute, test and deploy the application.

### Motivation

Check CloudWalk blog post about the motiviations create the this, [here.](https://www-staging.cloudwalk.io/en/blog/how-to-delivery-payment-applications-in-ruby)


## I would like to contribute

### What do I have here?

This repository contains a set of files and folder that compose the
**DaFunk API**. The structure goes as follows:

- The `guides` directory, which contains a group of files that are intended to instruct how to use our framework.
- An `imgs` directory, containing a picture that references the creative origins of this project.
- A `lib` directory, which holds the main source code of our Framework API.
  - `lib/da_funk` - DaFunk API, Helpers, Communication, Froms everything not related to a Device in order to help the developer.
  - `lib/device` - Interface between DaFunk API and homologate device
- An `out`directory, which has a previous generated binary of this project. All builds target this directory.
- A `test` directory with example test cases. Tests are divided by _integration_ tests and _unit_ tests.

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
