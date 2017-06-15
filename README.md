# Lottery Checker

Small utility to fetch results of CA Lottery draws, parse them and match against provided "ticket" using simple CLI interface. All three major lotteries are supported - Powerball, Mega Millions and SuperLotto Plus.

## Usage and options

```
  Usage: lotto.rb [options]
    -l, --lotto TYPE                 Type of lotto. Default: [mega], Available: [mega, power, super]
    -n, --numbers A,B,C              6 numbers you bet on
    -d, --draws NUMBER_OF_DRAWS      Number of last draws to check, 20 default
    -h, --help                       Prints this help
```

Example of usage:

```
ruby lotto.rb -l power -n 1,2,3,4,5,6 -d 1
```

## Dependencies

Use `bundle install` or make sure you have:

* "rest-client"
* "nokogiri"

## TODO

There are several potential enhancements and features I might want to add some day:

- [ ] accept CLI option with date of specific draw
- [ ] accept CLI option with number of specific draw
- [ ] support input file with list of "tickets"; it might be just "space-delimited" one, or JSON/YAML with additional support for other parameters
- [ ] integration with some image processing library capable of recognizing number entries on actual lottery ticket
- [ ] simple web interface
- [ ] export for retrieved data
- [ ] make it a gem
