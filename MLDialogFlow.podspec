Pod::Spec.new do |s|
  s.name             = 'MLDialogFlow'
  s.version          = '0.1.0'
  s.summary          = 'DialogFlow iOS sdk improved and extended with voice'
  s.description      = <<-DESC
Wraps DialogFlow iOS sdk with helper managers, adds native voice recognition and speech.
The original library doesn't provide swift support nor native voice recognition.
This library is used in the Aboutit application.
                       DESC

  s.homepage         = 'https://github.com/metrolab/MLDialogFlow'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eli Kohen' => 'eli.kohen@metropolis-lab.io' }
  s.source           = { :git => 'https://github.com/metrolab/MLDialogFlow.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/metrolabbcn'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MLDialogFlow/src/**/*'
  s.frameworks = 'Speech'
  s.dependency 'ApiAI'
  s.dependency 'RxSwift' , '~> 4.1'

end
