# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 20.03.16
# Time: 23:13
# To change this template use File | Settings | File Templates.

@CLASS
JsonFile

@OPTIONS
locals

@auto[]
###

#:constructor
#:param path type string Path to the json file
@create[path]
    $self.path[$path]
    $self.isLocal(!^self.path.match[^^https?])
    $self.data[]
    $self.rawData[]
    $self.isReaded(false)
    $self.isError(false)
###


# Returns path to file
#:result string
@getPath[]
    $result[$self.path]
###


#Check whatever file exists
#:result bool
@exists[]
    ^if($self.isLocal){
        $result(-f $path)
    }{
        ^if(!$self.isReaded){
            ^self.read[]
        }
        $result(!$self.isError)
    }
###


#Return contents of the file
#:result hash
@read[]
    $result[]
    ^try{
        $file[^file::load[text;$self.path]]
        $self.rawData[$file.text]
        ^if(!^self.validateSchema[]){
            ^throw[not-valid-schema]
        }
        $self.data[^JsonFile:decode[^taint[as-is][$self.rawData]]]
        $result[$self.data]
    }{
        $self.isError(true)
    }
###


#Saves new hash to file
#:param data type hash
@write[data]
    $result(false)
    ^if(!$self.isLocal){
        ^throw[remote-json-update]
    }
    ^try{
        $self.rawData[^JsonFile:encode[$data]]
        ^self.rawData.save[$self.path]
        $result(-f $self.path)
    }{
        $self.isError(true)
    }
###


#It should validate schema
#:result bool
@validateSchema[]
    ^rem{ TODO add real validating throw http://jsonschema.org }
    $result(true)
###


#Encodes data
#:param data type string
#:param options type hash
#:result string
@static:encode[data;options]
    $mergedOptions[
        $.indent(true)
    ]
    ^mergedOptions.add[$options]

    $result[^json:string[$data;$mergedOptions]]
###


#Decodes string
#:param string type string
#:result hash
@static:decode[string]
    $result[^json:parse[$string;
        $.distinct[first]
        $.taint[json]
    ]]
###
