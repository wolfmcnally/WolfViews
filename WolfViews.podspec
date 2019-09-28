Pod::Spec.new do |s|
    s.name             = 'WolfViews'
    s.version          = '4.0.1'
    s.summary          = 'Direct subclasses of iOS views implementing useful patterns, and various utility views.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/wolfmcnally/WolfViews'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfViews.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.ios.deployment_target = '12.0'
    s.ios.source_files = 'Sources/WolfViews/Shared/**/*', 'Sources/WolfViews/iOS/**/*', 'Sources/WolfViews/iOSShared/**/*', 'Sources/WolfViews/AppleShared/**/*'
    s.ios.resources = 'Assets/iOS/*'

    s.macos.deployment_target = '10.14'
    s.macos.source_files = 'Sources/WolfViews/Shared/**/*', 'Sources/WolfViews/macOS/**/*', 'Sources/WolfViews/AppleShared/**/*'

    s.tvos.deployment_target = '12.0'
    s.tvos.source_files = 'Sources/WolfViews/Shared/**/*', 'Sources/WolfViews/tvOS/**/*', 'Sources/WolfViews/iOSShared/**/*', 'Sources/WolfViews/AppleShared/**/*'

    s.module_name = 'WolfViews'

    s.dependency 'WolfCore'
    s.dependency 'WolfGraphics'
    s.dependency 'WolfLocale'
    s.dependency 'WolfAutolayout'
    s.dependency 'WolfAnimation'
    s.dependency 'WolfApp'
    s.dependency 'WolfCache'
end
