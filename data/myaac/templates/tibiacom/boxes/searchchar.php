<style>
    .searchchar{
        width: 180px;
        height: 145px;
    }
    .searchchar_header{
        height: 45px;
        width: 180px;
        background-image: url('templates/tibiacom/images/themeboxes/box_top.png');
        font-family: Verdana;
        font-weight: bold;
        color: #d5c3af;
        line-height: 65px;
    }
    .searchchar_bottom{
        height: 30px;
        width: 180px;
        margin-top: -20px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bottom.png');
    }
    .searchchar_content{
        padding: 0px 10px;
        width: 160px;
        height: 80px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bg.png');
    }
    .searchchar_text{
        margin-left: 45px;
        font-family: Verdana;
        color: #d5c3af;
        text-align: left;
    }
    .searchchar_button{
        height: 30px;
        width: 148px;
        border: 0;
        background: url('templates/tibiacom/images/themeboxes/button.png');
        font-family: Verdana;
        font-weight: 100;
        color: #d5c3af;
        font-size: 12px;
        cursor: pointer;
        margin-top: 5px;
    }
    .searchchar_button:hover{
        background: url('templates/tibiacom/images/themeboxes/button_over.png');
        color: #fff;
    }
    .searchchar_input{
        display: block;
        width: 100%;
        padding: 0.375rem 0.75rem;
        border-radius: 0.25rem;
        font-size: 0.8rem;
        font-weight: 400;
        line-height: 1.5;
        text-align: center;
        border: 0;
    }
</style>
<form method="post" action="<?php echo BASE_URL ?>?characters" style="margin-bottom: 0;">
<div class="searchchar">
    <div class="searchchar_header">Search Char</div>
    <div class="searchchar_content">
        <input type="text" class="searchchar_input" name="name" maxlength="29" placeholder="Character name">
        <button type="submit" class="searchchar_button">Search</button>       
    </div>
    <div class="searchchar_bottom"></div>
</div>
</form>
