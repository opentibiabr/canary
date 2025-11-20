<?php
if (!$auctions || !isset($auctions)) {
    $auctions = [];
}

foreach ($auctions as $auction) { /* LOOP AUCTIONS */
    /* GET INFO CHARACTER */
    $getCharacter = $db->query("SELECT `name`, `vocation`, `level`, `sex`, `looktype`, `lookaddons`, `lookhead`, `lookbody`, `looklegs`, `lookfeet`, `cap`, `soul` FROM `players` WHERE `id` = {$auction['player_id']}");
    $character = $getCharacter->fetch();
    /* GET INFO CHARACTER END */

    /* OUTFIT CHARACTER */
    $outfit_url = "{$config['outfit_images_url']}?id={$character['looktype']}" . (!empty($character['lookaddons']) ? "&addons={$character['lookaddons']}" : '') . "&head={$character['lookhead']}&body={$character['lookbody']}&legs={$character['looklegs']}&feet={$character['lookfeet']}";
    /* OUTFIT CHARACTER */

    /* EQUIPAMENT CHARACTER */
    global $db;
    $eq_sql = $db->query("SELECT `pid`, `itemtype` FROM player_items WHERE player_id = {$auction['player_id']} AND (`pid` >= 1 and `pid` <= 10)");
    $equipment = array();
    foreach ($eq_sql as $eq) {
        $equipment[$eq['pid']] = $eq['itemtype'];
    }
    $empty_slots = array("", "no_helmet", "no_necklace", "no_backpack", "no_armor", "no_handleft", "no_handright", "no_legs", "no_boots", "no_ring", "no_ammo");
    for ($i = 0; $i <= 10; $i++) {
        if (!isset($equipment[$i]) || $equipment[$i] == 0)
            $equipment[$i] = $empty_slots[$i];
    }

    for ($i = 1; $i < 11; $i++) {
        $equipment[$i] = Validator::number($equipment[$i])
            ? getItemImage($equipment[$i])
            : "<img src='images/items/{$equipment[$i]}.gif' width='32' height='32' border='0' alt='{$equipment[$i]}' />";
    }
    /* EQUIPAMENT CHARACTER END */

    /* CONVERT SEX */
    $character_sex = $config['genders'][$character['sex']] ?? ($character['sex'] == 0 ? 'Male' : 'Female');
    /* CONVERT SEX END */

    /* CONVERT VOCATION */
    $character_voc = $config['vocations'][$character['vocation']] ?? null;
    if (!$character_voc) {
        $vocationId = $character['vocation'];
        $character_voc = '';
        switch ($vocationId) {
            default:
            case 0:
                $character_voc = 'None';
                break;
            case 1:
            case 5:
                if ($vocationId == 5) {
                    $character_voc = 'Master ';
                }
                $character_voc .= 'Sorcerer';
                break;
            case 2:
            case 6:
                if ($vocationId == 6) {
                    $character_voc = 'Elder ';
                }
                $character_voc .= 'Druid';
                break;
            case 3:
            case 7:
                if ($vocationId == 7) {
                    $character_voc = 'Royal ';
                }
                $character_voc .= 'Paladin';
                break;
            case 4:
            case 8:
                if ($vocationId == 8) {
                    $character_voc = 'Elite ';
                }
                $character_voc .= 'Knight';
                break;
        }
    }
    /* CONVERT VOCATION END */

    /* GET BID */
    $getAuctionBid = $db->query("SELECT `account_id`, `auction_id`, `bid`, `date` FROM `myaac_charbazaar_bid` WHERE `auction_id` = {$auction['id']}");
    $getAuctionBid = $getAuctionBid->fetch();
    /* GET BID END */

    /* GET MY BID */
    $My_Bid = "<img src='$template_path/images/premiumfeatures/icon_no.png'>";
    if ($logged && isset($getAuctionBid['account_id']) && $account_logged == $getAuctionBid['account_id']) {
        $val = number_format($getAuctionBid['bid'], 0, ',', ',');
        $My_Bid = "<b>{$val}</b> <img src='{$template_path}/images/account/icon-tibiacointrusted.png' class='VSCCoinImages' title='Transferable Tibia Coins'>";
    }
    /* GET MY BID END */

    /* RIBBON NEW AUCTION */
    $ribbon_date = date('d-m-Y');
    $ribbon_auctiondate = date('d-m-Y', strtotime($auction['date_start']));
    $ribbon_status = '';
    if (strtotime($ribbon_date) == strtotime($ribbon_auctiondate)) {
        $ribbon_status = '<div class="AuctionNewIcon"><img src="' . $template_path . '/images/global/content/ribbon-new-top-left.png"></div>';
    }
    /* RIBBON NEW AUCTION END */

    /* VERIFY DATE */
    $Hoje = date('Y-m-d H:i:s');
    $End = date('Y-m-d H:i:s', strtotime($auction['date_end']));

    ?>
    <tr>
        <td>
            <div class="TableContentContainer">
                <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                    <tbody>
                    <tr>
                        <td>
                            <div class="Auction">
                                <div class="AuctionHeader">
                                    <div class="AuctionLinks"><a
                                            href="?subtopic=<?= $subtopic ?>&details=<?= $auction['id'] ?>">
                                            <img title="show auction details"
                                                 src="<?= $template_path; ?>/images/global/content/button-details-idle.png"></a>
                                    </div>
                                    <div class="AuctionCharacterName"><a
                                            href="?subtopic=<?= $subtopic ?>&details=<?= $auction['id'] ?>"><?= $character['name'] ?></a>
                                    </div>
                                    Level: <?= $character['level'] ?> |
                                    Vocation: <?= $character_voc ?> | <?= $character_sex ?> |
                                    World: <?= $config['lua']['serverName'] ?>
                                    <br>
                                </div>
                                <div class="AuctionBody">
                                    <div class="AuctionBodyBlock AuctionDisplay AuctionOutfit"><?= $ribbon_status ?>
                                        <img class="AuctionOutfitImage" src="<?= $outfit_url ?>">
                                    </div>
                                    <div class="AuctionBodyBlock AuctionDisplay AuctionItemsViewBox">
                                        <?php foreach ([2, 1, 3, 6, 4, 5, 9, 7, 10] as $i) { ?>
                                            <div class="CVIcon CVIconObject"><?= $equipment[$i]; ?></div>
                                        <?php } ?>
                                        <div class="CVIcon CVIconObject NoEquipment" title="soul">
                                            <p>Soul<br><?= $character['soul'] ?></p></div>
                                        <div class="CVIcon CVIconObject"
                                             title="boots"><?= $equipment[8]; ?></div>
                                        <div class="CVIcon CVIconObject NoEquipment" title="cap">
                                            <p>Cap<br><?= $character['cap'] ?></p></div>
                                    </div>
                                    <div class="AuctionBodyBlock ShortAuctionData">
                                        <?php $dateFormat = $subtopic == 'currentcharactertrades' ? 'M d Y, H:i:s' : 'd M Y' ?>
                                        <div class="ShortAuctionDataLabel">Auction Start:</div>
                                        <div class="ShortAuctionDataValue">
                                            <?= date($dateFormat, strtotime($auction['date_start'])) ?>
                                        </div>

                                        <div class="ShortAuctionDataLabel">Auction End:</div>
                                        <?php
                                        if ($subtopic == 'currentcharactertrades') {
                                            $dateTimer = date('Y-m-d', strtotime($auction['date_end']));
                                            if ($showCounter ?? (date('Y-m-d', strtotime($dateTimer . ' - 1 days')) == date('Y-m-d'))) { ?>
                                                <script>
                                                    const countDownDate<?= $auction['id'] ?> = new Date("<?= date($dateFormat, strtotime($auction['date_end'])) ?>").getTime();
                                                    const x = setInterval(function () {
                                                        const now = new Date().getTime();
                                                        const distance = countDownDate<?= $auction['id'] ?> - now;

                                                        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                                                        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                                        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                                        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                                                        document.getElementById("timeAuction_<?= $auction['id'] ?>").innerHTML = "in " + days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
                                                        document.getElementById("timeAuction_<?= $auction['id'] ?>").style.color = 'red';

                                                        if (distance < 0) {
                                                            clearInterval(x);
                                                            document.getElementById("timeAuction_<?= $auction['id'] ?>").innerHTML = "Finished";
                                                        }
                                                    }, 1000);
                                                </script>
                                        <?php } ?>
                                            <div id="timeAuction_<?= $auction['id'] ?>" class="ShortAuctionDataValue">
                                                <?= date($dateFormat, strtotime($auction['date_end'])) ?>
                                            </div>
                                            <!--<div class="ShortAuctionDataBidRow">
                                                  <div class="ShortAuctionDataLabel">Minimum Bid:</div>
                                                  <div class="ShortAuctionDataValue"><b><//?= number_format($auction['price'], 0, ',', ',') ?></b> <img src="<?= $template_path; ?>/images//account/icon-tibiacointrusted.png" class="VSCCoinImages" title="Transferable Tibia Coins"></div>
                                                </div>-->
                                            <div class="ShortAuctionDataBidRow">
                                                <div class="ShortAuctionDataLabel">Current Bid:</div>
                                                <div class="ShortAuctionDataValue">
                                                    <b><?= number_format($auction['price'], 0, ',', ',') ?></b>
                                                    <img
                                                        src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png"
                                                        class="VSCCoinImages" title="Transferable Tibia Coins">
                                                </div>
                                            </div>
                                        <?php } else { ?>
                                            <div
                                                class="ShortAuctionDataValue"><?= date($dateFormat, strtotime($auction['date_end'])) ?></div>
                                            <div class="ShortAuctionDataBidRow">
                                                <div class="ShortAuctionDataLabel">
                                                    Winning Bid:
                                                </div>
                                                <div class="ShortAuctionDataValue">
                                                    <b><?= number_format($auction['bid_price'], 0, ',', ',') ?></b>
                                                    <img
                                                        src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png"
                                                        class="VSCCoinImages" title="Transferable Tibia Coins">
                                                </div>
                                            </div>
                                        <?php }
                                        if ($logged && isset($getAuctionBid['account_id']) && $account_logged == $getAuctionBid['account_id']) { ?>
                                            <div class="ShortAuctionDataBidRow"
                                                 style="background-color: #d4c0a1; padding: 5px; border: 1px solid #f0e8da; box-shadow: 2px 2px 5px 0 rgb(0 0 0 / 50%);">
                                                <div class="ShortAuctionDataLabel">My Bid:</div>
                                                <div class="ShortAuctionDataValue"><?= $My_Bid ?></div>
                                            </div>
                                        <?php } ?>
                                    </div>
                                    <?php
                                    if ($subtopic == 'pastcharactertrades' && strtotime($Hoje) >= strtotime($End)) { ?>
                                        <div class="AuctionBodyBlock CurrentBid">
                                            <div class="Container">
                                                <?php if ($logged && $auction['account_old'] == $account_logged) { ?> <!-- VERIFY MY AUCTION -->
                                                    <div class="MyMaxBidLabel" style="font-weight: normal;">
                                                        My auction.
                                                    </div>
                                                <?php } ?> <!-- VERIFY MY AUCTION END -->
                                                <div class="MyMaxBidLabel" style="font-weight: bold; color: green;">
                                                    finished
                                                </div>
                                            </div>
                                        </div>
                                    <?php } else if ($subtopic == 'currentcharactertrades') { ?>
                                        <?php if ($logged) { ?> <!-- LOGGED -->
                                            <?php if ($auction['account_old'] != $account_logged) { ?>
                                                <div class="AuctionBodyBlock CurrentBid">
                                                    <div class="Container">
                                                        <div class="MyMaxBidLabel">My Bid Limit</div>
                                                        <form
                                                            action="?subtopic=<?= $subtopic ?>&action=bid"
                                                            method="post">
                                                            <input type="hidden"
                                                                   name="auction_iden"
                                                                   value="<?= $auction['id'] ?>">
                                                            <input class="MyMaxBidInput"
                                                                   type="number"
                                                                   name="maxbid"
                                                                   min="<?= $auction['price'] ?>">
                                                            <div class="BigButton"
                                                                 style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                                                                <div
                                                                    onmouseover="MouseOverBigButton(this);"
                                                                    onmouseout="MouseOutBigButton(this);">
                                                                    <div
                                                                        class="BigButtonOver"
                                                                        style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                                                    <input
                                                                        name="auction_confirm"
                                                                        class="BigButtonText"
                                                                        type="submit"
                                                                        value="Bid On Auction">
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            <?php } else { ?>
                                                <div class="AuctionBodyBlock CurrentBid">
                                                    <div class="Container">
                                                        <div class="MyMaxBidLabel" style="font-weight: normal;">
                                                            My auction.
                                                        </div>
                                                    </div>
                                                </div>
                                            <?php } ?>
                                        <?php } else { ?> <!-- LOGGED END -->
                                            <div class="AuctionBodyBlock CurrentBid">
                                                <div class="Container">
                                                    <div class="MyMaxBidLabel" style="font-weight: normal;">
                                                        Please login first.
                                                    </div>
                                                </div>
                                            </div>
                                        <?php } ?> <!-- LOGGED END -->
                                    <?php } ?>
                                </div>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </td>
    </tr>
    <?php
} /* LOOP END */
?>

