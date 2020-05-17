Pod::Spec.new do |s|

  s.name             = 'GrammarKit'
  s.version          = '1.0.3'
  s.summary          = 'Simple, extensible, and scalable grammar parsing scanner.'

  s.description      = <<-DESC
The goal of GrammarKit is to provide a lightweight and extensible framework for tokenizing and parsing stream of characters using a user defined grammar definition that can attribute meaning to occurrences and/or sequences of characters that match any number of custom rules belonging to that grammar. Using this framework should allow developers to not only define any number of custom languages without the need for a complete project rebuild (just the addition of a simple XML file or ParserParser grammar package using the .ppgrammar package extension), utilize syntax highlighting, identifier and scope recognition, code recommendation, and much more.

Support to import and convert ANTLR4 grammar files to GrammarKit grammar file format is a long term goal of this project, as well.
                       DESC

  s.homepage         = 'https://github.com/NoodleOfDeath/GrammarKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NoodleOfDeath' => 'git@noodleofdeath.com' }
  s.source           = { :git => 'https://github.com/NoodleOfDeath/GrammarKit.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  s.source_files = 'runtime/swift/GrammarKit/Classes/**/*{h,m,swift}'
  s.resources = 'common/**/*'

  s.dependency 'SwiftyUTType', '~>1.0'
  
end
