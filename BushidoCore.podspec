Pod::Spec.new do |s|
  s.name             = "BushidoCore"
  s.version          = "0.1.0"
  s.summary          = "Basic build configuration and macros for Bushido Coding apps"
  s.homepage         = "https://github.com/sethk/BushidoCore"
  s.license          = {:type => 'BSD'}
  s.author           = { "Seth Kingsley" => "sethk-pods@meowfishies.com" }
  s.source           = { :git => "https://github.com/sethk/BushidoCore.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.source_files = 'Sources/BC{Macros,URLFormatter}.[hm]'
  s.preserve_paths = 'Configurations/*.xcconfig'
  #s.ios.resources = 'Resources'

  s.public_header_files = 'Sources/BC{Macros,RectUtilities,URLFormatter}.h'
end