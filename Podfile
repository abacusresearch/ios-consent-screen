platform :ios, '11.0'

install! 'cocoapods', :deterministic_uuids => false
use_frameworks!

pre_install do |installer|
  def installer.verify_no_static_framework_transitive_dependencies; end
end

target 'ios-consent-screen' do
  pod 'PureLayout'
  #pod 'APNumberPad',      :git => "https://github.com/fuggly/APNumberPad", :inhibit_warnings => true
  pod 'DLRadioButton', :git => "https://github.com/fuggly/DLRadioButton", :inhibit_warnings => true
end



def update_target(target)
  target.build_configurations.each do |config|
    if target.name.end_with? "PureLayout"
      target.build_configurations.each do |build_configuration|
        if build_configuration.build_settings['APPLICATION_EXTENSION_API_ONLY'] == 'YES'
          build_configuration.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'PURELAYOUT_APP_EXTENSIONS=1']
        end
      end
    end
    
    config.build_settings['SWIFT_VERSION'] = '4.2'
    config.build_settings['GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS'] = 'NO'
    config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
    config.build_settings['FRAMEWORK_SEARCH_PATHS'] = '$(inherited) $(PODS_ROOT)/../Import'
    config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
#    config.build_settings['GCC_TREAT_WARNINGS_AS_ERRORS'] = 'YES'
    config.build_settings['ARCHS'] = '$(ARCHS_STANDARD_64_BIT)'
    config.build_settings['VALID_ARCHS'] = '$(ARCHS_STANDARD_64_BIT)'
    if !target.name.start_with?("AC") and !target.name.start_with?("Abacus")
      config.build_settings['OTHER_CFLAGS'] = "$(inherited) -Qunused-arguments -Xanalyzer -analyzer-disable-all-checks"
    else
      config.build_settings['WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'YES'
    end
  end
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    update_target(target)
  end
end
