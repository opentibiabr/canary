<?php
/**
 *
 * Char Bazaar
 *
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'My Auctions';

if ($logged) {
    require SYSTEM . 'pages/char_bazaar/coins_balance.php';
}
?>
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
            <table class="HintBox">
                <tbody>
                <tr>
                    <td>
                        <div style="float: right;"></div>
                        <p>Here you find <b>your character auctions</b> that:</p>
                        <ul>
                            <li>are about to start</li>
                            <li>are currently running</li>
                            <li>were recently successfully completed</li>
                            <li>were recently cancelled</li>
                        </ul>
                        <p>Check out your Tibia Coins History to see <b>all characters you have sold</b> successfully.
                        </p></td>
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
            <div class="Text">My Auctions</div>
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
    <table class="Table3" cellpadding="0" cellspacing="0">
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
                                        <tr class="Odd">
                                            <td class="LabelV">Name</td>
                                            <td class="LabelV">Start</td>
                                            <td class="LabelV">End</td>
                                            <td class="LabelV">Current Bid</td>
                                            <td></td>
                                        </tr>
                                        <?php
                                        $getAuctionsbyAccount = [];
                                        if ($logged) {
                                            $getAuctionsbyAccount = $db->query("SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `bid_price` FROM `myaac_charbazaar` WHERE `account_old` = {$account_logged->getId()}");
                                            $i_bg = 0;
                                            foreach ($getAuctionsbyAccount as $Auction) {
                                                $i_bg = $i_bg + 1;

                                                $getCharacterbyAccount = $db->query("SELECT `id`, `name`, `level` FROM `players` WHERE `id` = {$Auction['player_id']}");
                                                $getCharacterbyAccount = $getCharacterbyAccount->fetch();

                                                $Hoje = date('Y-m-d H:i:s');
                                                $End = date('Y-m-d H:i:s', strtotime($Auction['date_end']));
                                                $bg_DateEnd = (strtotime($End) > strtotime($Hoje)) ? '' : 'red';
                                                ?>
                                                <tr bgcolor="<?= getStyle($i_bg); ?>">
                                                    <td style="color: <?= $bg_DateEnd ?>;"><?= $getCharacterbyAccount['name'] ?></td>
                                                    <td style="color: <?= $bg_DateEnd ?>;"><?= date('d M Y', strtotime($Auction['date_start'])); ?></td>
                                                    <td style="color: <?= $bg_DateEnd ?>;"><?= date('d M Y', strtotime($Auction['date_end'])); ?></td>
                                                    <td style="color: <?= $bg_DateEnd ?>;"><?= number_format($Auction['bid_price'], 0, ',', ','); ?>
                                                        <img
                                                            src="<?= $template_path; ?>/images//account/icon-tibiacointrusted.png"
                                                            class="VSCCoinImages" title="Transferable Tibia Coins"></td>
                                                    <?php if (strtotime($End) > strtotime($Hoje)) { ?>
                                                        <td>
                                                            <a href="?subtopic=currentcharactertrades&details=<?= $Auction['id'] ?>">
                                                                <div class="BigButton"
                                                                     style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                                                                    <div onmouseover="MouseOverBigButton(this);"
                                                                         onmouseout="MouseOutBigButton(this);">
                                                                        <div class="BigButtonOver"
                                                                             style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                                                        <input name="auction_confirm"
                                                                               class="BigButtonText"
                                                                               type="button" value="Access">
                                                                    </div>
                                                                </div>
                                                            </a></td>
                                                    <?php } else { ?>
                                                        <td>
                                                            <a href="?subtopic=pastcharactertrades&details=<?= $Auction['id'] ?>">
                                                                <div class="BigButton"
                                                                     style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_red.gif)">
                                                                    <div onmouseover="MouseOverBigButton(this);"
                                                                         onmouseout="MouseOutBigButton(this);">
                                                                        <div class="BigButtonOver"
                                                                             style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_red_over.gif); visibility: hidden;"></div>
                                                                        <input name="auction_confirm"
                                                                               class="BigButtonText"
                                                                               type="button" value="Finished">
                                                                    </div>
                                                                </div>
                                                            </a></td>
                                                    <?php } ?>
                                                </tr>
                                                <?php
                                            }
                                        }
                                        ?>
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
