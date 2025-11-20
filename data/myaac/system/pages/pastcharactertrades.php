<?php
/**
 *
 * Char Bazaar
 *
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Auction History';
if ($logged) {
    require SYSTEM . 'pages/char_bazaar/coins_balance.php';
} else {
    $account_logged = null;
}
$subtopic = $_GET['subtopic'] ?? null;
$getPageDetails = $_GET['details'] ?? null;
$getPageAction = $_GET['action'] ?? null;
if (empty($getPageDetails) && empty($getPageAction)) {
    if (!$logged) { ?>
        <div class="SmallBox">
            <div class="MessageContainer">
                <div class="BoxFrameHorizontal"
                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-horizontal.gif);"></div>
                <div class="BoxFrameEdgeLeftTop"
                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></div>
                <div class="BoxFrameEdgeRightTop"
                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></div>
                <div class="Message">
                    <div class="BoxFrameVerticalLeft"
                         style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></div>
                    <div class="BoxFrameVerticalRight"
                         style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></div>
                    <table style="width: 100%;">
                        <tbody>
                        <tr>
                            <td>
                                <div style="float: right;">
                                    <a href="?account/manage" target="_blank">
                                        <div class="BigButton"
                                             style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton.gif)">
                                            <div onmouseover="MouseOverBigButton(this);"
                                                 onmouseout="MouseOutBigButton(this);">
                                                <div class="BigButtonOver"
                                                     style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_over.gif); visibility: hidden;"></div>
                                                <input name="auction_confirm" class="BigButtonText" type="button"
                                                       value="Login"></div>
                                        </div>
                                    </a>
                                </div>
                                <p>Below you find all characters which have been <b>auctioned in the last 30 days.</b>
                                </p>
                                <p><b>Log in</b> to your account for more options in this section.</p>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="BoxFrameHorizontal"
                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-horizontal.gif);"></div>
                <div class="BoxFrameEdgeRightBottom"
                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></div>
                <div class="BoxFrameEdgeLeftBottom"
                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></div>
            </div>
        </div>
        <br>
    <?php } ?>

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
                <div class="Text">Auction History</div>
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
                            <?php
                            $subtopic = 'pastcharactertrades';
                            $dateLimit = date('Y-m-d H:i:s');
                            $auctions = $db->query("SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `bid_price`, `status` FROM `myaac_charbazaar` WHERE `date_end` <= '{$dateLimit}' ORDER BY `date_start` DESC");
                            require SYSTEM . 'pages/char_bazaar/list_auctions.php';
                            ?>
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

//<!-- AUCTION DETAILS -->
if ($getPageDetails) {
    require SYSTEM . 'pages/char_bazaar/details.php';
} ?>
<!-- AUCTION DETAILS END -->
