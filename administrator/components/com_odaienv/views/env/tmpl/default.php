<?php
// no direct access
defined('_JEXEC') or die('Restricted access');

JHtml::_('bootstrap.tooltip');
JHtml::_('behavior.multiselect');
JHtml::_('dropdown.init');
JHtml::_('formbehavior.chosen', 'select');

?>
	<?php if (!empty( $this->sidebar)) : ?>
	<div id="j-sidebar-container" class="span2">
		<?php echo $this->sidebar; ?>
	</div>
	<div id="j-main-container" class="span10">
<?php else : ?>
	<div id="j-main-container">
<?php endif;?>
<div id="filter-bar" class="btn-toolbar">

		</div>
	
	<?php
	## Initialize array to store dropdown options ##
	$templateOptions = array();
	
	foreach($this->templates as $template) :
		## Create $value ##
		$templateOptions[] = JHTML::_('select.option', $template->id, $template->name);
	endforeach;
	
	## Create <select name="month" class="inputbox"></select> ##
	$templateDropdown = JHTML::_('select.genericlist', $templateOptions, 'template', 'style="width:150px;" class="inputbox"', 'value', 'text', 1);
	
	$isoOptions = array();
	
	foreach($this->isos as $iso) :
		## Create $value ##
		$isoOptions[] = JHTML::_('select.option', $iso->id, $iso->name);
	endforeach;
	
	## Create <select name="month" class="inputbox"></select> ##
	$isoDropdown = JHTML::_('select.genericlist', $isoOptions, 'iso', 'style="width:150px;" class="inputbox"', 'value', 'text', 1);

	## Output created <select> list ##
//	echo $templateDropdown;
	
	## diskOptions
	$diskOptions = array();
	foreach($this->diskOfferings as $diskOffering) :
		$diskOptions[] = JHTML::_('select.option', $diskOffering->id, $diskOffering->name);
	endforeach;
	$diskDropdown = JHTML::_('select.genericlist', $diskOptions, 'disk', 'style="width:150px;" class="inputbox"', 'value', 'text', 1);
//	echo JHTML::_('input.hidden', '', '', 12);
	
	## Output created <select> list ##
//	echo $diskDropdown;
	
	## serviceOptions
	$serviceOptions = array();
	foreach($this->serviceOfferngs as $serviceOfferng) :
		$serviceOptions[] = JHTML::_('select.option', $serviceOfferng->id, $serviceOfferng->name);
	endforeach;
	$serviceDropdown = JHTML::_('select.genericlist', $serviceOptions, 'service', 'style="width:150px;" class="inputbox"', 'value', 'text', 1);

	## Output created <select> list ##
//	echo $serviceDropdown;
	
	## serviceOptions
	$networkOptions = array();
	foreach($this->networks as $network) :
		$networkOptions[] = JHTML::_('select.option', $network->id, $network->name);
	endforeach;
	$networkDropdown = JHTML::_('select.genericlist', $networkOptions, 'network', 'style="width:150px;" class="inputbox"', 'value', 'text', 1);

	## Output created <select> list ##
//	echo $networkDropdown;
//	echo print_r($this->odaivms);
//	echo print_r($this->networks);
	?>
			<div class="clearfix"> </div>

	
<div id="editcell">
<h3><?php echo JText::_('COM_ODAIENV_DOMAIN') . ' ' . $this->domain; ?></h3>
	<table class="adminlist table table-striped">
                <thead><tr><th><?php echo JText::_('COM_ODAIENV_VMNAME'); ?></th>
        <th>
                <?php echo JText::_('COM_ODAIENV_STATUS'); ?>
        </th>
        <th>
                <?php echo JText::_('COM_ODAIENV_SERVICE'); ?>
        </th>
		<th>
                <?php echo JText::_('COM_ODAIENV_TEMPLATE'); ?>
        </th>
		<th>
                <?php echo JText::_('COM_ODAIENV_DISK'); ?>
        </th>
		<th>
                <?php echo JText::_('COM_ODAIENV_NETWORK'); ?>
        </th>
		<th>
                <?php echo JText::_('COM_ODAIENV_ACTION'); ?>
        </th>
		</tr>
		</thead>
                <tbody><?php 
    $i = 0;
	foreach($this->odaivms as $odaivm) :
		$present = false;
		foreach($this->vms as $vm) :
			if($vm->name == $odaivm){
				$present = true;
				break;
			}
		endforeach; 
		?>
		<form action="<?php echo JRoute::_('index.php?option=com_odaienv&task=env.vmdeploy&view=deployed'); ?>" method="post" name="<?php echo $odaivm; ?>">
		<tr class="row<?php echo $i % 2; ?>">
		<?php if($present){ ?>
		        <td><?php echo $odaivm; ?><input type="hidden" value="<?php echo $odaivm; ?>" name="vm"/></td>
                <td><?php echo $vm->state; ?></td>
                <td>
                        <?php echo $vm->serviceofferingname; ?>
                </td>
                <td>
                        <?php echo (isset($vm->templatename) ? $vm->templatename : '') . '/' . (isset($vm->isoname) ? $vm->isoname : ''); ?>
                </td>
				<td>
                        <?php echo $vm->rootdevicetype; ?>
                </td>
				<td>
                        <?php echo $vm->nic[0]->ipaddress; ?>
                </td>
				<td>
                        <?php echo $vm->templatename; ?>
                </td>
		<?php }else{ ?>
				<td><?php echo $odaivm; ?><input type="hidden" value="<?php echo $odaivm; ?>" name="vm"/></td>
                <td>
                        <?php echo JText::_('COM_ODAIENV_STATUS_TOCREATE'); ?>
                </td>
                <td><?php echo $serviceDropdown; ?></td>
				<td><?php echo $isoDropdown; ?></td>
				<td><?php echo $diskDropdown; ?></td>
				<td><?php echo $networkDropdown; ?></td>
				<td>
                        <button type="submit" >
				<?php echo JText::_('COM_ODAIENV_STATUS_BTN_DEPLOY') ?>
			</button>
                </td>
		<?php } ?>
		</tr>
		</form>
		<?php
		$i++;
	endforeach;
 ?>
	</tbody></table>
	</div>
	</div>