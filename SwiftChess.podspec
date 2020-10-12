#
# Be sure to run `pod lib lint SwiftChess.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftChess'
  s.version          = '1.1.2'
  s.summary          = 'Chess engine written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Chess engine written in Swift, support player vs player, and player vs AI games.
                       DESC

  s.homepage         = 'https://github.com/SteveBarnegren/SwiftChess'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steve Barnegren' => 'steve.barnegren@gmail.com' }
  s.source           = { :git => 'https://github.com/SteveBarnegren/SwiftChess.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/stevebarnegren'
  s.swift_version = '5.0'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftChess/Source/**/*'

end
