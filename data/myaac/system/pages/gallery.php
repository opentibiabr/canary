<?php
/**
 * Gallery
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Gallery';

$canEdit = hasFlag(FLAG_CONTENT_GALLERY) || superAdmin();
if($canEdit) {
	if(function_exists('imagecreatefrompng')) {
		if (!empty($action)) {
			if ($action == 'delete' || $action == 'edit' || $action == 'hide' || $action == 'moveup' || $action == 'movedown')
				$id = $_REQUEST['id'];

			if (isset($_REQUEST['comment']))
				$comment = stripslashes($_REQUEST['comment']);

			if (isset($_REQUEST['image']))
				$image = $_REQUEST['image'];

			if (isset($_REQUEST['author']))
				$author = $_REQUEST['author'];

			$errors = array();

			if ($action == 'add') {
				if (Gallery::add($comment, $image, $author, $errors))
					$comment = $image = $author = '';
			} else if ($action == 'delete') {
				Gallery::delete($id, $errors);
			} else if ($action == 'edit') {
				if (isset($id) && !isset($name)) {
					$tmp = Gallery::get($id);
					$comment = $tmp['comment'];
					$image = $tmp['image'];
					$author = $tmp['author'];
				} else {
					Gallery::update($id, $comment, $image, $author);
					$action = $comment = $image = $author = '';
				}
			} else if ($action == 'hide') {
				Gallery::toggleHidden($id, $errors);
			} else if ($action == 'moveup') {
				Gallery::move($id, -1, $errors);
			} else if ($action == 'movedown') {
				Gallery::move($id, 1, $errors);
			}

			if (!empty($errors))
				$twig->display('error_box.html.twig', array('errors' => $errors));
		}

		if(!isset($_GET['image'])) {
			$twig->display('gallery.form.html.twig', array(
				'link' => getLink('gallery/' . ($action == 'edit' ? 'edit' : 'add')),
				'action' => $action,
				'id' => isset($id) ? $id : null,
				'comment' => isset($comment) ? $comment : null,
				'image' => isset($image) ? $image : null,
				'author' => isset($author) ? $author : null
			));
		}
	}
	else
		echo 'You cannot edit/add gallery items as it seems your PHP installation doesnt have GD support enabled. Visit <a href="http://be2.php.net/manual/en/image.installation.php">PHP Manual</a> for more info.';
}

if(isset($_GET['image']))
{
	$image = $db->query('SELECT * FROM `' . TABLE_PREFIX . 'gallery`  WHERE `id` = ' . $db->quote($_GET['image']) . ' ORDER by `ordering` LIMIT 1;');
	if($image->rowCount() == 1)
		$image = $image->fetch();
	else
	{
		echo 'Image with this id does not exists.';
		return;
	}

	$previous_image = $db->query('SELECT `id` FROM `' . TABLE_PREFIX . 'gallery` WHERE `id` = ' . $db->quote($image['id'] - 1) . ' ORDER by `ordering`;');
	if($previous_image->rowCount() == 1)
		$previous_image = $previous_image->fetch();
	else
		$previous_image = NULL;

	$next_image = $db->query('SELECT `id` FROM `' . TABLE_PREFIX . 'gallery` WHERE `id` = ' . $db->quote($image['id'] + 1) . ' ORDER by `ordering`;');
	if($next_image->rowCount() == 1)
		$next_image = $next_image->fetch();
	else
		$next_image = NULL;

	$twig->display('gallery.get.html.twig', array(
		'previous' => $previous_image ? $previous_image['id'] : null,
		'next' => $next_image ? $next_image['id'] : null,
		'image' => $image
	));
	return;
}

$images =
	$db->query('SELECT `id`, `comment`, `image`, `author`, `thumb`' .
		($canEdit ? ', `hidden`, `ordering`' : '') .
		' FROM `' . TABLE_PREFIX . 'gallery`' .
		(!$canEdit ? ' WHERE `hidden` != 1' : '') .
		' ORDER BY `ordering`;');

$last = $images->rowCount();
if(!$last)
{
?>
	There are no images added to gallery yet.
<?php
	return;
}

$twig->display('gallery.html.twig', array(
	'images' => $images,
	'last' => $last,
	'canEdit' => $canEdit
));

class Gallery
{
	static public function add($comment, $image, $author, &$errors)
	{
		global $db;
		if(isset($comment[0]) && isset($image[0]) && isset($author[0]))
		{
			$query =
				$db->query(
					'SELECT `ordering`' .
					' FROM `' . TABLE_PREFIX . 'gallery`' .
					' ORDER BY `ordering`' . ' DESC LIMIT 1'
				);

			$ordering = 0;
			if($query->rowCount() > 0) {
				$query = $query->fetch();
				$ordering = $query['ordering'] + 1;
			}

			$pathinfo = pathinfo($image);
			$extension = strtolower($pathinfo['extension']);
			$thumb_filename = 'images/gallery/' . $pathinfo['filename'] . '_thumb.' . $extension;
			$filename = 'images/gallery/' . $pathinfo['filename'] . '.' . $extension;
			if($db->insert(TABLE_PREFIX . 'gallery', array(
				'comment' => $comment,
				'image' => $filename, 'author' => $author,
				'thumb' => $thumb_filename,
				'ordering' => $ordering))) {
				if(self::generateThumb($db->lastInsertId(), $image, $errors))
					self::resize($image, 650, 500, $filename, $errors);
			}
		}
		else
			$errors[] = 'Please fill all inputs.';

		return !count($errors);
	}

	static public function get($id) {
		global $db;
		return $db->select(TABLE_PREFIX . 'gallery', array('id' => $id));
	}

	static public function update($id, $comment, $image, $author) {
		global $db;

		$pathinfo = pathinfo($image);
		$extension = strtolower($pathinfo['extension']);
		$filename = 'images/gallery/' . $pathinfo['filename'] . '.' . $extension;

		if($db->update(TABLE_PREFIX . 'gallery', array(
			'comment' => $comment,
			'image' => $filename, 'author' => $author),
			array('id' => $id)
		)) {
			if(self::generateThumb($id, $image, $errors))
				self::resize($image, 650, 500, $filename, $errors);
		}
	}

	static public function delete($id, &$errors)
	{
		global $db;
		if(isset($id))
		{
			if(self::get($id) !== false)
				$db->delete(TABLE_PREFIX . 'gallery', array('id' => $id));
			else
				$errors[] = 'Image with id ' . $id . ' does not exists.';
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
				$db->update(TABLE_PREFIX . 'gallery', array('hidden' => ($query['hidden'] == 1 ? 0 : 1)), array('id' => $id));
			else
				$errors[] = 'Image with id ' . $id . ' does not exists.';
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
			$old_record = $db->select(TABLE_PREFIX . 'gallery', array('ordering' => $ordering));
			if($old_record !== false)
				$db->update(TABLE_PREFIX . 'gallery', array('ordering' => $query['ordering']), array('ordering' => $ordering));

			$db->update(TABLE_PREFIX . 'gallery', array('ordering' => $ordering), array('id' => $id));
		}
		else
			$errors[] = 'Image with id ' . $id . ' does not exists.';

		return !count($errors);
	}

	static public function resize($file, $new_width, $new_height, $new_file, &$errors)
	{
		$pathinfo = pathinfo($file);
		$extension = strtolower($pathinfo['extension']);

		switch ($extension)
		{
			case 'gif': // GIF
				$image = imagecreatefromgif($file);
				break;
			case 'jpg': // JPEG
			case 'jpeg':
				$image = imagecreatefromjpeg($file);
				break;
			case 'png': // PNG
				$image = imagecreatefrompng($file);
				break;
			default:
				$errors[] = 'Unsupported file format.';
				return false;
		}

		$width = imagesx($image);
		$height = imagesy($image);

		// create a new temporary image
		$tmp_img = imagecreatetruecolor($new_width, $new_height);

		// copy and resize old image into new image
		imagecopyresized($tmp_img, $image, 0, 0, 0, 0, $new_width, $new_height, $width, $height);

		// save thumbnail into a file
		switch($extension)
		{
			case 'gif':
				imagegif($tmp_img, $new_file);
				break;

			case 'jpg':
			case 'jpeg':
				imagejpeg($tmp_img, $new_file);
				break;

			case 'png':
				imagepng($tmp_img, $new_file);
				break;
		}

		return true;
	}

	static public function generateThumb($id, $file, &$errors)
	{
		$pathinfo = pathinfo($file);
		$extension = strtolower($pathinfo['extension']);
		$thumb_filename = 'images/gallery/' . $pathinfo['filename'] . '_thumb.' . $extension;

		if(!self::resize($file, 170, 110, $thumb_filename, $errors))
			return false;

		global $db;
		if(isset($id))
		{
			$query = self::get($id);
			if($query !== false)
				$db->update(TABLE_PREFIX . 'gallery', array('thumb' => $thumb_filename), array('id' => $id));
			else
				$errors[] = 'Image with id ' . $id . ' does not exists.';
		}
		else
			$errors[] = 'id not set';

		return !count($errors);
	}
}
