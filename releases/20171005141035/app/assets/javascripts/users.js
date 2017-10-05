function edit_row(user){
	$("#row-" + user + " td :input").attr('disabled', false);

	$("#edit-" + user).fadeOut(FADE_TIME,function(){
		$("#save-" + user).fadeIn(FADE_TIME);
	});
}

function save_row(user){
	var updateParams = $("#edit_user_" + user).serialize();
	$("#edit_user_" + user).submit(function(){
		$.ajax({
			url: $("#edit_user_" + user).attr('action'),
			method: "post",
			data: updateParams
		}).success(function(a,b){
			$("#row-" + user + " td :input").attr('disabled', true);

			$("#save-" + user).fadeOut(FADE_TIME,function(){
				$("#edit-" + user).fadeIn(FADE_TIME);
			});
		});
	});
}

function delete_row(user){
	if (confirm("Are you sure?")){
		$.ajax({
			url: $("#edit_user_" + user).attr('action'),
			method: "post",
			data: {_method:'delete'}
		}).success(function(a,b){
			$("#row-" + user).remove();
		});
	}

}
