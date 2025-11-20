function MouseOverBigButton(source) {
  if (typeof source == 'string') {
    const element = document.getElementById(source);
    if (element) {
      element.style.visibility = 'visible';
    }
  } else {
    source.firstChild.style.visibility = 'visible';
  }
}

function MouseOutBigButton(source) {
  if (typeof source == 'string') {
    const element = document.getElementById(source);
    if (element) {
      element.style.visibility = 'hidden';
    }
  } else {
    source.firstChild.style.visibility = 'hidden';
  }
}

function MouseOverLoginBoxText() {
  document.getElementById('LoginstatusText_2_1').style.visibility = 'hidden';
  document.getElementById('LoginstatusText_2_2').style.visibility = 'visible';
}

function MouseOutLoginBoxText() {
  document.getElementById('LoginstatusText_2_1').style.visibility = 'visible';
  document.getElementById('LoginstatusText_2_2').style.visibility = 'hidden';
}
