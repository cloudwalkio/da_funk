## DaFunk Framework

DaFunk is a entire new framework for embedded applications running on top of MRuby runtime, initially design for Payment solutions.

https://github.com/cloudwalkio/around_the_world/blob/master/imgs/apps.jpg


## Ruby Compatiblity

Support for Ruby 1.9.3 and ISO/IEC 30170:2012, where specifies the syntax and semantics of the computer programming language Ruby, and the requirements for conforming Ruby processors, strictly conforming Ruby programs.

## Devices

#### PAX POS Device and Prolin OS

Payment solutions that suport complete EMV transaction, check [here](https://docs.cloudwalk.io/pt-BR/framework/pax-d200).

#### Gertec POS

Payment solutions that suport complete EMV transaction, check [here](https://docs.cloudwalk.io/pt-BR/framework/gertec).

#### Implement the runtime in your OS

The runtime is open source and available for study, change, and distribution, check [here](https://github.com/cloudwalkio/around_the_world).


## DaFunk API

![DaFunkMap](https://github.com/cloudwalkio/around_the_world/blob/master/imgs/apps.jpg?raw=true)

## How do I use DaFunk?

### Embedded Projects

DaFunk is a gem to be used in MRuby environment, to provide the environment we created a CLI that is able to create, compile, run and test DaFunk Apps. You can check [here](https://docs.cloudwalk.io/en/cli/setup)

Project creation flow in Ruby environment:

```
cloudwalk new project
cd project
bundle install
bundle exec rake test:unit
```

## Guides/Samples

Check test samples [here](da_funk/Guide.html).


## License

```
The MIT License (MIT)

Copyright (c) 2016 CloudWalk, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
### 
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
