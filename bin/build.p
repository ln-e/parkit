#!cgi/parser3.cgi
@USE
../classes/Debug.p

#------------------------------------------------------------------------------
#Build
#------------------------------------------------------------------------------
@main[][result]
    $date[^date::now[]]
    $builded[#Build ^date.gmt-string[]]

    $self.classes[^hash::create[]]
    $self.files[^hash::create[]]

    ^self.collectFile[../bin;parsekit.p]
    ^self.collectClass[../classes;Erusage.p]

    ^self.collectClasses[../src]
    ^self.collectClasses[../vault]

    $concatedClasses[^hash::create[]]

    $loop(true)
    ^while($loop){
        $loop(false)

        ^self.files.foreach[key;data]{
            $builded[$builded^#0A$data^#0A]
        }

        ^self.classes.foreach[className;data]{
            ^if(!$data.concated && (!def $data.base || ^concatedClasses.contains[$data.base])){
                $self.classes.[$className].concated(true)
                $builded[$builded^#0A$data.text^#0A]
                $concatedClasses.[$data.class][]
            }(!$data.concated){
                $loop(true)
            }
        }
    }

    ^builded.save[../build/bin/parsekit.p]
    ^self.copy[parsekit;../build/bin/parsekit]
    ^self.copy[parsekit.bat;../build/bin/parsekit.bat]
    ^self.copy[eval.sh;../build/bin/eval.sh]
    ^self.copy[eval.sh;../build/bin/eval.bat]

    $empty[]
    ^empty.save[../build/cgi/.gitkeep]

    $result[Build success^#0A]
#--- end of main


@collectFile[dir;fileName][result]
    $file[^file::load[text;$dir/$fileName]]
    $text[^file.text.match[\s([^^\^^]?\^^use\[\S*\])][giU]{}]
    $self.files.[^self.files._count[]][$text]
###


@collectClass[dir;fileName][result]
    $file[^file::load[text;$dir/$fileName]]
    $matches[^file.text.match[@CLASS\n(\S+)][gi]]
    $className[$matches.1]
    $matches[^file.text.match[@base\n([\S]+)][gim]]
    $text[^file.text.match[@use\n(.*\.p\n)+][gmi]{}]
    $text[^text.match[\s([^^\^^]?\^^use\[\S*\])][giU]{}]
    $self.classes.[$className][
        $.file[$dir/$fileName]
        $.class[$className]
        $.base[$matches.1]
        $.text[$text]
        $.concated(false)
    ]
###


@collectClasses[dir][result;locals]
    $list[^file:list[$dir]]
    ^list.menu{
        ^if($list.dir){
            ^self.collectClasses[$dir/$list.name]
        }(^list.name.match[.p^$][in]>0){
            ^self.collectClass[$dir;$list.name]
        }
    }
###


@copy[from;to]
    $file[^file::load[text;$from]]
    ^file.save[text;$to]
###
