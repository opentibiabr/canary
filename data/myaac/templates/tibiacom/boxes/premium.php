<?php
/*$twig->display('premium.html.twig');*/
$activeBox = rand(1,7);
?>
<?php if($activeBox == 1){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coin_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coins_trade.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Trade Tibia Coins!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_tibia_coins.png);"></div>
</div>
<?php } ?>
<?php if($activeBox == 2){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coin_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coins_decoration.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Buy Epic Decoration!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_tibia_coins.png);"></div>
</div>
<?php } ?>
<?php if($activeBox == 3){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coin_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coins_premium.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Become <?= isVipSystemEnabled() ? 'VIP' : 'Premium' ?>!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_tibia_coins.png);"></div>
</div>
<?php } ?>
<?php if($activeBox == 4){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coin_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coins_exp.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Use XP Boosts!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_tibia_coins.png);"></div>
</div>
<?php } ?>
<?php if($activeBox == 5){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coin_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/coins_consumables.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Get Supplies Anywhere!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_tibia_coins.png);"></div>
</div>
<?php } ?>
<?php if($activeBox == 6){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/crown_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/premium_offline_training.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Train Skills Offline!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_premiumtime.png);"></div>
</div>
<?php } ?>
<?php if($activeBox == 7){ ?>
<div class="Themebox" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/themebox.png); height: 204px;">
  <div id="PremiumBoxDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/crown_animation.gif);"></div>
  <div id="PremiumBoxBg" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/premium_all_areas.png);"></div>
  <div id="PremiumBoxOverlay" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/type_overlay.png);">
    <p id="PremiumBoxOverlayText">Access ALL Areas!</p>
  </div>
  <div id="PremiumBoxButton">
    <form action="?donate" method="post" style="padding:0px;margin:0px;">
      <div class="BigButton" style="background-image:url(<?php echo $template_path ?>/images/global/buttons/button.png); width: 142px; height: 34px;"><div onmouseover="MouseOverBigButton(this);" onmouseout="MouseOutBigButton(this);"><div class="BigButtonOver" style="background-image: url(<?php echo $template_path ?>/images/global/buttons/button_hover.png); visibility: hidden;"></div><input class="BigButtonText" style="width: 142px; height: 34px;" type="submit" value="Get Tibia Coins"></div></div>
    </form>
  </div>
  <div id="PremiumBoxButtonDecor" style="background-image:url(<?php echo $template_path ?>/images/themeboxes/premium/button_premiumtime.png);"></div>
</div>
<?php } ?>
