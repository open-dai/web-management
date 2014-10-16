<?php
// no direct access
defined('_JEXEC') or die('Restricted access');
JHtml::_('behavior.tooltip');
JHtml::_('behavior.formvalidation');

// Set toolbar items for the page
$edit		= JRequest::getVar('edit', true);
$text = !$edit ? JText::_( 'New' ) : JText::_( 'Edit' );
JToolBarHelper::title(   JText::_( 'Api' ).': <small><small>[ ' . $text.' ]</small></small>' );
JToolBarHelper::apply('api.apply');
JToolBarHelper::save('api.save');
if (!$edit) {
	JToolBarHelper::cancel('api.cancel');
} else {
	// for existing items the button is renamed `close`
	JToolBarHelper::cancel( 'api.cancel', 'Close' );
}
?>

<script language="javascript" type="text/javascript">


Joomla.submitbutton = function(task)
{
	if (task == 'api.cancel' || document.formvalidator.isValid(document.id('adminForm'))) {
		Joomla.submitform(task, document.getElementById('adminForm'));
	}
}

</script>

	 	<form method="post" action="<?php echo JRoute::_('index.php?option=com_odaienv&layout=edit&id='.(int) $this->item->id);  ?>" id="adminForm" name="adminForm">
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
						<?php echo $this->form->getInput('vdbfile');  ?>
					</div>
				</div>		

				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('datasource'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('datasource');  ?>
					</div>
				</div>		
				
				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('jndiname'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('jndiname');  ?>
					</div>
				</div>		

				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('drivername'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('drivername');  ?>
					</div>
				</div>		

				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('driverclass'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('driverclass');  ?>
					</div>
				</div>		
				
				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('connectionurl'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('connectionurl');  ?>
					</div>
				</div>		

				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('user'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('user');  ?>
					</div>
				</div>		

				<div class="control-group">
					<div class="control-label">					
						<?php echo $this->form->getLabel('password'); ?>
					</div>
					
					<div class="controls">	
						<?php echo $this->form->getInput('password');  ?>
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
		<input type="hidden" name="view" value="api" />
		<?php echo JHTML::_( 'form.token' ); ?>
	</form>