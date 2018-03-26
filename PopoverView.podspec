# coding: utf-8
Pod::Spec.new do |s|
  s.name             = 'EPopoverView'
  s.version          = '0.3.3'
  s.summary          = '气泡弹出框'
  s.description      = <<-DESC
                        类似微信的汽泡弹出框
                       DESC

  s.homepage         = 'https://github.com/lazyjean/PopoverView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '刘真' => 'lazy66@me.com' }
  s.source           = { :git => 'https://github.com/lazyjean/PopoverView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PopoverView/**/*'
  s.public_header_files = 'PopoverView/**/*.h'
  s.frameworks = 'UIKit'
end
