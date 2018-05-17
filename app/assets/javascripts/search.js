//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
//
$(document).on("turbolinks:load", function() {
    // Function located in application.js
	$('form').on('click', '.remove_fields', remove_fields_click);
    $('form').on('click', '.add_fields', add_fields_click);

    $('.add_fields').click()


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

