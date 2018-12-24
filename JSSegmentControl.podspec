Pod::Spec.new do |s|

    s.name             = 'JSSegmentControl'
    s.version          = '1.1.1'
    s.summary          = '一个简便易用的自定义 Segment 框架。'
  
    s.description      = <<-DESC
    一个简便易用的自定义 Segment 框架，方便快捷的定制 Segment。
                         DESC
  
    s.homepage         = 'https://github.com/spirit-jsb/JSSegmentControl'
  
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
    s.author           = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
  
    s.swift_version = '4.2'
  
    s.ios.deployment_target = '9.0'
  
    s.source           = { :git => 'https://github.com/spirit-jsb/JSSegmentControl.git', :tag => s.version.to_s }
    
    s.requires_arc = true
  
    s.subspec "Core" do |ss|
      ss.source_files = "Sources/Core/"
      ss.frameworks = 'UIKit', 'Foundation'
    end

    s.subspec "RxSwift" do |ss|
      ss.source_files = "Sources/RxSegmentControl/"
      ss.dependency "RxSegmentControl/Core"
      ss.dependency "RxSwift", "~> 4.0"
      ss.dependency "RxCocoa", "~> 4.0"
    end
  end