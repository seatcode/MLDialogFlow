#
# Be sure to run `pod lib lint MLDialogFlow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MLDialogFlow'
  s.version          = '0.1.0'
  s.summary          = 'DialogFlow iOS sdk improved and extended with voice'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Wraps DialogFlow iOS sdk with helper managers, adds native voice recognition and speech.
The original library doesn't provide swift support nor native voice recognition.
This library is used in the Aboutit application.
                       DESC

  s.homepage         = 'https://github.com/metrolab/MLDialogFlow'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eli Kohen' => 'eli.kohen@metropolis-lab.io' }
  s.source           = { :git => 'https://github.com/metrolab/MLDialogFlow.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MLDialogFlow/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MLDialogFlow' => ['MLDialogFlow/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
