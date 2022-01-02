#
# Be sure to run `pod lib lint FFNATSClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FFNATSClient'
  s.version          = '1.0.0'
  s.summary          = 'NATS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                              利用webScocket封装成NATS消息中间件
                         DESC

  s.homepage         = 'https://github.com/RobenLo/FFNATSClient'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Roben' => '15056568157@163.com' }
  s.source           = { :git => 'https://github.com/RobenLo/FFNATSClient.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FFNATSClient/Classes/*'
  
  # s.resource_bundles = {
  #   'FFNATSClient' => ['FFNATSClient/Assets/*.png']
  # }

   s.public_header_files = 'Pod/Classes/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SocketRocket'
end
