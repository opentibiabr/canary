<?php
global $db, $config;
require_once(PLUGINS . 'pagseguro/config.php');

/**
 * Lista de donates
 *
 * @package   MyAAC
 * @author    Elson
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
if (!$db->hasTable('pagseguro_transactions')) {
    die("pagseguro_transactions table doesn't exists!");
}

$count = $db->query("SELECT `id` FROM `pagseguro_transactions` WHERE `payment_status` <> 'CANCELLED'")->rowCount();
$title = "$count donates até o momento";
$base = BASE_URL . 'admin/?p=pag_transactions';
$donates = $db->query("SELECT * FROM `pagseguro_transactions` ORDER BY `id` DESC")->fetchAll();
?>
<div class="row">
    <div class="col-md-12">
        <div class="box">
            <div class="box-body no-padding">
                <table id="tb_donates" class="table table-striped">
                    <tbody>
                    <tr>
                        <th style="width: 40px">#</th>
                        <th style="width: 60px">ID</th>
                        <th style="width: 140px;">Transação</th>
                        <th>Account & Players</th>
                        <th style="width: 160px; text-align: center">Valor / Qtd.</th>
                        <th style="width: 70px; text-align: center">Método Pag.</th>
                        <th style="width: 70px; text-align: center">Double</th>
                        <th style="width: 40px; text-align: center">Status</th>
                        <th style="width: 40px; text-align: center">Entregue</th>
                        <th style="width: 160px;">Donatado em</th>
                    </tr>
                    <?php foreach ($donates as $k => $donate) {
                        $account = $db->query("SELECT `id`, `email` FROM `accounts` WHERE `id` = {$donate['account_id']} LIMIT 1;")->fetch();
                        $players = getPlayerByAccountId($donate['account_id']);
                        ?>
                        <tr style="background-color: <?= $donate['payment_status'] == 'CANCELLED' ? '#502a2a' : '' ?>">
                            <td><?= $k + 1 ?></td>
                            <td><?= $donate['id'] ?></td>
                            <td><small><?= $donate['transaction_code'] ?></small></td>
                            <td><?= $account['email'] ?> (<?= $players ?>)</td>
                            <td style="text-align: center">
                                R$ <?= number_format($config['pagSeguro']['donates'][$donate['code']]['value'], 2, ',', '.') ?>
                                (<?= $donate['coins_amount'] ?> TC)
                            </td>
                            <td style="text-align: center"><?= $donate['payment_method'] ?? 'PIX' ?></td>
                            <td style="text-align: center"><?= $donate['in_double'] ? 'Sim' : 'Não' ?></td>
                            <td style="text-align: center"><?= $donate['payment_status'] ?></td>
                            <td style="text-align: center"><?= $donate['delivered'] ? 'Sim' : 'Não' ?></td>
                            <td><?= date("d/m/Y H:i:s", strtotime($donate['created_at'])) ?></td>
                        </tr>
                    <?php } ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        $('#tb_donates').DataTable()
    })
</script>
