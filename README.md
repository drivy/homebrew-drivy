# Drivy's Formulas

To add our repository:

```shell
brew tap drivy/drivy
```

## mydumper

Homebrew provides a `mydumper` formula but doesn't support getting HEAD. And `mydumper` only supports dumping/loading JSON columns in the last commits, not released yet.

So to get the last version of `mydumper`:

```shell
brew install drivy/drivy/mydumper --HEAD
```
