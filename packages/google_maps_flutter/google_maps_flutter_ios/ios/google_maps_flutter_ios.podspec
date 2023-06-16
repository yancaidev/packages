#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'google_maps_flutter_ios'
  s.version          = '0.0.1'
  s.summary          = 'Google Maps for Flutter'
  s.description      = <<-DESC
A Flutter plugin that provides a Google Maps widget.
Downloaded by pub (not CocoaPods).
                       DESC
  s.homepage         = 'https://github.com/flutter/packages'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :http => 'https://github.com/flutter/packages/tree/main/packages/google_maps_flutter/google_maps_flutter/ios' }
  s.documentation_url = 'https://pub.dev/packages/google_maps_flutter_ios'
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.module_map = 'Classes/google_maps_flutter_ios.modulemap'
  s.dependency 'Flutter'
  # Allow any version up to the next breaking change after the latest version that
  # has been confirmed to be compatible via an example in examples/. See discussion
  # in https://github.com/flutter/flutter/issues/86820 for why this is so broad.
  s.dependency 'GoogleMaps', '< 8.0'
  s.static_framework = true
  s.platform = :ios, '11.0'
  # GoogleMaps does not support arm64 simulators.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
