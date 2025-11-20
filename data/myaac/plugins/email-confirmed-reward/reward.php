<?php
defined('MYAAC') or die('Direct access not allowed!');

$reward = config('account_mail_confirmed_reward');

$hasCoinsTransferableColumn = $db->hasColumn('accounts', 'coins_transferable');
if (!$hasCoinsTransferableColumn && $reward['coins_transferable'] > 0) {
    log_append('email_confirm_error.log', 'accounts.coins_transferable column does not exist.');
}

$hasCoinsColumn = $db->hasColumn('accounts', 'coins');
if (!$hasCoinsColumn && $reward['coins'] > 0) {
    log_append('email_confirm_error.log', 'accounts.coins column does not exist.');
}

if (!isset($account) || !$account->isLoaded()) {
    log_append('email_confirm_error.log', 'Account not loaded.');
    return;
}

if ($hasCoinsTransferableColumn && $reward['coins_transferable'] > 0) {
    $account->setCustomField('coins_transferable', (int)$account->getCustomField('coins_transferable') + $reward['coins_transferable']);
    success(sprintf($reward['message'], $reward['coins_transferable'], 'coins transferable'));
}

if ($hasCoinsColumn && $reward['coins'] > 0) {
    $account->setCustomField('coins', (int)$account->getCustomField('coins') + $reward['coins']);
    success(sprintf($reward['message'], $reward['coins'], 'coins'));
}

if ($reward['premium_days'] > 0) {
    $account->setPremDays($account->getPremDays() + $reward['premium_days']);
    $account->save();
    success(sprintf($reward['message'], $reward['premium_days'], 'premium days'));
}
