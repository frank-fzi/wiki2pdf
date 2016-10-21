<?php
error_reporting(E_ALL);
ini_set("display_errors", 1);
require_once('smwpdfexport.php');
require_once("classes/pdf.class.php");
require_once("classes/template.class.php");


$pdf = new Pdf("http://smw.xan8.de/images/d/dc/PM_10_FB_FZI_Projektdatenblatt.pdf");
$pdf->initDevData();
//$pdf->printDebug();

$template = new Template("templates/editor.tpl");


$pages = "[";
foreach ($pdf->getImagedata() as $key => $value) {
	$pages .= '"' . $value . '"';
	if($key < count($pdf->getImagedata())-1){
		$pages .= ",";
	}
	$pages .= "\n";
}
$pages .= "]";
$ser = serialize($pdf);
$template->assignVariable("pages", $pages);
$template->assignVariable("pagecount", $pdf->getPages());
$template->assignVariable("width", $pdf->getWidth());
$template->assignVariable("height", $pdf->getHeight());
$imagedata =  $pdf->getImagedata();
$template->assignVariable("startpic", "/extensions/wiki2pdf/tmp/" . $pdf->getHash() . "/" . $imagedata[0]);
$template->assignVariable("image_basepath", "/extensions/wiki2pdf/tmp/" . $pdf->getHash() . "/" );
$template->assignVariable("images", $pdf->getImagedata());
$template->assignVariable("url", $pdf->getUrl());

//
//<script src="../lib/prism.js"></script>



foreach ($wgResourceModules['ext.wiki2pdf.editor']['styles'] as $key => $style) {
	$styles .='<link rel="stylesheet" href="http://smw.xan8.de/extensions/wiki2pdf/assets/' . $style . '" />';
}

$scripts .='<script src="http://smw.xan8.de/extensions/wiki2pdf/assets/jquery.min.js"></script>';
foreach ($wgResourceModules['ext.wiki2pdf.editor']['scripts'] as $key => $script) {
	$scripts .='<script src="http://smw.xan8.de/extensions/wiki2pdf/assets/'.$script.'"></script>';
}

?>
<html>
	<head>
		<?php echo $styles;?>
		<?php echo$scripts;?>
	    <style>
	     #scroll {
	     	height: 85vh !important;
	     }
	    </style>
	</head>
	<body><?php echo$template->compile();?></body>
</html>