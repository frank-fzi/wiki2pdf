<?php

class Template{
	
	private $filename;
	private $variables = array();
	
	public function __construct($filename){
		$this->filename = $filename;
	}
	
	public function assignVariable($name, $content){
		$this->variables[] = new Variable($name, $content);
	}
	
	public function compile(){
		if(is_file(!$this->filename)){
			throw new Exception("Error finding Template", 1);
		}
		
		$template = file_get_contents($this->filename);
		
		foreach ($this->variables as $var) {
			$template = str_replace("##" . $var->getName() . "##", $var->getContent(), $template);
		}
		
		return $template;
	}
}


class Variable{
	private $name, $content;
	public function __construct($name, $content){
		$this->name = $name;
		$this->content = $content;
	}
	
	
	public function getName(){
		return $this->name;
	}
	
	public function getContent(){
		return $this->content;
	}
}
