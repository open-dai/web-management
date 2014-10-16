<?php
/**
 * @version 1.0
 * @package    joomla
 * @subpackage Odaienv
 * @author	   	Luca Gioppo
 *  @copyright  	Copyright (C) 2014, Luca Gioppo. All rights reserved.
 *  @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */

//--No direct access
defined('_JEXEC') or die('Resrtricted Access');

if(!JFactory::getUser()->authorise('core.manage', 'come_odaienv')){
	return Jerror::raiseWarning(404, JText::_('JERROR_ALERTNOAUTHOR'));
}
require_once(JPATH_COMPONENT.'/helpers/odaienv.php');
$controller = JControllerLegacy::getInstance('odaienv');
$controller->execute(JFactory::getApplication()->input->get('task'));
$controller->redirect();