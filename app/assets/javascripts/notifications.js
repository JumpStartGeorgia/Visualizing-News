$(document).ready(function(){
	if (gon.notifications){
		if (gon.enable_notifications) {
			// enable new idea form fields
			$('#new_idea_notifications input').removeAttr('disabled');
			$('#new_idea_notifications select').removeAttr('disabled');
			$('#new_idea_notifications').css('opacity', 1.0);
			$('#new_idea_notifications').css('filter', 'alpha(opacity=100)');
		}

		// if want all notifications turn on new idea fields
		// else, turn them off
		$("input[name='enable_notifications']").click(function(){
			if ($(this).val() === 'true') {
				$('#new_idea_notifications input').removeAttr('disabled');
				$('#new_idea_notifications select').removeAttr('disabled');
				$('#new_idea_notifications').fadeTo('fast', 1.0);
			} else {
				$('#new_idea_notifications input').attr('disabled', 'disabled');
				$('#new_idea_notifications select').attr('disabled', 'disabled');
				$('#new_idea_notifications').fadeTo('fast', 0.5);
			}
		});


		// register click events to clear out other form fields
		// for new ideas
		$('input#all').click(function(){
			$('input#none').removeAttr('checked');
			$('select#categories').val([]);
		});

		$('input#none').click(function(){
			$('input#all').removeAttr('checked');
			$('select#categories').val([]);
		});

		$('select#categories').click(function(){
			$('input#all').removeAttr('checked');
			$('input#none').removeAttr('checked');
		});

	}

});
