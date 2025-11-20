function performInstall(url) {
	var lastResponseLength = false;
	var lastId = 1;

	var ajaxRequest = $.ajax({
		type: 'get',
		url: url,
		data: {},
		dataType: 'html',
		processData: false,
		xhrFields: {
			// Getting on progress streaming response
			onprogress: function (e) {
				var progressResponse;
				var response = e.currentTarget.response;
				progressResponse = response;
				if (lastResponseLength === false) {
					progressResponse = response;
					lastResponseLength = response.length;
				}
				else {
					progressResponse = response.substring(lastResponseLength);
					lastResponseLength = response.length;
				}

				$('<div class="alert p-1 alert-success" id="success-' + (lastId + 1) + '">' + progressResponse + '</div>').insertAfter("#success-" + lastId);
				lastId = lastId + 1;
			}
		}
	});
	// On completed
	ajaxRequest.done(function(data) {
		$('#spinner').hide();
	});
	// On failed
	ajaxRequest.fail(function(error){
		console.log('Error: ', error);
		$('<span class="error">Error while doing AJAX request. Please refresh the page.</span>').insertAfter("#success-" + lastId);
	});
}