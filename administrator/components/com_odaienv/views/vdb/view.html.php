 <?php
/**
* @version		$Id:vm.php 1 2014-07-07 14:44:16Z LG $
* @package		Odaienv
* @subpackage 	Views
* @copyright	Copyright (C) 2014, Luca Gioppo. All rights reserved.
* @license #http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

jimport('joomla.application.component.view');

 
class OdaienvViewVdb  extends JViewLegacy {

	
	protected $form;
	
	protected $item;
	
	protected $state;
	
	
	/**
	 *  Displays the list view
 	 * @param string $tpl   
     */
	public function display($tpl = null) 
	{
		JFactory::getApplication()->input->set('hidemainmenu', true);
		
		// Initialiase variables.
		$this->form		= $this->get('Form');
		$this->item		= $this->get('Item');
		$this->state	= $this->get('State');
		
		// Check for errors.
		if (count($errors = $this->get('Errors')))
		{
			JError::raiseError(500, implode("\n", $errors));
			return false;
		}
		
		// Datasources actions
    	$message = JText::_('JLIB_HTML_PLEASE_MAKE_A_SELECTION_FROM_THE_LIST');
    	 
    	$objDatasourcesToolBar = new JToolBar();
    	$html = "<button class=\"toolbar\" 
           onclick=\"Joomla.submitform('datasource.add', document.datasourcesForm)\" href=\"#\">";
	$html .= "<span class=\"icon-new\"></span>";
	$html .= JText::_('JTOOLBAR_NEW');
	$html .= "</button>\n";    	
    	$objDatasourcesToolBar->appendButton('Custom', $html, 'new');
	$html = "<button class=\"toolbar\" 
           onclick=\"if (document.datasourcesForm.boxchecked.value==0){alert('$message');}else{ Joomla.submitform('datasource.edit', document.datasourcesForm)}\" href=\"#\">";
    	$html .= "<span class=\"icon-edit\"></span>";
    	$html .= JText::_('JTOOLBAR_EDIT');
    	$html .= "</button>\n";
    	$objDatasourcesToolBar->appendButton('Custom', $html, 'edit');
    	$msg = JText::_( 'COM_REGISTRY_TASKS_CONFIRM_DELETE' );
    	$html = "<button class=\"toolbar\" 
           onclick=\"if (document.datasourcesForm.boxchecked.value==0){alert('$message');}else{if (confirm('$msg')){Joomla.submitform('detasource.delete', document.datasourcesForm);}}\" href=\"#\">";
	$html .= "<span class=\"icon-32-delete\"></span>";
	$html .= JText::_('JTOOLBAR_DELETE');
    	$html .= "</button>\n";
    	$objDatasourcesToolBar->appendButton('Custom', $html, 'delete');
    	 
 //   	$this->item = $item;
 //   	$this->form = $form;
    	$this->datasources = $this->get( 'Items', 'Datasources' );
    	$this->datasourcesToolBar = $objDatasourcesToolBar->render();
		
		// ------------ Resources stuff
		// ----------------------------
    	$message = JText::_('JLIB_HTML_PLEASE_MAKE_A_SELECTION_FROM_THE_LIST');
    	 
    	$objResourcesToolBar = new JToolBar();
    	$html = "<button class=\"toolbar\" 
           onclick=\"Joomla.submitform('resource.add', document.resourcesForm)\" href=\"#\">";
	$html .= "<span class=\"icon-new\"></span>";
	$html .= JText::_('JTOOLBAR_NEW');
	$html .= "</button>\n";    	
    	$objResourcesToolBar->appendButton('Custom', $html, 'new');
	$html = "<button class=\"toolbar\" 
           onclick=\"if (document.resourcesForm.boxchecked.value==0){alert('$message');}else{ Joomla.submitform('resource.edit', document.resourcesForm)}\" href=\"#\">";
    	$html .= "<span class=\"icon-edit\"></span>";
    	$html .= JText::_('JTOOLBAR_EDIT');
    	$html .= "</button>\n";
    	$objResourcesToolBar->appendButton('Custom', $html, 'edit');
    	$msg = JText::_( 'COM_REGISTRY_TASKS_CONFIRM_DELETE' );
    	$html = "<button class=\"toolbar\" 
           onclick=\"if (document.resourcesForm.boxchecked.value==0){alert('$message');}else{if (confirm('$msg')){Joomla.submitform('resource.delete', document.resourcesForm);}}\" href=\"#\">";
	$html .= "<span class=\"icon-32-delete\"></span>";
	$html .= JText::_('JTOOLBAR_DELETE');
    	$html .= "</button>\n";
    	$objResourcesToolBar->appendButton('Custom', $html, 'delete');
    	 
 //   	$this->item = $item;
 //   	$this->form = $form;
    	$this->resources = $this->get( 'Items', 'Resources' );
    	$this->resourcesToolBar = $objResourcesToolBar->render();

		parent::display($tpl);	
	}	
}
?>