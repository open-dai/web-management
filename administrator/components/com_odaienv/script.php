<?php
/*
 * @package		Joomla.Framework
 * @copyright	Copyright (C) Open Source Matters, Inc. All rights reserved.
 * @license		GNU General Public License version 2 or later; see LICENSE.txt
 * @component odaienv
 * @copyright Copyright (C) Luca Gioppo
 * @license http://www.gnu.org/copyleft/gpl.html GNU General Public License version 2 or later;
 */
defined( '_JEXEC' ) or die( 'Restricted access' );
if(!defined('DS')) define('DS', DIRECTORY_SEPARATOR);
jimport( 'joomla.filesystem.folder' );

class com_odaienvInstallerScript
{
	function install($parent) {
		
		//$db			= JFactory::getDBO();
		$msgSQL 	= '';
		$errFile	= array();
		$sccFile	= array();
		$msgError	= '';
		$msgSuccess	= '';
		
		// Install Lib
		$installLib 		= self::installLib($sccFile, $errFile);

		// Error
		if ($msgSQL !='') {
			$msgError .= '<br />' . $msgSQL;
		}
	
		if (!empty($sccFile)) {
			$msgSuccess .= '<br />' . implode("<br />", $sccFile);
		}
	
		if (!empty($errFile)) {
			$msgError .= '<br />' . implode("<br />", $errFile);
		}
		
	
		// END MESSAGE	
		if ($msgError != '') {
			$msg = '<span style="font-weight: bold;color:#ff0000;">'.JText::_('COM_ODAIENV_ERROR_INSTALL').'</span>: ' . $msgSuccess . $msgError;
			JFactory::getApplication()->enqueueMessage($msg, 'error');
		} else {
			$msg = '<span style="font-weight: bold;color:#00cc00;">'.JText::_('COM_ODAIENV_SUCCESS_INSTALL').'</span>: ' . $msgSuccess;
			$msg .= JText::_('COM_ODAIENV_INSTALLATION_NOT_COMPLETE');
			JFactory::getApplication()->enqueueMessage($msg, 'message');
		}
		

		
		$parent->getParent()->setRedirectURL('index.php?option=com_odaienv');
	}
	function uninstall($parent) {}

	function update($parent) {
		
		
		//$db			= &JFactory::getDBO();
		//$dbPref 	= $db->getPrefix();
		$msgSQL 	= '';
		$errFile	= array();
		$sccFile	= array();
		$msgError	= '';
		$msgSuccess	= '';
		
		// Install Lib
		$installLib 		= self::installLib($sccFile, $errFile);

		// Error
		if ($msgSQL !='') {
			$msgError .= '<br />' . $msgSQL;
		}
	
		if (!empty($sccFile)) {
			$msgSuccess .= '<br />' . implode("<br />", $sccFile);
		}
	
		if (!empty($errFile)) {
			$msgError .= '<br />' . implode("<br />", $errFile);
		}
		
	
			
		// End Message
		if ($msgError != '') {
			$msg = '<span style="font-weight: bold;color:#ff0000;">'.JText::_('COM_ODAIENV_ERROR_UPGRADE').'</span>: ' . $msgSuccess . $msgError;
			JFactory::getApplication()->enqueueMessage($msg, 'error');
		} else {
			$msg = '<span style="font-weight: bold;color:#00cc00;">'.JText::_('COM_ODAIENV_SUCCESS_UPGRADE').'</span>: ' . $msgSuccess;
			$msg .= JText::_('COM_ODAIENV_INSTALLATION_NOT_COMPLETE');
			JFactory::getApplication()->enqueueMessage($msg, 'message');
		}
		
		JFactory::getApplication()->redirect(JRoute::_('index.php?option=com_odaienv'));
	}

	function preflight($type, $parent) {}

	function postflight($type, $parent) {}
	
	
	function installLib(&$sccFile, &$errFile) {
		
		$success 	= '<span style="font-weight: bold;color:#00cc00;">'.JText::_('COM_ODAIENV_SUCCESS').'</span> - ';
		$error 		= '<span style="font-weight: bold;color:#ff0000;">'.JText::_('COM_ODAIENV_ERROR').'</span> - ';
		jimport( 'joomla.client.helper' );
		jimport( 'joomla.filesystem.file' );
		jimport( 'joomla.filesystem.folder' );
		$ftp 	=& JClientHelper::setCredentialsFromRequest('ftp');
		
		$src[0]		= JPATH_ROOT. '/administrator/components/com_odaienv/files/csClient/BaseCloudStackClient.php';
		$src[1]		= JPATH_ROOT. '/administrator/components/com_odaienv/files/csClient/ExtendedCloudStackClient.php';
		$src[2]		= JPATH_ROOT. '/administrator/components/com_odaienv/files/csClient/CloudStackClientException.php';
		$src[3]		= JPATH_ROOT. '/administrator/components/com_odaienv/files/csClient/CloudStackClient.php';
		$dest[0]	= JPATH_ROOT. '/libraries/csClient/BaseCloudStackClient.php';
		$dest[1]	= JPATH_ROOT. '/libraries/csClient/ExtendedCloudStackClient.php';
		$dest[2]	= JPATH_ROOT. '/libraries/csClient/CloudStackClientException.php';
		$dest[3]	= JPATH_ROOT. '/libraries/csClient/CloudStackClient.php';
		$folderPath = JPATH_ROOT. '/libraries/csClient';
		
		if(!JFolder::create($folderPath, 0755)) {
			$errFile[]	= $error . JText::_( 'COM_ODAIENV_FOLDER_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '', $folderPath);
		} else {
			$sccFile[]	= $success . JText::_( 'COM_ODAIENV_FOLDER_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '', $folderPath);
		}
		
		$data = "<html>\n<body bgcolor=\"#FFFFFF\">\n</body>\n</html>";
		if(!JFile::write($folderPath.DS."index.html", $data)) {
			$errFile[]	= $error . JText::_( 'COM_ODAIENV_FILE_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '',$folderPath).DS."index.html";
		} else {
			$sccFile[]	= $success . JText::_( 'COM_ODAIENV_FILE_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '',$folderPath).DS."index.html";
		}
		
		//// to do insert for cycle to install all files
		$i = 0;
		foreach ($dest as $destValue) {
			if (file_exists($src[$i])) {
				if (!JFile::copy($src[$i], $destValue)) {
					$errFile[]	= $error . JText::_( 'COM_ODAIENV_FILE_COPYING' ). ': '
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_SOURCE_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $src[$i])
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_DESTINATION_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $destValue);
				} else {
					$sccFile[]	= $success . JText::_( 'COM_ODAIENV_FILE_COPYING' ). ': '
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_SOURCE_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $src[$i])
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_DESTINATION_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $destValue);
				}
			} else {
				$errFile[] = $error . JText::_( 'COM_ODAIENV_ERROR_FILE_NOT_EXIST' ). ': ' . str_replace( JPATH_ROOT . '/', '', $src[$i]);
			}	
			
			if (!file_exists($destValue)) {
				$errFile[] = $error . JText::_( 'COM_ODAIENV_ERROR_FILE_NOT_EXIST' ). ': ' . str_replace( JPATH_ROOT . '/', '', $destValue);
			}
			$i++;
		}
		
		$src[0]		= JPATH_ROOT. '/administrator/components/com_odaienv/files/restmco/restmco.class.php';
		$src[1]		= JPATH_ROOT. '/administrator/components/com_odaienv/files/restmco/easy.curl.class.php';
		$dest[0]	= JPATH_ROOT. '/libraries/restmco/restmco.class.php';
		$dest[1]	= JPATH_ROOT. '/libraries/restmco/easy.curl.class.php';
		$folderPath = JPATH_ROOT. '/libraries/restmco';
		
		if(!JFolder::create($folderPath, 0755)) {
			$errFile[]	= $error . JText::_( 'COM_ODAIENV_FOLDER_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '', $folderPath);
		} else {
			$sccFile[]	= $success . JText::_( 'COM_ODAIENV_FOLDER_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '', $folderPath);
		}
		
		if(!JFile::write($folderPath.DS."index.html", $data)) {
			$errFile[]	= $error . JText::_( 'COM_ODAIENV_FILE_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '',$folderPath).DS."index.html";
		} else {
			$sccFile[]	= $success . JText::_( 'COM_ODAIENV_FILE_CREATING' ). ': ' . str_replace( JPATH_ROOT . '/', '',$folderPath).DS."index.html";
		}
		
		//// to do insert for cycle to install all files
		$i = 0;
		foreach ($dest as $destValue) {
			if (file_exists($src[$i])) {
				if (!JFile::copy($src[$i], $destValue)) {
					$errFile[]	= $error . JText::_( 'COM_ODAIENV_FILE_COPYING' ). ': '
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_SOURCE_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $src[$i])
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_DESTINATION_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $destValue);
				} else {
					$sccFile[]	= $success . JText::_( 'COM_ODAIENV_FILE_COPYING' ). ': '
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_SOURCE_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $src[$i])
						. '<br />&nbsp;&nbsp; - ' . JText::_( 'COM_ODAIENV_DESTINATION_FILE' ). ': ' . str_replace( JPATH_ROOT . '/', '', $destValue);
				}
			} else {
				$errFile[] = $error . JText::_( 'COM_ODAIENV_ERROR_FILE_NOT_EXIST' ). ': ' . str_replace( JPATH_ROOT . '/', '', $src[$i]);
			}	
			
			if (!file_exists($destValue)) {
				$errFile[] = $error . JText::_( 'COM_ODAIENV_ERROR_FILE_NOT_EXIST' ). ': ' . str_replace( JPATH_ROOT . '/', '', $destValue);
			}
			$i++;
		}
		
		
		return true;// will be not worked, we are working with errorMsg
	}
	

}
?>