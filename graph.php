<?php

var_dump($argv);

$a=file($argv[2]);

$b=preg_grep('/'.$argv[1].'/', $a);

var_dump($b); // $b is the original results
$bt=$b; // $bt is the tree for additional results

foreach($b as $k => $c) {
preg_match_all('/'.$argv[1].'/', $c, $m, PREG_OFFSET_CAPTURE);

$j=array();

// $j[$k][0]=$m;
$j[$k]['m']=$m;


// var_dump($m);
echo "\n".$k." ".count($m[0])." ";
foreach($m[0] as $kc => $d) {
echo $m[0][$kc][1]." ";
}
echo " | ";

$t = preg_split('/ /', $c, -1, PREG_SPLIT_OFFSET_CAPTURE);

// $j[$k][1]=$t;
$j[$k]['t']=$t; // json style string index

// var_dump($t);
foreach($t as $kt => $ta) {
echo $ta[1]." ";
}
echo "\n";

$bt[$k]=$j[$k];

// Store tree in memory first, can manipulate, or output to file?

}

// var_dump($bt);
# foreach($a as $k => $b)
/*
echo json_encode($bt, JSON_PRETTY_PRINT);

echo json_encode(array_keys($bt), JSON_PRETTY_PRINT);

echo json_encode($bt[81], JSON_PRETTY_PRINT);

echo json_encode($bt[81]['m'], JSON_PRETTY_PRINT);

// exit;


echo graph($bt, '');

echo graph($bt, '/81');

echo graph($bt, '/81/m');

echo graph($bt, '/81/m/0');

echo graph($bt, '/81/m/0/0');

echo graph($bt, '/81/m/0/0/0');
*/

echo graph($bt, $argv[3]);

function graph($t, $s)
{

// use string before first / as command or flags

if ($s=='' || $s=='/') return json_encode(array_keys($t), JSON_PRETTY_PRINT);
else {

$sa = explode('/', $s);

// var_dump($sa);

if (count($sa)==2) return json_encode(($t[$sa[1]]), JSON_PRETTY_PRINT);
else if (count($sa)==3) {
$ta=($t[$sa[1]]);

// var_dump($ta["m"]);
return json_encode(($ta[$sa[2]]), JSON_PRETTY_PRINT);
// return json_encode(($ta), JSON_PRETTY_PRINT);
}
else if (count($sa)>3) {

$ta=$t;
foreach($sa as $sk => $sb) {
if ($sk>0) {
$ta=($ta[$sb]);

echo "\n\n".__LINE__." $sk ".json_encode(($ta), JSON_PRETTY_PRINT);
}

}
echo "\n";
}

}

}
