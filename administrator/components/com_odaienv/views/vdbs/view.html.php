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

 
class OdaienvViewVdbs  extends JViewLegacy {


	protected $items;

	protected $pagination;

	protected $state;
	
	
	/**
	 *  Displays the list view
 	 * @param string $tpl   
     */
	public function display($tpl = null)
	{

		$this->items		= $this->get('Items');
		$this->pagination	= $this->get('Pagination');
		$this->state		= $this->get('State');

		// Check for errors.
		if (count($errors = $this->get('Errors')))
		{
			JError::raiseError(500, implode("\n", $errors));
			return false;
		}

		OdaienvHelper::addSubmenu('vdbs');

		$this->addToolbar();
		if(!version_compare(JVERSION,'3','<')){
			$this->sidebar = JHtmlSidebar::render();
		}
		
		if(version_compare(JVERSION,'3','<')){
			$tpl = "25";
		}
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
		JToolBarHelper::title( JText::_( 'Virtual Database' ), 'generic.png' );
		
		if ($canDo->get('core.create')) {
			JToolBarHelper::addNew('vdb.add');
		}	
		
		if (($canDo->get('core.edit')))
		{
			JToolBarHelper::editList('vdb.edit');
		}
		
				
		if ($this->state->get('filter.state') != 2)
		{
			JToolbarHelper::publish('vdbs.publish', 'JTOOLBAR_PUBLISH', true);
			JToolbarHelper::unpublish('vdbs.unpublish', 'JTOOLBAR_UNPUBLISH', true);
		}
				
		if ($canDo->get('core.edit.state'))
		{
			if ($this->state->get('filter.state') != -1)
			{
				if ($this->state->get('filter.state') != 2)
				{
					JToolbarHelper::archiveList('vdbs.archive');
				}
				elseif ($this->state->get('filter.state') == 2)
				{
					JToolbarHelper::unarchiveList('vdbs.publish');
				}
			}
			
		}
				
				

		if ($this->state->get('filter.state') == -2 && $canDo->get('core.delete'))
		{
			JToolbarHelper::deleteList('', 'vdbs.delete', 'JTOOLBAR_EMPTY_TRASH');
		}
				elseif ($canDo->get('core.edit.state'))
		{
			JToolbarHelper::trash('vdbs.trash');
		}		
				
		
		JToolBarHelper::preferences('com_odaienv', '550');  
		if(!version_compare(JVERSION,'3','<')){		
			JHtmlSidebar::setAction('index.php?option=com_odaienv&view=vdbs');
		}
				if(!version_compare(JVERSION,'3','<')){
			JHtmlSidebar::addFilter(
				JText::_('JOPTION_SELECT_PUBLISHED'),
				'filter_state',
				JHtml::_('select.options', JHtml::_('jgrid.publishedOptions'), 'value', 'text', $this->state->get('filter.state'), true)
			);
		}
				
			
	}	
	

	/**
	 * Returns an array of fields the table can be sorted by
	 *
	 * @return  array  Array containing the field name to sort by as the key and display text as value
	 */
	protected function getSortFields()
	{
		return array(
		 	          'a.name' => JText::_('Name'),
	     	          'a.state' => JText::_('JSTATUS'),
	     	          'a.id' => JText::_('JGRID_HEADING_ID'),
	     		);
	}	
}
?>
