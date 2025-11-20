<style>
    .rank{
        width: 180px;
        max-height: 360px;
    }
    .rank_header{
        height: 45px;
        width: 180px;
        background-image: url('templates/tibiacom/images/themeboxes/box_top.png');
        font-family: Verdana;
        font-weight: bold;
        color: #d5c3af;
        line-height: 65px;
    }
    .rank_bottom{
        height: 30px;
        width: 180px;
        margin-top: -20px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bottom.png');
    }
    .rank_content{
        padding: 0px 10px;
        width: 160px;
        max-height: 290px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bg.png');
    }
    .rank_player{
        font-family: Verdana;
        color: #d5c3af;
        text-align: left;
        display: flex;
        align-items: center;
        padding: 10px 5px;
    }
    .rank_outfit{
        position: absolute;
        width: 64px;
        height: 64px;
        background-position: bottom right;
        left: -15px;
        margin-top: -30px;
    }
    .rank_text{
        margin-left: 45px;
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
    }
    .rank_text a{
        text-decoration: none;
        color: #d5c3af;
    }
    .rank_button{
        height: 30px;
        width: 148px;
        border: 0;
        background: url('templates/tibiacom/images/themeboxes/button.png');
        font-family: Verdana;
        font-weight: 100;
        color: #d5c3af;
        font-size: 12px;
        cursor: pointer;
    }
    .rank_button:hover{
        background: url('templates/tibiacom/images/themeboxes/button_over.png');
        color: #fff;
    }
</style>
<div class="rank">
    <div class="rank_header">Highscores</div>
    <div class="rank_content">
        <?php
        $topPlayers = getTopPlayers(5);
        foreach($topPlayers as $player){
            $outfit_url = '';
            if ($config['online_outfit']){
                $outfit_url = $config['outfit_images_url'] . '?id=' . $player['looktype'] . ( !empty( $player['lookaddons'] ) ? '&addons=' . $player['lookaddons'] : '' ) . '&head=' . $player['lookhead'] . '&body=' . $player['lookbody'] . '&legs=' . $player['looklegs'] . '&feet=' . $player['lookfeet'];
                $player['outfit'] = $outfit_url;
            }
            $player_voc = $config['vocations'][$player['vocation']];
        ?>
        <div class="rank_player">
            <div class="rank_outfit" style="background-image: url('<?php echo $player['outfit'] ?>')"></div>
            <div class="rank_text">
                <a href="<?php echo getPlayerLink($player['name'], false) ?>"><b><?php echo $player['name'] ?></b></a><br>
                <small>Level: <?php echo $player['level'] ?> / <?php echo $player_voc ?></small>
            </div>
        </div>
        <?php } ?>
        <a href="<?php echo BASE_URL ?>?highscores">
            <button type="button" class="rank_button">Ver Highscores</button>
        </a>
    </div>
    <div class="rank_bottom"></div>
</div>
