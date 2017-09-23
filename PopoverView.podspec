Pod::Spec.new do |s|
  s.name             = 'PopoverView'
  s.version          = '0.2.0'
  s.summary          = '气泡弹出框'
  s.description      = <<-DESC
                        类似微信的汽泡弹出框
                       DESC

  s.homepage         = 'http://git.oschina.net/leeszi/PopoverView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '刘真' => 'lazy66@me.com' }
  s.source           = { :git => 'https://git.oschina.net/leeszi/PopoverView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PopoverView/**/*'
  s.public_header_files = 'PopoverView/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Colours'
end
