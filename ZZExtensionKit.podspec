
Pod::Spec.new do |s|
    s.name             = 'ZZExtensionKit'
    s.version          = '0.1.0'
    s.summary          = 'ZZExtensionKit is a collection of extensions and utility.'
    s.description      = <<-DESC
    ZZExtensionKit is a collection of extensions and utility for Swift.
    DESC

    s.homepage         = 'https://github.com/zzangzio/ZZExtensionKit'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'zzangzio' => 'zzangzio@gmail.com' }

    s.platform     = :ios, '10.0'
    s.swift_version = '4.2'
    s.requires_arc = true
    s.source       = { git: 'https://github.com/zzangzio/ZZExtensionKit.git', tag: s.version.to_s }
    s.source_files = 'ZZExtensionKit/Classes/**/*'

    # s.resource_bundles = {
    #   'ZZExtensionKit' => ['ZZExtensionKit/Assets/*.png']
    # }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
