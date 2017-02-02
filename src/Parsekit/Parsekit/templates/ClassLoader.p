@CLASS
Parsekit/Parsekit/ClassLoader

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
    $self.classes[^hash::create[]]
    $self.namespaces[^hash::create[]]
    $self.files[^hash::create[]]
    $self.classpath[^table::create{path}]
###


#------------------------------------------------------------------------------
#Adds location of single class
#
#:param class type string
#:param path type string
#------------------------------------------------------------------------------
@addClass[class;path]
    $self.classes.$class[$path]
###


#------------------------------------------------------------------------------
#Adds location of namespace (class can be subclass of namespace) i.e. if
#namespace is Parsekit/Parsekit then Parsekit/Parsekit/Some/Class should be
#search in $path/Some/Class.p file
#
#:param class type string
#:param path type string
#------------------------------------------------------------------------------
@addNamespace[namespace;path]
    $self.namespaces.$class[$path]
###


#------------------------------------------------------------------------------
#Adds one directory to $MAIN:classpath
#
#:param class type string
#:param path type string
#------------------------------------------------------------------------------
@addClasspath[dir]
    ^self.classpath.append{$dir}
###


#------------------------------------------------------------------------------
#Adds single file to be called
#
#:param class type string
#:param path type string
#------------------------------------------------------------------------------
@addFile[file]
    $self.files.[^self.files._count[]][$file]
###



#------------------------------------------------------------------------------
#Make all common preparations like update $MAIN:classpath or ^use files
#------------------------------------------------------------------------------
@register[]
    ^if($MAIN:CLASS_PATH is table){
        ^MAIN:CLASS_PATH.join[$self.classpath]
    }{
        $MAIN:CLASS_PATH[$self.classpath]
    }

    ^self.files.foreach[key;path]{
        ^use[$path]
    }
###


#------------------------------------------------------------------------------
#Try to find file that should be ^use in case of $class called
#
#:param class type string
#
#:result string
#------------------------------------------------------------------------------
@findClass[className][result]
    $result[]
    ^if(^self.classes.contains[$className]){
        $result[$self.classes.$className]
    }(def $self.namespaces && ^className.pos[/] != -1){
        ^self.namespaces.foreach[namespace;path]{
            ^if(^className.pos[$namespace] == 0){
                $result[$path^className.mid(^namespace.length[]).p]
            }
        }
    }
###
