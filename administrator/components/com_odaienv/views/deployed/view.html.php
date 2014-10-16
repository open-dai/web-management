<?php

class OdaienvViewDeployed extends JViewLegacy
{
  /** @var  string   my variable */
  public $templates;
  public $serviceOfferngs;
  public $diskOfferings;
  public $vms;
  public $odaivms;
  public $networks;

  public function display($tpl = null)
  {
    //$myVariable = $this->myVariable;
    //...
	
//	echo new JResponseJson($this->templates);
parent::display($tpl);
  }
}

?>