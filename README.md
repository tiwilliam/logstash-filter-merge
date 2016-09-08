# Logstash Merge Filter Documentation

[![Travis Build Status](https://travis-ci.org/tiwilliam/logstash-filter-merge.svg)](https://travis-ci.org/tiwilliam/logstash-filter-merge)
[![Gem Version](https://badge.fury.io/rb/logstash-filter-merge.svg)](https://badge.fury.io/rb/logstash-filter-merge)

This filter helps you to merge your fields.

## Merge with root

```
merge {
    field => "something"
}
```

## Merge with custom target

```
merge {
    field => "something"
    target => "something_else"
}
```

## Merge with whitelisted keys

```
merge {
	field => "something"
	whitelist => ["user_agent", "browser_family"]
}
```

## Filter options

* **field**

  The source field to read data from.

* **target**

  The field to merge source field with. Defaults to event root.

* **overwrite**

  Overwrite target fields with source field. Defaults to `true`.

* **whitelist**

  If source is a hash, only merge keys listed in this array. Disabled by default.

## Changelog

You can read about all changes in [CHANGELOG.md](CHANGELOG.md).

## Need help?

Need help? Try #logstash on freenode IRC or the [Logstash discussion forum](https://discuss.elastic.co/c/logstash).

## Want to contribute?

Get started by reading [BUILD.md](BUILD.md).
