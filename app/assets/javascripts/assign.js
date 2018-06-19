var assign_key;

$(document).on("turbolinks:load", () => {
	$(".assign-title").click(function(){
		$(this).toggle()
        var id = $(this).attr('id').split('-')[0];
		$("#" + id + "-assign-new-or-search").toggle();
	})
});

function check_assign_ready(){
    var count = 0;
    var assign_params = ["purchaseorders", "purchasers", "endusers", "keys"];
    
    for (var i = 0; i < assign_params.length; i++){
        if ($("input[name=" + assign_params[i] + "]").val() != "")
            count++;
    }

    if (count > 1){
        $("#assign-button").show();
    }
}

function change_assign_entry(type){
    $("input[name=" + type + "]").val("")
    $("#" + type + "-assign-selected").hide();
    $("#" + type + "-assign-new-or-search").show();

    if (type === "endusers"){
        var elementValue = $.trim($(this).find(type + "-id").html());
        $.ajax({
            method: "POST",
            url: "/assign/enduser",
            data: {
                enduser: elementValue
            }
        })
    }
    
    check_assign_ready();
}

function initCircle(color, radius, position, map){
    return new google.maps.Circle({
        strokeColor: color,
        strokeWeight: 5,
        fillColor: color,
        fillOpacity: '0.1',
        radius: radius, // radius * MILE
        center: position,
        map: map,
        clickable: false
    });
}

function addMapMarker(lat, lng, name, icon, map){
    return new google.maps.Marker({
        position: {
            lat: lat, 
            lng: lng
        },
        map: map,
        icon: icon,
        title: name,
        animation: google.maps.Animation.DROP
    })
}

