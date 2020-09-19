# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

#plugin 'cocoapods-binary'

#all_binary!
use_frameworks!

target 'EmployeeManager' do
  # Comment the next line if you don't want to use dynamic frameworks
  #use_frameworks!

  # Pods for EmployeeManager
  pod 'MarqueeLabel'

  target 'EmployeesTests' do
    # Pods for EmployeeTests
    inherit! :search_paths
    
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
