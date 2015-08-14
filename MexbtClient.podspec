#
# Be sure to run `pod lib lint MexbtClient.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MexbtClient"
  s.version          = "0.0.1"
  s.summary          = "Objective C client library for the meXBT exchange API"
  s.description      = <<-DESC
                       Objective C client library for the meXBT exchange API.
                       DESC
  s.homepage         = "https://github.com/Ahimta/mexbt-objective-c"
  s.license          = 'MIT'
  s.author           = { "Abdullah Alansari" => "ahimta@gmail.com" }
  s.source           = { :git => "https://github.com/Ahimta/mexbt-objective-c.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Ahymta'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MexbtClient' => ['Pod/Assets/*.png']
  }
end
