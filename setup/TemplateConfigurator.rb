require 'fileutils'
require 'colored2'

module Pod
  class TemplateConfigurator

    attr_reader :pod_name, :pods_for_podfile, :prefixes, :test_example_file, :username, :email

    def initialize(pod_name)
      @pod_name = pod_name
      @pods_for_podfile = []
      @prefixes = []
      @message_bank = MessageBank.new(self)
    end

    def ask(question)
      answer = ""
      loop do
        puts "\n#{question}?"

        @message_bank.show_prompt
        answer = gets.chomp

        break if answer.length > 0

        print "\nYou need to provide an answer."
      end
      answer
    end

    def ask_with_answers(question, possible_answers)

      print "\n#{question}? ["

      print_info = Proc.new {

        possible_answers_string = possible_answers.each_with_index do |answer, i|
           _answer = (i == 0) ? answer.underlined : answer
           print " " + _answer
           print(" /") if i != possible_answers.length-1
        end
        print " ]\n"
      }
      print_info.call

      answer = ""

      loop do
        @message_bank.show_prompt
        answer = gets.downcase.chomp

        answer = "yes" if answer == "y"
        answer = "no" if answer == "n"

        # default to first answer
        if answer == ""
          answer = possible_answers[0].downcase
          print answer.yellow
        end

        break if possible_answers.map { |a| a.downcase }.include? answer

        print "\nPossible answers are ["
        print_info.call
      end

      answer
    end

    def run
      @message_bank.welcome_message

      platform = self.ask_with_answers("What platform do you want to use?", ["iOS", "macOS"]).to_sym

      case platform
        when :macos
          ConfigureMacOSSwift.perform(configurator: self)
        when :ios
          framework = self.ask_with_answers("What language do you want to use?", ["Swift", "ObjC"]).to_sym
          case framework
            when :swift
              ConfigureSwift.perform(configurator: self)

            when :objc
              ConfigureIOS.perform(configurator: self)
          end
      end

      replace_variables_in_files
      clean_template_files
      rename_template_files
      add_pods_to_podfile
      customise_prefix
      rename_classes_folder
      ensure_carthage_compatibility
      reinitialize_git_repo
      run_pod_install

      @message_bank.farewell_message
    end

    #----------------------------------------#

    def ensure_carthage_compatibility
      FileUtils.ln_s('Example/Pods/Pods.xcodeproj', '_Pods.xcodeproj')
    end

    def run_pod_install
      
      puts "\nRunning " + "npm install" + " on your new library."
      puts ""
      
      # 1.add package.json
      system "touch package.json"
      system "echo '{\n  \"name\": \"lint\",\n  \"version\": \"1.0.0\",\n  \"private\": true,\n  \"devDependencies\": {\n\n  },\n  \"lint-staged\": {\n    \"*.swift\": [\n      \"Example/Pods/SwiftLint/swiftlint lint\"\n    ]\n  },\n  \"scripts\": {\n    \"commit\": \"git-cz\"\n  },\n  \"config\": {\n    \"commitizen\": {\n      \"path\": \"node_modules/cz-customizable\"\n    },\n    \"cz-customizable\": {\n      \"config\": \"cz-config.js\"\n    }\n  }\n}' >> package.json"
      
      # 2.add SwiftLint
      system "npm install --save-dev lint-staged"
      system "npm install husky --save-dev"
      system "npx husky install"
      system "npx husky add .husky/pre-commit \"Example/Pods/SwiftFormat/CommandLineTool/swiftformat ../#{pod_name}\n\nnpx lint-staged\""
      system "npm install commitizen cz-conventional-changelog -D"
      system "npm i @commitlint/config-conventional @commitlint/cli -D"
      system "npm install cz-customizable -D"
      system "npx husky add .husky/commit-msg \"npx --no-install commitlint --edit $1\""
      
      # 3.add .swiftlint.yml
      system "touch Example/.swiftlint.yml"
      system "echo 'included:                                       # 执行lint包含的路径\n#    - Example/Folder                            # 指定目录\n#    - Example/Folder/AppDelegate.swift         # 指定文件\n    - ../#{pod_name}/Classes                 # 指定lint需包含../#{pod_name}/Classes目录\n\nexcluded:                                       # 执行lint忽略的路径，优先级高于 `included`\n    - Pods                                      # 忽略Pods\n\nline_length:                                    # 单行代码长度,默认error 200\n    warning: 300 \n    error: 350\n\nfunction_parameter_count:                       # 函数参数个数\n    warning: 5\n    error: 7' >> Example/.swiftlint.yml"
      
      # 4.add .swiftformat
      system "touch Example/.swiftformat"
      system "echo '--allman false \n--assetliterals visual-width\n--beforemarks\n--binarygrouping none\n--categorymark \"MARK: %c\"\n--classthreshold 0\n--closingparen balanced\n--commas always\n--conflictmarkers reject\n--decimalgrouping none\n--elseposition same-line\n--enumthreshold 0\n--exponentcase lowercase\n--exponentgrouping disabled\n--extensionacl on-extension\n--extensionlength 0\n--extensionmark \"MARK: - %t + %c\"\n--fractiongrouping disabled\n--fragment false\n--funcattributes preserve\n--groupedextension \"MARK: %c\"\n--guardelse auto\n--header ignore\n--hexgrouping 4,8\n--hexliteralcase uppercase\n--ifdef indent\n--importgrouping alphabetized\n--indent 4\n--indentcase false\n--lifecycle\n--linebreaks lf\n--markextensions always\n--marktypes always\n--maxwidth none\n--modifierorder\n--nevertrailing\n--nospaceoperators ...,..<\n--nowrapoperators\n--octalgrouping none\n--operatorfunc spaced\n--organizetypes class,enum,struct\n--patternlet hoist\n--ranges spaced\n--redundanttype inferred\n--self remove\n--selfrequired\n--semicolons inline\n--shortoptionals always\n--smarttabs enabled\n--stripunusedargs closure-only\n--structthreshold 0\n--tabwidth unspecified\n--trailingclosures\n--trimwhitespace always\n--typeattributes preserve\n--typemark \"MARK: - %t\"\n--varattributes preserve\n--voidtype void\n--wraparguments preserve\n--wrapcollections preserve\n--wrapconditions preserve\n--wrapparameters preserve\n--wrapreturntype preserve\n--xcodeindentation disabled\n--yodaswap always' >> Example/.swiftformat"
      
      # 5.add commitlint.config.js
      system "touch commitlint.config.js"
      system "echo 'module.exports = {\n  extends: [\"@commitlint/config-conventional\"]\n}' >> commitlint.config.js"

      # 6.add .cz-config.js
      system "touch .cz-config.js"
      system "echo 'module.exports = {\ntypes: [\n  { value: \"feat\", name: \"feat: 新增功能\" },\n  { value: \"fix\", name: \"fix: 修复 bug\" },\n  { value: \"docs\", name: \"docs: 文档变更\" },\n  { value: \"style\", name: \"style: 代码格式（不影响功能，例如空格、分号等格式修正）\" },\n  { value: \"refactor\", name: \"refactor: 代码重构（不包括 bug 修复、功能新增）\" },\n  { value: \"perf\", name: \"perf: 性能优化\" },\n  { value: \"test\", name: \"test: 添加、修改测试用例\" },\n  { value: \"build\", name: \"build: 构建流程、外部依赖变更（如升级 npm 包、修改 webpack 配置等）\" },\n  { value: \"ci\", name: \"ci: 修改 CI 配置、脚本\" },\n  { value: \"chore\", name: \"chore: 对构建过程或辅助工具和库的更改（不影响源文件、测试用例）\" },\n  { value: \"revert\", name: \"revert: 回滚 commit\" }\n],\nscopes: [\n  [\"components\", \"组件相关\"],\n  [\"hooks\", \"hook 相关\"],\n  [\"utils\", \"utils 相关\"],\n  [\"styles\", \"样式相关\"],\n  [\"deps\", \"项目依赖\"],\n  [\"auth\", \"对 auth 修改\"],\n  [\"other\", \"其他修改\"],\n  [\"custom\", \"以上都不是？我要自定义\"]\n].map(([value, description]) => {\n  return {\n    value,\n    name: `${value.padEnd(30)} (${description})`\n  }\n}),\nmessages: {\n  type: \"请选择提交类型(必填)\",\n  scope: \"选择一个 scope (可选)\",\n  customScope: \"请输入文件修改范围(可选)\",\n  subject: \"请简要描述提交(必填)\",\n  body:\"请输入详细描述(可选)\",\n  breaking: \"列出任何BREAKING CHANGES(破坏性修改)(可选)\",\n  footer: \"请输入要关闭的issue(可选)\",\n  confirmCommit: \"确认提交？\"\n},\nallowBreakingChanges: [\"feat\", \"fix\"],\nsubjectLimit: 100,\nbreaklineChar: \"|\"\n  }' >> .cz-config.js"
      
      puts "\nRunning " + "pod install".magenta + " on your new library."
      puts ""
      
      Dir.chdir("Example") do
        system "pod install"
      end
      
      `git add Example/#{pod_name}.xcodeproj/project.pbxproj`
      `git commit -m "Initial commit"`
      
    end

    def clean_template_files
      ["./**/.gitkeep", "configure", "_CONFIGURE.rb", "README.md", "LICENSE", "templates", "setup", "CODE_OF_CONDUCT.md"].each do |asset|
        `rm -rf #{asset}`
      end
    end

    def replace_variables_in_files
      file_names = ['POD_LICENSE', 'POD_README.md', 'NAME.podspec', '.travis.yml', podfile_path]
      file_names.each do |file_name|
        text = File.read(file_name)
        text.gsub!("${POD_NAME}", @pod_name)
        text.gsub!("${REPO_NAME}", @pod_name.gsub('+', '-'))
        text.gsub!("${USER_NAME}", user_name)
        text.gsub!("${USER_EMAIL}", user_email)
        text.gsub!("${YEAR}", year)
        text.gsub!("${DATE}", date)
        File.open(file_name, "w") { |file| file.puts text }
      end
    end

    def add_pod_to_podfile podname
      @pods_for_podfile << podname
    end

    def add_pods_to_podfile
      podfile = File.read podfile_path
      podfile_content = @pods_for_podfile.map do |pod|
        "pod '" + pod + "'"
      end.join("\n    ")
      podfile.gsub!("${INCLUDED_PODS}", podfile_content)
      File.open(podfile_path, "w") { |file| file.puts podfile }
    end

    def add_line_to_pch line
      @prefixes << line
    end

    def customise_prefix
      prefix_path = "Example/Tests/Tests-Prefix.pch"
      return unless File.exist? prefix_path

      pch = File.read prefix_path
      pch.gsub!("${INCLUDED_PREFIXES}", @prefixes.join("\n  ") )
      File.open(prefix_path, "w") { |file| file.puts pch }
    end

    def set_test_framework(test_type, extension, folder)
      content_path = "setup/test_examples/" + test_type + "." + extension
      tests_path = "templates/" + folder + "/Example/Tests/Tests." + extension
      tests = File.read tests_path
      tests.gsub!("${TEST_EXAMPLE}", File.read(content_path) )
      File.open(tests_path, "w") { |file| file.puts tests }
    end

    def rename_template_files
      FileUtils.mv "POD_README.md", "README.md"
      FileUtils.mv "POD_LICENSE", "LICENSE"
      FileUtils.mv "NAME.podspec", "#{pod_name}.podspec"
    end

    def rename_classes_folder
      FileUtils.mv "Pod", @pod_name
    end

    def reinitialize_git_repo
      `rm -rf .git`
      `git init`
      `git add -A`
    end

    def validate_user_details
        return (user_email.length > 0) && (user_name.length > 0)
    end

    #----------------------------------------#

    def user_name
      (ENV['GIT_COMMITTER_NAME'] || github_user_name || `git config user.name` || `<GITHUB_USERNAME>` ).strip
    end

    def github_user_name
      github_user_name = `security find-internet-password -s github.com | grep acct | sed 's/"acct"<blob>="//g' | sed 's/"//g'`.strip
      is_valid = github_user_name.empty? or github_user_name.include? '@'
      return is_valid ? nil : github_user_name
    end

    def user_email
      (ENV['GIT_COMMITTER_EMAIL'] || `git config user.email`).strip
    end

    def year
      Time.now.year.to_s
    end

    def date
      Time.now.strftime "%m/%d/%Y"
    end

    def podfile_path
      'Example/Podfile'
    end

    #----------------------------------------#
  end
end
