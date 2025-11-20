<?php global $db, $account_logged;
/**
 * Premium/VIP Updater
 *
 * @package   MyAAC
 * @author    Elson
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$title = 'Premium/VIP Updater';
$base = BASE_URL . 'admin/?p=premiumvipupdater';
$addTitle = isVipSystemEnabled() ? 'VIP' : "Premium";
$now = time();

function echo_success($message)
{
    echo '<p class="success">' . $message . '</p>';
}

function echo_error($message)
{
    global $error;
    echo '<p class="error">' . $message . '</p>';
    $error = true;
}

$query = $db->query("SELECT `id`, `name`, `email`, `premdays`, `lastday` FROM `accounts` WHERE ID > 1;");
$accounts = [];
if ($query->rowCount() > 0) {
    $accounts = $query->fetchAll();
}

if (isset($_POST['add_days']) && $account_logged->isSuperAdmin()) {
    $daysToAdd = (int)$_POST['days_'] ?? 0;
    if ($daysToAdd < 1) {
        echo_error("You need add 1 or more days!");
    } else {
        if ($query->rowCount() > 0) {
            try {
                foreach ($accounts as $acc) {
                    $days = (int)$acc['premdays'] + $daysToAdd;
                    $lastDay = (int)$acc['lastday'] > 0 ? (int)$acc['lastday'] : $now;
                    $newLastDay = $lastDay + ($daysToAdd * 86400);
                    $db->exec("UPDATE `accounts` SET `premdays` = {$days}, `lastday` = {$newLastDay} WHERE `id` = {$acc['id']}");
                }
                echo_success("You have added {$daysToAdd} {$addTitle} days to all accounts at: " . date('G:i'));
                $accounts = $db->query("SELECT `id`, `name`, `email`, `premdays`, `lastday` FROM `accounts` WHERE ID > 1;")->fetchAll();
            } catch (PDOException $error) {
                echo_error($error->getMessage());
            }
        } else {
            echo_error("You don't have accounts to update!");
        }
    }
}
?>
<div class="row">
    <div class="col-12 col-md-8">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Add Premium or Vip Days to Accounts</h3><br>
                <span>How many days, do you want to add?</span>
                <?php if (count($accounts) > 0 && $account_logged->isSuperAdmin()) { ?>
                    <div class="box mt-4">
                        <div class="box-body">
                            <form action="<?= $base ?>" method="post">
                                <div class="form-group">
                                    <div class="input-group justify-content-between">
                                        <div>
                                            <small>Insert days you want to add for all accounts.</small><br>
                                            <input type="number" name="days_" maxlength="2" min="1" max="99" autofocus
                                                   placeholder="(min 1, max 99)" style="width: 140px;">
                                        </div>
                                        <div class="input-group-btn d-flex align-items-end">
                                            <button type="submit" class="btn btn-success" name="add_days"><i
                                                    class="fa fa-add"></i> ADD
                                            </button>
                                        </div>
                                    </div>

                                </div>
                            </form>
                        </div>
                    </div>
                <?php } ?>
            </div>
        </div>

        <div class="box">
            <div class="box-header">
                <h3 class="box-title">Accounts:</h3>
            </div>
            <div class="box-body no-padding">
                <table class="table table-striped">
                    <tbody>
                    <tr>
                        <th style="width: 15px">#</th>
                        <th style="width: 50px">ID</th>
                        <th style="width: 50px">Acc Name</th>
                        <th style="width: 50px">E-mail</th>
                        <th style="width: 120px; text-align: right">Actual <?= $addTitle ?> Days</th>
                        <th style="width: 230px">LastDay (until)</th>
                    </tr>
                    <?php foreach ($accounts as $k => $acc) { ?>
                        <tr>
                            <td><?= $k + 1 ?></td>
                            <td><?= $acc['id'] ?></td>
                            <td><?= $acc['name'] ?></td>
                            <td><?= $acc['email'] ?></td>
                            <td style="text-align: right"><?= $acc['premdays'] ?></td>
                            <td><?= $acc['lastday'] ?>
                                (<?= date("M d Y, G:i:s", $acc['lastday']) ?>)
                            </td>
                        </tr>
                    <?php } ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
