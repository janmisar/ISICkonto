# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!
  use_frameworks!

def shared_pods
  # UI
  pod 'SnapKit', '~> 5.0'
  # Reactive
  pod 'ReactiveSwift', '~> 6.0'
  pod 'ACKReactiveExtensions', '~> 5.0'
  # Bunch of tools
  pod 'ACKategories', '~> 6.1'
  # Networking
  pod 'Alamofire', '~> 4.8'
  pod 'SwiftSoup', '~> 2.2'
  # Keychain
  pod 'SwiftKeychainWrapper', '~> 3.4'
end


target 'ISICbalance' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

  # Pods for ISICbalance
  shared_pods
  # Localization
  pod 'ACKLocalization', '~> 0.3'
  pod 'SwiftGen', '~> 6.1'
  # Style and conventions checker
  pod 'SwiftLint', '~> 0.33'
  # Balance requests progress
  pod 'SVProgressHUD', '~> 2.2'
  
  target 'ISICbalanceTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ISICbalanceUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'ISICbalanceExtension' do
  shared_pods
end

