<style>
  #eventscheduletable {
    border-collapse: collapse;
    table-layout: fixed;
    border-spacing: 1px;
    padding: 1px;
    border: 1px;
    background: #d4c0a1;
    border-color: #5f4d41;
    -moz-box-shadow: 2px 2px 3px 3px #7c5231;
    -webkit-box-shadow: 2px 2px 3px 3px #7c5231;
    -ms-box-shadow: 2px 2px 3px 3px #7c5231;
    box-shadow: 2px 2px 3px 3px #7c5231;
  }

  #eventscheduletable td {
    border: 1px solid #faf0d7;
    height: 24px;
    overflow: hidden;
    font-weight: bold;
    color: #fff;
  }

  .eventscheduleheadertop {
    margin: auto;
    width: 100%;
    display: flex;
    min-width: 400px;
  }

  .eventscheduleheaderblockleft {
    margin-left: auto;
    margin-right: auto;
    text-align: center;
    position: relative;
  }

  .eventscheduleheaderdateblock {
    position: absolute;
    width: 150px;
    text-align: center;
  }

  .eventscheduleheaderleft {
    float: left;
  }

  .eventscheduleheaderright {
    float: right;
  }

  .eventscheduleheaderblockright {
    text-align: right;
    white-space: nowrap;
    margin-right: 5px;
  }

  td#default {
    color: #5f4d41;
    background-color: #e7d1af;
  }

  td#today {
    color: #5f4d41;
    background-color: #f3e5d0;
  }

  td#other_day {
    color: #5f4d41;
    background-color: #d4c0a1;
    border: none;
  }

  .day {
    font-weight: bold;
    margin-left: 3px;
    margin-bottom: 2px;
  }

  .activated {
    font-size: 12pt;
    font-weight: bold;
    word-break: break-word;
  }

  .event_name {
    color: #fff;
    width: 100%;
    font-weight: bold;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    padding: 1% 1% 1% 3px;
    margin-bottom: 2px;
  }
</style>
<?php
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Event Schedule';

function showWeeks(): string
{
  $out = "";
  $weeks = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  for ($i = 0; $i < 7; $i++) $out .= "<td>$weeks[$i]</td>";
  return $out;
}

function getAmountDays(string $month): int
{
  $amountDays = [
    '01' => 31, '02' => 28, '03' => 31, '04' => 30, '05' => 31, '06' => 30,
    '07' => 31, '08' => 31, '09' => 30, '10' => 31, '11' => 30, '12' => 31
  ];
  if (((date('Y') % 4) == 0 and (date('Y') % 100) != 0) or (date('Y') % 400) == 0) {
    $amountDays['02'] = 29;  // altera o numero de dias de fevereiro se o ano for bissexto
  }
  return $amountDays[$month];
}

function getMonthName($month): string
{
  $months = [
    '01' => "January", '02' => "February", '03' => "March",
    '04' => "April", '05' => "May", '06' => "June",
    '07' => "July", '08' => "August", '09' => "September",
    '10' => "October", '11' => "November", '12' => "December"
  ];
  return ($month >= 01 && $month <= 12) ? $months[$month] : "Unknown month";
}

function generateIndicator($event): string
{
  $out = "<span style='width: 120px;' class='HelperDivIndicator'";
  $div = "<div class='activated'>{$event['name']}:</div><div style='margin-bottom: 20px'>&amp;bull; {$event->description['description']}</div>";
  $out .= 'onmouseover="ActivateHelperDiv($(this), &quot;&quot;, &quot;' . $div . '&quot;, &quot;&quot;);"';
  $out .= 'onmouseout="$(&quot;#HelperDivContainer&quot;).hide();">';
  $out .= "<div class='event_name' style='background: {$event->colors['colordark']};'>{$event['name']}</div></span>";
  return $out;
}

function showCalendar($month = null): string
{
  $month = $month ?: date('m');
  $amountDays = getAmountDays(str_pad($month, 2, '0', STR_PAD_LEFT));
  $currentDay = 0;

  $dayOfWeek = jddayofweek(cal_to_jd(CAL_GREGORIAN, $month, "01", date('Y')), 0);

  $outDays = "<tr style='text-align:center; width:120px; background-color:#5f4d41;'>" . showWeeks() . "</tr>";

  for ($row = 0; $row < 5; $row++) {
    $outDays .= "<tr>";
    for ($column = 0; $column < 7; $column++) {
      $outDays .= "<td style='height:82px; background-clip: padding-box; overflow: hidden; vertical-align:top;' ";
      $color = "other_day";
      if (($currentDay == (date('d') - 1) && date('m') == $month)) {
        $color = "today";
      } else {
        if (($currentDay + 1) <= $amountDays) {
          $color = ($column < $dayOfWeek && $row == 0) ? "other_day" : "default";
        }
      }
      $outDays .= "id='$color'>";

      if ($currentDay + 1 <= $amountDays) {
        if ($column < $dayOfWeek && $row == 0) {
          $outDays .= " ";
        } else {
          $outDays .= "<div class='day'><span style='vertical-align: text-bottom;'>" . ++$currentDay . " <img style='border:0;' src='https://static.tibia.com/images/global/content/icon-seasonal.png'></span></div>";

          global $config;
          $events_xml = $config['data_path'] . 'XML/events.xml';
          $xml = simplexml_load_file($events_xml);

          $currentDay = str_pad($currentDay, 2, '0', STR_PAD_LEFT);

          $verif_date = "$month/$currentDay/" . date('Y');

          foreach ($xml->event as $event) {
            $start_date = strtotime($event['startdate']);
            $end_date = strtotime($event['enddate']);
            $current_date = strtotime($verif_date);

            if ($current_date >= $start_date && $current_date <= $end_date) {
              $outDays .= generateIndicator($event);
            }
          }
        }
      } else {
        break;
      }
      $outDays .= "</td>";
    }
    $outDays .= "</tr>";
  }

  return $outDays;
}

function showCalendarFull(): string
{
  $out = "";
  $count = 1;
  for ($j = 0; $j < 4; $j++) {
    $out .= "<tr>";
    for ($i = 0; $i < 3; $i++) {
      $cal = showCalendar(str_pad($count, 2, '0', STR_PAD_LEFT));
      $out .= "<td style='border: none'>{$cal}</td>";
      $count++;
    }
    $out .= "</tr>";
  }
  return $out;
}

?>

<div class="BoxContent" style="background-image:url(https://static.tibia.com/images/global/content/scroll.gif);">
  <div id="eventscheduletablecontainer">
    <div class="TableContainer">
      <div class="CaptionContainer">
        <div class="CaptionInnerContainer">
          <span class="CaptionEdgeLeftTop"
                style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
          <span class="CaptionEdgeRightTop"
                style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
          <span class="CaptionBorderTop"
                style="background-image:url(https://static.tibia.com/images/global/content/table-headline-border.gif);"></span>
          <span class="CaptionVerticalLeft"
                style="background-image:url(https://static.tibia.com/images/global/content/box-frame-vertical.gif);"></span>
          <div class="Text">
            <div class="eventscheduleheadertop">
              <div class="eventscheduleheaderblockleft">
                <div class="eventscheduleheaderdateblock">
                  <span class="eventscheduleheaderleft"></span><?= date('M Y') ?>
                  <span class="eventscheduleheaderright">
                    <?php /*<a href="<?= '?eventcalendar&mes=' . $month . '&dia=' . ($currentDay + 1) ?>" style="color:white;">»</a>*/ ?>
                  </span>
                </div>
              </div>
              <div class="eventscheduleheaderblockright"><?= date('Y-m-d H:i') ?></div>
            </div>
          </div>
          <span class="CaptionVerticalRight"
                style="background-image:url(https://static.tibia.com/images/global/content/box-frame-vertical.gif);"></span>
          <span class="CaptionBorderBottom"
                style="background-image:url(https://static.tibia.com/images/global/content/table-headline-border.gif);"></span>
          <span class="CaptionEdgeLeftBottom"
                style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
          <span class="CaptionEdgeRightBottom"
                style="background-image:url(https://static.tibia.com/images/global/content/box-frame-edge.gif);"></span>
        </div>
      </div>
      <table class="Table1" cellpadding="0" cellspacing="0" style="background-color: rgb(241, 224, 197);">
        <tbody>
        <tr>
          <td>
            <div class="InnerTableContainer" style="padding: 10px;">
              <table style="width:100%;" id="eventscheduletable">
                <tbody>
                <?= showCalendar() ?>
                </tbody>
              </table>
            </div>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
  <br>
  <div>* Event starts/ends at server save of this day.</div>
</div>
