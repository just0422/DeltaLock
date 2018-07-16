// When page loads, initialize search forms
$(document).on("turbolinks:load", function() {
    // Assign function to any buttons that will be created
    $('form').on('click', '.add_fields', add_fields_click);
	$('form').on('click', '.remove_fields', remove_fields_click);
    
    // Add the first search field to the page
    $('.add_fields').click()
    
    // Setup click behavior for any given result row
	$(".search-row").click(function() {
		window.location = $(this).data("href");
	});
        
    // Initialize tabs on search page
    var searchTabs = document.querySelector('.tabs');
    M.Tabs.init(searchTabs, {});
    
    // Initialize select elements in form
    var selectElements = document.querySelectorAll('select');
    for (var i = 0; i < selectElements.length; i++){
        M.FormSelect.init(selectElements[i]);
    }
});

