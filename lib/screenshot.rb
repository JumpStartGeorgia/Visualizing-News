module Screenshot
  require "headless"
  require "selenium-webdriver"

  def self.take(url)
    filename = nil
    if url && (url =~ URI::regexp(['http','https'])) == 0
      headless = Headless.new
      headless.start
      driver = Selenium::WebDriver.for :chrome
      driver.navigate.to url
      sleep 30
      filename = "#{Rails.root}/tmp/screenshot_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}.png"
      driver.save_screenshot(filename)
      driver.quit
      headless.destroy
    end

    return filename
  end


end
