atom_feed do |feed|

	feed.title t '.title_feed', :app_name => (t'app.common.app_name')

  feed.updated @visualizations.maximum(:published_date)

	@visualizations.each do |visual|
		feed.entry visual, :published => visual.published_date, url: visualization_path(visual.permalink) do |entry|
			entry.title visual.title

			entry.content(simple_format(visual.explanation), :type => 'html')

			entry.author do |author|
				author.name visual.reporter
			end
		end
	end

end
