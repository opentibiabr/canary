<?php global $db;
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

$title = 'Premium/VIP Fixer';
$base = BASE_URL . 'admin/?p=fixvippremiumnewsystem';
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

function getNewValue($acc, $column)
{
    $days = $acc['premdays'];
    $lastDay = $acc['lastday'];
    global $now;

    if ($lastDay <= $now && $days > 0) {
        $timeLeft = $lastDay + ($days * 86400);
        if ($timeLeft > $now) {
            if ($column == 'premdays') {
                return (int)(($now - $lastDay) / 86400);
            }

            $lastDay += ($days * 86400);
            $d = date('M d Y, G:i:s', $lastDay);
            return [$lastDay, "{$lastDay} ({$d})"];
        } else {
            return 0;
        }
    }
    return $column == 'premdays' ? $days : [$lastDay, "{$lastDay} (" . date('M d Y, G:i:s', $lastDay) . ")"];
}

$query = $db->query("SELECT `id`, `premdays`, `lastday` FROM `accounts` WHERE (`premdays` > 0 OR `lastday` > 0) AND `lastday` <= {$now};");
$accounts = [];
if ($query->rowCount() > 0) {
    $accounts = $query->fetchAll();
}

if (isset($_POST['update_all']) && $account_logged->isSuperAdmin()) {
    if ($query->rowCount() > 0) {
        try {
            foreach ($accounts as $acc) {
                $premDays = getNewValue($acc, 'premdays');
                $lastDay = getNewValue($acc, 'lastday')[0] ?? 0;
                $db->exec("UPDATE `accounts` SET `premdays` = {$premDays}, `lastday` = {$lastDay} WHERE `id` = {$acc['id']}");
            }
            echo_success('Accounts premdays and lastday updated successfully at: ' . date('G:i'));
            $accounts = $db->query("SELECT `id`, `premdays`, `lastday` FROM `accounts` WHERE (`premdays` > 0 OR `lastday` > 0) AND `lastday` <= {$now};")->fetchAll();
        } catch (PDOException $error) {
            echo_error($error->getMessage());
        }
    }
}
?>
<div class="row">
    <div class="col-12 col-md-8">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Update Premium and Vip Days of Accounts</h3><br>
                <span>This action will refresh all accounts to new premium/vip system!</span>
            </div>
        </div>

        <div class="box">
            <div class="box-header">
                <h3 class="box-title">Account List:</h3>
            </div>
            <div class="box-body no-padding">
                <table class="table table-striped">
                    <tbody>
                    <tr>
                        <th style="width: 15px">#</th>
                        <th style="width: 50px">ID</th>
                        <th style="width: 70px; text-align: right">Prem/VIP Days</th>
                        <th style="width: 40px; text-align: left">after run</th>
                        <th style="width: 120px; text-align: right">LastDay (time bought)</th>
                        <th style="width: 120px; text-align: left">after run (until)</th>
                    </tr>
                    <?php foreach ($accounts as $k => $acc) {
                        $i = $k + 1; ?>
                        <tr>
                            <td><?= $i ?></td>
                            <td><?= $acc['id'] ?></td>
                            <td style="text-align: right"><?= $acc['premdays'] ?></td>
                            <td style="text-align: left"><?= getNewValue($acc, 'premdays') ?></td>
                            <td style="text-align: right"><?= $acc['lastday'] ?>
                                (<?= date("M d Y, G:i:s", $acc['lastday']) ?>)
                            </td>
                            <td style="text-align: left"><?= getNewValue($acc, 'lastday')[1] ?? 0 ?></td>
                        </tr>
                    <?php } ?>
                    </tbody>
                </table>
            </div>
        </div>
        <?php if (count($accounts) > 0 && $account_logged->isSuperAdmin()) { ?>
            <div class="box">
                <div class="box-body">
                    <form action="<?= $base ?>" method="post">
                        <div class="input-group input-group-sm justify-content-end">
                        <span class="input-group-btn">
                          <button type="submit" class="btn btn-success" name="update_all"><i
                                  class="fa fa-refresh"></i> Run Update</button>
                        </span>
                        </div>
                    </form>
                </div>
            </div>
        <?php } ?>
    </div>
</div>
