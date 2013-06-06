var Client = {};

(function () {
	Client.setPage = function (page) {
		window.location = page;
	};
	Client.post = function (page, params) {
		var form = $('<form action="' + page + '" method="post"></form>').appendTo('body');
		if (params !== undefined) {
			for (var i in params) {
				if (params.hasOwnProperty(i)) {
					form.append($('<input type="hidden" name="' + i + '" />').val(params[i]));
				}
			}
		}
		form.submit();
	};
	Client.showWindow = function (url) {
		window.open(url, 'child', 'toolbar=no,location=no,directories=no,menubar=no,width=850px,scrollbars=yes');
	};
}());

