// enable form fields for the provided type
function enable_notifications(type){
	$('#' + type + '_notifications input').removeAttr('disabled');
	$('#' + type + '_notifications select').removeAttr('disabled');
	$('#' + type + '_notifications').css('opacity', 1.0);
	$('#' + type + '_notifications').css('filter', 'alpha(opacity=100)');
}

function disable_all_fields(type){
	$('#' + type + '_notifications input').attr('disabled', 'disabled');
	$('#' + type + '_notifications select').attr('disabled', 'disabled');
	$('#' + type + '_notifications').fadeTo('fast', 0.5);
}

function enable_all_fields(type){
	$('#' + type + '_notifications input').removeAttr('disabled');
	$('#' + type + '_notifications select').removeAttr('disabled');
	$('#' + type + '_notifications').fadeTo('fast', 1.0);
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
			enable_notifications('language');
			enable_notifications('new_visual');
			enable_notifications('visual_comment');
			enable_notifications('new_idea');
		}

		// if want all notifications turn on fields
		// else, turn them off
		$("input[name='enable_notifications']").click(function(){
			if ($(this).val() === 'true') {
			  enable_all_fields('language');
			  enable_all_fields('new_visual');
			  enable_all_fields('visual_comment');
			  enable_all_fields('new_idea');
			} else {
			  disable_all_fields('language');
			  disable_all_fields('new_visual');
			  disable_all_fields('visual_comment');
			  disable_all_fields('new_idea');
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
