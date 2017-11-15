$(document).ready(function() {

//	submit form with 'enter' press
$("input, textarea").keypress(function(event) {
    if (event.which == 13) {
        event.preventDefault();
        $("form").submit();
    }
});


$("#region-name").change(function() {
	
	var regionName = $("#region-name option:selected").text();
	
	$('#selected-region').remove()
	
	$('#output-column > .header').append('<h1 id="selected-region">' + regionName + '</h1>');

	var regionGuid = $('#region-name').val();
	
	$.ajax ({
    url: "/region-name?region-guid=" + regionGuid,
    method: "GET", 
    dataType: "json"
	})
	.done(function(data){

//		console.log(JSON.stringify(data,null,'\t'));
		
		console.log(data);

	})
	.fail(function(xhr, status, error) {

		console.log(error);
		
	});
});

 
});
 