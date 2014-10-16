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
class OdaienvControllerResource extends JControllerForm
{
	public function __construct($config = array())
	{

		$this->view_item = 'resource';
		$this->view_list = 'vdb';
		parent::__construct($config);
	}
	
	public function add($cachable = false, $urlparams = false)
	{
		if (parent::add()) {
			$app = JFactory::getApplication();
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
		// ---------------------------- File Upload Starts ------------------------
		jimport( 'joomla.filesystem.folder' );
        jimport('joomla.filesystem.file');

        // Create the gonewsleter folder if not exists in images folder
        if ( !JFolder::exists( JPATH_COMPONENT_ADMINISTRATOR . DS . "files" . DS . "res" ) ) {
            JFolder::create( JPATH_COMPONENT_ADMINISTRATOR . DS . "files" . DS . "res" );
        }
		// Get the file data array from the request.
        $file = JFactory::getApplication()->input->files->get('jform');

        // Make the file name safe.
        $filename = JFile::makeSafe($file['resfile']['name']);

        // Move the uploaded file into a permanent location.
        if ( $filename != '' ) {
            // Make sure that the full file path is safe.
			$filepath = JPath::clean( JPATH_COMPONENT_ADMINISTRATOR . '/files/res/' . strtolower( $filename ) );

            // Move the uploaded file.
            JFile::upload( $file['resfile']['tmp_name'], $filepath );
            // Change $data['file'] value before save into the database 
        }
		$data = JRequest::getVar( 'jform', null, 'post', 'array' );
		$data['resfile'] = strtolower( $filename );

		JRequest::setVar('jform', $data );
        // ---------------------------- File Upload Ends ------------------------

		if (parent::save($key, $urlVar)) {
			$task = $this->getTask();
			if ($task == 'save')
			{
				// Add the master pk and the right layout
				$app = JFactory::getApplication();
						
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