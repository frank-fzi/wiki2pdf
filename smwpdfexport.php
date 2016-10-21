<?php
@session_start();
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
$wgHooks['ParserFirstCallInit'][] = 'smwpdfexport';

$wgResourceModules['ext.wiki2pdf'] = array(
    'scripts' => array('bootstrap.min.js', 'jquery.bootpag.min.js', 'ext.wiki2pdf.js'),
    'styles' => array('bootstrap.min.css', 'bootstrap-theme.min.css', 'ext.wiki2pdf.css', ),
    'messages' => array(),
    'dependencies' => array(),
    'position' => 'top',
    'localBasePath' => dirname( __FILE__ ) . '/assets',
    'remoteExtPath' => 'wiki2pdf/assets'
);


$wgResourceModules['ext.wiki2pdf.editor'] = array(//'fabricjs_viewport.js',
    'scripts' => array('jquery-ui.min.js', 'bootstrap.min.js', 'jquery.bootpag.min.js', 'fabric.min.js',  'ext.wiki2pdf.js', 'editor.js'),
    'styles' => array('bootstrap.min.css', 'bootstrap-theme.min.css', 'ext.wiki2pdf.css', 'ext.wiki2pdf.editor.css', 'font-awesome.min.css'),
    'messages' => array(),
    'dependencies' => array(),
    'position' => 'top',
    'localBasePath' => dirname( __FILE__ ) . '/assets',
    'remoteExtPath' => 'wiki2pdf/assets'
);



		


require_once('lib/fpdf/fpdf.php');
require_once('lib/fpdi/fpdi.php');
 
require_once("classes/pdfgenerator.class.php");
require_once("PdfTemplateEditor.php");

function smwpdfexport( Parser $parser ) {
	$parser->setHook( 'smwpdfexport', 'smwpdfexportrender' );
       return true;
}

function smwpdfexportrender( $input, array $args, Parser $parser, PPFrame $frame ) {
	$parser->disableCache();
	$frameArgs = $frame -> namedArgs;

	if(isset($frameArgs)){
		preg_match("/\|(.*?)]]/", trim($frameArgs[1]->textContent), $reg_result);
		$rep_value = $reg_result[1];
		$input = str_replace("{{{INDEX}}}", $rep_value, $input);
		//print_r($frameArgs);
		foreach ($frameArgs as $key => $value) {
			$searchkey = str_replace("?", "", $key);
			preg_match("/\|(.*?)]]/", trim($value->textContent), $reg_result);
			$rep_value = $reg_result[1];
			$input = str_replace("{{{".$searchkey."}}}", $rep_value, $input);
		}

		$data = json_decode(utf8_encode($input));

		$lines = array();

		foreach ($data as $key => $value) {
			$term = trim($value->text);
			//echo substr($term, 0, 3) . " " . substr($term, -3) . "<br>";
			if(substr($term, 0, 3) != "{{{" && substr($term, -3) !== "}}}"){
				$lines[] = SmwPDFLine::fromLine($value);
			}	
			
		}


		$hash = md5(rand());
		$_SESSION['smwpdfexport'][$hash]['template'] = $args['template'];
		$_SESSION['smwpdfexport'][$hash]['lines'] = $lines; 

		//@TODO: Extract URL from $_SERVER and make it dynamic
		$output[] = '* [https://amazonas.fzi.de/britsch/extensions/wiki2pdf/smwpdfexport.php?action=pdfdownload&hash='.$hash.' PDF-Download]';
	}else{
		$output[] = "[[DownloadLink]]";
	}

	foreach ($output as $key => $out) {
		$return .= $out;
	}

	return $return;
}


function file_get_contents_curl($url) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_AUTOREFERER, TRUE);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);       

    $data = curl_exec($ch);
    curl_close($ch);

    return $data;
}

function px2pt($px){
	$ret = ceil(($px-0.76470588)/(1.529411765));
	return $ret;
}

function createPDF($template, $lines, $hash){

	

	file_put_contents("tmp/" . $hash . ".pdf", file_get_contents_curl($template));


	$generator = new PDFGenerator();

	$generator->setTemplateFile("tmp/" . $hash . ".pdf");

	foreach ($lines as $key => $line) {

		switch ($line->getType()) {
			case 'text':

				$style = new Style();
				$style->setFont($line->getProperty('fontFamily'));
				$style->setFontSize(px2pt($line->getProperty('fontSize')));

				$generator->addElement(
					new StringElement(
						new Position($line->getPage(), $line->getX(), $line->getY()), 
						$line->getValue(),
						$style
					)
				);
				break;
			case 'checkbox':
				$generator->addElement(new CheckboxElement(new Position($line->getPage(), $line->getX(), $line->getY()), $line->getValue()));
				break;
			case 'dblCheckbox':
				$generator->addElement(
					new DblCheckboxElement(
						new Position($line->getPage(), SmwPDFLine::dimensionizeX($line->getProperty('elem_true')->left),SmwPDFLine::dimensionizeY($line->getProperty('elem_true')->top)),
						new Position($line->getPage(), SmwPDFLine::dimensionizeX($line->getProperty('elem_false')->left),SmwPDFLine::dimensionizeY($line->getProperty('elem_false')->top)),
						$line->getValue()
					)
				);
				break;
			
			default:
				$generator->addElement(new StringElement(new Position($line->getPage(), $line->getX(), $line->getY()), "Error: Unknown Datatype: " . $line->getType()));
				break;
		}
	}


	$style = new Style();
	$style->setTextcolor(122, 100, 5);
	$style->setFont("courier");


	$generator->createPDF();
}


if($_GET['action']=="pdfdownload"){

	$hash = $_GET['hash'];

	createPDF($_SESSION['smwpdfexport'][$hash]['template'], $_SESSION['smwpdfexport'][$hash]['lines'], $hash);

}

class SmwPDFLine{
	private $type;
	private $page;
	private $x;
	private $y;
	private $value;

	private $properties;


	public function __construct() {

    }

    public static function fromLine($line) {
    	$instance = new self();
    	$instance->properties = (array) $line;
    	return $instance;
    }

    public static function fromValues($type, $page, $x, $y, $value) {
    	$instance = new self();
    	$instance->type = $type;
		$instance->page = $page;
		$instance->x = $x;
		$instance->y = $y;
		$instance->value = $value;
    	return $instance;
    }

    public function getType(){
		if(array_key_exists('type', $this->properties)){
			return $this->properties['type'];
		}else{
			return $this->type;
		}
	}

	public function setType($type){
		$this->type = $type;
	}

	public function getPage(){
		if(array_key_exists('page', $this->properties)){
			return $this->properties['page'];
		}else{
			return $this->page;
		}
	}

	public function setPage($page){
		$this->page = $page;
	}


	public static function dimensionizeX($x){
		return $x*595;
	}

	public static function dimensionizeY($y){
		return $y*842;
	}

	public function getX(){
		if(array_key_exists('left', $this->properties)){
			return $this->dimensionizeX($this->properties['left']);
		}else{
			return $this->x;
		}
	}

	public function setX($x){
		$this->x = $x;
	}

	public function getY(){
		if(array_key_exists('top', $this->properties)){
			return $this->dimensionizeY($this->properties['top']);
		}else{
			return $this->y;
		}
	}

	public function setY($y){
		$this->y = $y;
	}

	public function getValue(){
		if(array_key_exists('text', $this->properties)){
			return $this->properties['text'];
		}else{
			return $this->value;
		}
	}

	public function setValue($value){
		$this->value = $value;
	}

	public function getProperty($prop){
		return $this->properties[$prop];
	}

	public function setProperty($property, $value){
		$this->properties[$property] = $value;
	}


}

function debug_to_console( $data ) {

		if ( is_array( $data ) )
			$output = "<script>console.log( 'Debug Objects: " . implode( ',', $data) . "' );</script>";
		else
			$output = "<script>console.log( 'Debug Objects: " . $data . "' );</script>";

		echo $output;
}

class SMWConfig{

	public static $true_answers = array('ja', 'yes', 'true');
}