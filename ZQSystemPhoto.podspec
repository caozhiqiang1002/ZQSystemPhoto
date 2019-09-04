#
#  Be sure to run `pod spec lint ZQTransition.podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # 组件名称
  s.name         = "ZQSystemPhoto"
 
  # 组件版本号
  s.version      = "1.0.2"
 
  # 组件简介
  s.summary      = "访问系统相册的组件"

  # 组件详细描述
  s.description  = <<-DESC
  通过该组件，可以访问系统相册，该组件仿照微信开发，支持照片的多选，单选。
                   DESC

  # 首页
  s.homepage     = "https://github.com/caozhiqiang1002"

  # 证书
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # 作者
  s.author             = { "caozhiqiang1002" => "1053524532@qq.com" }

  # 组件资源链接
  s.source       = { :git => "https://github.com/caozhiqiang1002/ZQSystemPhoto.git", :tag => "#{s.version}" }

  # 公共头文件
  s.public_header_files = 'Core/*.{h}'

  # 私有头文件
  s.private_header_files = 'Private/**/*.{h}'

  # 代码文件
  s.source_files = 'Core/*.{h,m}', 'Private/Controller/*.{h,m}', 'Private/Manager/*.{h,m}', 'Private/Other/*.{h,m}', 'Private/View/*.{h,m}'

  # 全局头文件
  s.prefix_header_file = 'Private/ZQSystemPhoto_Header.pch'

  # 资源文件
  s.resources = 'Private/Resources/*.{png}'

  # 是否支持arc
  s.requires_arc = true

  # 支持的最低版本
  s.ios.deployment_target = '9.0'

end
