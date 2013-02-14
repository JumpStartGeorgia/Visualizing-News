class Ideas::ReportController < ApplicationController
	layout "fancybox"

	def inappropriate
		@report = IdeaInappropriateReport.new()
		if request.post?
			# save the report
	    @report = IdeaInappropriateReport.new(params[:idea_inappropriate_report])

			respond_to do |format|
			  if @report.save
					flash[:notice] = I18n.t('ideas.report.form.success')
					format.js {render :js => "window.location.replace('#{idea_path(@report.idea_id)}');"}
				else
					# calls inappropriate.js which reloads the form partial and shows errors messages
					format.js {}
			  end
			end
		end
	end

end
