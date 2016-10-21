<?php
class Pdf{
		
	private $url;
	private $pages;
	private $imagedata = array();
	private $hash;
	private $resolution = 180;
	private $width, $height;
	
	private $upload_dir = 'tmp/';
	
	public function __construct($url){
		$this->url = $url;
	}
	
	public function createImagesFromPdf(){

	
		$this->hash = md5($this->url . $this->resolution);
		@mkdir($this->upload_dir . $this->hash);
	
		$file = file_get_contents($this->url);
	
		file_put_contents($this->upload_dir . $this->hash . "/file.pdf", $file);
	
		$pdf= new fpdi();
		$pagecount = $pdf->setSourceFile($this->upload_dir . $this->hash . "/file.pdf");
	
	
		$imagick = new Imagick(); 
		$imagick->setResolution($this->resolution, $this->resolution);
		$imagick->readImage($this->upload_dir . $this->hash . "/file.pdf"); 
		$imagick->writeImages($this->upload_dir . $this->hash . "/".'converted.jpg', false); 
	
		$imageinfo = $imagick->identifyImage();
	
		$this->width = $imageinfo['geometry']['width'];
		$this->height = $imageinfo['geometry']['height'];
	
	
		$this->pages = $pagecount;
	
		if($pagecount == 1){
			$this->imagedata[] = 'converted.jpg';
		}else{
			for ($i=0; $i < $pagecount; $i++) { 
				$this->imagedata[] = 'converted-' . $i . '.jpg';
			}	
		}

	
	}
	
	
	public function initDevData(){
		$this->url = "http://smw.xan8.de/images/0/0d/Buchbestellung.pdf";
		$this->pages = 2;
		$this->imagedata[] = "converted.jpg";
		$this->imagedata[] = "converted-1.jpg";
		$this->hash = "cde5513fe4377bec8fbe3a049cc0fcbb";
		$this->resolution = 180;
		$this->width = 1489;
		$this->height = 2105;
		$this->upload_dir = "tmp/";
	}
	
	
	public function getUrl(){
		return $this->url;
	}

	public function setUrl($url){
		$this->url = $url;
	}

	public function getPages(){
		return $this->pages;
	}

	public function setPages($pages){
		$this->pages = $pages;
	}

	public function getImagedata(){
		return $this->imagedata;
	}

	public function setImagedata($imagedata){
		$this->imagedata = $imagedata;
	}

	public function getHash(){
		return $this->hash;
	}

	public function setHash($hash){
		$this->hash = $hash;
	}

	public function getResolution(){
		return $this->resolution;
	}

	public function setResolution($resolution){
		$this->resolution = $resolution;
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
	
	public function printDebug(){
		print_r($this);
	}
}
