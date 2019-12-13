#
# Be sure to run `pod lib lint JBDatePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#/Users/joost/Desktop/JBDatePicker

Pod::Spec.new do |s|
  s.name             = 'JBDatePicker'
  s.version          = '1.2.4'
  s.summary          = 'A calendar field in which the user can select a date.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JBDatePicker is a view which shows a month with all of its days. The user can select a date, which is returned as a Date object. It is possible to swipe between months, or manually select them. It is possible to load the datepicker with a specific date selected.
                       DESC

  s.homepage         = 'https://github.com/Tuslareb/JBDatePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tuslareb' => 'tuslareb@yahoo.com' }
  s.source           = { :git => 'https://github.com/Tuslareb/JBDatePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/strafpleiter'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JBDatePicker/Classes/**/*.{swift}'

  # s.resource_bundles = {
  #   'JBDatePicker' => ['JBDatePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
