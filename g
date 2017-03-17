<?php

/*

PAGE (Programming As Graph Editing) demo

$ php g ja e/81/t/5 doremi | php g . p/81/t/5
json_pretty
[
    "demo_boxstack_a$(EXEEXT)",
    "doremi"
]


*/
// L S Ng lsn95r@gmail.com 2017-03-17

// no path view keys of root
// / view full root
// j/ view as json (not implemented)
// p/ pretty print json

// maintain table of command mapped to function source file $FLUT

if ($argv[1]=='.') $a=file("php://stdin");
else $a=file($argv[1]);


$b=json_decode($a[0], TRUE);

$rb=&$b;
echo gcmd($rb, $argv)."\n"; // array('$n',0) was added

// 20170317 need to print json of full tree because command only can return json of branch


exit;

function sequence(&$t, $n)
{

echo __FUNCTION__." ".__LINE__."\n";

var_dump($t);
var_dump($n);

$t[0]['p']=-1;
$t[0]['n']=1;

foreach($t as $kt => $ta) {
// $ta['p']=$kt-1; // cannot reassign to other variable
// $ta['n']=$kt+1; // need to use $t directly
$t[$kt]['p']=$kt-1;
$t[$kt]['n']=$kt+1;
}


}


function add_element(&$t, $n)
{

// flag for FLUT? add node from json file? or json string?
// multiple arguments? make multiple arguments into json, then add
// f jsonfile -- 2 arguments open json file. 
// json string treat as one argument '{   }'

$l=count($n);

if ($l==5 && $n[3]=='f') {
    $a=file($n[5]);
    $b=json_decode($a[0],true);
    $t[]=$b;
}
else $t[]=($n[3]); // if json need to parse? or just make it to file

return json_encode($t); // return to gcmd, this function has no access to tree, gcmd need to return original tree

}


function add_node(&$t, $n)
{

// flag for FLUT? add node from json file? or json string?
// multiple arguments? make multiple arguments into json, then add
// f jsonfile -- 2 arguments open json file. 
// json string treat as one argument '{   }'

echo __FUNCTION__." ".__LINE__."\n";

$l=count($n);

if ($l==5 && $n[3]=='f') {
    $a=file($n[5]);
    $b=json_decode($a[0],true);
    $t[]=$b;
}
else $t[]=array($n[3]); // if json need to parse? or just make it to file?

return json_encode($t);

}

function rootkeys($t)
{

echo __FUNCTION__."\n";

return json_encode(array_keys($t), JSON_PRETTY_PRINT);;
}

function view_keys($t)
{

echo __FUNCTION__."\n";

return json_encode(array_keys($t), JSON_PRETTY_PRINT);;
}

function json_pretty($t)
{

echo __FUNCTION__."\n";

return json_encode(($t), JSON_PRETTY_PRINT);;
}


function view_json($t)
{

echo __FUNCTION__."\n";

return json_encode(($t));;
}

function gcmd(&$t, $s)
{

// use string before first / as command or flags
// read additional commands from external file in future

$FLUT=array('v'=>"view_json",'k'=>"view_keys",'p'=>"json_pretty",'a'=>"add_node",
            'e'=>"add_element");

// echo __FUNCTION__." ".__LINE__." ".json_encode($t)."\n";
// $t[]='a'; // add successful, but branch of a tree is a copy, modifying the copy does not change the original?


if (count($s)<3) { $func="rootkeys"; $addr=$t; return call_user_func($func, $addr, $arg); }
else {

$sa = explode('/', $s[2]);

if ($sa[0]!='') { $func=$FLUT[$sa[0]]; }     // 20170317: separate logic of command and address
else { $func=$FLUT['v']; }

if ($sa[1]=='') { 
    if ($sa[0]=='p') return json_encode(($t), JSON_PRETTY_PRINT);
    else return json_encode(($t));
    // $func=$FLUT[$sa[0]] command mapped to function names
}

else if (count($sa)==2) {

    if ($sa[0]=='k') { $addr=$t[$sa[1]]; return json_encode(array_keys($t[$sa[1]])); }
    else if ($sa[0]=='p') return json_encode(($t[$sa[1]]), JSON_PRETTY_PRINT);    
    else if ($sa[0]!='') { $func=$FLUT[$sa[0]]; $addr=&$t[$sa[1]]; }   // must pass & reference in $addr
    else { $func=$FLUT['v']; $addr=&$t[$sa[1]]; }
    // shoud get address then pass to processing function, including view
    // view keys, or view what, or process what?
    // save addresses in address decoding part (here), call processing function at the end.
    
    // 20170317: separate logic of command and address
}
else if (count($sa)==3) {
    
    $ta=&$t[$sa[1]]; // (&$t[$sa[1]]) does not work?

    $addr=&$ta[$sa[2]];    
    // $addr=$r;
    
    /* above and below has different effect!!
       $r=&$ta[$sa[2]];    
       $addr=$r; */
    
}
else if (count($sa)>3) {

    // $ta=&$t; // initial assignment need & !! but  $ta=($ta[$sb]) overrides original tree!!
    
    $ta=&$t[$sa[1]]; // (&$t[$sa[1]]) does not work?
    foreach($sa as $sk => $sb) {

    if ($sk>1) {
        $ta = &$ta[$sb]; // undocumented behaviour of & reference to array?
        // $ta=($ta[$sb]);
        $addr=&$ta;
    }
}
}


}

$arg=$s;
$C=$sa[0];

// p,k,v return partial view format, other commands return full tree
if ($C=='p' || $C=='k' || $C=='v' ) return call_user_func($func, $addr, $arg);
else {
    call_user_func($func, $addr, $arg);
    return json_encode($t); 
}

}
