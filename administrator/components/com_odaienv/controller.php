<?php
/**
 * @version		$Id:controller.php 1 2014-07-07Z LG $
 * @author	   	Luca Gioppo
 * @package    Odaienv
 * @subpackage Controllers
 * @copyright  	Copyright (C) 2014, Luca Gioppo. All rights reserved.
 * @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */

// no direct access
defined('_JEXEC') or die('Restricted access');

jimport('joomla.application.component.controller');

require_once JPATH_ROOT . '/libraries/csClient/CloudStackClient.php';

/**
 * Odaienv Standard Controller
 *
 * @package Odaienv   
 * @subpackage Controllers
 */
class OdaienvController extends JControllerLegacy
{
	/**
	 * @var		string	The default view.
	 * @since   1.6
	 */
	protected $default_view = 'env';
	protected $vmList = array('puppet', 'wso2api', 'wso2greg', 'apache', 'nfs', 'jbossvdbmaster', 'wso2bam', 'wso2esb', 'wso2bps');
	
	/**
	 * Method to display a view.
	 *
	 * @param   boolean			If true, the view output will be cached
	 * @param   array  An array of safe url parameters and their variable types, for valid values see {@link JFilterInput::clean()}.
	 *
	 * @return  JController		This object to support chaining.
	 * @since   1.5
	 */
	public function display($cachable = false, $urlparams = false)
	{


		// prepare the CloudStack client
		$params = JComponentHelper::getParams('com_odaienv');
		$domid = $params->get('domid');
		$endpoint = $params->get('endpoint');
		$api_key = $params->get('api_key');
		$secret_key = $params->get('secret_key');
		$cloudstack = new CloudStackClient($endpoint, $api_key, $secret_key);
		
		// Get the list of VM 
		$listVirtualMachines_params = array();
		$listVirtualMachines_params['isrecursive']='true';
		$listVirtualMachines_params['listall']='true';
		try {
			$csVmList = $cloudstack->listVirtualMachines($listVirtualMachines_params);
		} catch (CloudStackClientException $e) {
			echo 'Caught exception: ',  $e->getMessage(), "\n";
		}
		
		// get the list of Domains
		$domains= $cloudstack->listDomains(array(
			"listall"=>"false")
			);

		// get the list of Zones
		$zones= $cloudstack->listZones(array(
			"available"=>"false")
			);
		
		// get the list of Templates
		$templates = $cloudstack->listTemplates(array(
			"templatefilter" => "featured",
			"zoneid"=>$zones[0]->id)
			);

		// get the list of Isos
		$isos = $cloudstack->listIsos(array(
			"listall" => "true",
			"isofilter" => "featured",
			"ispublic" => "true",
			"zoneid"=>$zones[0]->id)
			);
			
		$diskOfferings = $cloudstack->listDiskOfferings(array());	
		
		$serviceOfferings = $cloudstack->listServiceOfferings(array());
		
		$networks = $cloudstack->listNetworks(array(
									"acltype" => "Account",
									"listall" => "true"));
		
		// get the list of compute offerings
		$view = $this->getView('env','html');
		$view->odaivms = $this->vmList;
		$view->vms = $csVmList;
		$view->templates = $templates;
		$view->isos = $isos;
		$view->serviceOfferngs = $serviceOfferings;
		$view->diskOfferings = $diskOfferings;
		$view->networks = $networks;
		$view->domain = $domains[0]->path;

		$viewName = JRequest::getCmd('view', $this->default_view);
//		echo 'in controller vdb_id: ' . JRequest::getCmd('vdb_id');
		switch ($viewName) {
			case "vdb":
				$document = JFactory::getDocument();
				$viewType = $document->getType();
				$viewLayout = JRequest::getCmd('layout', 'default');
				
				$view = $this->getView($viewName, $viewType, '',
                            array('base_path' => $this->basePath, 'layout' => $viewLayout));
				
				// Get/Create the model
				$view->setModel($this->getModel('Vdb'), true);
				$view->setModel($this->getModel('Datasources'));
				$view->setModel($this->getModel('Resources'));
				
				$view->assignRef('document', $document);
				$view->display();
				
				break;
			default:
				// call parent behavior
				parent::display($cachable, $urlparams);
				break;
		}


//		parent::display();
	
		return $this;
	}

}// class
  
?>