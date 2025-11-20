<?php
if($config['banner_status'] == true){
?>
<div class="modal fade" id="BannerModal" tabindex="-1" aria-labelledby="BannerModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" style="background: none; border: none; border-radius: 0.3rem;">
      <div class="modal-body">
		  <a href="http://<?php echo $config['banner_link'] ?>">
			<img src="<?php echo $template_path; ?>/images/carousel/<?php echo $config['banner_image'] ?>" style="width: 100%;">
		  </a>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$("#BannerModal").modal('show');
});
</script>
<?php } ?>
<?php
/**
 * News
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

require_once LIBS . 'forum.php';
require_once LIBS . 'news.php';

if(isset($_GET['archive']))
{
	$title = 'News Archive';

	$categories = array();
	foreach($db->query('SELECT id, name, icon_id FROM ' . TABLE_PREFIX . 'news_categories WHERE hidden != 1') as $cat)
	{
		$categories[$cat['id']] = array(
			'name' => $cat['name'],
			'icon_id' => $cat['icon_id']
		);
	}

	// display big news by id
	if(isset($_GET['id']))
	{
		$field_name = 'date';
		if($_REQUEST['id'] < 100000)
			$field_name = 'id';

		$news = $db->query('SELECT * FROM `'.TABLE_PREFIX . 'news` WHERE `hidden` != 1 AND `' . $field_name . '` = ' . (int)$_REQUEST['id']  . '');
		if($news->rowCount() == 1)
		{
			$news = $news->fetch();
			$author = '';
			$query = $db->query('SELECT `name` FROM `players` WHERE id = ' . $db->quote($news['player_id']) . ' LIMIT 1;');
			if($query->rowCount() > 0) {
				$query = $query->fetch();
				$author = $query['name'];
			}

			$content_ = $news['body'];
			$firstLetter = '';
			if($content_[0] != '<')
			{
				$tmp = $template_path.'/images/letters/' . $content_[0] . '.gif';
				if(file_exists($tmp)) {
					$firstLetter = '<img src="' . $tmp . '" alt="' . $content_[0] . '" border="0" align="bottom">';
					$content_ = $firstLetter . substr($content_, 1);
				}
			}

			$twig->display('news.html.twig', array(
				'title' => stripslashes($news['title']),
				'content' => $content_,
				'date' => $news['date'],
				'icon' => $categories[$news['category']]['icon_id'],
				'author' => $config['news_author'] ? $author : '',
				'comments' => $news['comments'] != 0 ? getForumThreadLink($news['comments']) : null,
				'news_date_format' => $config['news_date_format']
			));
		}
		else
			echo "This news doesn't exist or is hidden.<br/>";

		$twig->display('news.back_button.html.twig');
		return;
	}
	?>

	<?php

	$newses = array();
	$news_DB = $db->query('SELECT * FROM '.$db->tableName(TABLE_PREFIX . 'news').' WHERE `type` = 1 AND `hidden` != 1 ORDER BY `date` DESC');
	foreach($news_DB as $news)
	{
		$newses[] = array(
			'link' => getLink('news') . '/archive/' . $news['id'],
			'icon_id' => $categories[$news['category']]['icon_id'],
			'title' => stripslashes($news['title']),
			'date' => $news['date']
		);
	}

	$twig->display('news.archive.html.twig', array(
		'newses' => $newses
	));

	return;
}

header('X-XSS-Protection: 0');
$title = 'Latest News';

$cache = Cache::getInstance();
$canEdit = hasFlag(FLAG_CONTENT_NEWS) || superAdmin();

$news_cached = false;
if($cache->enabled())
	$news_cached = News::getCached(NEWS);

if(!$news_cached)
{
	$categories = array();
	foreach($db->query('SELECT `id`, `name`, `icon_id` FROM `' . TABLE_PREFIX . 'news_categories` WHERE `hidden` != 1') as $cat)
	{
		$categories[$cat['id']] = array(
			'name' => $cat['name'],
			'icon_id' => $cat['icon_id']
		);
	}

	$tickers_db = $db->query('SELECT * FROM `' . TABLE_PREFIX . 'news` WHERE `type` = ' . TICKER .($canEdit ? '' : ' AND `hidden` != 1') .' ORDER BY `date` DESC LIMIT ' . $config['news_ticker_limit']);
	$tickers_content = '';
	if($tickers_db->rowCount() > 0)
	{
		$tickers = $tickers_db->fetchAll();
		foreach($tickers as &$ticker) {
			$ticker['icon'] = $categories[$ticker['category']]['icon_id'];
			$ticker['body_short'] = short_text(strip_tags($ticker['body']), 100);
		}

		$tickers_content = $twig->render('news.tickers.html.twig', array(
			'tickers' => $tickers,
			'canEdit' => $canEdit
		));
	}

	if($cache->enabled() && !$canEdit)
		$cache->set('news_' . $template_name . '_' . TICKER, $tickers_content, 60 * 60);

	$featured_article_db =$db->query('SELECT `id`, `title`, `article_text`, `article_image`, `hidden` FROM `' . TABLE_PREFIX . 'news` WHERE `type` = ' . ARTICLE . ($canEdit ? '' : ' AND `hidden` != 1') .' ORDER BY `date` DESC LIMIT 1');
	$article = '';
	if($featured_article_db->rowCount() > 0) {
		$article = $featured_article_db->fetch();

		$featured_article = '';
		if($twig->getLoader()->exists('news.featured_article.html.twig')) {
			$featured_article = $twig->render('news.featured_article.html.twig', array(
				'article' => array(
					'id' => $article['id'],
					'title' => $article['title'],
					'text' => $article['article_text'],
					'image' => $article['article_image'],
					'hidden' => $article['hidden'],
					'read_more'=> getLink('news/archive/') . $article['id']
				),
				'canEdit' => $canEdit
			));
		}

		if($cache->enabled() && !$canEdit)
			$cache->set('news_' . $template_name . '_' . ARTICLE, $featured_article, 60 * 60);
	}
}
else {
	$tickers_content = News::getCached(TICKER);
	$featured_article = News::getCached(ARTICLE);
}

if(!$news_cached)
{
	ob_start();
	$newses = $db->query('SELECT * FROM ' . $db->tableName(TABLE_PREFIX . 'news') . ' WHERE type = ' . NEWS . ($canEdit ? '' : ' AND hidden != 1') . ' ORDER BY date' . ' DESC LIMIT ' . $config['news_limit']);
	if($newses->rowCount() > 0)
	{
		foreach($newses as $news)
		{
			$author = '';
			$query = $db->query('SELECT `name` FROM `players` WHERE id = ' . $db->quote($news['player_id']) . ' LIMIT 1');
			if($query->rowCount() > 0) {
				$query = $query->fetch();
				$author = $query['name'];
			}

			$admin_options = '';
			if($canEdit)
			{
				$admin_options = '<br/><br/><a target="_blank" rel="noopener noreferrer" href="/admin/?p=news&action=edit&id=' . $news['id'] . '" title="Edit">
					<img src="images/edit.png"/>Edit
				</a>
				<a id="delete" target="_blank" rel="noopener noreferrer" href="/admin/?p=news&action=delete&id=' . $news['id'] . '" onclick="return confirm(\'Are you sure?\');" title="Delete">
					<img src="images/del.png"/>Delete
				</a>
				<a target="_blank" rel="noopener noreferrer" href="/admin/?p=news&action=hide&id=' . $news['id'] . '" title="' . ($news['hidden'] != 1 ? 'Hide' : 'Show') . '">
					<img src="images/' . ($news['hidden'] != 1 ? 'success' : 'error') . '.png"/>
					' . ($news['hidden'] != 1 ? 'Hide' : 'Show') . '
				</a>';
			}

			$content_ = $news['body'];
			$firstLetter = '';
			if($content_[0] != '<')
			{
				$tmp = $template_path.'/images/letters/' . $content_[0] . '.gif';
				if(file_exists($tmp)) {
					$firstLetter = '<img src="' . $tmp . '" alt="' . $content_[0] . '" border="0" align="bottom">';
					$content_ = $firstLetter . substr($content_, 1);
				}
			}

			$twig->display('news.html.twig', array(
				'id' => $news['id'],
				'title' => stripslashes($news['title']),
				'content' => $content_ . $admin_options,
				'date' => $news['date'],
				'icon' => $categories[$news['category']]['icon_id'],
				'author' => $config['news_author'] ? $author : '',
				'comments' => $news['comments'] != 0 ? getForumThreadLink($news['comments']) : null,
				'news_date_format' => $config['news_date_format'],
				'hidden'=> $news['hidden']
			));
		}
	}

	$tmp_content = ob_get_contents();
	ob_end_clean();

	if($cache->enabled() && !$canEdit)
		$cache->set('news_' . $template_name . '_' . NEWS, $tmp_content, 60 * 60);

	echo $tmp_content;
}
else
	echo $news_cached;
