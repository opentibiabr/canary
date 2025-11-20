<style>
    .donate{
        width: 180px;
        height: 190px;
    }
    .donate_header{
        height: 45px;
        width: 180px;
        background-image: url('templates/tibiacom/images/themeboxes/box_top.png');
        font-family: Verdana;
        font-weight: bold;
        color: #d5c3af;
        line-height: 65px;
    }
    .donate_bottom{
        height: 30px;
        width: 180px;
        margin-top: -20px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bottom.png');
    }
    .donate_content{
        padding: 0px 10px;
        width: 160px;
        height: 125px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bg.png');
        display: grid;
        justify-content: center;
        align-items: center;
    }
    .donate_outfit{
        position: absolute;
        width: 64px;
        height: 64px;
        background-position: bottom right;
        left: 10px;
        margin-top: -15px;
    }
    .donate_text{
        margin-left: 45px;
        font-family: Verdana;
        color: #d5c3af;
        text-align: left;
    }
    .donate_button{
        height: 30px;
        width: 148px;
        border: 0;
        background: url('templates/tibiacom/images/themeboxes/button.png');
        font-family: Verdana;
        font-weight: 100;
        color: #d5c3af;
        font-size: 12px;
        cursor: pointer;
    }
    .donate_button:hover{
        background: url('templates/tibiacom/images/themeboxes/button_over.png');
        color: #fff;
    }
</style>
<div class="donate">
    <div class="donate_header">Donate Here</div>
    <div class="donate_content">
        <div>
            <img src="templates/tibiacom/images/themeboxes/donate/donate.png">
        </div>
        <a href="<?php echo BASE_URL ?>?donate">
            <button type="button" class="donate_button">Donate Now</button>
        </a>
    </div>
    <div class="donate_bottom"></div>
</div>
