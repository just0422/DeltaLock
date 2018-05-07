//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
//
$(document).on("turbolinks:load", function() {
	$('form').on('click', '.remove_fields', function(event) {
		$(this).closest('.field').remove();
        //var modalElement = document.querySelector('.modal');
        //M.Modal.init(modalElement, {opacity: 0.9});
		return event.preventDefault();
	});
	$('form').on('click', '.add_fields', function(event) {
		var regexp, time;
		time = new Date().getTime();
		regexp = new RegExp($(this).data('id'), 'g');
		$(this).before($(this).data('fields').replace(regexp, time));

        //var modalElement = document.querySelector('.modal');
        //M.Modal.init(modalElement, {opacity: 0.9});
        var selectElements = document.querySelectorAll('select');
        for (var i = 0; i < selectElements.length; i++){
            M.FormSelect.init(selectElements[i]);
        }

		return event.preventDefault();
	});

	$(".search-row").click(function() {
		window.location = $(this).data("href");
	});

    var searchTabs = document.querySelector('.tabs');
    M.Tabs.init(searchTabs, {});

    var selectElements = document.querySelectorAll('select');
    for (var i = 0; i < selectElements.length; i++){
        M.FormSelect.init(selectElements[i]);
    }
});

