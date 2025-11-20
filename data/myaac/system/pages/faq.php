<?php
/**
 * FAQ
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Frequently Asked Questions';

$canEdit = hasFlag(FLAG_CONTENT_FAQ) || superAdmin();
if($canEdit)
{
	if(!empty($action))
	{
		if($action == 'delete' || $action == 'edit' || $action == 'hide' || $action == 'moveup' || $action == 'movedown')
			$id = $_REQUEST['id'];

		if(isset($_REQUEST['question']))
			$question = $_REQUEST['question'];

		if(isset($_REQUEST['answer']))
			$answer = stripslashes($_REQUEST['answer']);

		$errors = array();

		if($action == 'add') {
			if(FAQ::add($question, $answer, $errors))
				$question = $answer = '';
		}
		else if($action == 'delete') {
			FAQ::delete($id, $errors);
		}
		else if($action == 'edit')
		{
			if(isset($id) && !isset($question)) {
				$faq = FAQ::get($id);
				$question = $faq['question'];
				$answer = $faq['answer'];
			}
			else {
				FAQ::update($id, $question, $answer);
				$action = $question = $answer = '';
			}
		}
		else if($action == 'hide') {
			FAQ::toggleHidden($id, $errors);
		}
		else if($action == 'moveup') {
			FAQ::move($id, -1, $errors);
		}
		else if($action == 'movedown') {
			FAQ::move($id, 1, $errors);
		}

		if(!empty($errors))
			$twig->display('error_box.html.twig', array('errors' => $errors));
	}

	$twig->display('faq.form.html.twig', array(
		'link' => getLink('faq/' . ($action == 'edit' ? 'edit' : 'add')),
		'action' => $action,
		'id' => isset($id) ? $id : null,
		'question' => isset($question) ? $question : null,
		'answer' => isset($answer) ? $answer : null
	));
}

$faqs =
	$db->query('SELECT `id`, `question`, `answer`' .
		($canEdit ? ', `hidden`, `ordering`' : '') .
		' FROM `' . TABLE_PREFIX . 'faq`' .
		(!$canEdit ? ' WHERE `hidden` != 1' : '') .
		' ORDER BY `ordering`;');

if(!$faqs->rowCount())
{
	?>
	There are no questions added yet.
	<?php
}

$last = $faqs->rowCount();
$twig->display('faq.html.twig', array(
	'faqs' => $faqs,
	'last' => $last,
	'canEdit' => $canEdit
));

class FAQ
{
	static public function add($question, $answer, &$errors)
	{
		global $db;
		if(isset($question[0]) && isset($answer[0]))
		{
			$query = $db->select(TABLE_PREFIX . 'faq', array('question' => $question));

			if($query === false)
			{
				$query =
					$db->query(
						'SELECT ' . $db->fieldName('ordering') .
						' FROM ' . $db->tableName(TABLE_PREFIX . 'faq') .
						' ORDER BY ' . $db->fieldName('ordering') . ' DESC LIMIT 1'
					);

				$ordering = 0;
				if($query->rowCount() > 0) {
					$query = $query->fetch();
					$ordering = $query['ordering'] + 1;
				}
				$db->insert(TABLE_PREFIX . 'faq', array('question' => $question, 'answer' => $answer, 'ordering' => $ordering));
			}
			else
				$errors[] = 'FAQ with this question already exists.';
		}
		else
			$errors[] = 'Please fill all inputs.';

		return !count($errors);
	}

	static public function get($id) {
		global $db;
		return $db->select(TABLE_PREFIX . 'faq', array('id' => $id));
	}

	static public function update($id, $question, $answer) {
		global $db;
		$db->update(TABLE_PREFIX . 'faq', array('question' => $question, 'answer' => $answer), array('id' => $id));
	}

	static public function delete($id, &$errors)
	{
		global $db;
		if(isset($id))
		{
			if(self::get($id) !== false)
				$db->delete(TABLE_PREFIX . 'faq', array('id' => $id));
			else
				$errors[] = 'FAQ with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'id not set';

		return !count($errors);
	}

	static public function toggleHidden($id, &$errors)
	{
		global $db;
		if(isset($id))
		{
			$query = self::get($id);
			if($query !== false)
				$db->update(TABLE_PREFIX . 'faq', array('hidden' => ($query['hidden'] == 1 ? 0 : 1)), array('id' => $id));
			else
				$errors[] = 'FAQ with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'id not set';

		return !count($errors);
	}

	static public function move($id, $i, &$errors)
	{
		global $db;
		$query = self::get($id);
		if($query !== false)
		{
			$ordering = $query['ordering'] + $i;
			$old_record = $db->select(TABLE_PREFIX . 'faq', array('ordering' => $ordering));
			if($old_record !== false)
				$db->update(TABLE_PREFIX . 'faq', array('ordering' => $query['ordering']), array('ordering' => $ordering));

			$db->update(TABLE_PREFIX . 'faq', array('ordering' => $ordering), array('id' => $id));
		}
		else
			$errors[] = 'FAQ with id ' . $id . ' does not exists.';

		return !count($errors);
	}
}
