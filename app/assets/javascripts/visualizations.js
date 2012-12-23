$(document).ready(function(){

	if (gon.edit_visualization){
		// load the date time pickers
		$('#visualization_published_date').datepicker({
				dateFormat: 'dd.mm.yy',
		});
		if (gon.published_date !== undefined && gon.published_date.length > 0)
		{
			$("#visualization_published_date").datepicker("setDate", new Date(gon.published_date));
		}

	}

});
