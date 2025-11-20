<?php
$diasemana = array('domingo', 'segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sabado');
$data = date('Y-m-d');
$diasemana_numero = date('w', strtotime($data));
		
if($diasemana[$diasemana_numero] == 'domingo'){
	$rashid_city = 'Carlin';
}
if($diasemana[$diasemana_numero] == 'segunda'){
	$rashid_city = 'Svargrond';
}
if($diasemana[$diasemana_numero] == 'terça'){
	$rashid_city = 'Liberty Bay';
}
if($diasemana[$diasemana_numero] == 'quarta'){
	$rashid_city = 'Port Hope';
}
if($diasemana[$diasemana_numero] == 'quinta'){
	$rashid_city = 'Ankrahmun';
}
if($diasemana[$diasemana_numero] == 'sexta'){
	$rashid_city = 'Darashia';
}
if($diasemana[$diasemana_numero] == 'sabado'){
	$rashid_city = 'Edron';
}
?>
<style>
    .rashid{
        width: 180px;
        height: 145px;
    }
    .rashid_header{
        height: 45px;
        width: 180px;
        background-image: url('templates/tibiacom/images/themeboxes/box_top.png');
        font-family: Verdana;
        font-weight: bold;
        color: #d5c3af;
        line-height: 65px;
    }
    .rashid_bottom{
        height: 30px;
        width: 180px;
        margin-top: -20px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bottom.png');
    }
    .rashid_content{
        padding: 0px 10px;
        width: 160px;
        height: 80px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bg.png');
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .rashid_outfit{
        position: absolute;
        width: 64px;
        height: 64px;
        background-position: bottom right;
        left: 10px;
        margin-top: -15px;
    }
    .rashid_text{
        margin-left: 45px;
        font-family: Verdana;
        color: #d5c3af;
        text-align: left;
    }
</style>
<div class="rashid">
    <div class="rashid_header">Rashid</div>
    <div class="rashid_content">
        <div class="rashid_outfit" style="background-image: url('<?php echo $template_path ?>/images/themeboxes/rashid/Rashid.gif')"></div>
        <div class="rashid_text">
            <b>City:</b><br>
            <small><?php echo $rashid_city ?></small>
        </div>
    </div>
    <div class="rashid_bottom"></div>
</div>