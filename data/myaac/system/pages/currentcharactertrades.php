<?php
/**
 *
 * Char Bazaar
 *
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Current Auctions';

if ($logged) {
    $getAccountCoins = $db->query("SELECT `id`, `premdays`, `coins` FROM `accounts` WHERE `id` = {$account_logged->getId()}");
    $getAccountCoins = $getAccountCoins->fetch();
} else {
    $account_logged = null;
}
// GET PAGES
$subtopic = $_GET['subtopic'] ?? null;
$getPageDetails = $_GET['details'] ?? null;
$getPageAction = $_GET['action'] ?? null;
// GET PAGES

/* CHAR BAZAAR CONFIG */
$charbazaar_tax = $config['bazaar_tax'];
$charbazaar_bid = $config['bazaar_bid'];
/* CHAR BAZAAR CONFIG END */

/* COUNTER CONFIG */
$showCounter = true;
/* COUNTER CONFIG END */
?>

<!-- ACCOUNT COINS TOP BOX -->
<?php if ($logged) {
    require SYSTEM . 'pages/char_bazaar/coins_balance.php';
} ?>
<!-- ACCOUNT COINS TOP BOX -->

<!-- FIRST PAGE - SHOW AUCTIONS -->
<?php
if (!$getPageDetails) {
    if (!$logged) {
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
                                <p><b>Use Tibia's character auction feature to sell or purchase Tibia characters without
                                        risk!</b></p>
                                <p><b>Log in</b> to submit a bid to <b>purchase a Tibia character</b> from another
                                    player for your Tibia account!</p>
                                <p>To <b>sell a Tibia character</b> from your account to another player, log into the
                                    <b>Tibia Client</b> and set up an auction.</p>
                                <p>Note that Tibia characters can only be <b>purchased with transferable Tibia
                                        Coins!</b></p>
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
                <div class="Text">Current Auctions</div>
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
                            $subtopic = 'currentcharactertrades';
                            $dateLimit = date('Y-m-d H:i:s');
                            $auctions = $db->query("SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `bid_price`, `status` FROM `myaac_charbazaar` WHERE `date_end` >= '{$dateLimit}' ORDER BY `date_start` DESC");
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
<?php } ?>
<!-- FIRST PAGE - SHOW AUCTIONS END -->

<!-- AUCTION DETAILS -->
<?php
if ($getPageDetails) {
    require SYSTEM . 'pages/char_bazaar/details.php';
} ?>
<!-- AUCTION DETAILS END -->

<?php
if ($getPageAction == 'bid') {

    $Auction_iden = $_POST['auction_iden'];
    $Auction_maxbid = $_POST['maxbid'];

    /* GET INFO CHARACTER */
    $getAuction = $db->query('SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `bid_price` FROM `myaac_charbazaar` WHERE `id` = ' . $db->quote($Auction_iden) . '');
    $getAuction = $getAuction->fetch();
    /* GET INFO CHARACTER END */


    if ($logged && $getAuction['account_old'] != $account_logged) {


        /* GET INFO CHARACTER */
        $getCharacter = $db->query('SELECT `name`, `vocation`, `level`, `sex` FROM `players` WHERE `id` = ' . $getAuction['player_id'] . '');
        $character = $getCharacter->fetch();
        /* GET INFO CHARACTER END */

        if ($logged) {
            $getAccount = $db->query('SELECT `id`, `premdays`, `coins` FROM `accounts` WHERE `id` = ' . $account_logged->getId() . '');
            $getAccount = $getAccount->fetch();
        }

        /* CONVERT SEX */
        $character_sex = $config['genders'][$character['sex']];
        /* CONVERT SEX END */

        /* CONVERT VOCATION */
        $character_voc = $config['vocations'][$character['vocation']];
        /* CONVERT VOCATION END */

        if ($Auction_maxbid >= $getAccount['coins']) {
            $Verif_CoinsAcc = 'false';
        } else {
            $Verif_CoinsAcc = 'true';
        }

        if ($Auction_maxbid > $getAuction['price'] && $Auction_maxbid > $getAuction['bid_price']) {
            $Verif_Price = 'true';
        } else {
            $Verif_Price = 'false';
        }
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
                    <div class="Text">You account</div>
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
                                                    <td style="font-weight:normal;"><?= $getAccount['coins'] ?>
                                                        <img
                                                            src="<?= $template_path; ?>/images/account/icon-tibiacoin.png">
                                                        (<?= $getAccount['coins'] ?> <img
                                                            src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png">)
                                                    </td>
                                                    <td style="font-weight:normal;"><?= $charbazaar_bid ?> <img
                                                            src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png">
                                                        to give an bid.
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
        <div class="CharacterDetailsBlock">
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
                        <div class="Text">Confirm Bid For Auction</div>
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
                <table class="Table1" cellspacing="0" cellpadding="0">
                    <tbody>
                    <tr>
                        <td>
                            <div class="InnerTableContainer">
                                <table style="width:100%;">
                                    <tbody>
                                    <tr>
                                        <td><br>Do you really want to bid the following amount for the character listed
                                            below:
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <br>
                                            <table style="width:50%;">
                                                <tbody>
                                                <?php
                                                if ($Verif_Price == 'true' and $Verif_CoinsAcc == 'true') {
                                                    ?>
                                                    <tr>
                                                        <td style="font-weight: bold;">Maximum Bid:</td>
                                                        <td><?= $Auction_maxbid ?> <img
                                                                src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png"
                                                                class="VSCCoinImages" title="Transferable Tibia Coins">
                                                        </td>
                                                    </tr>
                                                <?php } else { ?>
                                                    <tr>
                                                        <td style="font-weight: bold; color: red;">Maximum Bid:</td>
                                                        <td style="font-weight: bold; color: red;"><?= $Auction_maxbid ?>
                                                            <img
                                                                src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png"
                                                                class="VSCCoinImages" title="Transferable Tibia Coins">
                                                        </td>
                                                    </tr>
                                                <?php } ?>
                                                <tr>
                                                    <td style="font-weight: bold;">Character:</td>
                                                    <td><?= $character['name'] ?></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-weight: bold;">Level:</td>
                                                    <td><?= $character['level'] ?></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-weight: bold;">Profession:</td>
                                                    <td><?= $character_voc ?></td>
                                                </tr>
                                                </tbody>
                                            </table>

                                        </td>
                                    </tr>

                                    <tr>
                                        <td><br>If you confirm this bid, a <b>deposit</b> of <b>50</b> <img
                                                src="<?= $template_path; ?>/images//account/icon-tibiacointrusted.png"
                                                class="VSCCoinImages" title="Transferable Tibia Coins"> transferable
                                            Tibia Coins will be subtracted from your account's Tibia Coins balance.<br>If
                                            someone is submiting a <b>higher bid</b>, the <b>deposit will be
                                                returned</b> to your account.
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
        </div>
        <br>
        <?php
        if ($Verif_Price == 'false') {
            ?>
            <div class="TableContainer">
                <div class="CaptionContainer">
                    <div class="CaptionInnerContainer">
                        <span class="CaptionEdgeLeftTop"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                        <span class="CaptionEdgeRightTop"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                        <span class="CaptionBorderTop"
                              style="background-image:url(<?= $template_path; ?>/images/content/table-headline-border.gif);"></span>
                        <span class="CaptionVerticalLeft"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-vertical.gif);"></span>
                        <div class="Text">Erro</div>
                        <span class="CaptionVerticalRight"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-vertical.gif);"></span>
                        <span class="CaptionBorderBottom"
                              style="background-image:url(<?= $template_path; ?>/images/content/table-headline-border.gif);"></span>
                        <span class="CaptionEdgeLeftBottom"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                        <span class="CaptionEdgeRightBottom"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                    </div>
                </div>
                <table class="Table1" cellspacing="0" cellpadding="0">

                    <tbody>
                    <tr>
                        <td>
                            <div class="InnerTableContainer">
                                <table style="width:100%;">
                                    <tbody>
                                    <tr>
                                        <td>Your bid is lower than the last one.</td>
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
        <?php } ?>
        <?php
        if ($Verif_CoinsAcc == 'false') {
            ?>
            <div class="TableContainer">
                <div class="CaptionContainer">
                    <div class="CaptionInnerContainer">
                        <span class="CaptionEdgeLeftTop"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                        <span class="CaptionEdgeRightTop"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                        <span class="CaptionBorderTop"
                              style="background-image:url(<?= $template_path; ?>/images/content/table-headline-border.gif);"></span>
                        <span class="CaptionVerticalLeft"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-vertical.gif);"></span>
                        <div class="Text">Erro</div>
                        <span class="CaptionVerticalRight"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-vertical.gif);"></span>
                        <span class="CaptionBorderBottom"
                              style="background-image:url(<?= $template_path; ?>/images/content/table-headline-border.gif);"></span>
                        <span class="CaptionEdgeLeftBottom"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                        <span class="CaptionEdgeRightBottom"
                              style="background-image:url(<?= $template_path; ?>/images/content/box-frame-edge.gif);"></span>
                    </div>
                </div>
                <table class="Table1" cellspacing="0" cellpadding="0">

                    <tbody>
                    <tr>
                        <td>
                            <div class="InnerTableContainer">
                                <table style="width:100%;">
                                    <tbody>
                                    <tr>
                                        <td>You don't have enough coins to bid.</td>
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
        <?php } ?>


        <div style="width: 100%; text-align: center; display: flex; justify-content: center;">
            <?php
            if ($Verif_Price == 'true' && $Verif_CoinsAcc == 'true') {
                ?>
                <script>
                    var myModalFinishBid = document.getElementById('ModalOpenFinishBid')
                    var myInputFinishBid = document.getElementById('ModalInputFinishBid')
                    myModalFinishBid.addEventListener('shown.bs.modal', function () {
                        myInputFinishBid.focus()
                    })
                </script>
                <div class="BigButton"
                     style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                    <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                        <div class="BigButtonOver"
                             style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                        <input name="auction_confirm" class="BigButtonText" type="submit" value="Submit Bid"
                               data-bs-toggle="modal" data-bs-target="#ModalOpenFinishBid"></div>
                </div>
                <div class="modal fade" id="ModalOpenFinishBid" data-bs-backdrop="static" data-bs-keyboard="false"
                     tabindex="-1" aria-labelledby="ModalOpenFinishBidLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <!--<div class="modal-header">
        <h5 class="modal-title" id="ModalOpenFinishBidLabel">You bid created!</h5>
		<img src="<?= $template_path; ?>/images/content/circle-symbol-minus.gif" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
      </div>-->
                            <div class="modal-body">
                                <div style="width: 100%; display: flex; justify-content: center; align-items: center;">
                                    <img src="<?= $template_path; ?>/images/charactertrade/confirm.gif"> <span
                                        style="font-weight: bold; font-size: 16px; padding-left: 10px; text-align: left; color: #ffffff">You submitted a bid successfully.<br><small
                                            style="font-weight: 100;">You will be redirected in a few moments.</small></span>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <!--<div class="BigButton" style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_red.gif)"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_red_over.gif); visibility: hidden;"></div><input name="auction_confirm" class="BigButtonText" type="button" value="Close" data-bs-dismiss="modal"></div></div>-->
                                <form method="post" action="?subtopic=currentcharactertrades&action=bidfinish">
                                    <input type="hidden" name="bid_iden" value="<?= $getAuction['id'] ?>">
                                    <input type="hidden" name="bid_max" value="<?= $Auction_maxbid ?>">
                                    <div class="BigButton"
                                         style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                                        <div onmouseover="MouseOverBigButton(this);"
                                             onmouseout="MouseOutBigButton(this);">
                                            <div class="BigButtonOver"
                                                 style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                            <input name="bid_confirm" class="BigButtonText" type="submit" value="Exit">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            <?php } ?>
            <a href="?subtopic=currentcharactertrades" style="margin-left: 3px">
                <div class="BigButton"
                     style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_red.gif)">
                    <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                        <div class="BigButtonOver"
                             style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_red_over.gif); visibility: hidden;"></div>
                        <input class="BigButtonText" type="button" value="Cancel"></div>
                </div>
            </a>
        </div>

        <?php
    }
}
?>

<!-- REGISTRO NA DB -->
<?php
if ($getPageAction == 'bidfinish') {

    if (isset($_POST['bid_confirm']) && $_POST['bid_max'] && $logged) {
        $bid_iden = $_POST['bid_iden'];
        $bid_max = $_POST['bid_max'];

        $getAuction = $db->query("SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `bid_price` FROM `myaac_charbazaar` WHERE `id` = {$db->quote($bid_iden)}");
        $getAuction = $getAuction->fetch();

        $getAuctionBid = $db->query("SELECT `id`, `account_id`, `auction_id`, `bid`, `date` FROM `myaac_charbazaar_bid` WHERE `auction_id` = {$db->quote($bid_iden)} ORDER BY `bid` DESC LIMIT 1");
        $countAuctionBid = $getAuctionBid->rowCount();
        $getAuctionBid = $getAuctionBid->fetch();

        if ($countAuctionBid > 0) {
            // OLD BID ACCOUNT RETURN COINS
            $getAccountOldBid = $db->query('SELECT `id`, `coins` FROM `accounts` WHERE `id` = ' . $getAuctionBid['account_id'] . '');
            $getAccountOldBid = $getAccountOldBid->fetch();
            $SomaCoinsOldBid = $getAccountOldBid['coins'] + $getAuctionBid['bid'];
            $UpdateAccountOldBid = $db->exec('UPDATE `accounts` SET `coins` = ' . $SomaCoinsOldBid . ' WHERE `id` = ' . $getAuctionBid['account_id'] . '');
            // OLD BID ACCOUNT RETURN COINS

            // NEW BID ACCOUNT REMOVE COINS
            $getAccountNewBid = $db->query('SELECT `id`, `coins` FROM `accounts` WHERE `id` = ' . $account_logged . '');
            $getAccountNewBid = $getAccountNewBid->fetch();
            $SubCoinsNewBid = $getAccountNewBid['coins'] - $bid_max;
            $TaxCoinsNewBid = $SubCoinsNewBid - $charbazaar_bid; // TAX TO CREATE BID
            $UpdateAccountNewBid = $db->exec('UPDATE `accounts` SET `coins` = ' . $TaxCoinsNewBid . ' WHERE `id` = ' . $account_logged . '');
            // NEW BID ACCOUNT REMOVE COINS

            // UPDATE AUCTION NEW BID
            $Update_Auction = $db->exec('UPDATE `myaac_charbazaar` SET `price` = ' . $db->quote($bid_max) . ', `bid_account` = ' . $account_logged . ', `bid_price` = ' . $db->quote($bid_max) . ' WHERE `id` = ' . $getAuction['id'] . '');

            // INSERT NEW BID
            $Insert_NewBid = $db->exec('UPDATE `myaac_charbazaar_bid` SET `account_id` = ' . $account_logged . ', `auction_id` = ' . $getAuction['id'] . ', `bid` = ' . $db->quote($bid_max) . '');

        } else {

            // NEW BID ACCOUNT REMOVE COINS
            $getAccountNewBid = $db->query('SELECT `id`, `coins` FROM `accounts` WHERE `id` = ' . $account_logged . '');
            $getAccountNewBid = $getAccountNewBid->fetch();
            $SubCoinsNewBid = $getAccountNewBid['coins'] - $bid_max;
            $TaxCoinsNewBid = $SubCoinsNewBid - $charbazaar_bid; // TAX TO CREATE BID
            $UpdateAccountNewBid = $db->exec('UPDATE `accounts` SET `coins` = ' . $db->quote($TaxCoinsNewBid) . ' WHERE `id` = ' . $account_logged . '');
            // NEW BID ACCOUNT REMOVE COINS

            // UPDATE AUCTION NEW BID
            $Update_Auction = $db->exec('UPDATE `myaac_charbazaar` SET `price` = ' . $db->quote($bid_max) . ', `bid_account` = ' . $account_logged . ', `bid_price` = ' . $db->quote($bid_max) . ' WHERE `id` = ' . $getAuction['id'] . '');

            // INSERT NEW BID
            $Insert_NewBid = $db->exec('INSERT INTO `myaac_charbazaar_bid` (`account_id`, `auction_id`, `bid`) VALUES (' . $account_logged . ', ' . $getAuction['id'] . ', ' . $db->quote($bid_max) . ')');

        }

        header('Location: ' . BASE_URL . '?subtopic=currentcharactertrades');
    }
}
?>

<?php
if ($getPageAction == 'finish') {
    $auction_iden = $_POST['auction_iden'];

    /* GET INFO AUCTION */
    $getAuction = $db->query("SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `status` FROM `myaac_charbazaar` WHERE `id` = {$db->quote($auction_iden)}");
    $getAuction = $getAuction->fetch();
    /* GET INFO AUCTION END */

    /* GET INFO BID */
    $getBid = $db->query("SELECT `id`, `account_id`, `auction_id`, `bid`, `date` FROM `myaac_charbazaar_bid` WHERE `auction_id` = {$getAuction['id']}");
    $getBid = $getBid->fetch();
    /* GET INFO BID END */

    /* GET COINS VENDEDOR */
    $getCoinsVendedor = $db->query("SELECT `id`, `coins` FROM `accounts` WHERE `id` = {$getAuction['account_old']}");
    $getCoinsVendedor = $getCoinsVendedor->fetch();
    /* GET COINS VENDEDOR END */

//    $auction_taxacoins = $getBid['bid'] / 100;
//    $auction_taxacoins = $auction_taxacoins * $config['bazaar_tax'];
//    $auction_finalcoins = $getBid['bid'] - $auction_taxacoins;
    $sellerCoins = $getCoinsVendedor['coins'] + ($getBid['bid'] - (($getBid['bid'] / 100) * $charbazaar_tax));
    $db->exec("UPDATE `accounts` SET `coins` = {$sellerCoins} WHERE `id` = {$getAuction['account_old']}"); // adicionar os coins ao vendedor

    $account_new = $getBid['account_id'];

    $db->exec("UPDATE `players` SET `account_id` = {$account_new} WHERE `id` = {$getAuction['player_id']}"); // muda o player de conta
    $db->exec("UPDATE `myaac_charbazaar` SET `status` = 1, `account_new` = {$account_new} WHERE `id` = {$getAuction['id']}"); // muda status da auction

    header('Location: ' . BASE_URL . '?account/manage');
}
?>
