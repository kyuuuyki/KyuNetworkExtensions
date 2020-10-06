#
# Be sure to run `pod lib lint KyuNetworkExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KyuNetworkExtensions'
  s.version          = '0.1.2'
  s.swift_version    = '5'
  s.summary          = 'The Swift Network Extensions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kyuuuyki/KyuNetworkExtensions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chayanon Ardkham' => 'develop@chayanon.dev' }
  s.source           = { :git => 'https://github.com/kyuuuyki/KyuNetworkExtensions.git', :tag => s.version.to_s }
  #  s.social_media_url = 'https://twitter.chayanon.dev'

  s.ios.deployment_target = '13.0'

  s.source_files = 'KyuNetworkExtensions/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KyuNetworkExtensions' => ['KyuNetworkExtensions/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'Moya'
  s.dependency 'ObjectMapper'
  
end
