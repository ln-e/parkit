# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 13:27
# To change this template use File | Settings | File Templates.


@auto[]
$MAIN:CLASS_PATH[^table::create{path
../classes
../src
../src/Parsekit
}]

@rsplit[sText;sRegex;sDelimiter][result]
^if(def $sText && def $sRegex){
	$result[^sText.match[(.+?)(?:$sRegex|^$)][g]]
}{
	$result[^table::create{1}]
}
^if(def $sDelimiter){
	^if($result && (^sDelimiter.pos[r]>=0 || ^sDelimiter.pos[R]>=0)){
		$result[^table::create[$result;$.reverse(true)]]
	}
	^if(^sDelimiter.pos[v]>=0 || ^sDelimiter.pos[V]>=0){
		$result[^result.flip[]]
	}
}


# mysql 3.xx & 4.0
#$SQL.connect-string[mysql://user:pass@host/db?charset=cp1251_koi8]
# mysql 4.1 and higher
#$SQL.connect-string[mysql://user:pass@host/db?charset=cp1251]
#$SQL.connect-string[sqlite://db]
#$SQL.connect-string[pgsql://user:pass@host/db]
#$SQL.connect-string[oracle://user:pass@service?NLS_LANG=RUSSIAN_AMERICA.CL8MSWIN1251&NLS_DATE_FORMAT=YYYY-MM-DD HH24:MI:SS]