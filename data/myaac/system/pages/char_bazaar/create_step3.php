<?php

if (isset($_POST['auction_submit']) && isset($_POST['auction_character'])) {
    $selectCharacter = $_POST['auction_character'];

    /* PLAYERS */
    $getCharacter = $db->query('SELECT `id`, `account_id`, `name`, `level`, `vocation`, `sex`, `health`, `healthmax`, `mana`, `manamax`, `maglevel`, `manaspent`, `balance`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`, `skill_shielding`, `skill_shielding_tries`, `cap`, `experience`, `created`, `soul`, `blessings`' . 'FROM `players`' . 'WHERE `id` = ' . $db->quote($selectCharacter) . '');
    $getCharacter = $getCharacter->fetch();
    /* PLAYERS END */

    /* ACCOUNT BY PLAYER */
    $getAccount = $db->query('SELECT `id`, `premdays`, `coins`' . 'FROM `accounts`' . 'WHERE `id` = ' . $getCharacter['account_id'] . '');
    $getAccount = $getAccount->fetch();
    if ($getAccount['premdays'] > 0) {
        $character_prem = '<b>Premium Account</b>';
    } else {
        $character_prem = '<b>Free Account</b>';
    }
    /* ACCOUNT BY PLAYER END */

    if ($getCharacter['sex'] == 0) {
        $character_sex = 'Female';
    } else {
        $character_sex = 'Male';
    }

    if ($getCharacter['vocation'] == 0) {
        $character_voc = 'None';
    } elseif ($getCharacter['vocation'] == 1) {
        $character_voc = 'Sorcerer';
    } elseif ($getCharacter['vocation'] == 2) {
        $character_voc = 'Druid';
    } elseif ($getCharacter['vocation'] == 3) {
        $character_voc = 'Paladin';
    } elseif ($getCharacter['vocation'] == 4) {
        $character_voc = 'Knight';
    } elseif ($getCharacter['vocation'] == 5) {
        $character_voc = 'Master Sorcerer';
    } elseif ($getCharacter['vocation'] == 6) {
        $character_voc = 'Elder Druid';
    } elseif ($getCharacter['vocation'] == 7) {
        $character_voc = 'Royal Paladin';
    } elseif ($getCharacter['vocation'] == 8) {
        $character_voc = 'Elite Knight';
    } else {
        $character_voc = 'None';
    }

    $getAccountLogged = $db->query('SELECT `id`, `premdays`, `coins`' . 'FROM `accounts`' . 'WHERE `id` = ' . $account_logged->getId() . '');
    $getAccountLogged = $getAccountLogged->fetch();
    if ($getAccountLogged['premdays'] > 0) {
        $character_prem = '<b>Premium Account</b>';
    } else {
        $character_prem = '<b>Free Account</b>';
    }

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
                            <div class="StepText" style="font-weight:normal;">Check character</div>
                        </div>
                    </div>
                    <div class="Steps" style="width:33%">
                        <div class="TubeContainer">
                            <img class="Tube"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-green.gif">
                        </div>
                        <div class="SingleStepContainer">
                            <img class="StepIcon"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-3-green.gif">
                            <div class="StepText" style="font-weight:bold;">Set up auction</div>
                        </div>
                    </div>
                    <div class="Steps" style="width:33%">
                        <div class="TubeContainer">
                            <img class="Tube"
                                 src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-green-blue.gif">
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
                <div class="Text">Your account</div>
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
        <table class="Table5" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td>
                    <div class="InnerTableContainer">
                        <table style="width:100%;">
                            <tbody>
                            <tr>
                                <td>
                                    <div class="TableContentContainer">
                                        <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                                            <tbody>
                                            <tr>
                                                <td style="font-weight:normal;">
                                                    <?= $getAccount['coins'] ?> <img
                                                        src="<?= $template_path; ?>/images/account/icon-tibiacoin.png">
                                                    (<?= $getAccount['coins'] ?> <img
                                                        src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png">)
                                                </td>
                                                <td style="font-weight:normal;">
                                                    <?= $charbazaar_create ?> <img
                                                        src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png">
                                                    to create an auction.
                                                </td>
                                                <td style="font-weight:normal;">
                                                    <?= $charbazaar_tax ?>% fee on auction.
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
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <br>
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
                <div class="Text">Set up auction (3/4)</div>
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
        <table class="Table5" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td>
                    <div class="InnerTableContainer">
                        <table style="width:100%;">
                            <tbody>
                            <tr>
                                <td>
                                    <div class="TableContentContainer">
                                        <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                                            <tbody>
                                            <tr>
                                                <td>
                                                    <div class="AuctionHeader">
                                                        <div
                                                            class="AuctionCharacterName"><?= $getCharacter['name'] ?></div>
                                                        Level: <?= $getCharacter['level'] ?> |
                                                        Vocation: <?= $character_voc ?> | <?= $character_sex ?><br>
                                                    </div>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <table style="width: 100%;" cellspacing="0" cellpadding="0">
                                        <tbody>
                                        <tr>
                                            <td style="vertical-align:top;width:210px;;">
                                                <div class="TableContentContainer">
                                                    <table class="TableContent" style="border:1px solid #faf0d7;"
                                                           width="100%">
                                                        <tbody>
                                                        <tr class="Even">
                                                            <td><span class="LabelV">Health:</span>
                                                                <div
                                                                    style="float:right; text-align: right;"><?= $getCharacter['health'] ?>
                                                                    / <?= $getCharacter['healthmax'] ?></div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td><span class="LabelV">Mana:</span>
                                                                <div
                                                                    style="float:right; text-align: right;"><?= $getCharacter['mana'] ?>
                                                                    / <?= $getCharacter['manamax'] ?></div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Even">
                                                            <td><span class="LabelV">Capacity:</span>
                                                                <div
                                                                    style="float:right; text-align: right;"><?= $getCharacter['cap'] ?></div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td><span class="LabelV">Soul:</span>
                                                                <div
                                                                    style="float:right; text-align: right;"><?= $getCharacter['soul'] ?></div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Even">
                                                            <td><span class="LabelV">Blessings:</span>
                                                                <div
                                                                    style="float:right; text-align: right;"><?= $getCharacter['blessings'] ?></div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td><span class="LabelV">Mounts:</span>
                                                                <div style="float:right; text-align: right;">-</div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Even">
                                                            <td><span class="LabelV">Outfits:</span>
                                                                <div style="float:right; text-align: right;">-
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td><span class="LabelV">Titles:</span>
                                                                <div style="float:right; text-align: right;">-</div>
                                                            </td>
                                                        </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="TableContentContainer">
                                                    <table class="TableContent" style="border:1px solid #faf0d7;"
                                                           width="100%">
                                                        <tbody>
                                                        <tr class="Even">
                                                            <td class="LabelColumn"><b>Axe Fighting</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_axe'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_axe_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_axe_tries'] ?> %</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td class="LabelColumn"><b>Club Fighting</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_club'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_club_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_club_tries'] ?> %</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Even">
                                                            <td class="LabelColumn"><b>Distance Fighting</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_dist'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_dist_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_dist_tries'] ?> %</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td class="LabelColumn"><b>Fishing</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_fishing'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_fishing_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_fishing_tries'] ?> %</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Even">
                                                            <td class="LabelColumn"><b>Fist Fighting</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_fist'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_fist_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_fist_tries'] ?> %</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td class="LabelColumn"><b>Magic Level</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['maglevel'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= OTS_Player::getMagicLevelPercent($getCharacter) ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer">
                                                                    <span class="PercentageString">
                                                                        <?= OTS_Player::getMagicLevelPercent($getCharacter) ?> %
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Even">
                                                            <td class="LabelColumn"><b>Shielding</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_shielding'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_shielding_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_shielding_tries'] ?> %</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr class="Odd">
                                                            <td class="LabelColumn"><b>Sword Fighting</b></td>
                                                            <td class="LevelColumn"><?= $getCharacter['skill_sword'] ?></td>
                                                            <td class="PercentageColumn">
                                                                <div id="SkillBar" class="PercentageBar"
                                                                     style="width: <?= $getCharacter['skill_sword_tries'] ?>%">
                                                                    <div class="PercentageBarSpacer"></div>
                                                                </div>
                                                                <div class="PercentageStringContainer"><span
                                                                        class="PercentageString"><?= $getCharacter['skill_sword_tries'] ?> %</span>
                                                                </div>
                                                            </td>
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
                            <tr>
                                <td>
                                    <div class="TableContentContainer">
                                        <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                                            <tbody>
                                            <tr class="Even">
                                                <td><span class="LabelV">Creation Date:</span>
                                                    <div style="float:right; text-align: right;">
                                                        <?= date('M d Y, H:i:s', $getCharacter['created']) ?>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr class="Odd">
                                                <td><span class="LabelV">Experience:</span>
                                                    <div style="float:right; text-align: right;">
                                                        <?= number_format($getCharacter['experience'], 0, ',', ',') ?>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr class="Even">
                                                <td><span class="LabelV">Gold:</span>
                                                    <div style="float:right; text-align: right;">
                                                        <?= $getCharacter['balance'] ?>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr class="Odd">
                                                <td><span class="LabelV">Achievement Points:</span>
                                                    <div style="float:right; text-align: right;">-</div>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="TableContentContainer">
                                        <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                                            <tbody>
                                            <tr class="Odd">
                                                <td><span class="LabelV">Charm Expansion:</span>
                                                    <div style="float:right; text-align: right;">
                                                        <img
                                                            src="<?= $template_path; ?>/images/charactertrade/icon_no.png">
                                                        no
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr class="Even">
                                                <td><span class="LabelV">Available Charm Points:</span>
                                                    <div style="float:right; text-align: right;">-</div>
                                                </td>
                                            </tr>
                                            <tr class="Odd">
                                                <td><span class="LabelV">Spent Charm Points:</span>
                                                    <div style="float:right; text-align: right;">-</div>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>

                            <form method="post" action="?subtopic=createcharacterauction&step=4">
                                <input type="hidden" name="auction_character" value="<?= $getCharacter['id']; ?>">
                                <tr>
                                    <td>
                                        <div class="TableContentContainer">
                                            <table class="TableContent" style="border:1px solid #faf0d7;"
                                                   width="100%">
                                                <tbody>
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;">
                                                            <tbody>
                                                            <tr>
                                                                <td style="vertical-align:middle; text-align: right;"
                                                                    class="LabelV150">Price:
                                                                </td>
                                                                <td class="GreedyCell">
                                                                    <input style="width: 100%;" name="auction_price"
                                                                           type="text" placeholder="in Tibia Coins"
                                                                           size="15" maxlength="15" autofocus="">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="vertical-align:middle; text-align: right;"
                                                                    class="LabelV150">Days to end:
                                                                </td>
                                                                <td class="GreedyCell">
                                                                    <input style="width: 100%;" name="auction_days"
                                                                           type="text"
                                                                           placeholder="min 1 day and max 28 days"
                                                                           size="29" maxlength="2" autofocus="">
                                                                </td>
                                                                <td>
                                                                    <div id="auction_result"></div>
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
                                <input class="BigButtonText" type="button" value="Back">
                            </div>
                        </div>
                    </a>
                </div>
            </td>
            <td>
                <div style="float: left;">
                    <div class="BigButton"
                         style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                        <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                            <div class="BigButtonOver"
                                 style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                            <input name="auction_submit" class="BigButtonText" type="submit" value="Next">
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
    </form>
    <?php
}
