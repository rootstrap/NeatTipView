#
# Be sure to run `pod lib lint NeatTipView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NeatTipView'
  s.version          = '1.0.1'
  s.summary          = 'Display tooltip views in swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  NeatTipView allows you to display message tooltips that can be used as call to actions or informative tips.
                       DESC

  s.homepage         = 'https://github.com/rootstrap/NeatTipView'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'german.stabile@gmail.com' => 'german.stabile@gmail.com' }
  s.source           = { :git => 'https://github.com/rootstrap/NeatTipView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'NeatTipView/Classes/**/*'

  s.frameworks = 'UIKit'

  s.swift_version = '5.0'
end
