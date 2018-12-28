Pod::Spec.new do |s|
    s.name             = 'WolfViews'
    s.version          = '1.0.7'
    s.summary          = 'Direct subclasses of iOS views implementing useful patterns, and various utility views.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/wolfmcnally/WolfViews'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfViews.git', :tag => s.version.to_s }

    s.swift_version = '4.2'

    s.ios.deployment_target = '9.3'
    s.ios.source_files = 'WolfViews/Classes/Shared/**/*', 'WolfViews/Classes/iOS/**/*', 'WolfViews/Classes/iOSShared/**/*', 'WolfViews/Classes/AppleShared/**/*'
    s.ios.resources = 'WolfViews/Assets/iOS/*'

    s.macos.deployment_target = '10.13'
    s.macos.source_files = 'WolfViews/Classes/Shared/**/*', 'WolfViews/Classes/macOS/**/*', 'WolfViews/Classes/AppleShared/**/*'

    s.tvos.deployment_target = '11.0'
    s.tvos.source_files = 'WolfViews/Classes/Shared/**/*', 'WolfViews/Classes/tvOS/**/*', 'WolfViews/Classes/iOSShared/**/*', 'WolfViews/Classes/AppleShared/**/*'

    s.module_name = 'WolfViews'

    s.dependency 'WolfFoundation'
    s.dependency 'WolfNesting'
    s.dependency 'WolfColor'
    s.dependency 'WolfLocale'
    s.dependency 'WolfStrings'
    s.dependency 'WolfConcurrency'
    s.dependency 'WolfWith'
    s.dependency 'WolfAutolayout'
    s.dependency 'WolfGeometry'
    s.dependency 'WolfImage'
    s.dependency 'WolfAnimation'
    s.dependency 'WolfApp'
    s.dependency 'WolfCache'
    s.dependency 'WolfOSBridge'
end
