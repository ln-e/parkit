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


Autoload
--------

Parsekit allows to forget about direct calls of `^use` or `@USE`. Any package as such as root package can
determine autload section in parsekit.

```
{
    "autoload": {
        "files":[
            "main.p"
        ],
        "nested-classpath": [
            "../src"
        ],
        "classpath":[
            "../classes",
            "../tests"
        ],
        "namespace":[
            "Vendor/Package": "path/to/src"
        ]
    }
}
```

Update you project dependencies or just call `parsekit dumpclasspath` and
add to you `auto.p` `^use[]` of automatically generated file:

```
@auto[]
    ^use[vault/classpath.p]
```

For parsekit.json listed above it will:
* use all files listed in `files` section i.e. `^use[main.p]`
* add all directories listed in `classpath` section to `$MAIN:CLASS_PATH`
i.e. `../classes` and `../tests`
* recursively add all directories found in `../src` to `$MAIN:CLASS_PATH`
* create `@autoload` method which can resolve `Vendor/Package/Folder/ClassName`
to `path/to/src/Folder/ClassName.p` inside which should be defined class
```parser3
@CLASS
Vendor/Package/Folder/ClassName
```


Requirements
------------

[Parser](http://www.parser.ru/en/download/) 3.4.3 and above


TODO
----

* Check resolving algorithm for bugs
* Implement better constraint collapsing (`>=1 <=2 <2` should collapsed to `>=1 <2`)
* Improve console output
