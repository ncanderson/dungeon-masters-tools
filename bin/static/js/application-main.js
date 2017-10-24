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
    
    });
	
//	Make ajax call to update output column
//    $("#region-name").change(function() {
//        
//    	var regionName = $(this).text();
//    	
//        $.ajax ({
//            url: "/region-name?region-name=" + regionName,
//            method: "GET", 
//            dateType: "text"
//       /*     dataType: "json"*/
//        })
//        .done(function(data){
//
//        	$('#output-column').append('<h1>' + regionName + '</h1>');
//        	console.log(regionName);
//
//        })
//        .fail(function(xhr, status, error) {
//
//            console.log(error);
//        });
//    });
    
});
 