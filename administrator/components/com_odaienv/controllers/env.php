<?php
/**
* @version		$Id$ $Revision$ $Date$ $Author$ $
* @package		Odaienv
* @subpackage 	Controllers
* @copyright	Copyright (C) 2014, Luca Gioppo.
* @license #http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
*/

// 

defined('_JEXEC') or die;

jimport('joomla.application.component.controlleradmin');

require_once JPATH_ROOT . '/libraries/csClient/CloudStackClient.php';

/**
 * OdaienvControllerEnv Controller
 *
 * @package    Joomla.Administrator
 * @subpackage Odaienv
 */
 class OdaienvControllerEnv extends JControllerAdmin{

	protected $vmList = array('puppet', 'wso2api', 'wso2greg', 'apache', 'nfs', 'jbossvdbmaster', 'wso2bam', 'wso2esb', 'wso2bps');

	public function vmdeploy($cachable = false, $urlparams = false)
	{
		// prepare the CloudStack client
		$params = JComponentHelper::getParams('com_odaienv');
		$domid = $params->get('domid');
		$endpoint = $params->get('endpoint');
		$api_key = $params->get('api_key');
		$secret_key = $params->get('secret_key');
		$cloudstack = new CloudStackClient($endpoint, $api_key, $secret_key);
	
//		echo "deploy";
		$jinput = JFactory::getApplication()->input;
//		$service = $jinput->get('service', 'default_value', 'filter');
		$template = $jinput->get('template', 'default_value', 'filter');
		$iso = $jinput->get('iso', 'default_value', 'filter');
		$disk = $jinput->get('disk', 'default_value', 'filter');
		$service = $jinput->get('service', 'default_value', 'filter');
		$network = $jinput->get('network', 'default_value', 'filter');
		$vm = $jinput->get('vm', 'default_value', 'filter');
		$post_array = $jinput->getArray($_POST);
//		echo $service;
//		echo $template;
//		echo print_r($post_array);
//		echo date_default_timezone_get();
//		echo gethostname(); 
//		echo php_uname('n');

		
		$userdata = "role=".$vm."\nenv=".date_default_timezone_get()."\npuppet_master=".gethostname()."\ntimezone=".date_default_timezone_get()."\n";
		$userdata_encoded = base64_encode($userdata);

		$vars = array(
			"serviceofferingid" => $service,
//			"templateid" => $template,
			"templateid" => $iso,
//			"account" => "ACC-Italy",
			"hypervisor" => "KVM",
			"diskOfferingId" => $disk,
			"zoneid" => $params->get('zoneid'),
			"displayname" => $vm,
//			"hostid" => "c97b2d3e-29f9-4b40-a57d-5b45d7016a51",
			"domainid" => $params->get('domid'),
			"name" => $vm,
			"networkIds" => $network,
//			"startvm" => "false",
//			"userdata" => $userdata_encoded
			);
			
		$created = $cloudstack->deployVirtualMachine($vars);
		echo print_r($created);
		echo $cloudstack->getLastUrl();
		$view = $this->getView('deployed','html');
		$view->thevm = $vm;
		$view->result = $created;
		$view->display();
		return $this;
	}
}