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
//= require turbolinks
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require underscore
//= require gmaps/google
//= require materialize
//= require_tree .
//

const FADE_TIME = 200;

$(document).on("turbolinks:load", function(){
    var selectElement = document.querySelector('select');
    M.FormSelect.init(selectElement);

/*    $("li[data-link]").click(function() {
          window.location = $(this).data("link");
    });
    $("tr[data-link]").click(function() {
          window.location = $(this).data("link");
    });

	enable_all_highlights(".all-tables", "tbody tr");
	enable_all_highlights(".all-maps", "ul li");
	*/

});

function toggle_edit_save(button){
	var id = '#' + $(button).attr('id').split('-')[0];
	var cl = '.' + $(button).attr('id').split('-')[0];
	labels = $(cl + '-label');
	inputs = $(cl + '-input');

	if ($(button).html() == 'Edit'){
		$(button).css('display', 'none');
		$(id + "-submit").css('display', 'block');

		for (var i = 0; i < labels.length; i++){
			$(labels[i]).css('display', 'none');
			$(inputs[i]).css('display', 'block');
			
			$(inputs[i]).find('input').val($(labels[i]).find('span').html());
		}
	}
	else{
		$(button).css('display', 'none');
		$(id + "-edit").css('display', 'block');
		
		for (var i = 0; i < labels.length; i++){
			$(labels[i]).css('display', 'block');
			$(inputs[i]).css('display', 'none');
			
			$(labels[i]).find('span').html($(inputs[i]).find('input').val());
		}
	}
}


function enable_all_highlights(type, element){
	$(type).on("mouseleave",element,function(){
		if (!$(this).hasClass("bg-primary"))
			$(this).removeClass("bg-info");
	});
	$(type).on("mouseenter",element,function(){
		if (!$(this).hasClass("bg-primary"))
			$(this).addClass("bg-info");
	});
	$(type).on("click",element,function(){
		var selected = $(this).hasClass("bg-primary");
		$("tr,li").removeClass("bg-info");
		$("tr,li").removeClass("bg-primary");
		if (selected)
			$(this).removeClass("bg-primary");
		else
			$(this).addClass("bg-primary");
	});
}
