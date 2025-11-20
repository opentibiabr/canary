// build the helper div to display on mouse over
function BuildHelperDiv(a_DivID, a_IndicatorDivContent, a_Title, a_Text) {
    var l_Qutput = '';
    l_Qutput += '<span class="HelperDivIndicator" onMouseOver="ActivateHelperDiv($(this), \'' + a_Title + '\', \'' + escapeHtml(a_Text) + '\');" onMouseOut="$(\'#HelperDivContainer\').hide();" >' + a_IndicatorDivContent + '</span>';
    return l_Qutput;
}

// build the helper div to display on mouse over
function BuildHelperDivLink(a_DivID, a_IndicatorDivContent, a_Title, a_Text, a_SubTopic) {
    var l_Qutput = '';
    l_Qutput += '<a href="../common/help.php?subtopic=' + a_SubTopic + '" target="_blank" ><span class="HelperDivIndicator" onMouseOver="ActivateHelperDiv($(this), \'' + a_Title + '\', \'' + a_Text + '\', \'' + a_DivID + '\');" onMouseOut="$(\'#HelperDivContainer\').hide();" >' + a_IndicatorDivContent + '</span></a>';
    return l_Qutput;
}

// displays a helper div at the current mause position
function ActivateHelperDiv(a_Object, a_Title, a_Text, a_HelperDivPositionID) {
    // initialize variables
    var l_Left = 0;
    var l_Top = 0;
    var l_WindowHeight = $(window).height();
    var l_PageHeight = $(document).height();
    var l_ScrollTop = $(document).scrollTop();
    // set the new content of the tool tip
    $('#HelperDivHeadline').html(a_Title);
    $('#HelperDivText').html(a_Text);
    // check additional parameter and set the position
    if (a_HelperDivPositionID.length > 0) {
        l_Left = $('#' + a_HelperDivPositionID).offset().left;
        l_Top = $('#' + a_HelperDivPositionID).offset().top;
    } else {
        l_Left = (a_Object.offset().left + a_Object.parent().width());
        l_Top = a_Object.offset().top;
    }
    // get new tool tip height
    var l_ToolTipHeight = $('#HelperDivContainer').outerHeight(true);
    // check if the tool tip fits in the browser window
    if ((l_Top - l_ScrollTop + l_ToolTipHeight) > l_WindowHeight) {
        var l_TopBefore = l_Top;
        l_Top = (l_ScrollTop + l_WindowHeight - l_ToolTipHeight);
        if (l_Top < l_ScrollTop) {
            l_Top = l_ScrollTop;
        }
        $('.HelperDivArrow').css('top', (l_TopBefore - l_Top));
    } else {
        // console.log('# FIT#');
        $('.HelperDivArrow').css('top', -1);
    }
    // set position and display the tool tip
    $('#HelperDivContainer').css('top', l_Top);
    $('#HelperDivContainer').css('left', l_Left);
    $('#HelperDivContainer').show();
}

// toggle masked texts with readable texts
function ToggleMaskedText(a_TextFieldID) {
    m_DisplayedText = document.getElementById('Display' + a_TextFieldID).innerHTML;
    m_MaskedText = document.getElementById('Masked' + a_TextFieldID).innerHTML;
    m_ReadableText = document.getElementById('Readable' + a_TextFieldID).innerHTML;
    if (m_DisplayedText === m_MaskedText) {
        document.getElementById('Display' + a_TextFieldID).innerHTML = document.getElementById('Readable' + a_TextFieldID).innerHTML;
        document.getElementById('Button' + a_TextFieldID).src = JS_DIR_IMAGES + 'global/general/hide.gif';
    } else {
        document.getElementById('Display' + a_TextFieldID).innerHTML = document.getElementById('Masked' + a_TextFieldID).innerHTML;
        document.getElementById('Button' + a_TextFieldID).src = JS_DIR_IMAGES + 'global/general/show.gif';
    }
}