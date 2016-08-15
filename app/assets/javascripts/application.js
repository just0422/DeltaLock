// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery_ujs
//= require jquery
//= require bootstrap
//= require_tree .
//
$(document).ready(function(){
    $("li[data-link]").click(function() {
          window.location = $(this).data("link");
    });
    $("tr[data-link]").click(function() {
          window.location = $(this).data("link");
    });
});

function toggle_edit_save(button){
	var id = $(button).attr('id').split('-')[0];

	if ($(button).html() == 'Edit'){
		$(button).css('display', 'none');
		$("#" + id + "-submit").css('display', 'block');
	}
	else{
		$(button).css('display', 'none');
		$("#" + id + "-edit").css('display', 'block');
	}
}
