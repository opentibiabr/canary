<?php
global $action, $config, $twig, $template_path, $config_salt_enabled;

if ($action == 'step3') {
    $rec_key = trim($_REQUEST['key']);
    $nick = stripslashes($_REQUEST['nick']);
    $new_pass = trim($_REQUEST['passor']);
    $new_email = trim($_REQUEST['email']);
    if (Validator::characterName($nick)) {
        $player = new OTS_Player();
        $account = new OTS_Account();
        $player->find($nick);
        if ($player->isLoaded())
            $account = $player->getAccount();
        if ($account->isLoaded()) {
            $account_key = $account->getCustomField('key');
            if (!empty($account_key)) {
                if ($account_key == $rec_key) {
                    if (Validator::password($new_pass)) {
                        if (Validator::email($new_email)) {
                            $account->setEMail($new_email);

                            $tmp_new_pass = $new_pass;
                            if ($config_salt_enabled) {
                                $salt = generateRandomString(10, false, true, true);
                                $tmp_new_pass = $salt . $new_pass;
                            }

                            $account->setPassword(encrypt($tmp_new_pass));
                            $account->save();

                            if ($config_salt_enabled)
                                $account->setCustomField('salt', $salt);

                            echo 'Your account name, new password and new e-mail.<BR>
							<FORM ACTION="?subtopic=accountmanagement" onsubmit="return validate_form(this)" METHOD=post>
							<INPUT TYPE=hidden NAME="character" VALUE="">
							<TABLE CELLSPACING=1 CELLPADDING=4 BORDER=0 WIDTH=100%>
							<TR><TD BGCOLOR="' . $config['vdarkborder'] . '" class="white"><B>Your account name, new password and new e-mail</B></TD></TR>
							<TR><TD BGCOLOR="' . $config['darkborder'] . '">
							Account name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>' . $account->getCustomField('name') . '</b><BR>
							New password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>' . $new_pass . '</b><BR>
							New e-mail address:&nbsp;<b>' . $new_email . '</b><BR>';
                            if ($account->getCustomField('email_next') < time()) {
                                $mailBody = '
								<h3>Your account name and new password!</h3>
								<p>Changed password and e-mail to your account in Lost Account Interface on server <a href="' . BASE_URL . '"><b>' . $config['lua']['serverName'] . '</b></a></p>
								<p>Account name: <b>' . $account->getCustomField('name') . '</b></p>
								<p>New password: <b>' . $new_pass . '</b></p>
								<p>E-mail: <b>' . $new_email . '</b> (this e-mail)</p>
								<br />
								<p><u>It\'s automatic e-mail from OTS Lost Account System. Do not reply!</u></p>';

                                if (_mail($account->getCustomField('email'), $config['lua']['serverName'] . " - New password to your account", $mailBody)) {
                                    echo '<br /><small>Sent e-mail with your account name and password to new e-mail. You should receive this e-mail in 15 minutes. You can login now with new password!</small>';
                                } else {
                                    echo '<br /><p class="error">An error occurred while sending email! You will not receive e-mail with this informations. For Admin: More info can be found in system/logs/mailer-error.log</p>';
                                }
                            } else {
                                echo '<br /><small>You will not receive e-mail with this informations.</small>';
                            }
                            echo '<INPUT TYPE=hidden NAME="account_login" VALUE="' . $account->getId() . '">
							<INPUT TYPE=hidden NAME="password_login" VALUE="' . $new_pass . '">
							</TD></TR></TABLE><BR>
							<TABLE CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH=100%><TR><TD><div style="text-align:center">
							<INPUT TYPE=image NAME="Login" ALT="Login" SRC="' . $template_path . '/images/global/buttons/sbutton_login.gif" BORDER=0 WIDTH=120 HEIGHT=18></div>
							</TD></TR></FORM></TABLE></TABLE>';
                        } else
                            echo Validator::getLastError();
                    } else
                        echo Validator::getLastError();
                } else
                    echo 'Wrong recovery key!';
            } else
                echo 'Account of this character has no recovery key!';
        } else
            echo 'Player or account of player <b>' . $nick . '</b> doesn\'t exist.';
    } else
        echo 'Invalid player name format. If you have other characters on account try with other name.';
    echo '<BR /><TABLE CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH=100%><TR><TD><div style="text-align:center">
				<a href="?subtopic=lostaccount&action=step1&action_type=reckey&nick=' . urlencode($nick) . '" border="0"><IMG SRC="' . $template_path . '/images/global/buttons/sbutton_back.gif" NAME="Back" ALT="Back" BORDER=0 WIDTH=120 HEIGHT=18></a></div>
				</TD></TR></FORM></TABLE></TABLE>';
}
