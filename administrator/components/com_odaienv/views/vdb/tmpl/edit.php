<?php
// no direct access
defined('_JEXEC') or die('Restricted access');
JHtml::_('behavior.tooltip');
JHtml::_('behavior.formvalidation');

// Set toolbar items for the page
$edit		= JRequest::getVar('edit', true);
$text = !$edit ? JText::_( 'New' ) : JText::_( 'Edit' );
JToolBarHelper::title(   JText::_( 'COM_ODAIENV_VDB' ).': <small><small>[ ' . $text.' ]</small></small>' );
JToolBarHelper::apply('vdb.apply');
JToolBarHelper::save('vdb.save');
if (!$edit) {
	JToolBarHelper::cancel('vdb.cancel');
} else {
	// for existing items the button is renamed `close`
	JToolBarHelper::cancel( 'vdb.cancel', 'Close' );
}

$option = JRequest::getCmd('option');
?>

<script language="javascript" type="text/javascript">


Joomla.submitbutton = function(task)
{
	if (task == 'vdb.cancel' || document.formvalidator.isValid(document.id('adminForm'))) {
		Joomla.submitform(task, document.getElementById('adminForm'));
	}
}

</script>

	 	<form method="post" action="<?php echo JRoute::_('index.php?option=com_odaienv&layout=edit&id='.(int) $this->item->id);  ?>" id="adminForm" name="adminForm" enctype="multipart/form-data">
	 	<div class="col <?php if(version_compare(JVERSION,'3.0','lt')):  ?>width-60  <?php endif; ?>span8 form-horizontal fltlft">
		  <fieldset class="adminform">
			<legend><?php echo JText::_( 'Details' ); ?></legend>
		
				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('name'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('name');  ?>
					</div>
				</div>		
					
				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('vdbfile'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('vdbfile');  ?><?php echo $this->item->vdbfile ?>
					</div>
				</div>		

				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('state'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('state');  ?>
					</div>
				</div>		
			
						
          </fieldset>                      
        </div>
        <div class="col <?php if(version_compare(JVERSION,'3.0','lt')):  ?>width-30  <?php endif; ?>span2 fltrgt">
			        

        </div>                   
		<input type="hidden" name="option" value="com_odaienv" />
	    <input type="hidden" name="cid[]" value="<?php echo $this->item->id ?>" />
		<input type="hidden" name="task" value="" />
		<input type="hidden" name="view" value="vdb" />
		<?php echo JHTML::_( 'form.token' ); ?>
	</form>
	<div class="clearfix"> </div>
	<?php    if ($this->item->id) { ?>
<form action="index.php" method="post" name="datasourcesForm" id="datasourcesForm">
    <input type="hidden" name="option" value="<?php echo $option?>" />
    <input type="hidden" name="task" value="" />
    <input type="hidden" name="boxchecked" value="0" />
    <input type="hidden" name="vdb_id" value="<?php echo $this->item->id?>" />
    <?php echo JHtml::_('form.token'); ?>
    
    <fieldset class="adminform">
        <legend><?php echo JText::_( 'COM_ODAIENV_DATASOURCES_X_VDB_LIST' ); ?></legend>
    <div class="subhead">
        <?php echo $this->datasourcesToolBar ?>
		</div>
        <table class="adminlist">
            <thead>
                <tr>
                    <th width="1%">
                        <input type="checkbox" onclick="Joomla.checkAll(this)" title="<?ph echo JText::_( 'JGLOBAL_CHECK_ALL' )?>" value="" name="checkall-toggle">
                    </th>
                    <th>
                        <?php echo JText::_('COM_ODAIENV_DATASOURCES_NAME'); ?>
                    </th>
                    <th>
                        <?php echo JText::_('JGLOBAL_FIELD_ID_LABEL'); ?>
                    </th>
                </tr>
            </thead>
            <tbody>
<?php
        $k = 0;
        $i = 0;
        foreach ($this->datasources as &$row)
        {
            $checked = '<input type="checkbox" id="cb' . $i . '" name="cid[]" value="' . $row->id
                . '" onclick="Joomla.isChecked(this.checked, document.datasourcesForm);" title="' . JText::sprintf('JGRID_CHECKBOX_ROW_N', ($i + 1)) . '" />';
            $i++;
            $link = JRoute::_( 'index.php?option=' . $option . '&task=datasource.edit&id=' . $row->id );
?>
                <tr class="row<?php echo $k?>">
                    <td><?php echo $checked?></td>
                    <td>
                        <a href="<?php echo $link?>">
                            <?php echo $row->name?>
                        </a>
                    </td>
                    <td>
                        <a href="<?php echo $link?>">
                            <?php echo $row->id?>
                        </a>
                    </td>
                </tr>
<?php
            $k = 1 - $k;
        }
?>
            </tbody>
        </table>
    </fieldset>
</form>
<?php    } ?>
	<div class="clearfix"> </div>
	<?php    if ($this->item->id) { ?>
<form action="index.php" method="post" name="resourcesForm" id="resourcesForm">
    <input type="hidden" name="option" value="<?php echo $option?>" />
    <input type="hidden" name="task" value="" />
    <input type="hidden" name="boxchecked" value="0" />
    <input type="hidden" name="vdb_id" value="<?php echo $this->item->id?>" />
    <?php echo JHtml::_('form.token'); ?>
    
    <fieldset class="adminform">
        <legend><?php echo JText::_( 'COM_ODAIENV_RESOURCES_X_VDB_LIST' ); ?></legend>
    <div class="subhead">
        <?php echo $this->resourcesToolBar ?>
		</div>
        <table class="adminlist">
            <thead>
                <tr>
                    <th width="1%">
                        <input type="checkbox" onclick="Joomla.checkAll(this)" title="<?ph echo JText::_( 'JGLOBAL_CHECK_ALL' )?>" value="" name="checkall-toggle">
                    </th>
                    <th>
                        <?php echo JText::_('COM_ODAIENV_RESOURCES_NAME'); ?>
                    </th>
                    <th>
                        <?php echo JText::_('JGLOBAL_FIELD_ID_LABEL'); ?>
                    </th>
                </tr>
            </thead>
            <tbody>
<?php
        $k = 0;
        $i = 0;
        foreach ($this->resources as &$row)
        {
            $checked = '<input type="checkbox" id="cb' . $i . '" name="cid[]" value="' . $row->id
                . '" onclick="Joomla.isChecked(this.checked, document.resourcesForm);" title="' . JText::sprintf('JGRID_CHECKBOX_ROW_N', ($i + 1)) . '" />';
            $i++;
            $link = JRoute::_( 'index.php?option=' . $option . '&task=resource.edit&id=' . $row->id );
?>
                <tr class="row<?php echo $k?>">
                    <td><?php echo $checked?></td>
                    <td>
                        <a href="<?php echo $link?>">
                            <?php echo $row->name?>
                        </a>
                    </td>
                    <td>
                        <a href="<?php echo $link?>">
                            <?php echo $row->id?>
                        </a>
                    </td>
                </tr>
<?php
            $k = 1 - $k;
        }
?>
            </tbody>
        </table>
    </fieldset>
</form>
<?php    } ?>