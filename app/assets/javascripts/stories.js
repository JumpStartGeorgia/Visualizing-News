$(document).ready(function(){

	if (gon.edit_story){
		// load the date time pickers
		$('#story_published_date').datepicker({
				dateFormat: 'dd.mm.yy',
		});
		if (gon.published_date !== undefined && gon.published_date.length > 0)
		{
			$("#story_published_date").datepicker("setDate", new Date(gon.published_date));
		}

	}

});
