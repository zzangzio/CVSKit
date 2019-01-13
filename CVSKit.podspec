
Pod::Spec.new do |s|
    s.name             = 'CVSKit'
    s.version          = '0.6.1'
    s.summary          = 'CVSKit is a collection of Swift extensions and utility.'
    s.description      = <<-DESC
    CVSKit is a collection of Swift extensions and utility for better programming.
    Interactive Swipe dismiss, Interactive Tab Control and etc.
    DESC

    s.homepage         = 'https://github.com/zzangzio/CVSKit'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'zzangzio' => 'zzangzio@gmail.com' }

    s.platform     = :ios, '10.0'
    s.swift_version = '4.2'
    s.requires_arc = true
    s.source       = { git: 'https://github.com/zzangzio/CVSKit.git', tag: s.version.to_s }
    s.source_files = 'Sources/**/*'

    # Foundation Extension
    #s.subspec 'Foundation' do |sp|
    #    sp.source_files  = 'Sources/Foundation/*.swift'
    #end

    # UIKit Extension
    #s.subspec 'UIKit' do |sp|
    #    sp.source_files  = 'Sources/UIKit/*.swift'
    #end
end
