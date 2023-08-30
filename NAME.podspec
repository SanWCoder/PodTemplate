#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '1.0.0'
  s.summary          = 'A short description of ${POD_NAME}.'
  s.swift_version    = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/${USER_NAME}/${POD_NAME}'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source           = { :git => 'https://github.com/${USER_NAME}/${POD_NAME}.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  # 是否支持ARC
  # s.requires_arc = true
  # 是否是静态库
  # s.static_framework = true
  
  s.source_files = '${POD_NAME}/Classes/**/*'
  
  # 子模块
  # s.subspec 'subspec' do |ss|
  #   ss.source_files = '${POD_NAME}/Classes/subspec/*'
  # end
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  # s.frameworks = 'UIKit', 'MapKit'
  # 自己制作的framework
  # s.vendored_frameworks = 'HCYUIKit'
  # 引用的静态库,多个用逗号隔开,需要省略 lib 及 .tbd
  # s.libraries = 'c++'
  # 自己制作的.a
  # s.vendored_libraries = 'HCYCore'
  
  # s.dependency 'AFNetworking', '~> 2.3'
  
end
