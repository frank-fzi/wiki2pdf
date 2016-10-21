<?php
require_once("classes/pdf.class.php");
require_once("classes/template.class.php");
class SpecialPdfTemplateEditor extends SpecialPage {
	function __construct() {
		parent::__construct( 'PdfTemplateEditor' );
		chdir('extensions/wiki2pdf/');
	}

	function execute( $par ) {
		//Manual: https://www.mediawiki.org/wiki/Manual:Special_pages
		global $wgRequest, $wgOut, $wgResourceModules;

		$this->setHeaders();

		# Get request data from, e.g.
		$param = $wgRequest->getText('param');

		# Do stuff
		# ...
		//$output = '[http://smw.xan8.de/extensions/wiki2pdf/upload.php Editor öffnen]';
		//$wgOut->addWikiText( $output );

		//$output = $this->getOutput();
		//$output->addHTML('<canvas></canvas>');


		$action = ($this->getRequest()->getVal('action') !== null) ? ($this->getRequest()->getVal('action')) : ('upload');

		switch ($action) {
			case 'upload':
				$this->uploadPrompt();
				break;
			case 'editor':
				$this->editorPrompt();
				break;
			default:
				# code...
				break;
		}
		


	}

	function uploadPrompt(){
		global $wgResourceModules;

		
	
		
		$output = $this->getOutput();
		$this->getOutput()->addModules( 'ext.wiki2pdf' );
				
		
		$template = new Template("templates/upload.tpl");
		$template->assignVariable("FORMURL", $this->buildQueryString(array('action' => 'editor')));
		
	
		
		$output -> setPageTitle("Wiki2PDF Editor - Upload your file");
		$output->addHTML($template->compile());
	}
	
	private function buildQueryString($add){
		$str = "?";
		$data = array_merge($_GET, $add);
		$keys = array_keys($data);
		$last_key = end($keys);
		foreach ($data as $key => $value) {
			
			if ($key == $last_key) {
		        // last element
    			$str .= $key . "=" . $value;
		        
		    } else {
		        // not last element
    			$str .= $key . "=" . $value . "&";
		    }
		}
		
		return $str;
		
		
	}

	function editorPrompt(){
		$pdf = new Pdf($_POST['url']);
		$pdf->createImagesFromPdf();
		//$pdf->printDebug();
		$output = $this->getOutput();
		$this->getOutput()->addModules( 'ext.wiki2pdf.editor' );
	
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

		
		$template->assignVariable("pages", $pages);
		$template->assignVariable("pagecount", $pdf->getPages());
		$template->assignVariable("width", $pdf->getWidth());
		$template->assignVariable("height", $pdf->getHeight());
		$imagedata = $pdf->getImagedata();
		//@TODO: Make Link dynamic
		$template->assignVariable("startpic", "/britsch/extensions/wiki2pdf/tmp/" . $pdf->getHash() . "/" . $imagedata[0]);
		$template->assignVariable("image_basepath", "/britsch/extensions/wiki2pdf/tmp/" . $pdf->getHash() . "/" );
		$template->assignVariable("images", $pdf->getImagedata());
		$template->assignVariable("url", $pdf->getUrl());

		
		$output -> setPageTitle("MagicPDF Editor - Upload your file");
		$output->addHTML($template->compile());
	}
	
	

}