<?php

if (isset($_POST['auction_submit']) && isset($_POST['auction_character'])) {
    $selected_character = $_POST['auction_character'];
    $next_truecount = 0;

    /* PLAYERS */
    $getCharacter = $db->query('SELECT `id`, `account_id`, `name`, `level`, `vocation`' . 'FROM `players`' . 'WHERE `id` = ' . $db->quote($selected_character) . '');
    $getCharacter = $getCharacter->fetch();
    /* PLAYERS END */


    /* VERIFICA CONTA */
    $idLogged = $account_logged->getCustomField('id');

    if ($idLogged == $getCharacter['account_id']) {
        $next_truecount++;
    } else {
        header('Location: index.php?news');
    }
    /* VERIFICA CONTA */


    /* GET LEVEL PLAYERS */
    if ($getCharacter['level'] >= 8) {
        $verif_level = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_level = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET LEVEL PLAYERS END */


    /* GET FRAGS PLAYERS */
    $frags_enabled = $db->hasTable('player_killers') && $config['characters']['frags'];
    $frags_count = 0;
    if ($frags_enabled) {
        $query = $db->query(
            'SELECT COUNT(`player_id`) as `frags`' .
            'FROM `player_killers`' .
            'WHERE `player_id` = ' . $getCharacter['id'] . ' ' .
            'GROUP BY `player_id`' .
            'ORDER BY COUNT(`player_id`) DESC');

        $frags_count = $query['frags'];
    }
    if ($frags_count == 0) {
        $verif_frags = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_frags = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET FRAGS PLAYERS END */


    /* GET COINS */
    $getCoins = $db->query('SELECT `coins`' . 'FROM `accounts`' . 'WHERE `id` = ' . $getCharacter['account_id'] . '');
    $getCoins = $getCoins->fetch();

    if ($getCoins >= $charbazaar_create) {
        $verif_coins = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_coins = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET COINS END */


    /* GET HOUSE */
    $getHouse = $db->query('SELECT `owner`' . 'FROM `houses`' . 'WHERE `owner` = ' . $getCharacter['id'] . '');
    $getHouse = $getHouse->fetch();

    if ($getHouse == 0) {
        $verif_house = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_house = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET HOUSE END */


    /* GET GUILD */
    $getGuildOwner = $db->query('SELECT `ownerid`' . 'FROM `guilds`' . 'WHERE `ownerid` = ' . $getCharacter['id'] . '');
    $getGuildOwner = $getGuildOwner->fetch();

    $getGuildInvited = $db->query('SELECT `player_id`' . 'FROM `guild_invites`' . 'WHERE `player_id` = ' . $getCharacter['id'] . '');
    $getGuildInvited = $getGuildInvited->fetch();

    $getGuildMember = $db->query('SELECT `player_id`' . 'FROM `guild_membership`' . 'WHERE `player_id` = ' . $getCharacter['id'] . '');
    $getGuildMember = $getGuildMember->fetch();

    if ($getGuildOwner == 0 && $getGuildInvited == 0 && $getGuildMember == 0) {
        $verif_guild = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_guild = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET GUILD END */


    /* GET MARKET */
    $getMarket = $db->query('SELECT `player_id`' . 'FROM `market_offers`' . 'WHERE `player_id` = ' . $getCharacter['id'] . '');
    $getMarket = $getMarket->fetch();

    if ($getMarket == 0) {
        $verif_market = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_market = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET MARKET END */


    /* GET REGISTER ACCOUNT */
    $recovery_key = $account_logged->getCustomField('key');
    if (empty($recovery_key)) {
        $verif_registered = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    } else {
        $verif_registered = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    }
    /* GET REGISTER ACCOUNT END */


    /* GET CHARACTER ONLINE */
    $getOnline = $db->query('SELECT `player_id`' . 'FROM `players_online`' . 'WHERE `player_id` = ' . $getCharacter['id'] . '');
    $getOnline = $getOnline->rowCount();

    if ($getOnline == 0) {
        $verif_online = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        $next_truecount++;
    } else {
        $verif_online = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
    }
    /* GET CHARACTER ONLINE */


    ?>
    <div id="ProgressBar">
        <div id="MainContainer">
            <div id="BackgroundContainer">
                <img id="BackgroundContainerLeftEnd"
                     src="<?= $template_path; ?>/images/global/content/stonebar-left-end.gif">
                <div id="BackgroundContainerCenter">
                    <div id="BackgroundContainerCenterImage"
                         style="background-image:url(<?= $template_path; ?>/images/global/content/stonebar-center.gif);"></div>
                </div>
                <img id="BackgroundContainerRightEnd"
                     src="<?= $template_path; ?>/images/global/content/stonebar-right-end.gif"></div>
            <img id="TubeLeftEnd"
                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-left-green.gif">
            <img id="TubeRightEnd"
                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-right-blue.gif">
            <div id="FirstStep" class="Steps">
                <div class="SingleStepContainer">
                    <img class="StepIcon"
                         src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-1-green.gif">
                    <div class="StepText" style="font-weight:normal;">Select character</div>
                </div>
            </div>
            <div id="StepsContainer1">
                <div id="StepsContainer2">
                    <div class="Steps" style="width:33%">
                        <div class="TubeContainer">
                            <img class="Tube"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-green.gif">
                        </div>
                        <div class="SingleStepContainer">
                            <img class="StepIcon"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-2-green.gif">
                            <div class="StepText" style="font-weight:bold;">Check character</div>
                        </div>
                    </div>
                    <div class="Steps" style="width:33%">
                        <div class="TubeContainer">
                            <img class="Tube"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-green-blue.gif">
                        </div>
                        <div class="SingleStepContainer">
                            <img class="StepIcon"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-3-blue.gif">
                            <div class="StepText" style="font-weight:normal;">Set up auction</div>
                        </div>
                    </div>
                    <div class="Steps" style="width:33%">
                        <div class="TubeContainer">
                            <img class="Tube"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-blue.gif">
                        </div>
                        <div class="SingleStepContainer">
                            <img class="StepIcon"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-4-blue.gif">
                            <div class="StepText" style="font-weight:normal;">Confirm auction</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <br>
    <form method="post" action="?subtopic=createcharacterauction&step=3">
        <input type="hidden" name="auction_character" value="<?= $getCharacter['id'] ?>">
        <div class="TableContainer">
            <div class="CaptionContainer">
                <div class="CaptionInnerContainer">
                    <span class="CaptionEdgeLeftTop"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                    <span class="CaptionEdgeRightTop"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                    <span class="CaptionBorderTop"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
                    <span class="CaptionVerticalLeft"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
                    <div class="Text">Check Character (2/4)</div>
                    <span class="CaptionVerticalRight"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
                    <span class="CaptionBorderBottom"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
                    <span class="CaptionEdgeLeftBottom"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                    <span class="CaptionEdgeRightBottom"
                          style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                </div>
            </div>
            <table class="Table3" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td>
                        <div class="InnerTableContainer">
                            <table style="width:100%;">
                                <tbody>
                                <tr>
                                    <td>
                                        <table style="width:100%;">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    <div class="TableContentContainer">
                                                        <table class="TableContent"
                                                               style="border:1px solid #faf0d7;" width="100%">
                                                            <tbody>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_coins; ?></td>
                                                                <td>You need to have enough transferable Tibia Coins
                                                                    to create this auction.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_registered; ?></td>
                                                                <td>Your account must be registered.</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_level ?></td>
                                                                <td>The character needs to be al least level 8.</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_house; ?></td>
                                                                <td>The character may not own any houses.</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_house; ?></td>
                                                                <td>The character may not bid for a house.</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_house; ?></td>
                                                                <td>The character may not be involved in a house
                                                                    transfer.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_guild; ?></td>
                                                                <td>The character may not be a member of a guild.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_guild; ?></td>
                                                                <td>The character may not have applied to a guild.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_market; ?></td>
                                                                <td>The character may not have any running auctions
                                                                    in the Market.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_frags; ?></td>
                                                                <td>The character may not be marked with a skull.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_online; ?></td>
                                                                <td>The character must be in a protection zone.</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align: middle;"><?= $verif_online; ?></td>
                                                                <td>Your character may not have a logout block.</td>
                                                            </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <br>
        <table class="InnerTableButtonRow" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td>
                    <div style="float: right;">
                        <a href="?subtopic=createcharacterauction&step=1">
                            <div class="BigButton"
                                 style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton.gif)">
                                <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                                    <div class="BigButtonOver"
                                         style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_over.gif); visibility: hidden;"></div>
                                    <input class="BigButtonText" type="button" value="Back"></div>
                            </div>
                        </a>
                    </div>
                </td>
                <td>
                    <div style="float: left;">
                        <?php if ($next_truecount == 9) { ?>
                            <div class="BigButton"
                                 style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                                <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                                    <div class="BigButtonOver"
                                         style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                    <input name="auction_submit" class="BigButtonText" type="submit" value="Next">
                                </div>
                            </div>
                        <?php } else { ?>
                            <div class="BigButton"
                                 style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_red.gif)">
                                <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                                    <div class="BigButtonOver"
                                         style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_red_over.gif); visibility: hidden;"></div>
                                    <input name="auction_submit" class="BigButtonText" type="button" value="Erro">
                                </div>
                            </div>
                        <?php } ?>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
    <?php
}
