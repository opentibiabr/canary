<style>
    .serversave {
        width: 180px;
        height: 135px;
    }

    .serversave_header {
        height: 45px;
        width: 180px;
        background-image: url('templates/tibiacom/images/themeboxes/box_top.png');
        font-family: Verdana;
        font-weight: bold;
        color: #d5c3af;
        line-height: 65px;
    }

    .serversave_bottom {
        height: 30px;
        width: 180px;
        margin-top: -20px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bottom.png');
    }

    .serversave_content {
        padding: 0px 10px;
        width: 160px;
        height: 70px;
        background-image: url('templates/tibiacom/images/themeboxes/box_bg.png');
        text-align: center;
        display: grid;
        justify-content: center;
        align-items: center;
    }

    .serversave_text {
        font-family: Verdana;
        color: #d5c3af;
        font-size: 12px !important;
    }

    .serversave_countdown {
        font-family: Verdana;
        font-size: 22px !important;
        font-weight: bold;
        color: #d5c3af;
        border: 1px solid #d5c3af;
        border-radius: 3px;
        padding: 5px 0px;
    }
</style>
<?php
$explodeServerSave = explode(':', configLua('globalServerSaveTime') ?? '05:00:00');
$hours_ServerSave = $explodeServerSave[0];
$minutes_ServerSave = $explodeServerSave[1];
$seconds_ServerSave = $explodeServerSave[2];

$now = new DateTime();
$serverSaveTime = new DateTime();
$serverSaveTime->setTime($hours_ServerSave, $minutes_ServerSave, $seconds_ServerSave);

if ($now > $serverSaveTime) {
    $serverSaveTime->modify('+1 day');
}

$interval = $now->diff($serverSaveTime);
?>
<script>
    var serverSaveTime = new Date(<?= $serverSaveTime->format('Y, n-1, j, G, i, s') ?>);

    var x = setInterval(function () {
        var now = new Date().getTime();
        var distance = serverSaveTime - now;

        var hours = Math.floor(distance / (1000 * 60 * 60));
        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Adiciona zeros à esquerda, se necessário
        hours = hours < 10 ? "0" + hours : hours;
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        document.getElementById("timerServerSave").innerHTML = hours + ":" + minutes + ":" + seconds;

        if (distance < 0) {
            clearInterval(x);
            document.getElementById("timerServerSave").innerHTML = "Server save now!";
        }
    }, 1000);
</script>
<div class="serversave">
    <div class="serversave_header">Server Save</div>
    <div class="serversave_content">
        <div class="serversave_text">
            <small>Countdown to server save</small>
        </div>
        <div class="serversave_countdown" id="timerServerSave"></div>
    </div>
    <div class="serversave_bottom"></div>
</div>
