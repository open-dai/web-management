<?php
/**
 * @package     Joomla.Administrator
 * @subpackage  com_banners
 *
 * @copyright   Copyright (C) 2005 - 2014 Open Source Matters, Inc. All rights reserved.
 * @license     GNU General Public License version 2 or later; see LICENSE.txt
 */

defined('_JEXEC') or die;

/**
 * View class for a list of tracks.
 *
 * @package     Joomla.Administrator
 * @subpackage  com_banners
 * @since       1.6
 */
class OdaienvViewVdb extends JViewLegacy
{
	/**
	 * Display the view
	 *
	 * @param   string  $tpl  The name of the template file to parse; automatically searches through the template paths.
	 *
	 * @return  void
	 */
	public function display($tpl = null)
	{
		$mimetype		= 'application/zip';

		// Check for errors.
		if (count($errors = $this->get('Errors')))
		{
			JError::raiseError(500, implode("\n", $errors));

			return false;
		}
//		echo 'attachment; filename=' . $this->file_name . '.zip';
//		die;
//$this->file_name = 'group.png';
$contentdisp = 'attachment; filename=' . $this->file_name . '.zip';

//		echo $contentdisp;
//		die;
		$vdb_file_location = JPath::clean( JPATH_COMPONENT_ADMINISTRATOR . '/files/vdbs/' . strtolower( $this->file_name ) );
//		$document = JFactory::getDocument();
//		$document->setMimeEncoding($mimetype);
//		$document->setTitle('pippo.zip');
		JFactory::getApplication()->clearHeaders();
		JFactory::getApplication()->setHeader('Content-Disposition', $contentdisp, true);
		//JFactory::getApplication()->setHeader('Content-Disposition', 'attachment; filename=pippo.zip', true);
		JFactory::getApplication()->setHeader('Content-Type', 'application/zip',true);
		JFactory::getApplication()->setHeader('Content-Description', 'File Transfer',true);
		JFactory::getApplication()->setHeader('Cache-Control', 'must-revalidate',true);
		JFactory::getApplication()->setHeader('Expires', '0',true);
		JFactory::getApplication()->setHeader('Content-Transfer-Encoding', 'binary',true);
		JFactory::getApplication()->setHeader('Content-Length',@filesize($vdb_file_location),true);
		
//echo print_r(JFactory::getApplication()->getHeaders());
//die;
		$vdb_file_location = JPath::clean( JPATH_COMPONENT_ADMINISTRATOR . '/files/vdbs/' . strtolower( $this->file_name ) );
		JFactory::getApplication()->sendHeaders();
		die;
/*
		ob_end_clean();
JResponse::clearHeaders();
JResponse::setHeader('Content-Type', 'application/zip', true);
JResponse::setHeader('Content-Disposition', 'attachment; filename='.$this->file_name.';', true);
JResponse::sendHeaders();
*/
		@readfile($vdb_file_location);
		die;
	//	JFactory::getApplication()->close();
	}
}
