Pod::Spec.new do |s|

s.name         = "JKCycleScrollView"
s.version      = "0.1.0"
s.summary      = "简单易用的无限轮播器. 支持横向、竖向两种滑动方式"
s.description  = <<-DESC
                    It is a cycle scroll view used on iOS, which implement by Objective-C.
                    DESC

s.homepage     = "https://github.com/pjk1129/JKCycleScroll.git"
s.license          = { :type => 'MIT', :file => 'LICENSE' }

s.platform     = :ios, "8.0"
s.author       = { 'pjk1129' => 'pjk1129@qq.com' }

s.source       = { :git => "https://github.com/pjk1129/JKCycleScroll.git", :tag => "0.1.0"}
s.source_files  = "JKCycleScrollView/**/*.{h,m}"

s.requires_arc = true

s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
