Pod::Spec.new do |s|
  s.name             = "BushidoCore"
  s.version          = "0.1.1"
  s.summary          = "Basic build configuration and macros for Bushido Coding apps"
  s.homepage         = "https://github.com/sethk/BushidoCore"
  s.license          = {:type => 'BSD'}
  s.author           = { "Seth Kingsley" => "sethk-pods@meowfishies.com" }
  s.source           = { :git => "https://github.com/sethk/BushidoCore.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.source_files = 'Sources/{BCMacros,BCURLFormatter,NSError+Generic}.[hm]'
  s.preserve_paths = 'Configurations/*.xcconfig'
  #s.ios.resources = 'Resources'

  s.public_header_files = 'Sources/{BCMacros,BCRectUtilities,BCURLFormatter,NSError+Generic}.h'
end
