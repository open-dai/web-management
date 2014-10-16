<?php
/**
* @version		$Id: default_controller.php 136 2013-09-24 14:49:14Z michel $ $Revision$ $DAte$ $Author$ $
* @package		Odaienv
* @subpackage 	Controllers
* @copyright	Copyright (C) 2014, Luca Gioppo. All rights reserved.
* @license #http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

jimport('joomla.application.component.controlleradmin');
jimport('joomla.application.component.controllerform');

/**
 * OdaienvVm Controller
 *
 * @package    Odaienv
 * @subpackage Controllers
 */
class OdaienvControllerDatasource extends JControllerForm
{
	public function __construct($config = array())
	{

		$this->view_item = 'datasource';
		$this->view_list = 'vdb';
		parent::__construct($config);
//		echo 'in datasource vdb_id: ' . JRequest::getCmd('vdb_id');
//		$app = JFactory::getApplication();
/*		echo $app->setUserState('vdb_id', JRequest::getCmd('vdb_id'));
		echo JRequest::getCmd('layout', 'default');
		echo JRequest::getCmd('view', 'default');
		echo JRequest::getCmd('task', 'default');
	*/	
	}
	
	public function add($cachable = false, $urlparams = false)
	{
//	echo "gioppo add";
//	echo 'in add vdb_id: ' . JRequest::getCmd('vdb_id');
		if (parent::add()) {
			$app = JFactory::getApplication();
//			$context = "$this->option.edit.$this->context";
//			echo $context;
//			echo 'in if add vdb_id: ' . JRequest::getCmd('vdb_id');
			// we need to set the vdb_id in state otherwise the redirect will loose it
			$app->setUserState('vdb_id', JRequest::getCmd('vdb_id'));
			
			return true;
		}
	}
	
	public function cancel($key = null)
	{
		if (parent::cancel($key)) {
			// Set right layout
			$app = JFactory::getApplication();
//			$context = "$this->option.edit.$this->context";
						
			$this->setRedirect(
				JRoute::_(
					'index.php?option=' . $this->option . '&view=' . $this->view_list
					. '&layout=edit'
					. '&id=' . $app->getUserState('vdb_id')
					. $this->getRedirectToListAppend(), false
				)
			);
			return true;
		}
		return false;
	}
	
	public function save($key = null, $urlVar = null)
	{
		if (parent::save($key, $urlVar)) {
			$task = $this->getTask();
			if ($task == 'save')
			{
				// Add the master pk and the right layout
				$app = JFactory::getApplication();
//				$context = "$this->option.edit.$this->context";
						
				$this->setRedirect(
					JRoute::_(
						'index.php?option=' . $this->option . '&view=' . $this->view_list
						. '&layout=edit'
						. '&id=' . $app->getUserState('vdb_id')
						. $this->getRedirectToListAppend(), false
					)
				);
			}
			return true;
		}
		
		return false;
	}
}// class
?>