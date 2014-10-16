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
class OdaienvControllerVm extends JControllerForm
{
	public function __construct($config = array())
	{
	
		$this->view_item = 'vm';
		$this->view_list = 'vms';
		parent::__construct($config);
	}	
}// class
?>