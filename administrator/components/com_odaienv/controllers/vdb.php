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

require_once JPATH_ROOT . '/libraries/restmco/restmco.class.php';

/**
 * OdaienvVm Controller
 *
 * @package    Odaienv
 * @subpackage Controllers
 */
class OdaienvControllerVdb extends JControllerForm
{
	public function __construct($config = array())
	{
	
		$this->view_item = 'vdb';
		$this->view_list = 'vdbs';
		parent::__construct($config);
	}	
	
	function save($key = null, $urlVar = null)
	{
		// ---------------------------- File Upload Starts ------------------------
		jimport( 'joomla.filesystem.folder' );
        jimport('joomla.filesystem.file');

        // Create the gonewsleter folder if not exists in images folder
        if ( !JFolder::exists( JPATH_COMPONENT_ADMINISTRATOR . '/files/vdbs/' ) ) {
            JFolder::create( JPATH_COMPONENT_ADMINISTRATOR . '/files/vdbs/' );
        }
		// Get the file data array from the request.
        $file = JFactory::getApplication()->input->files->get('jform');

        // Make the file name safe.
        $filename = JFile::makeSafe($file['vdbfile']['name']);

        // Move the uploaded file into a permanent location.
        if ( $filename != '' ) {
            // Make sure that the full file path is safe.
			$filepath = JPath::clean( JPATH_COMPONENT_ADMINISTRATOR . '/files/vdbs/' . strtolower( $filename ) );

            // Move the uploaded file.
            JFile::upload( $file['vdbfile']['tmp_name'], $filepath );
            // Change $data['file'] value before save into the database 
        }
		$data = JRequest::getVar( 'jform', null, 'post', 'array' );
		$data['vdbfile'] = $filename;

		JRequest::setVar('jform', $data );
        // ---------------------------- File Upload Ends ------------------------

		return parent::save();
	}
	
	public function postSaveHook($model, $validData){
	
		// the REST mco server used to send commands
		$mco = new restmco('http://194.116.110.69:4567');
//		$item = $model->getItem();
//echo print_r($item);
//echo print_r($validData);
		// the data to access to the JBoss console
		$params = JComponentHelper::getParams('com_odaienv');
		$jboss_user = $params->get('jboss_user');
		$jboss_pwd = $params->get('jboss_pwd');
		$jboss_dom = $params->get('jboss_dom');
		$jboss_srg = $params->get('jboss_srg');
		$file_cript_key = $params->get('file_cript_key');

		switch ($validData['state']) {
			case 0:     // Unpublished
				$mod = $this->getModel('Datasources');
				$mod->setState('filter.vdb_id','1');
				$rows = $mod->getItems();
				echo "result";
				echo print_r($rows);
				foreach ($rows as &$row){
					echo $row->name;
				}
				break;
			case 1:
				
				// first will have to deploy all the datasources of the VDB
				$mod = $this->getModel('Datasources');
				$mod->setState('filter.vdb_id',$validData['id']);
				$rows = $mod->getItems();
				foreach ($rows as &$row){
					echo $row->name;
					if ($row->state ==1){
					// curl -X POST -H 'content-type: application/json' -d '{"parameters":{"cli_pwd":"opendaiadmin","cli_user":"admin","url":"http://yum-repo.cloudlabcsi.eu/","artefact":"geoserver.war","msg":"test","mode":"domain","server_groups":"geo_group"}}' http://localhost:4567/mcollective/jboss/deploy_url/; echo
						
//						$ret = $mco->call_agent('jboss', 'create_datasource',null,array("cli_pwd"=>$jboss_pwd,"cli_user"=>$jboss_user,"domain_mode"=>$jboss_dom, "datasource"=>$row->name, "jndi_name"=>"java:/rep", "driver"=>"mysql", "driver_class"=>"com.mysql.driver", "connection_url"=>"jdbc:/server.some:2344/ertt", "db_user"=>"pippo", "db_pwd"=>"pluto" ,"msg"=>"test","profile"=>"ha","server_groups"=>$jboss_srg));
//	echo print_r('ret :'.$ret, true);
//	echo print_r('result :'.$mco->result, true);
//	echo print_r('error :'.$mco->error_message, true);
//	echo print_r('error_code :'.$mco->error_code, true);
					}
				}
				// second will have to deploy all the Resources of the VDB
				$mod = $this->getModel('Resources');
				$mod->setState('filter.vdb_id',$validData['id']);
				$rows = $mod->getItems();
				foreach ($rows as &$row){
					echo $row->name;
					if ($row->state ==1){
//						$ret = $mco->call_agent('rpcutil', 'ping');
//	echo print_r('ret :'.$ret, true);
//	echo print_r('result :'.$mco->result, true);
//	echo print_r('error :'.$mco->error_message, true);
//	echo print_r('error_code :'.$mco->error_code, true);
					}
				}
//				$ret = $mco->call_agent('rpcutil', 'ping');
				
				// last call the restmco server to invoke the deployVDB command passing the url of this site to get the VDB
				
				// will have to generate the crypted info for the file
				# create a random IV to use with CBC encoding
				$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
//				echo 'iv_size: ' .$iv_size .' \n';
				$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
				$vdb_item = $model->getItem();
				$encrypted_file_name = mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $file_cript_key, $vdb_item->vdbfile, MCRYPT_MODE_CBC,$iv);  //encrypt using triple DES
//				echo 'iv: ' .$iv .' \n';
//				echo 'encrypted_file_name: ' .$encrypted_file_name .' \n';
				$file_name = urlencode(base64_encode($iv.$encrypted_file_name));
				$url = JRoute::_('index.php?option=com_odaienv&task=vdb.download&file_name='.$file_name);
//				echo 'file: ' .$vdb_item->vdbfile .'\n';
//				echo $url;
//						$ret = $mco->call_agent('jboss', 'deploy_url',null,array("cli_pwd"=>$jboss_pwd,"cli_user"=>$jboss_user,"url"=>$url,"artefact"=>$vdb_item->vdbfile,"msg"=>"test","domain_mode"=>$jboss_dom,"server_groups"=>$jboss_srg));

				break;
		}

	die;
		return parent::postSaveHook($model, $validData);
	}
	
	function download(){
		$params = JComponentHelper::getParams('com_odaienv');
		$file_cript_key = $params->get('file_cript_key');

		$file_name_encoded = JFactory::getApplication()->input->get('file_name',null,'JREQUEST_ALLOWRAW');
	
	
//	echo 'file_name_encoded: ' .$file_name_encoded .'\n';
		$file_name_crypted = base64_decode(urldecode($file_name_encoded));
//	echo 'file_name_crypted: ' .$file_name_crypted .'\n';

	
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
//	echo 'iv_size: ' .$iv_size .' \n';
		$iv_dec = substr($file_name_crypted, 0, $iv_size);
		$file_name_crypted = substr($file_name_crypted, $iv_size);
//	echo 'file_name_crypted only: ' .$file_name_crypted .'\n';
		$decrypted_data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128,$file_cript_key,$file_name_crypted, MCRYPT_MODE_CBC,$iv_dec);
//	echo 'decrypted_data: ' .$decrypted_data .'\n';
//	die;

		$vName		= 'vdb';
		$vFormat	= 'raw';

		// Get and render the view.
		if ($view = $this->getView($vName, $vFormat))
		{

	// Push file name into the view.
			$view->file_name = trim($decrypted_data);

			$view->display();
		}
	}
}// class
?>