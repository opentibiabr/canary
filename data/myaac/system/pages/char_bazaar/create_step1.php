<?php

/* PLAYERS */
$players = array();
$account_players = $account_logged->getPlayersList();
/* PLAYERS END */

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
                 src="<?= $template_path; ?>/images/global/content/stonebar-right-end.gif">
        </div>
        <img id="TubeLeftEnd"
             src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-left-green.gif"> <img
            id="TubeRightEnd"
            src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-right-blue.gif">
        <div id="FirstStep" class="Steps">
            <div class="SingleStepContainer">
                <img class="StepIcon"
                     src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-1-green.gif">
                <div class="StepText" style="font-weight:bold;">Select character</div>
            </div>
        </div>
        <div id="StepsContainer1">
            <div id="StepsContainer2">
                <div class="Steps" style="width:33%">
                    <div class="TubeContainer">
                        <img class="Tube"
                             src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-green-blue.gif">
                    </div>
                    <div class="SingleStepContainer">
                        <img class="StepIcon"
                             src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-icon-2-blue.gif">
                        <div class="StepText" style="font-weight:normal;">Check character</div>
                    </div>
                </div>
                <div class="Steps" style="width:33%">
                    <div class="TubeContainer">
                        <img class="Tube"
                             src="<?= $template_path; ?>/images/global/content/progressbar/progress-bar-tube-blue.gif">
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
<form method="post" action="?subtopic=createcharacterauction&step=2">
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
                <div class="Text">Select Character (1/4)</div>
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
                                                    <table style="float: left; width: 100%; " cellspacing="0"
                                                           cellpadding="0">
                                                        <tbody>
                                                        <tr>
                                                            <td>
                                                                <table style="float: left; width: 100%; "
                                                                       cellspacing="0" cellpadding="0">
                                                                    <tbody>
                                                                    <tr>
                                                                        <td><select style="width: 100%;"
                                                                                    name="auction_character">
                                                                                <?php foreach ($account_players as $player) {
                                                                                    $item = "{$player->getname()} | Level {$player->getLevel()} | Vocation: {$player->getVocationName()}"
                                                                                    ?>
                                                                                    <option
                                                                                        value="<?= $player->getId() ?>"><?= $item ?></option>
                                                                                <?php } ?>
                                                                            </select></td>
                                                                    </tr>
                                                                    </tbody>
                                                                </table>
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
                    <a href="?news">
                        <div class="BigButton"
                             style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_red.gif)">
                            <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                                <div class="BigButtonOver"
                                     style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_red_over.gif); visibility: hidden;"></div>
                                <input class="BigButtonText" type="button" value="Cancel"></div>
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
                            <input name="auction_submit" class="BigButtonText" type="submit" value="Next"></div>
                    </div>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</form>
