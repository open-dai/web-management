<?php
/**
 * @version		$Id:extensions.php 1 2014-07-07Z LG $
 * @author	   	Luca Gioppo
 * @package    Odaienv
 * @subpackage Controllers
 * @copyright  	Copyright (C) 2014, Luca Gioppo. All rights reserved.
 * @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die;


require_once (JPATH_ADMINISTRATOR.'/components/com_odaienv/helpers/odaienv.php' );

class JElementExtensions extends JElement
{
	/**
	 * Element name
	 *
	 * @access	protected
	 * @var		string
	 */
	var	$_name = 'Extensions';

	function fetchElement($name, $value, &$node, $control_name)
	{
	
		$extensions = OdaienvHelper::getExtensions();
		$options = array();
		foreach ($extensions as $extension) {   
		
			$option = new stdClass();
			$option->text = JText::_(ucfirst((string) $extension->name));
			$option->value = (string) $extension->name;
			$options[] = $option;
			
		}		
		
		return JHTML::_('select.genericlist', $options, ''.$control_name.'['.$name.']', 'class="inputbox"', 'value', 'text', $value, $control_name.$name );
	}
}