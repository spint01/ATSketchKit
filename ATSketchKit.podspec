#
#  Be sure to run `pod spec lint ATSketchKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  These will help people to find your library, and whilst it
    #  can feel like a chore to fill in it's definitely to your advantage. The
    #  summary should be tweet-length, and the description more in depth.
    #

    s.name         = "ATSketchKit"
    s.version      = "0.2.0"
    s.summary      = "Swift framework for drawing."

    s.homepage         = "https://github.com/spint01/ATSketchKit"
    s.license          = 'MIT'
    s.author           = { "SGP Enterprises, Inc." => "steve.pint@gmail.com", "Copyright (c) 2015-2016 Arnaud Thiercelin" }
    s.source           = { :git => "https://github.com/spint01/ATSketchKit", :tag => s.version.to_s }
    s.platform         = :ios, '10.0'
    s.requires_arc     = true
    s.source_files     = 'Source/**/*'
    s.frameworks       = 'AVFoundation'
    s.swift_version    = "4.1"
    s.ios.deployment_target = "10.0"

end
