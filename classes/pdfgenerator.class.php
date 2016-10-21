<?php


class PDFGenerator {

	private $templatefile;

	private $elements = array();

	public function __construct() {

	}

	public function setTemplateFile($tpl) {
		$this -> tpl = $tpl;
	}

	public function addElement(Element $element) {
		$this -> elements[] = $element;
	}

	public function createPDF() {
		// initiate FPDI
		//A4		 595x842A4		 595x842
		$pdf = new FPDI('P', 'pt', 'A4');

		// set the source file
		//@TODO Check File integrity
		$pageCount = $pdf -> setSourceFile($this -> tpl);

		for ($pageNo = 1; $pageNo <= $pageCount; $pageNo++) {
			// import a page
			$templateId = $pdf -> importPage($pageNo);
			// get the size of the imported page
			$size = $pdf -> getTemplateSize($templateId);

			// create a page (landscape or portrait depending on the imported page size)
			if ($size['w'] > $size['h']) {
				$pdf -> AddPage('L', array($size['w'], $size['h']));
			} else {
				$pdf -> AddPage('P', array($size['w'], $size['h']));
			}

			// use the imported page
			$pdf -> useTemplate($templateId);

			foreach ($this->elements as $key => $element) {
				if ($element -> getPosition() -> getPage() == $pageNo) {
					$element -> drawElement($pdf);
				}
			}
		}

		$pdf -> Output();
	}

}

abstract class Element {

	protected $position;
	protected $style;

	public function __construct(Position $position, Style $style = null) {
		$this->position = $position;
		if($style == null){
			$this -> style = new Style();
		}else{
			$this -> style = $style;
		}
		
	}

	abstract function drawElement(FPDF $pdf);

	public function getPosition() {
		return $this -> position;
	}
	
	public function setStyle(Style $style){
		$this->style = $style;
		
		return $this;
	}

}

class StringElement extends Element {
	private $txt;

	public function __construct(Position $position, $txt, Style $style = null) {
		parent::__construct($position, $style);
		$this -> txt = $txt;
	}

	public function drawElement(FPDF $pdf) {
		$pdf -> SetFont($this->style->getFont());
		$pdf -> SetFontSize($this->style->getFontSize());
		$color = $this->style->getTextcolor();
		$pdf -> SetTextColor($color['r'], $color['g'], $color['b']);
		$pdf -> SetXY($this -> getPosition() -> getX(), $this -> getPosition() -> getY());
		//$str = utf8_decode($str); 
		$pdf -> MultiCell(0, $this->style->getLineHeight(), utf8_decode($this -> txt));
		$pdf -> Ln(10);
	}

}

class CheckboxElement extends Element {
	private $cross;
	public function __construct(Position $position, $cross, Style $style = null) {
		parent::__construct($position, $style);
		$this->cross = $cross;
	}

	public function drawElement(FPDF $pdf) {
		//echo $this->cross;
		if(in_array(strtolower(trim($this->cross)), SMWConfig::$true_answers)){
			$pdf -> SetFont($this->style->getFont());
			$pdf -> SetFontSize($this->style->getFontSize());
			$color = $this->style->getTextcolor();
			$pdf -> SetTextColor($color['r'], $color['g'], $color['b']);
			$pdf -> SetXY($this -> getPosition() -> getX(), $this -> getPosition() -> getY());
			$pdf -> Cell(0, $this->style->getLineHeight(), "X");
		}

	}

}


class DblCheckboxElement extends Element {
	private $cross;
	private $element_true, $element_false;
	public function __construct(Position $position_true, Position $position_false, $cross, Style $style = null) {
		parent::__construct($position_true, $style);
		$this->cross = $cross;
		$this->element_true = new CheckboxElement($position_true, $cross);
		$this->element_false = new CheckboxElement($position_false, !$cross);
		//print_r($this);
	}

	public function drawElement(FPDF $pdf) {
		//echo $this->cross;
		$this->element_true->drawElement($pdf);
		$this->element_false->drawElement($pdf);

	}

}

class Position {

	private $page;
	private $x;
	private $y;
	private $width;
	private $height;

	public function __construct($page, $x, $y, $width = -1, $height = -1) {
		$this -> page = $page;
		$this -> x = $x;
		$this -> y = $y;
		$this -> width = $width;
		$this -> height = $height;
	}

	public function getPage() {
		return $this -> page;
	}

	public function getX() {
		return $this -> x;
	}

	public function getY() {
		return $this -> y;
	}

	public function getWidth(){
		return $this->width;
	}

	public function setWidth($width){
		$this->width = $width;
	}
	public function getHeight(){
		return $this->height;
	}

	public function setHeight($height){
		$this->height = $height;
	}


	public function setPage($page) {
		$this -> page = $page;
	}

	public function setX($x) {
		$this -> x = $x;
	}

	public function setY($y) {
		$this -> y = $y;
	}

}

class Style {

	private $font = "Helvetica";
	private $textcolor_r = 0;
	private $textcolor_g = 0;
	private $textcolor_b = 0;
	
	private $line_height = 10;
	private $font_size = 10;
	

	public function __construct() {

	}

	public function getFont() {
		return $this -> font;
	}
	
	public function getLineHeight() {
		return $this -> line_height;
	}
		
	public function getFontSize() {
		return $this -> font_size;
	}

	public function getTextcolor() {
		return array("r" => $this -> textcolor_r, "g" => $this -> textcolor_g, "b" => $this -> textcolor_b, );
	}

	public function setFont($font) {
		$this -> font = $font;
	}
	
	
	public function setLineHeight($line_height) {
		$this -> line_height = $line_height;
	}
	
	public function setFontSize($font_size) {
		$this -> font_size = $font_size;
	}
	

	public function setTextcolor($r, $g, $b) {
		$this -> textcolor_r = $r;
		$this -> textcolor_g = $g;
		$this -> textcolor_b = $b;
	}

	public function applyStyle($pdf) {
		$pdf -> SetFont($this -> getFont());
		$color = $this -> getTextcolor();
		$pdf -> SetTextColor($color['r'], $color['g'], $color['b']);
	}

}
