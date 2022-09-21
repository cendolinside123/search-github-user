# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GitUser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitUser
  pod 'Alamofire'
  pod 'Kingfisher'
  
  pre_install do |installer|
      remove_swiftui()
  end

  def remove_swiftui
    # source https://github.com/onevcat/Kingfisher/issues/1725#issuecomment-927861930
    system("rm -rf ./Pods/Kingfisher/Sources/SwiftUI")
    code_file = "./Pods/Kingfisher/Sources/General/KFOptionsSetter.swift"
    code_text = File.read(code_file)
    code_text.gsub!(/#if canImport\(SwiftUI\) \&\& canImport\(Combine\)(.|\n)+#endif/,'')
    system("rm -rf " + code_file)
    aFile = File.new(code_file, 'w+')
    aFile.syswrite(code_text)
    aFile.close()
  end
  
end
