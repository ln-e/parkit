Parsekit - Dependency manager for parser3
=========================================

It aims to manage your [parser3](http://parser.ru) project dependencies in
declarative way.


Installation
------------

Right now only manual install are available.
Download or clone files to some folder on your system, and add `bin/`
directory to your path.

If you haven't parser3 installed globally (through apt package in ubuntu or
added cgi to path) you should install parser in `parser/` directory inside
parsekit installation folder. Be careful and do not update parser/auto.p!

Then just verify installation by run
```shell
    $ parsekit
```
You should see table with available command.
After that your can start use parsekit.


Usage
-----

Create parsekit.json file in the root project folder. In the require section
specify which packages do you need, and their versions.

```json
    {
        "name":"New Project",
        "require":{
            "parser": ">=3.4.3",
            "test/a": ">=1.1 <=1.3",
            "test/b": ">=1.1 <=1.2",
            "test/c": "1.2"
        }
    }
```

Parsekit also supports range identifiers like `~` and `-`


Requirements
------------

[Parser](http://www.parser.ru/en/download/) 3.4.3 and above


TODO
----

* Check resolving algorithm for bugs
* Implement lazy DI "service" instantiating
* Implement better constraint collapsing (`>=1 <=2 <2` should collapsed to `>=1 <2`)
* Implement require command with interactive search/choose packages
* Improve console output
