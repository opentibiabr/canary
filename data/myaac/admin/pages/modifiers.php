<?php
/**
 * Dashboard
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Global Modifiers';

?>
    <!--
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
      Launch demo modal
    </button>

    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            ...
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
    -->


    <div class="row">
        <div class="col-5">
            <div class="box">
                <div class="box-header with-border" data-widget="collapse" style="cursor: pointer;">
                    <h3 class="box-title">Characters</h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i
                                class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="box-body">
                        <button type="button" class="btn btn-myaac" data-bs-toggle="modal"
                                data-bs-target="#resetposModal">
                            <i class="fa-solid fa-map-location-dot"></i> Reset Position
                        </button>
                        <button type="button" class="btn btn-myaac" data-bs-toggle="modal"
                                data-bs-target="#resettownModal">
                            <i class="fa-solid fa-earth-americas"></i> Reset Town
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-5">
            <div class="box">
                <div class="box-header with-border" data-widget="collapse" style="cursor: pointer;">
                    <h3 class="box-title">Accounts</h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i
                                class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="box-body">
                        <button type="button" class="btn btn-myaac" data-bs-toggle="modal"
                                data-bs-target="#resetpremModal">
                            <i class="fa-solid fa-star"></i> Reset Premium
                        </button>
                        <button type="button" class="btn btn-myaac" data-bs-toggle="modal"
                                data-bs-target="#resetcoinsModal"><i class="fa-solid fa-sack-dollar"></i> Reset Coins
                        </button>
                        <button type="button" class="btn btn-myaac" data-bs-toggle="modal"
                                data-bs-target="#resetcoinsTransferableModal"><i class="fa-solid fa-sack-dollar"></i>
                            Reset Coins Transferable
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="resetposModal" tabindex="-1" aria-labelledby="resetposModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resetposModalLabel"><i class="fa-solid fa-map-location-dot"></i> Reset
                        Position</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <form method="post" action="">
                    <div class="modal-body">
                        <div class="form-group">
                            <div class="input-group">
                                <input type="number" class="form-control" min="0" placeholder="X" name="inp_posx">
                                <input type="number" class="form-control" min="0" placeholder="Y" name="inp_posy">
                                <input type="number" class="form-control" min="0" placeholder="Z" name="inp_posz">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success" name="btn_pos">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="modal fade" id="resettownModal" tabindex="-1" aria-labelledby="resettownModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resettownModalLabel"><i class="fa-solid fa-earth-americas"></i> Reset
                        Town
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <form method="post" action="">
                    <div class="modal-body">
                        <div class="form-group">
                            <select class="form-select" name="inp_town">
                                <?php foreach ($config['towns'] as $id => $town) { ?>
                                    <option value="<?= $id ?>"><?= $town ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success" name="btn_town">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="modal fade" id="resetpremModal" tabindex="-1" aria-labelledby="resetpremModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resetpremModalLabel"><i class="fa-solid fa-star"></i> Reset Premium Days
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <form method="post" action="">
                    <div class="modal-body">
                        <input type="number" class="form-control" min="0" placeholder="days" name="inp_prem">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success" name="btn_prem">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="modal fade" id="resetcoinsModal" tabindex="-1" aria-labelledby="resetcoinsModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resetcoinsModalLabel"><i class="fa-solid fa-sack-dollar"></i> Reset
                        Tibia
                        Coins</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <form method="post" action="">
                    <div class="modal-body">
                        <input type="number" class="form-control" min="0" placeholder="tibia coins" name="inp_coins">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success" name="btn_coins">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="modal fade" id="resetcoinsTransferableModal" tabindex="-1"
         aria-labelledby="resetcoinsTransferableModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resetcoinsTransferableModalLabel">
                        <i class="fa-solid fa-sack-dollar"></i> Reset Coins Transferable</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <form method="post" action="">
                    <div class="modal-body">
                        <input type="number" class="form-control" min="0" placeholder="coins transferable"
                               name="inp_coins_transferable">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success" name="btn_coins_transferable">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<?php
if (isset($_POST['btn_pos'])) {
    $posx = $_POST['inp_posx'];
    $posy = $_POST['inp_posy'];
    $posz = $_POST['inp_posz'];
    $db->exec("UPDATE `players` SET `posx` = {$posx}, `posy` = {$posy}, `posz` = {$posz}");
    success('Character position reset successfully.');
}
if (isset($_POST['btn_town'])) {
    $inp_town = $_POST['inp_town'];
    $db->exec("UPDATE `players` SET `town_id` = {$inp_town}");
    success('City of characters successfully reset.');
}
if (isset($_POST['btn_prem'])) {
    $inp_prem = $_POST['inp_prem'];
    $lastDay = ($inp_prem > 0 && $inp_prem < OTS_Account::GRATIS_PREMIUM_DAYS) ? time() + ($inp_prem * 86400) : 0;
    $db->exec("UPDATE `accounts` SET `premdays` = {$inp_prem}, `lastday` = {$lastDay}");
    success('Premium days reset successfully.');
}
if (isset($_POST['btn_coins'])) {
    $inp_coins = $_POST['inp_coins'];
    $db->exec("UPDATE `accounts` SET `coins` = {$inp_coins}");
    success('Coins reset successfully.');
}
if (isset($_POST['btn_coins_transferable'])) {
    $inp_coins_transferable = $_POST['inp_coins_transferable'];
    $db->exec("UPDATE `accounts` SET `coins_transferable` = {$inp_coins_transferable}");
    success('Coins Transferable reset successfully.');
}
