Pod::Spec.new do |s|
  s.name             = "BushidoCore"
  s.version          = "0.1.2"
  s.summary          = "Basic build configuration and macros for Bushido Coding apps"
  s.homepage         = "https://github.com/sethk/BushidoCore"
  s.license          = {:type => 'BSD'}
  s.author           = { "Seth Kingsley" => "sethk-pods@meowfishies.com" }
  s.source           = { :git => "https://github.com/sethk/BushidoCore.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.default_subspec = 'Core'
  s.prefix_header_contents = '#import <BushidoCore/BCMacros.h>'

  s.subspec "Core" do |ss|
	  ss.source_files = 'Sources/Core/*.[hm]'
	  ss.public_header_files = 'Sources/Core/*.h'
	  ss.preserve_paths = 'Configurations/*.xcconfig'
  end

  s.subspec "Foundation" do |ss|
	  ss.dependency 'BushidoCore/Core'
	  ss.source_files = 'Sources/Foundation/*.[hm]'
	  ss.public_header_files = 'Sources/*.h'
  end

  s.subspec "AppKit" do |ss|
	  ss.platform = :osx
	  ss.dependency 'BushidoCore/Core'
	  ss.source_files = 'Sources/AppKit/*.[hm]'
	  ss.public_header_files = 'Sources/AppKit/*.h'
	  ss.frameworks = 'AppKit'
  end

  s.subspec "UIKit" do |ss|
	  ss.platform = :ios
	  ss.dependency 'BushidoCore/Core'
	  ss.source_files = 'Sources/UIKit/*.[hm]'
	  ss.public_header_files = 'Sources/UIKit/*.h'
	  ss.frameworks = 'UIKit'
  end

  s.subspec "CoreGraphics" do |ss|
	  ss.dependency 'BushidoCore/Core'
	  ss.source_files = 'Sources/CoreGraphics/*.[hm]'
	  ss.public_header_files = 'Sources/CoreGraphics/*.h'
	  ss.frameworks = 'CoreGraphics'
  end

  s.subspec "JavaScriptCore" do |ss|
	  ss.dependency 'BushidoCore/Core'
	  ss.source_files = 'Sources/JavaScriptCore/*.[hm]'
	  ss.public_header_files = 'Sources/JavaScriptCore/*.h'
	  ss.frameworks = 'JavaScriptCore'
  end

  s.subspec "RestKit" do |ss|
	  ss.dependency 'BushidoCore/Core'
	  ss.dependency 'RestKit/Core', '~> 0.20'
	  ss.source_files = 'Source/RestKit/*.[hm]'
	  ss.ios.source_files = 'Source/RestKit/iOS/*.[hm]'
	  ss.ios.resources = 'Resources/RestKit/iOS/*.xib'
	  ss.public_header_files = 'Sources/RestKit/*.h'
	  ss.ios.public_header_files = 'Sources/RestKit/iOS/*.h'
	  ss.frameworks = 'RestKit'
  end


  s.public_header_files = 'Sources/{BCMacros,BCRectUtilities,BCURLFormatter,NSError+Generic}.h'
end
