#
#  Be sure to run `pod spec lint AbaOauth.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ios-consent-screen"
  s.version      = "0.0.1"
  s.summary      = "A short description of ios-consent-screen."

  s.description  = <<-DESC
                 Abacus ios-consent-screen Library
                 DESC

  s.homepage     = "http://EXAMPLE/ios-consent-screen"

  s.license      = "Abacus Proprietary (All Rights reserved)"
  s.author       = { "Roger Misteli" => "roger.misteli@abacus.ch" }
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/fuggly/ios-consent-screen.git", :tag => "#{s.version}" }

  s.subspec 'Core' do |core|
     core.source_files = "ios-consent-screen/*.{swift}"
     core.dependency "PureLayout"
     core.dependency "DLRadioButton"
  end

end