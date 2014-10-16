<?php

class OdaienvViewEnv extends JViewLegacy
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
	//OdaienvHelper::addSubmenu('vms');
	$this->addToolbar();
//	echo new JResponseJson($this->templates);

parent::display($tpl);
  }
  
  /**
	 * Add the page title and toolbar.
	 *
	 * @return  void
	 */
	protected function addToolbar()
	{
		
		$canDo = OdaienvHelper::getActions();
		$user = JFactory::getUser();
		JToolBarHelper::title( JText::_( 'Environment' ), 'generic.png' );
				
					
	}	
}

?>