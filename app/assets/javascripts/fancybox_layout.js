//= require i18n
//= require i18n/translations
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require fancybox
//= require fancybox2
//= require vendor
//= require visualizations

	// set focus to first text box on page
	if (gon.highlight_first_form_field){
	  $("#fancybox-content :input:visible:enabled:first").focus();
	}

