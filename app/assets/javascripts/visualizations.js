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

		// if record is published, show pub date field by default
		if ($('input:radio[name=visualization[published]]:checked').val() === 'true') {
			$('#visualization_published_date_input').show();
		} else {
			$('#visualization_published_date_input').hide();
		}

		// if record is marked as published, show pub date field
		$("input:radio[name=visualization[published]]").click(function(){
			if ($(this).val() === 'true'){
				// show url textbox
			  $('#visualization_published_date_input').show(300);
			} else {
				// clear and hide pub date textbox
				$('#visualization_published_date').attr('value', '');
			  $('#visualization_published_date_input').hide(300);
			}
		});

	}

});
