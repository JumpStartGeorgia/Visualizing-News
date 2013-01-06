// enable form fields for the provided type
function enable_notifications(type){
	$('#new_' + type + '_notifications input').removeAttr('disabled');
	$('#new_' + type + '_notifications select').removeAttr('disabled');
	$('#new_' + type + '_notifications').css('opacity', 1.0);
	$('#new_' + type + '_notifications').css('filter', 'alpha(opacity=100)');  
}

function disable_all_fields(type){
	$('#new_' + type + '_notifications input').attr('disabled', 'disabled');
	$('#new_' + type + '_notifications select').attr('disabled', 'disabled');
	$('#new_' + type + '_notifications').fadeTo('fast', 0.5);
}

function enable_all_fields(type){
	$('#new_' + type + '_notifications input').removeAttr('disabled');
	$('#new_' + type + '_notifications select').removeAttr('disabled');
	$('#new_' + type + '_notifications').fadeTo('fast', 1.0);
}

function all_clicked(type){
	$('input#' + type + '_none').removeAttr('checked');
	$('select#' + type + '_categories').val([]);  
}

function none_clicked(type){
	$('input#' + type + '_all').removeAttr('checked');
	$('select#' + type + '_categories').val([]);
}

function categories_clicked(type){
	$('input#' + type + '_all').removeAttr('checked');
	$('input#' + type + '_none').removeAttr('checked');
}

$(document).ready(function(){
	if (gon.notifications){
		if (gon.enable_notifications) {
			// enable new visual and idea form fields
			enable_notifications('visual');
			enable_notifications('idea');
		}

		// if want all notifications turn on new idea fields
		// else, turn them off
		$("input[name='enable_notifications']").click(function(){
			if ($(this).val() === 'true') {
			  enable_all_fields('visual');
			  enable_all_fields('idea');
			} else {
			  disable_all_fields('visual');
			  disable_all_fields('idea');
			}
		});


		// register click events to clear out other form fields
		// for new visuals
		$('input#visuals_all').click(function(){
			all_clicked('visuals');
		});
		$('input#visuals_none').click(function(){
			none_clicked('visuals');
		});
		$('select#visuals_categories').click(function(){
			categories_clicked('visuals');
		});

		// for new ideas
		$('input#ideas_all').click(function(){
			all_clicked('ideas');
		});
		$('input#ideas_none').click(function(){
			none_clicked('ideas');
		});
		$('select#ideas_categories').click(function(){
			categories_clicked('ideas');
		});

	}

});
