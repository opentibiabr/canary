<?php
/**
 * Menus
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Menus';

if (!hasFlag(FLAG_CONTENT_MENUS) && !superAdmin()) {
    echo 'Access denied.';
    return;
}

if (isset($_REQUEST['template'])) {
    $template = $_REQUEST['template'];

    if (isset($_REQUEST['menu'])) {
        $post_menu = $_REQUEST['menu'];
        $post_menu_link = $_REQUEST['menu_link'];
        $post_menu_blank = $_REQUEST['menu_blank'];
        $post_menu_color = $_REQUEST['menu_color'];
        if (count($post_menu) != count($post_menu_link)) {
            echo 'Menu count is not equal menu links. Something went wrong when sending form.';
            return;
        }

        $db->query('DELETE FROM `' . TABLE_PREFIX . 'menu` WHERE `template` = ' . $db->quote($template));
        foreach ($post_menu as $category => $menus) {
            foreach ($menus as $i => $menu) {
                if (empty($menu)) // don't save empty menu item
                    continue;

                try {
                    $db->insert(TABLE_PREFIX . 'menu', array('template' => $template, 'name' => $menu, 'link' => $post_menu_link[$category][$i], 'blank' => $post_menu_blank[$category][$i] == 'on' ? 1 : 0, 'color' => str_replace('#', '', $post_menu_color[$category][$i]), 'category' => $category, 'ordering' => $i));
                } catch (PDOException $error) {
                    warning('Error while adding menu item (' . $menu . '): ' . $error->getMessage());
                }
            }
        }

        $cache = Cache::getInstance();
        if ($cache->enabled()) {
            $cache->delete('template_menus');
        }

        success('Saved at ' . date('H:i'));
    }

    $file = TEMPLATES . $template . '/config.php';
    if (file_exists($file)) {
        require_once $file;
    } else {
        echo 'Cannot find template config.php file.';
        return;
    }

    if (!isset($config['menu_categories'])) {
        echo "No menu categories set in template config.php.<br/>This template doesn't support dynamic menus.";
        return;
    }

    echo 'Hint: You can drag menu items.<br/>
	Hint: Add links to external sites using: <b>http://</b> or <b>https://</b> prefix.<br/>
	Not all templates support blank and colorful links.<br/><br/>
    <div>';
    $menus = array();
    $menus_db = $db->query('SELECT `name`, `link`, `blank`, `color`, `category`, `ordering` FROM `' . TABLE_PREFIX . 'menu` WHERE `enabled` = 1 AND `template` = ' . $db->quote($template) . ' ORDER BY `ordering` ASC;')->fetchAll();
    foreach ($menus_db as $menu) {
        $menus[$menu['category']][] = array('name' => $menu['name'], 'link' => $menu['link'], 'blank' => $menu['blank'], 'color' => $menu['color'], 'ordering' => $menu['ordering']);
    }

    $last_id = array();
    echo '<form method="post" id="menus-form" class="row" action="?p=menus">';
    echo '<input type="hidden" name="template" value="' . $template . '"/>';
    foreach ($config['menu_categories'] as $id => $cat) {
        echo '        <div class="col-6">
            <div class="box box-danger">
                <div class="box-header with-border">
                    <h3 class="box-title">' . $cat['name'] . ' <i class="fa fa-plus-circle btn btn-success add-button" title="New" id="add-button-' . $id . '"></i></h3>
                </div>
                <div class="box-body">';


        echo '<ul class="sortable" id="sortable-' . $id . '">';
        if (isset($menus[$id])) {
            $i = 0;
            foreach ($menus[$id] as $menu) {
                echo '<li class="ui-state-default" id="list-' . $id . '-' . $i . '"><label>Name: </label><input type="text" name="menu[' . $id . '][]" value="' . escapeHtml($menu['name']) . '"/>
				<label>Link: </label><input type="text" name="menu_link[' . $id . '][]" value="' . $menu['link'] . '"/>
				<input type="hidden" name="menu_blank[' . $id . '][]" value="0" />
				<label><input class="blank-checkbox" type="checkbox" ' . ($menu['blank'] == 1 ? 'checked' : '') . '/> <span title="Open in New Window">Open in New Window</span></label>

				<input class="color-picker" type="text" name="menu_color[' . $id . '][]" value="#' . $menu['color'] . '" />

				<a class="btn btn-danger" id="remove-button-' . $id . '-' . $i . '"><i class="fas fa-trash-alt text-white" title="Remove"></i></a></li>';

                $i++;
                $last_id[$id] = $i;
            }
        }

        echo '</ul>';
        echo '                </div>
            </div>
        </div>
';
    }
    echo ' </div><div class="row"><div class="col-md-3">';
    echo '<input type="submit" class="btn btn-success" value="Save">';
    echo '<input type="button" class="btn btn-info pull-right" value="Cancel" onclick="window.location = \'' . ADMIN_URL . '?p=menus&template=' . $template . '\';">';
    echo '</div></div>';
    echo '</form>';

    $twig->display('admin.menus.js.html.twig', array(
        'menus' => $menus,
        'last_id' => $last_id
    ));
    ?>

    <?php
} else {
    $templates = $db->query('SELECT `template` FROM `' . TABLE_PREFIX . 'menu` GROUP BY `template`;')->fetchAll();
    foreach ($templates as $key => $value) {
        $file = TEMPLATES . $value['template'] . '/config.php';
        if (!file_exists($file)) {
            unset($templates[$key]);
        }
    }

    $twig->display('admin.menus.form.html.twig', array(
        'templates' => $templates
    ));
}
