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
    $self.docroot[$request:document-root]
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
# Set docroot for that particular loader. @findClass return path relative from
# docroot set at the moment we call @findClass to that  stored docroot.
#
#:param path type string
#------------------------------------------------------------------------------
@setDocumentRoot[path]
  $self.docroot[$path]
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
        ^self.use[$path]
    }
###

#------------------------------------------------------------------------------
# Try to use in $self.docroot
# Todo probably it will be better to just resolve path and not change
# document-root each class call
#
#:param path type string
#------------------------------------------------------------------------------
@use[path]
    $docRootOrigin[$request:document-root]
    $request:document-root[$self.docroot]
    ^use[$path]
    $request:document-root[$docRootOrigin]
###


#------------------------------------------------------------------------------
#Try to find file that should be ^use in case of $class called
#
#:param class type string
#
#:result boolean
#------------------------------------------------------------------------------
@loadClass[className][result]
    $result(false)
    ^if(^self.classes.contains[$className]){
        ^self.use[$self.classes.$className]
        $result(true)
    }(def $self.namespaces && ^className.pos[/] != -1){
        ^self.namespaces.foreach[namespace;path]{
            ^if(^className.pos[$namespace] == 0){
                ^self.use[$path^className.mid(^namespace.length[]).p]
                $result(true)
                ^break[]
            }
        }
    }
    ^if(!$result){
        ^try{
            ^self.use[${className}.p]
            $result(true)
        }{
            $exception.handled(true)
        }
    }
###
