Pod::Spec.new do |s|

    s.name             = 'JSSegmentControl'
    s.version          = '2.0.0'
    s.summary          = '一个简便易用的自定义 Segment 框架。'
  
    s.description      = <<-DESC
    一个简便易用的自定义 Segment 框架，方便快捷的定制 Segment。
                         DESC
  
    s.homepage         = 'https://github.com/spirit-jsb/JSSegmentControl'
  
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
    s.author           = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
  
    s.swift_version = '5.0'
  
    s.ios.deployment_target = '9.0'
  
    s.source           = { :git => 'https://github.com/spirit-jsb/JSSegmentControl.git', :tag => s.version.to_s }
    
    s.requires_arc = true
  
    s.subspec "Core" do |ss|
      ss.source_files = "Sources/Core/"
      ss.frameworks = 'UIKit', 'Foundation'
    end
  end