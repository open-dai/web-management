<?php
// no direct access
defined('_JEXEC') or die('Restricted access');

JHtml::_('bootstrap.tooltip');
JHtml::_('behavior.multiselect');
JHtml::_('dropdown.init');
JHtml::_('formbehavior.chosen', 'select');

?>

<?php  ?>
<h3><?php 
if (isset($this->result->errorcode)){
echo JText::_('COM_ODAIENV_DEPLOYED_FALIURE') . $this->thevm;
echo $this->result->errortext;
}else{
echo JText::_('COM_ODAIENV_DEPLOYED_SUCCESS') . $this->thevm;
} ?></h3>
<?php
$link = JRoute::_( 'index.php?option=com_odaienv');
?>
<a <?php echo $onclick; ?>href="<?php echo $link; ?>"><?php echo JText::_('COM_ODAIENV_DEPLOYED_RETURN'); ?></a>