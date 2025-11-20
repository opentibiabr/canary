<?php

global $config, $db, $template_path;
$auction_iddetails = $getPageDetails;

/* GET INFO AUCTION */
$getAuction = $db->query("SELECT `id`, `account_old`, `account_new`, `player_id`, `price`, `date_end`, `date_start`, `bid_account`, `bid_price`, `status` FROM `myaac_charbazaar` WHERE `id` = {$db->quote($auction_iddetails)}");
if (!$getAuction = $getAuction->fetch()) {
    echo "We can not find auction with this id!";
    return;
}
/* GET INFO AUCTION END */

/* GET INFO CHARACTER */
$getCharacter = $db->query("SELECT `name`, `vocation`, `level`, `sex`, `looktype`, `lookaddons`, `lookhead`, `lookbody`, `looklegs`, `lookfeet`, `health`, `healthmax`, `mana`, `manamax`, `maglevel`, `manaspent`, `balance`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`, `skill_shielding`, `skill_shielding_tries`, `cap`, `soul`, `created`, `experience`, `blessings1`, `blessings2`, `blessings3`, `blessings4`, `blessings5`, `blessings6`, `blessings7`, `blessings8` FROM `players` WHERE `id` = {$getAuction['player_id']}");
$character = $getCharacter->fetch();
/* GET INFO CHARACTER END */

/* GET ITEMS DEPOT */
$getDepotItems = $db->query("SELECT `sid`, `pid`, `itemtype`, `count`, `attributes` FROM `player_depotitems` WHERE `player_id` = {$getAuction['player_id']}");
$getDepotItems = $getDepotItems->fetch();
/* GET ITEMS DEPOT END */

/* GET BLESS */
$BlessCount = 0;
for ($b = 1; $b < 8; $b++) {
    if ($character["blessings$b"] >= 1) {
        $BlessCount = $BlessCount++;
    }
}
$BlessTwist = ($character['blessings8'] >= 1) ? 'yes' : 'no';
/* GET BLESS END */

/* GET CHARM CHARACTER */
$getCharm = $db->query("SELECT `player_guid`, `charm_points`, `charm_expansion`, `rune_wound`, `rune_enflame`, `rune_poison`, `rune_freeze`, `rune_zap`, `rune_curse`, `rune_cripple`, `rune_parry`, `rune_dodge`, `rune_adrenaline`, `rune_numb`, `rune_cleanse`, `rune_bless`, `rune_scavenge`, `rune_gut`, `rune_low_blow`, `rune_divine`, `rune_vamp`, `rune_void`, `UsedRunesBit` FROM `player_charms` WHERE `player_guid` = {$getAuction['player_id']}");
$getCharm = $getCharm->fetch();

$Charm_Points = $getCharm['charm_points'] ?? '0';
$Charm_UsedPoints = $getCharm['UsedRunesBit'] ?? '0';
$Charm_Expansion = isset($getCharm['charm_expansion']) && $getCharm['charm_expansion'] == 1
    ? "<img src='{$template_path}/images/premiumfeatures/icon_yes.png'> yes"
    : "<img src='{$template_path}/images/premiumfeatures/icon_no.png'> no";
/* GET CHARM CHARACTER END */

/* OUTFIT CHARACTER */
$outfit_url = "{$config['outfit_images_url']}?id={$character['looktype']}" . (!empty($character['lookaddons']) ? "&addons={$character['lookaddons']}" : '') . "&head={$character['lookhead']}&body={$character['lookbody']}&legs={$character['looklegs']}&feet={$character['lookfeet']}";
/* OUTFIT CHARACTER */

/* EQUIPAMENT CHARACTER */
global $db;
$eq_sql = $db->query("SELECT `pid`, `itemtype` FROM player_items WHERE player_id = {$getAuction['player_id']} AND (`pid` >= 1 and `pid` <= 10)");
$equipment = [];
foreach ($eq_sql as $eq)
    $equipment[$eq['pid']] = $eq['itemtype'];

$empty_slots = ["", "no_helmet", "no_necklace", "no_backpack", "no_armor", "no_handleft", "no_handright", "no_legs", "no_boots", "no_ring", "no_ammo"];
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

/* GET QUESTS */
$quests = $config['quests'];
$sql_query_in = '';
$i = 0;
foreach ($quests as $quest_name => $quest_storage) {
    if ($i != 0)
        $sql_query_in .= ', ';

    $sql_query_in .= $quest_storage;
    $i++;
}
$storage_sql = $db->query("SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = {$getAuction['player_id']} AND `key` IN ({$sql_query_in})");
$player_storage = [];
foreach ($storage_sql as $storage)
    $player_storage[$storage['key']] = $storage['value'];

foreach ($quests as &$storage) {
    $storage = isset($player_storage[$storage]) && $player_storage[$storage] > 0;
}
/* GET QUESTS END */

/* GET MY BID */
$getAuctionBid = $db->query("SELECT `account_id`, `auction_id`, `bid`, `date` FROM `myaac_charbazaar_bid` WHERE `auction_id` = {$getAuction['id']}");
$getAuctionBid = $getAuctionBid->fetch();

$My_Bid = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
if ($logged && isset($getAuctionBid['account_id']) && $account_logged == $getAuctionBid['account_id']) {
    $val = number_format($getAuctionBid['bid'], 0, ',', ',');
    $My_Bid = "<b>{$val}</b> <img src='{$template_path}/images/account/icon-tibiacointrusted.png' class='VSCCoinImages' title='Transferable Tibia Coins'>";
}
/* GET MY BID END */

/* VERIFY DATE */
$Hoje = date('Y-m-d H:i:s');
$End = date('Y-m-d H:i:s', strtotime($getAuction['date_end']));
/* VERIFY DATE END */
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
            <div class="Text">Auction Details</div>
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
                                                <div class="Auction">
                                                    <div class="AuctionHeader">
                                                        <div class="AuctionLinks"></div>
                                                        <div
                                                            class="AuctionCharacterName"><?= $character['name'] ?></div>
                                                        Level: <?= $character['level'] ?> |
                                                        Vocation: <?= $character_voc ?> | <?= $character_sex ?> |
                                                        World: <?= $config['lua']['serverName'] ?>
                                                        <br>
                                                    </div>
                                                    <div class="AuctionBody">
                                                        <div class="AuctionBodyBlock AuctionDisplay AuctionOutfit"
                                                             style="font-size: 10px; text-align: center;">
                                                            Current outfit:
                                                            <img class="AuctionOutfitImage" src="<?= $outfit_url ?>">
                                                        </div>
                                                        <div
                                                            class="AuctionBodyBlock AuctionDisplay AuctionItemsViewBox">
                                                            <?php foreach ([2, 1, 3, 6, 4, 5, 9, 7, 10] as $i) { ?>
                                                                <div class="CVIcon CVIconObject">
                                                                    <?= $equipment[$i]; ?></div>
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
                                                            <div
                                                                class="ShortAuctionDataValue"><?= date($dateFormat, strtotime($getAuction['date_start'])) ?></div>
                                                            <div class="ShortAuctionDataLabel">Auction End:</div>
                                                            <?php
                                                            if ($subtopic == 'currentcharactertrades') {
                                                                $dateTimer = date('Y-m-d', strtotime($getAuction['date_end']));
                                                                if ($showCounter ?? (date('Y-m-d', strtotime($dateTimer . ' - 1 days')) == date('Y-m-d'))) { ?>
                                                                    <script>
                                                                        const countDownDate = new Date("<?= date($dateFormat, strtotime($getAuction['date_end'])) ?>").getTime();
                                                                        const x = setInterval(function () {
                                                                            const now = new Date().getTime();
                                                                            const distance = countDownDate - now;

                                                                            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                                                                            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                                                            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                                                            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                                                                            document.getElementById("timeAuction").innerHTML = "in " + days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
                                                                            document.getElementById("timeAuction").style.color = 'red';

                                                                            if (distance < 0) {
                                                                                clearInterval(x);
                                                                                document.getElementById("timeAuction").innerHTML = "Finished";
                                                                            }
                                                                        }, 1000);
                                                                    </script>
                                                            <?php } ?>
                                                                <div id="timeAuction" class="ShortAuctionDataValue">
                                                                    <?= date($dateFormat, strtotime($getAuction['date_end'])) ?>
                                                                </div>
                                                                <div class="ShortAuctionDataBidRow">
                                                                    <div class="ShortAuctionDataLabel">Current Bid:
                                                                    </div>
                                                                    <div class="ShortAuctionDataValue">
                                                                        <b><?= number_format($getAuction['price'], 0, ',', ',') ?></b>
                                                                        <img
                                                                            src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png"
                                                                            class="VSCCoinImages"
                                                                            title="Transferable Tibia Coins">
                                                                    </div>
                                                                </div>
                                                            <?php } else { ?>
                                                                <div class="ShortAuctionDataValue">
                                                                    <?= date($dateFormat, strtotime($getAuction['date_end'])) ?></div>
                                                                <div class="ShortAuctionDataBidRow">
                                                                    <div class="ShortAuctionDataLabel">Winning Bid:
                                                                    </div>
                                                                    <div class="ShortAuctionDataValue">
                                                                        <b><?= number_format($getAuction['bid_price'], 0, ',', ',') ?></b>
                                                                        <img
                                                                            src="<?= $template_path; ?>/images/account/icon-tibiacointrusted.png"
                                                                            class="VSCCoinImages"
                                                                            title="Transferable Tibia Coins"></div>
                                                                </div>
                                                            <?php } ?>
                                                            <?php if ($logged && isset($getAuctionBid['account_id']) && $account_logged == $getAuctionBid['account_id']) { ?>
                                                                <div class="ShortAuctionDataBidRow"
                                                                     style="background-color: #d4c0a1; padding: 5px; border: 1px solid #f0e8da; box-shadow: 2px 2px 5px 0 rgb(0 0 0 / 50%);">
                                                                    <div class="ShortAuctionDataLabel">My Bid:</div>
                                                                    <div
                                                                        class="ShortAuctionDataValue"><?= $My_Bid ?></div>
                                                                </div>
                                                            <?php } ?>
                                                        </div>
                                                        <?php if ($logged && $getAuction['status'] == 0) { ?>
                                                            <?php if (strtotime($End) > strtotime($Hoje) && $account_logged != $getAuction['account_old']) { ?>
                                                                <div class="AuctionBodyBlock CurrentBid">
                                                                    <div class="Container">
                                                                        <div class="MyMaxBidLabel">My Bid Limit
                                                                        </div>
                                                                        <form
                                                                            action="?subtopic=currentcharactertrades&action=bid"
                                                                            method="POST">
                                                                            <input type="hidden" name="auction_iden"
                                                                                   value="<?= $getAuction['id'] ?>">
                                                                            <input class="MyMaxBidInput" type="text"
                                                                                   name="maxbid">
                                                                            <div class="BigButton"
                                                                                 style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                                                                                <div
                                                                                    onmouseover="MouseOverBigButton(this);"
                                                                                    onmouseout="MouseOutBigButton(this);">
                                                                                    <div class="BigButtonOver"
                                                                                         style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                                                                    <input name="auction_confirm"
                                                                                           class="BigButtonText"
                                                                                           type="submit"
                                                                                           value="Bid On Auction">
                                                                                </div>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            <?php } ?>
                                                            <?php if (strtotime($End) > strtotime($Hoje) && $account_logged == $getAuction['account_old']) { ?>
                                                                <div class="AuctionBodyBlock CurrentBid">
                                                                    <div class="Container">
                                                                        <div class="MyMaxBidLabel"
                                                                             style="font-weight: normal;">My auction.
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            <?php } ?>
                                                            <?php if (strtotime($End) < strtotime($Hoje) && (
                                                                    ($account_logged == $getAuction['account_old'] && $account_logged != $getAuction['bid_account']) ||
                                                                    ($account_logged != $getAuction['account_old'] && $account_logged == $getAuction['bid_account'])
                                                                )) { ?>
                                                                <div class="AuctionBodyBlock CurrentBid">
                                                                    <div class="Container">
                                                                        <div class="MyMaxBidLabel"
                                                                             style="font-weight: bold; color: green;">
                                                                            <form method="post"
                                                                                  action="?subtopic=currentcharactertrades&action=finish">
                                                                                <input type="hidden"
                                                                                       name="auction_iden"
                                                                                       value="<?= $getAuction['id'] ?>">
                                                                                <div class="BigButton"
                                                                                     style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton_green.gif)">
                                                                                    <div
                                                                                        onmouseover="MouseOverBigButton(this);"
                                                                                        onmouseout="MouseOutBigButton(this);">
                                                                                        <div class="BigButtonOver"
                                                                                             style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_green_over.gif); visibility: hidden;"></div>
                                                                                        <input name="auction_finish"
                                                                                               class="BigButtonText"
                                                                                               type="submit"
                                                                                               value="Finish Auction">
                                                                                    </div>
                                                                                </div>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            <?php } ?>
                                                            <?php if (strtotime($End) < strtotime($Hoje) && $account_logged != $getAuction['account_old'] && $account_logged != $getAuction['bid_account']) { ?>
                                                                <div class="AuctionBodyBlock CurrentBid">
                                                                    <div class="Container">
                                                                        <div class="MyMaxBidLabel"
                                                                             style="font-weight: bold; color: green;">
                                                                            finished
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            <?php } ?>
                                                        <?php } ?>
                                                        <?php if (!$logged) { ?>
                                                            <?php if ($getAuction['status'] == 0) { ?>
                                                                <div class="AuctionBodyBlock CurrentBid">
                                                                    <div class="Container">
                                                                        <div class="MyMaxBidLabel"
                                                                             style="font-weight: normal;">Please
                                                                            first login.
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            <?php } ?>
                                                            <?php if ($getAuction['status'] == 1) { ?>
                                                                <div class="AuctionBodyBlock CurrentBid">
                                                                    <div class="Container">
                                                                        <div class="MyMaxBidLabel"
                                                                             style="font-weight: normal;">finished
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            <?php } ?>
                                                        <?php } ?>
                                                        <div class="AuctionBodyBlock SpecialCharacterFeatures">
                                                            <div class="Entry">
                                                                <img class="CharacterFeatureCategory"
                                                                     src="<?= $template_path; ?>/images/charactertrade/usp-category-3.png">Blessings
                                                                active: <?= $BlessCount ?>/7, Twist of Fate
                                                                active: <?= $BlessTwist ?>
                                                            </div>
                                                            <div class="Entry">
                                                                <img class="CharacterFeatureCategory"
                                                                     src="<?= $template_path; ?>/images/charactertrade/usp-category-7.png">Total
                                                                Charm Points <?= $Charm_Points ?>, Unused
                                                                Charm Points: <?= $Charm_UsedPoints ?>
                                                            </div>
                                                            <div class="Entry">
                                                                <img class="CharacterFeatureCategory"
                                                                     src="<?= $template_path; ?>/images/charactertrade/usp-category-0.png">10
                                                                Distance Fighting (Loyalty bonus not included)
                                                            </div>
                                                            <div class="Entry">
                                                                <img class="CharacterFeatureCategory"
                                                                     src="<?= $template_path; ?>/images/charactertrade/usp-category-0.png">10
                                                                Shielding (Loyalty bonus not included)
                                                            </div>

                                                        </div>
                                                    </div>
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
            </td>
        </tr>
        </tbody>
    </table>
</div>
<br>
<center>
    <a href="?subtopic=<?= $subtopic == 'currentcharactertrades' ? 'currentcharactertrades' : 'pastcharactertrades' ?>">
        <div class="BigButton"
             style="background-image:url(<?= $template_path; ?>/images/global/buttons/sbutton.gif)">
            <div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);">
                <div class="BigButtonOver"
                     style="background-image: url(<?= $template_path; ?>/images/global/buttons/sbutton_over.gif); visibility: hidden;"></div>
                <input name="auction_confirm" class="BigButtonText" type="button" value="Back"></div>
        </div>
    </a>
</center>
<br>
<div class="TopButtonContainer">
    <div class="TopButton" style="">
        <a href="#top">
            <img style="border:0px;" src="<?= $template_path; ?>/images/content/back-to-top.gif">
        </a>
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
            <div class="Text">General</div>
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
                                                                style="float:right; text-align: right;"><?= $character['health'] ?>
                                                                / <?= $character['healthmax'] ?></div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td><span class="LabelV">Mana:</span>
                                                            <div
                                                                style="float:right; text-align: right;"><?= $character['mana'] ?>
                                                                / <?= $character['manamax'] ?></div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Even">
                                                        <td><span class="LabelV">Capacity:</span>
                                                            <div
                                                                style="float:right; text-align: right;"><?= $character['cap'] ?></div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td><span class="LabelV">Soul:</span>
                                                            <div
                                                                style="float:right; text-align: right;"><?= $character['soul'] ?></div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Even">
                                                        <td><span class="LabelV">Blessings:</span>
                                                            <div
                                                                style="float:right; text-align: right;"><?= $BlessCount ?>
                                                                /7
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td><span class="LabelV">Mounts:</span>
                                                            <div style="float:right; text-align: right;">0</div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Even">
                                                        <td><span class="LabelV">Outfits:</span>
                                                            <div style="float:right; text-align: right;">0</div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td><span class="LabelV">Titles:</span>
                                                            <div style="float:right; text-align: right;">0</div>
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
                                                        <td class="LevelColumn"><?= $character['skill_axe'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_axe_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_axe_tries'] ?> %</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td class="LabelColumn"><b>Club Fighting</b></td>
                                                        <td class="LevelColumn"><?= $character['skill_club'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_club_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_club_tries'] ?> %</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Even">
                                                        <td class="LabelColumn"><b>Distance Fighting</b></td>
                                                        <td class="LevelColumn"><?= $character['skill_dist'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_dist_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_dist_tries'] ?> %</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td class="LabelColumn"><b>Fishing</b></td>
                                                        <td class="LevelColumn"><?= $character['skill_fishing'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_fishing_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_fishing_tries'] ?> %</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Even">
                                                        <td class="LabelColumn"><b>Fist Fighting</b></td>
                                                        <td class="LevelColumn"><?= $character['skill_fist'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_fist_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_fist_tries'] ?> %</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td class="LabelColumn"><b>Magic Level</b></td>
                                                        <td class="LevelColumn"><?= $character['maglevel'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= OTS_Player::getMagicLevelPercent($character) ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer">
                                                                <span class="PercentageString">
                                                                    <?= OTS_Player::getMagicLevelPercent($character) ?> %
                                                                </span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Even">
                                                        <td class="LabelColumn"><b>Shielding</b></td>
                                                        <td class="LevelColumn"><?= $character['skill_shielding'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_shielding_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_shielding_tries'] ?> %</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="Odd">
                                                        <td class="LabelColumn"><b>Sword Fighting</b></td>
                                                        <td class="LevelColumn"><?= $character['skill_sword'] ?></td>
                                                        <td class="PercentageColumn">
                                                            <div id="SkillBar" class="PercentageBar"
                                                                 style="width: <?= $character['skill_sword_tries'] ?>%">
                                                                <div class="PercentageBarSpacer"></div>
                                                            </div>
                                                            <div class="PercentageStringContainer"><span
                                                                    class="PercentageString"><?= $character['skill_sword_tries'] ?> %</span>
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
                                                <div
                                                    style="float:right; text-align: right;"><?= date('d M Y, H:i:s', $character['created']) ?></div>
                                            </td>
                                        </tr>
                                        <tr class="Odd">
                                            <td><span class="LabelV">Experience:</span>
                                                <div
                                                    style="float:right; text-align: right;"><?= number_format($character['experience'], 0, ',', ',') ?></div>
                                            </td>
                                        </tr>
                                        <tr class="Even">
                                            <td><span class="LabelV">Gold:</span>
                                                <div
                                                    style="float:right; text-align: right;"><?= $character['balance'] ?></div>
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
                                                <div
                                                    style="float:right; text-align: right;"><?= $Charm_Expansion ?></div>
                                            </td>
                                        </tr>
                                        <tr class="Even">
                                            <td><span class="LabelV">Available Charm Points:</span>
                                                <div
                                                    style="float:right; text-align: right;"><?= $Charm_Points ?></div>
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
<div class="TopButtonContainer">
    <div class="TopButton" style="">
        <a href="#top">
            <img style="border:0px;" src="<?= $template_path; ?>/images/content/back-to-top.gif">
        </a>
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
            <div class="Text">Item Summary</div>
            <span class="CaptionVerticalRight"
                  style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
            <span class="CaptionBorderBottom"
                  style="background-image:url(<?= $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
            <span class="CaptionEdgeLeftBottom"
                  style="background-image:url(<?= $template_path; ?>https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
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
                                <div class="TableContentContainer">
                                    <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                                        <tbody>
                                        <tr class="Even tmp-container-ItemSummary">
                                            <td>
                                                <div id="ajax-target-type-0"
                                                     class="paged-container page-object-container">

                                                    <div class="BlockPage BlockPageObject">
                                                        <?php
                                                        $getDepotItems = $db->query("SELECT `sid`, `pid`, `itemtype`, `count`, `attributes` FROM `player_depotitems` WHERE `player_id` = {$getAuction['player_id']}");
                                                        $getDepotItems = $getDepotItems->fetch();
                                                        if ($getDepotItems) {
                                                            foreach ($getDepotItems as $DepotItem) {
                                                                ?>
                                                                <div class="CVIcon CVIconObject">
                                                                    <img
                                                                        src="<?= $template_path; ?>/images/charactertrade/objects/<?= $DepotItem['sid'] ?>.gif">
                                                                    <?php if ($DepotItem['count'] > 1) { ?>
                                                                        <div
                                                                            class="ObjectAmount"><?= $DepotItem['count'] ?></div>
                                                                    <?php } ?>
                                                                </div>
                                                            <?php }
                                                        } ?>
                                                    </div>
                                                    <?php if (!$getDepotItems || count($getDepotItems) == 0) { ?>
                                                        <div style="text-align: center;">No items.</div>
                                                    <?php } ?>
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
            </td>
        </tr>
        </tbody>
    </table>
</div>
<br>
<div class="CharacterDetailsBlock " id="Charms"><a name="Charms"></a>
    <div class="TopButtonContainer"><a name="Charms"></a>
        <div class="TopButton"><a name="Charms"></a><a onclick="ScrollToAnchor('top');">
                <img style="border: 0px;" src="<?= $template_path; ?>/images/global/content/back-to-top.gif"></a>
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
                <div class="Text">Charms</div>
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
        <?php
        $Charm_CountRunes = 0;
        $charmNames = ['wound', 'enflame', 'poison', 'freeze', 'zap', 'curse', 'cripple', 'parry', 'dodge', 'adrenaline', 'numb', 'cleanse', 'bless', 'scavenge', 'gut', 'low_blow', 'divine', 'vamp', 'void'];
        $runes = [];
        foreach ($charmNames as $charm) {
            if (!$getCharm || $charm < 1) {
                $runes["rune_$charm"] = '<img src="' . $template_path . '/images/premiumfeatures/icon_no.png">';
                continue;
            }
            $Charm_CountRunes++;
            $runes["rune_$charm"] = '<img src="' . $template_path . '/images/premiumfeatures/icon_yes.png">';
        }
        ?>
        <table class="Table3" cellspacing="0" cellpadding="0">
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
                                            <?php foreach ($charmNames as $k => $charm) { ?>
                                                <tr class="<?= $k % 2 == 0 ? 'Even' : 'Odd' ?>">
                                                    <td>
                                                        <?= $runes["rune_$charm"] ?>
                                                        Rune <?= ucwords(str_replace('_', ' ', $charm)) ?>
                                                    </td>
                                                </tr>
                                            <?php } ?>
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
</div>
<br>
<div class="CharacterDetailsBlock " id="CompletedQuestLines"><a name="Completed Quest Lines"></a>
    <div class="TopButtonContainer"><a name="Completed Quest Lines"></a>
        <div class="TopButton"><a name="Completed Quest Lines"></a><a onclick="ScrollToAnchor('top');"><img
                    style="border: 0px;" src="<?= $template_path; ?>/images/global/content/back-to-top.gif"></a>
        </div>
    </div>
    <div class="TableContainer">
        <div class="CaptionContainer">
            <div class="CaptionInnerContainer"><span class="CaptionEdgeLeftTop"
                                                     style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                <span class="CaptionEdgeRightTop"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-edge.gif);"></span>
                <span class="CaptionBorderTop"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/table-headline-border.gif);"></span>
                <span class="CaptionVerticalLeft"
                      style="background-image:url(<?= $template_path; ?>/images/global/content/box-frame-vertical.gif);"></span>
                <div class="Text">Completed Quest Lines</div>
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
                                    <div class="TableContentContainer">
                                        <table class="TableContent" style="border:1px solid #faf0d7;" width="100%">
                                            <tbody>
                                            <tr class="LabelH">
                                                <td>Quest Line Name</td>
                                            </tr>
                                            <?php
                                            $i_bg = 0;
                                            foreach ($quests as $quest_name => $quest_storage) {
                                                $i_bg = $i_bg + 1;
                                                ?>
                                                <tr bgcolor="<?= getStyle($i_bg) ?>">
                                                    <td> <?= $quest_name; ?></td>
                                                </tr>
                                            <?php } ?>
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
</div>
<!-- END PAGE DETAILS -->
