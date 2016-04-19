@dstop[o]
	^if(^Debug:isDeveloper[]){
		^process[$MAIN:CLASS]{@unhandled_exception[hException^;tStack]^#0A^^Debug:exception[^$hException^;^$tStack]}
		^if($o is double){ ^Debug:stop($o) }{ ^Debug:stop[$o] }
	}
	$result[]

@dshow[o][result]
	^if(^Debug:isDeveloper[] && (!def $form:mode || $form:mode ne xml)){
		^if($o is double){ ^Debug:show($o) }{ ^Debug:show[$o] }
	}

@dcompact[h][result]
	^Debug:compact[^hash::create[$h]]

@CLASS
Debug

@USE
ConsoleHelper.p

@auto[]
	$self.bDeveloper(^env:REMOTE_ADDR.match[^^127\.0\.|^^91\.197\.114|^^91\.197\.113^$|^^58\.96\.54\.98^$|^^10\.0\.|^^^$]))
	$self.tReplacePath[^table::create[nameless]{^if(def $env:DOCUMENT_ROOT){^env:DOCUMENT_ROOT.trim[end;/]	&#8230^;}}]
	$self.sSavePath[/../data/log/debug.html]
	$self.hStatistics[
		$.iCalls(0)
		$.iCompact(0)
		$.hUsage[
			$.hBegin[$status:rusage]
		]
		$.hMemory[
			$.iEnd(0)
			$.iCollected(0)
			$.iBegin($status:memory.used)
		]
		$.fStartTime($status:rusage.tv_sec+$status:rusage.tv_usec/1000000)
	]
	
	$self.sConsole[^self.getInfo[]]

	$self.iTabSize(4)

	$self.iLimit(16384)
	$self.iCall(0)
	$self.iHashId(0)

	$self.iShift(0)
	$self.hShowing[^hash::create[]]

@isDeveloper[][result]
	$result($bDeveloper)

@exception[hException;tStack]
	$response:status(500)
	$response:content-type[
		$.value[text/html]
		$.charset[$response:charset]
	]
	<div id="_D">
		^if($hException.type eq "debug"){
			^untaint[as-is]{$hException.source}
		}{
			<pre>^untaint[html]{$hException.comment}</pre>
			^if(def $hException.source){
				<b>$hException.source</b><br>
				<pre>^untaint[html]{$hException.file^($hException.lineno^)}</pre>
			}
			^if(def $hException.type){ exception.type=$hException.type }
		}
		^if($tStack is table){
            ^ConsoleHelper:formatTable[$tStack]
#^tStack.menu{^if($hException.type eq debug && ^tStack.line[] < 4 && $tStack.name ne rem){}{|  ^^$tStack.name | ^file:dirname[^if(def $tStack.file){^tStack.file.replace[$self.tReplacePath]}]/<i>^file:basename[$tStack.file] ^[$tStack.lineno^]</i><sup>$tStack.colno</sup>|}}[
#]
		}
	</div>
	
	

@extendPostprocess[]
	^if($MAIN:postprocess is junction){
		$MAIN:jOriginalPostprocess[$MAIN:postprocess]
	}
	^process[$MAIN:CLASS]{@postprocess[body][result]
		^^if(^$MAIN:jOriginalPostprocess is junction){
			^$body[^^MAIN:jOriginalPostprocess[^$body]]
		}
		^^if(^$Debug:iCall){
			^$result[^^body.match[(<body[^^^^>]*>)?][i]{^$match.1<div style="display:none" id="_D">^^Debug:getScript^[^]^$Debug:sConsole</div>}]
		}
	}

@getInfo[]
$dNow[^date::now[]]
^rem{ посчитать параметры запроса }
$uriParam[^request:uri.match[^^[^^\?]*\??(.*)?][]{$match.1}]
$uriParam[^uriParam.split[&]]
$uriParamReal(0)
$queryParam[$request:query]
$queryParam[^queryParam.split[&]]
$queryParamCount(^queryParam.count[]-^uriParam.count[])
^if($form:tables is "hash"){^form:tables.foreach[;val]{^uriParamReal.inc(^val.count[])}}
$result[<dfn>
	${dNow.hour}:^dNow.minute.format[%.02u]:^dNow.second.format[%.02u]&#160^;
	<em>[^if(def $env:REMOTE_HOST && $env:REMOTE_HOST ne $env:REMOTE_ADDR){REMOTE_ADDR: $env:REMOTE_ADDR REMOTE_HOST: $env:REMOTE_HOST}{$env:REMOTE_ADDR}]&#160^;
	^env:PARSER_VERSION.match[compiled on ][]{}</em>&#160^;
	post/get/query: ^eval($uriParamReal-^queryParam.count[])/^uriParam.count[]/$queryParamCount&#160^;
	^if($cookie:fields){cookie: ^cookie:fields._count[]}
</dfn>
<hr />]

@compact[hParam][iPrevUsed;result]
^hStatistics.iCalls.inc(1)
^if($hParam.bForce || !$hStatistics.hMemory.iEnd || ($self.iLimit && ($status:memory.used - $hStatistics.hMemory.iEnd) > $self.iLimit)){
	^hStatistics.iCompact.inc(1)
	$iPrevUsed($status:memory.used)
	^memory:compact[]
	^hStatistics.hMemory.iCollected.inc($iPrevUsed - $status:memory.used)
	$hStatistics.hMemory.iEnd($status:memory.used)
}

@showSystemParam[][result]
$self.hStatistics.hMemory.iEnd($status:memory.used)
$self.hStatistics.hUsage.hEnd[$status:rusage]
$usage((^self.hStatistics.hUsage.hEnd.tv_sec.double[] -
				^self.hStatistics.hUsage.hBegin.tv_sec.double[]) +
				(^self.hStatistics.hUsage.hEnd.tv_usec.double[] -
				^self.hStatistics.hUsage.hBegin.tv_usec.double[])/1000000)
$utime($self.hStatistics.hUsage.hEnd.utime - $self.hStatistics.hUsage.hBegin.utime)
$result[
+------------------------+-----------+
| memory used/collected: | $self.hStatistics.hMemory.iEnd/$self.hStatistics.hMemory.iCollected KB |
| calls/dcompacts:       | $self.hStatistics.iCalls/$self.hStatistics.iCompact       |
| Usage:                 | ^usage.format[%.3f] s,  |
| Utime:                 | ^utime.format[%.3f] s   |
+------------------------+-----------+
]

@show[o][result]
^if(!$self.iCall){^extendPostprocess[]}
$self.iCall(1)
$sConsole[$sConsole
^showSystemParam[]
<pre>^apply-taint[html][^if($o is double){^showObject($o)}{^showObject[$o]}]</pre>
]

@stop[o][result]
^if($o is "double"){ ^self.show($o) }{ ^self.show[$o] }
^sConsole.save[$self.sSavePath]
^throw[debug;$sConsole]

@showObject[o][result;jShow]
^iHashId.inc[]
^if($o is "string" && !def $o){
	^show_void[]
}{
	$jShow[$[show_$o.CLASS_NAME]]
	^if($jShow is junction){
		^if($o is double){^jShow($o)}{^jShow[$o]}
	}{
		^show_userclass[$o]
	}
}

@show_userclass[o][sTabs;i;j;jForeach;hMethods;hFields;sName;h;z;sUID;t]
$sTabs[^for[i](1;$self.iShift){&#09^;}]
$sUID[^reflection:uid[$o]]
$z[^reflection:class[$o]]
$result[<u class="userclass value">^reflection:class_name[$o]</u> (UID: $sUID)^while(def ^reflection:base[$z]){ &lt^;= ^reflection:base_name[$z]$z[^reflection:base[$z]]}:]
^if($self.hShowing.$sUID){
	$result[$result -already shown- (recursion?)]
}{
	$hMethods[^reflection:methods[$o.CLASS_NAME]]
	^if($hMethods){
		$jForeach[^reflection:method[$hMethods;foreach]]
		$t[^table::create{name}]
		^jForeach[sName;]{^t.append{$sName}}
		^t.sort{$t.name}
		$result[${result}^#0A&#09^;$sTabs<span class="hide" onclick="sh('obj_methods_$iHashId')">Methods</span> (^t.count[])<span id="obj_methods_$iHashId" style="display:none">^t.menu{$h[^reflection:method_info[$o.CLASS_NAME;$t.name]]^#0A&#09^;$sTabs<span title="^if($h){^file:dirname[^h.file.replace[$self.tReplacePath]]/^file:basename[$h.file]}">^@$t.name^[^for[j](0;100){^if(def $h.$j){$h.$j}{^break[]}}[^;]^]</span>}</span>^#0A$sTabs]
	}
	$self.hShowing.$sUID(true)
	$hFields[^reflection:fields[$o]]
	^if($hFields){
		$result[$result^show_hash[$hFields]]
	}
	^self.hShowing.delete[$sUID]
}

@show_void[o]
$result[<span class="void value">void</span>]

@show_bool[o]
$result[<span class="bool value">^if($o){true}{false}</span>]

@show_string[o]
$result[<span class="string value">^taint[$o]</span>]

@show_int[o]
$result[<span class="numeric value">$o</span>]

@show_double[o]
$result[<span class="numeric value">$o</span>]

@show_date[d]
$result[<del>^^date::create^[</del><span class="date value">^d.sql-string[]</span><del>^]</del>]

@show_hash[h;b;sort][k;v;sTabs;i;j;sUID;s]
$sUID[^reflection:uid[$h]]
^if($self.hShowing.$sUID){
	$result[$result -already shown- (recursion?)]
}{
	$self.hShowing.$sUID(true)
	^self.iShift.inc[]
	$sTabs[^for[i](2;$self.iShift){&#09^;}]
	$j[^reflection:method[$h;foreach]]
	$result[^if($h){
<span class="hash value">^j[k;v]{$s[^k.match[(.*[^^a-zа-я0-9_\-].*)][i]{<s>^[</s>$match.1<s>^]</s>}]&#09^;$sTabs^switch(true){^case($v is "double" || $v is "int" || $v is "bool"){<var>^$.$s</var>(^self.showObject($v))}^case($v is "junction"){<var>^$.$s</var>^{-junction-here-^}}^case($v is "string" || $v is "date"){<var>^$.$s</var>^[^self.showObject[$v]^]}^case[DEFAULT]{<var>^$.<span class="hide" onclick="sh('hash_$iHashId', true)"^if($v is "hash" || $v is "table"){ title="Items: ^eval($v)"}>$s</span></var>^[<span id="hash_$iHashId">^self.showObject[$v]</span>^]}}
}</span>$sTabs}{<del>^^hash::create^[</del>-empty-hash-here-<del>^]</del>}]
	^self.iShift.dec[]
	^self.hShowing.delete[$sUID]
}

@show_table[t][tCol;tFlipped;bNamless;bF;sTabs;fMarginLeft;i]
	$tCol[^t.columns[]]
	^if(!$tCol){
		$bNamless(true)
		$tFlipped[^t.flip[]]
		$tCol[^table::create{column}]
		^for[i](0;$tFlipped-1){^tCol.append{$i}}
		$t[^tFlipped.flip[]] ^rem{ it helps for named tables without columns }
	}{
		$bNamless(false)
	}
	$sTabs[^for[i](1;$self.iShift){&#09^;}]
	$fMarginLeft($self.iShift*5)
	^if($self.iShift > 0){^fMarginLeft.inc(5)}
	$bF(false)
	$result[<del>^^table::create^if($bNamless){^[nameless^]}^{</del>^if($t || !$bNamless){<table class="table value" style="margin-left: ${fMarginLeft}em">^if(!$bNamless){^#0A<tr>^tCol.menu{<th>$tCol.column</th>}</tr>}^t.menu{^#0A<tr>^tCol.menu{<td>^show_string[$t.fields.[$tCol.column]]</td>}</tr>}^#0A</table><del>^}</del>$sTabs}{-empty-nameless-table-here-<del>^}</del>}]

@show_file[f]
$result[<u class="file value">file</u> (UID: ^reflection:uid[$f]): ^self.show_hash[
	$.name[$f.name]
	$.size[$f.size bytes]
	^if(def $f.mode){
		$.mode[$f.mode]
	}
	^if(def $f.cdate){
		$.cdate[$f.cdate]
	}
	^if(def $f.mdate){
		$.mdate[$f.mdate]
	}
	^if(def $f.adate){
		$.adate[$f.adate]
	}
	^if(def $f.mode && def $f.[content-type]){
		$.content-type[$f.content-type]
	}
	^if(def $f.tables){
		$.tables[$f.tables]
	}
	^if(def $f.cookies){
		$.cookies[$f.cookies]
	}
	^if($f.mode eq "text" || ^f.content-type.left(5) eq "text/"){
		^if(^f.text.length[] <= 100){
			$.text[$f.text]
		}{
			$.[First 100 symbols][^f.text.left(100)]
			$.[Last 100 symbols][^f.text.right(100)]
		}
	}
]]

@show_regex[r]
$result[<del>^^regex::create^[</del>$r.pattern<del>^]^[$r.options^]</del>]

@show_image[i][f]
$result[<u class="image value">image</u> (UID: ^reflection:uid[$i]): ^self.show_hash[
	$.width[$i.width px]
	$.height[$i.height px]
	^if(def $i.src){
		$.html[^i.html[]]]
		^try{
			$f[^file::stat[$i.src]]
			$.size[$f.size bytes]
			$.cdate[$f.cdate]
			$.mdate[$f.mdate]
			$.adate[$f.adate]
		}{
			$exception.handled(true)
		}
	}
	^if(def $i.exif){
		$.exif[$i.exif]
	}
]]

@show_xdoc[x][s;sTabs;fMarginLeft]
	^self.prepareFormat[$x]
	$s[^x.string[ $.omit-xml-declaration[no] $.method[xml] $.indent[yes]]]

	$sTabs[^for[i](1;$self.iShift){&#09^;}]
	$fMarginLeft($self.iShift*5)
	^if($self.iShift > 0){^fMarginLeft.inc(5)}

	$result[<pre class="xdoc value" style="margin-left: ${fMarginLeft}em"><del>^^xdoc::create^{</del>^taint[^s.trim[end]]<del>^}</del></pre>$sTabs]

@show_xnode[x][result]
	$result[^switch($x.nodeType){
		^case($xdoc:ELEMENT_NODE){<span class="node1 value">&lt^;^taint[$x.nodeName]^self.showAttributes[$x]^if(def $x.childNodes){&gt^;^self.showChildren[$x]&lt^;/$x.nodeName&gt^;}{/&gt^;}</span>}
		^case($xdoc:ATTRIBUTE_NODE){<span class="node2 value">^taint[$x.nodeName]="^self.showNodeValue[$x]"</span>}
		^case($xdoc:TEXT_NODE){<span class="node3 value">^self.showNodeValue[$x]</span>}
	}]

@showAttributes[x][result;v]
	$result[^if(def $x.attributes){^x.attributes.foreach[;v]{ ^self.show_xnode[$v]}}]

@showChildren[x][result;v]
	$result[^if(def $x.childNodes){^x.childNodes.foreach[;v]{^self.show_xnode[$v]}}]

@showNodeValue[x]
	$result[^taint[^apply-taint[html][^taint[$x.nodeValue]]]]

@show_Array[a][result]
	$result[Array(^eval($a)): <br/> ^show_hash[^hash::create[$a];;1]]

@showXObject[o]
	$result[<span style="color:red">$o.typeName</span>
		^if($o.getID is junction){<b>^o.getID[]</b>}
		^if($o.getName is junction){<span style="color:blue">(^o.getName[])</span>}
		^if($o.ToString is junction){<span style="color:red">(^o.ToString[])</span>}
		^if($o.current){
			^self.showObject[$o.current]
		}
	]

# clear empty text nodes
@prepareFormat[document][result]
	^self.prepareFormatChild[$document.documentElement;$document.documentElement.childNodes]

@prepareFormatChild[parent;child][i;node;result]
	^for[i](0;$child-1){
		$node[$child.$i]
		^switch($node.nodeType){
			^case($xdoc:TEXT_NODE){
				^if(!def ^node.nodeValue.trim[]){
					$node[^parent.removeChild[$node]]
				}
			}
			^case($xdoc:ELEMENT_NODE){
				^if($node.childNodes){
					^self.prepareFormatChild[$node;$node.childNodes]
				}
			}
		}
	}
