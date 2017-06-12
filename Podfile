inhibit_all_warnings!

def pods
  pod "ObjectiveGumbo", "~> 0.1"
  pod "AFNetworking", "~> 2.0"
  pod 'AFNetworkActivityLogger', '~> 2.0'
  pod 'ACKategories', :git => 'https://github.com/AckeeCZ/ACKategories.git', :commit => 'cc8e9b6'
  pod 'SVProgressHUD', '~> 1.0'

end

target 'ISICbalance' do

  pods

  target 'ISICbalanceTests' do
    inherit! :search_paths

  end

end
