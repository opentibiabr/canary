<?php
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Download Client';


$getpage_download = $_GET['step'] ?? '';
if (empty($getpage_download)) {
    ?>
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
                <div class="Text">Download Client</div>
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
        <table class="Table5" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td>
                    <div class="InnerTableContainer">
                        <table style="width:100%;">
                            <tbody>
                            <tr>
                                <td>
                                    <div class="TableContentContainer">
                                        <table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
                                            <tbody>
                                            <tr>
                                                <td style="text-align: center; padding: 1.5rem;">
                                                    <h1>Official <?= configLua('serverName') ?> Client</h1>
                                                    <a href="<?= $config['client_link'] ?? '' ?>" target="_new">
                                                        <img alt="<?= configLua('serverName') ?> Client"
                                                             style="width: 90px; height: 90px; border: 0;"
                                                             src="<?= $template_path ?>/images/download_windows.gif">
                                                        <br>
                                                        <span style="font-size: 12pt;">
                                                        Download <?= configLua('serverName') ?> Client
                                                        <br>
                                                        <span style="font-size: 10pt;">Windows Client</span></span>
                                                        <br>
                                                        <small>Version <?= config('client') / 100 ?></small>
                                                    </a>
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
                                        <table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
                                            <tbody>
                                            <tr>
                                                <td class="LabelV">Disclaimer</td>
                                            </tr>
                                            <tr>
                                                <td>The software and any related documentation is provided "as is"
                                                    without warranty of any kind. The entire risk arising out of use of
                                                    the software remains with you. In no event shall CipSoft GmbH be
                                                    liable for any damages to your computer or loss of data.
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
    <?php
}

if ($_GET['subtopic'] == 'downloadclient' and $getpage_download == 'downloadagreement') {
    ?>
    <p>Before you can download the client program please read the Tibia Service Agreement and state if you agree to it
        by clicking on the appropriate button below.</p>

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
                <div class="Text">Tibia Service Agreement</div>
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
        <table class="Table1" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td>
                    <div class="InnerTableContainer"><p>This agreement describes the terms on which CipSoft GmbH offers
                            you access to an account for being able to play the online role playing game "Tibia". By
                            creating an account or downloading the client software you accept the terms and conditions
                            below and state that you are of full legal age in your country or have the permission of
                            your parents to play this game.</p>
                        <p>You agree that the use of the software is at your sole risk. We provide the software, the
                            game, and all other services "as is". We disclaim all warranties or conditions of any kind,
                            expressed, implied or statutory, including without limitation the implied warranties of
                            title, non-infringement, merchantability and fitness for a particular purpose. We do not
                            ensure continuous, error-free, secure or virus-free operation of the software, the game, or
                            your account.</p>
                        <p>We are not liable for any lost profits or special, incidental or consequential damages
                            arising out of or in connection with the game, including, but not limited to, loss of data,
                            items, accounts, or characters from errors, system downtime, or adjustments of the
                            gameplay.</p>
                        <p>While you are playing "Tibia", you must abide by some rules ("Tibia Rules") that are stated
                            on this homepage. If you break any of these rules, your account may be removed and all other
                            services terminated immediately.</p>
                        <p>CipSoft GmbH is neither willing nor required to take part in out-of-court dispute
                            resolution.</p>
                        <p>By creating an account or downloading the client software, you also accept the terms and
                            conditions stated in the BattlEye End-User Licence Agreement.</p>
                        <table style="width:100%;"></table>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <br>
    <center>
        <form action="?subtopic=downloadclient" method="post" style="padding:0px;margin:0px;">
            <div class="BigButton"
                 style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton.gif)">
                <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                    <div class="BigButtonOver"
                         style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_over.gif);"></div>
                    <input class="BigButtonText" type="submit" value="I agree"></div>
            </div>
        </form>
    </center>
    <?php
}
