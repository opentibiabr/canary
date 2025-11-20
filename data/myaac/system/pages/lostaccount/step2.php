<?php
global $action, $action_type, $config, $twig, $template_path;

if ($action == 'step2') {
    $rec_key = trim($_REQUEST['key']);
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
                if ($account_key == $rec_key) {
                    echo '<script type="text/javascript">
					function validate_required(field,alerttxt)
					{
					with (field)
					{
					if (value==null||value==""||value==" ")
					  {alert(alerttxt);return false;}
					else {return true}
					}
					}
					function validate_email(field,alerttxt)
					{
					with (field)
					{
					apos=value.indexOf("@");
					dotpos=value.lastIndexOf(".");
					if (apos<1||dotpos-apos<2)
					  {alert(alerttxt);return false;}
					else {return true;}
					}
					}
					function validate_form(thisform)
					{
					with (thisform)
					{
					if (validate_required(email,"Please enter your e-mail!")==false)
					  {email.focus();return false;}
					if (validate_email(email,"Invalid e-mail format!")==false)
					  {email.focus();return false;}
					if (validate_required(passor,"Please enter password!")==false)
					  {passor.focus();return false;}
					if (validate_required(passor2,"Please repeat password!")==false)
					  {passor2.focus();return false;}
					if (passor2.value!=passor.value)
					  {alert(\'Repeated password is not equal to password!\');return false;}
					}
					}
					</script>';
                    echo 'Set new password and e-mail to your account.<BR>
					<FORM ACTION="?subtopic=lostaccount&action=step3" onsubmit="return validate_form(this)" METHOD=post>
					<INPUT TYPE=hidden NAME="character" VALUE="">
					<TABLE CELLSPACING=1 CELLPADDING=4 BORDER=0 WIDTH=100%>
					<TR><TD BGCOLOR="' . $config['vdarkborder'] . '" class="white"><B>Please enter new password and e-mail</B></TD></TR>
					<TR><TD BGCOLOR="' . $config['darkborder'] . '">
					<span style="margin-right: 44px">Character name:</span><INPUT TYPE=text NAME="nick" VALUE="' . $nick . '" SIZE="40" readonly="readonly"><BR />
					<span style="margin-right: 55px">New password:</span><INPUT id="passor" TYPE=password NAME="passor" VALUE="" SIZE="40"><BR>
					<span style="margin-right: 5px">Repeat new password:</span><INPUT id="passor2" TYPE=password NAME="passor" VALUE="" SIZE="40"><BR>
					<span style="margin-right: 19px">New e-mail address:</span><INPUT id="email" TYPE=text NAME="email" VALUE="" SIZE="40"><BR>
					<INPUT TYPE=hidden NAME="key" VALUE="' . $rec_key . '">
					</TD></TR>
					</TABLE>
					<BR>
					<TABLE CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH=100%><TR><TD><div style="text-align:center">
					' . $twig->render('buttons.submit.html.twig') . '</div>
					</TD></TR></FORM></TABLE></TABLE>';
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
