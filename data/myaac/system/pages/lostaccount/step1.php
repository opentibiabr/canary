<?php
global $action, $action_type, $config, $twig, $template_path;

if ($action == 'step1' && $action_type == 'email') {
    if ($nick = stripslashes($_REQUEST['nick']) ?? null) {
        if (Validator::characterName($nick)) {
            $player = new OTS_Player();
            $account = new OTS_Account();
            $player->find($nick);
            if ($player->isLoaded())
                $account = $player->getAccount();

            if ($account->isLoaded()) {
                if ($account->getCustomField('email_next') < time())
                    echo 'Please enter e-mail to account with this character.<br><br>
				<form action="?subtopic=lostaccount&action=sendcode" method=post>
                <input type=hidden name="character">
                <table cellspacing="1" cellpadding="4" border="0" width="100%">
                <tr><td bgcolor="' . $config['vdarkborder'] . '" class="white"><b>Please enter e-mail to account</b></td></tr>
                <tr><td bgcolor="' . $config['darkborder'] . '">
                <span style="margin-right: 55px">Character:</span><input type=text name="nick" value="' . $nick . '" size="40" readonly="readonly"><br>
                <span style="margin-right: 3px">E-mail to account:</span><input type=text name="email" value="" size="40"><br>
                </td></tr>
                </table>
                <br>
                <table cellspacing=0 cellpadding=0 border=0 width=100%><tr><td><div style="text-align:center">
				' . $twig->render('buttons.submit.html.twig') . '</div></td></tr></form></table></table>';
                else {
                    $insec = $account->getCustomField('email_next') - time();
                    $minutesleft = floor($insec / 60);
                    $secondsleft = $insec - ($minutesleft * 60);
                    $timeleft = $minutesleft . ' minutes ' . $secondsleft . ' seconds';
                    echo 'Account of selected character (<b>' . $nick . '</b>) received e-mail in last ' . ceil($config['email_lai_sec_interval'] / 60) . ' minutes. You must wait ' . $timeleft . ' before you can use Lost Account Interface again.';
                }
            } else
                echo 'Player or account of player <b>' . $nick . '</b> doesn\'t exist.';
        } else
            echo 'Invalid player name format. If you have other characters on account try with other name.';
    }

    echo '<BR /><TABLE CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH=100%><TR><TD><div style="text-align:center">
				<a href="?subtopic=lostaccount" border="0"><IMG SRC="' . $template_path . '/images/global/buttons/sbutton_back.gif" NAME="Back" ALT="Back" BORDER=0 WIDTH=120 HEIGHT=18></a></div>
				</TD></TR></FORM></TABLE></TABLE>';
} elseif ($action == 'step1' && $action_type == 'reckey') {
    $nick = stripslashes($_REQUEST['nick']);
    if (Validator::characterName($nick)) {
        $player = new OTS_Player();
        $account = new OTS_Account();
        $player->find($nick);
        if ($player->isLoaded())
            $account = $player->getAccount();
        if ($account->isLoaded()) {
            $account_key = $account->getCustomField('key');
            if (!empty($account_key)) {
                echo 'If you enter right recovery key you will see form to set new e-mail and password to account. To this e-mail will be send your new password and account name.<BR>
						<FORM ACTION="?subtopic=lostaccount&action=step2" METHOD=post>
						<TABLE CELLSPACING=1 CELLPADDING=4 BORDER=0 WIDTH=100%>
						<TR><TD BGCOLOR="' . $config['vdarkborder'] . '" class="white"><B>Please enter your recovery key</B></TD></TR>
						<TR><TD BGCOLOR="' . $config['darkborder'] . '">
						<span style="margin-right: 3px">Character name:</span><INPUT TYPE=text NAME="nick" VALUE="' . $nick . '" SIZE="40" readonly="readonly"><BR />
						<span style="margin-right: 21px">Recovery key:</span><INPUT TYPE=text NAME="key" VALUE="" SIZE="40"><BR>
						</TD></TR>
						</TABLE>
						<BR>
						<TABLE CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH=100%><TR><TD><div style="text-align:center">
						' . $twig->render('buttons.submit.html.twig') . '</div>
						</TD></TR></FORM></TABLE></TABLE>';
            } else
                echo 'Account of this character has no recovery key!';
        } else
            echo 'Player or account of player <b>' . $nick . '</b> doesn\'t exist.';
    } else
        echo 'Invalid player name format. If you have other characters on account try with other name.';
    echo '<BR /><TABLE CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH=100%><TR><TD><div style="text-align:center">
				<a href="?subtopic=lostaccount" border="0"><IMG SRC="' . $template_path . '/images/global/buttons/sbutton_back.gif" NAME="Back" ALT="Back" BORDER=0 WIDTH=120 HEIGHT=18></a></div>
				</TD></TR></FORM></TABLE></TABLE>';
}
