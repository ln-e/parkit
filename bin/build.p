#!cgi/parser3.cgi

#------------------------------------------------------------------------------
#Build
#------------------------------------------------------------------------------
@main[][result]
    $date[^date::now[]]
    $builded[#Build ^date.gmt-string[]]

    $self.classes[^hash::create[]]
    $self.files[^hash::create[]]

    ^self.collectFile[.;parsekit.p]
    ^self.collectFile[../classes;Erusage.p]
    ^self.collectFile[../classes;ConsoleTable.p]

    ^self.collectClasses[../src]

    $concatedClasses[^hash::create[]]

    $loop(true)
    ^while($loop){
        $loop(false)

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

    ^builded.save[../build/parsekit.p]
    ^self.copy[parsekit;../build/parsekit]
    ^self.copy[parsekit.bat;../build/parsekit.bat]
    ^self.copy[eval.sh;../build/eval.sh]

    $result[Build success^#0A]
#--- end of main


@collectFile[dir;fileName][result]
    $className[^fileName.replace[.p;]]
    $file[^file::load[text;$dir/$fileName]]
    $matches[^file.text.match[@base\n([\S]+)][gim]]
    $self.classes.[$className][
        $.file[$dir/$fileName]
        $.class[$className]
        $.base[$matches.1]
        $.text[^file.text.match[@use\n(.*\.p\n)+][gmi]{}]
        $.concated(false)
    ]
###


@collectClasses[dir][result;locals]
    $list[^file:list[$dir]]
    ^list.menu{
        ^if($list.dir){
            ^self.collectClasses[$dir/$list.name]
        }(^list.name.match[.p^$][in]>0){
            ^self.collectFile[$dir;$list.name]
        }
    }
###


@copy[from;to]
    $file[^file::load[text;$from]]
    ^file.save[text;$to]
###