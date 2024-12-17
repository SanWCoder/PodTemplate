# PodTemplate

## Description

基于官方模版库https://github.com/CocoaPods/pod-template.git 改造的组件模版库，加入 swiftformat，swiftlint，husky，lint-staged and commitlint

## Use

### 创建组件
```
// 创建iOS组件项目

~ pod lib create {PROJECT_NAME} --template-url=https://github.com/SanWCoder/PodTemplate.git

```
### 提交
```
// 提交变更
~ yarn commit
// 如果使用git commit 需要规则符合，否则提交不成功
```

## 代码规范检测

### 1. SwiftFormat - 代码格式化

#### 1.1 Podfile添加依赖

```

  pod 'SwiftFormat/CLI'    ,"0.50.1"

```
#### 1.2 添加脚本

TARGETS -> Build Phases -> + -> New Run Script Phase

```
// /bin/sh

# 1.Pod方式
# TARGETNAME - target名称   PROJECT-项目名称
"${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat" "../$(PROJECT)"
# 2.local方式
# if which swiftformat >/dev/null; then
#   swiftformat .
# else
#   echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
# fi

```
#### 1.3 自定义规则

在Example根目录下创建.swiftformat文件

```
~ touch .swiftformat

~ echo '--allman false \n--assetliterals visual-width\n--beforemarks\n--binarygrouping none\n--categorymark \"MARK: %c\"\n--classthreshold 0\n--closingparen balanced\n--commas always\n--conflictmarkers reject\n--decimalgrouping none\n--elseposition same-line\n--enumthreshold 0\n--exponentcase lowercase\n--exponentgrouping disabled\n--extensionacl on-extension\n--extensionlength 0\n--extensionmark \"MARK: - %t + %c\"\n--fractiongrouping disabled\n--fragment false\n--funcattributes preserve\n--groupedextension \"MARK: %c\"\n--guardelse auto\n--header ignore\n--hexgrouping 4,8\n--hexliteralcase uppercase\n--ifdef indent\n--importgrouping alphabetized\n--indent 4\n--indentcase false\n--lifecycle\n--linebreaks lf\n--markextensions always\n--marktypes always\n--maxwidth none\n--modifierorder\n--nevertrailing\n--nospaceoperators ...,..<\n--nowrapoperators\n--octalgrouping none\n--operatorfunc spaced\n--organizetypes class,enum,struct\n--patternlet hoist\n--ranges spaced\n--redundanttype inferred\n--self remove\n--selfrequired\n--semicolons inline\n--shortoptionals always\n--smarttabs enabled\n--stripunusedargs closure-only\n--structthreshold 0\n--tabwidth unspecified\n--trailingclosures\n--trimwhitespace always\n--typeattributes preserve\n--typemark \"MARK: - %t\"\n--varattributes preserve\n--voidtype void\n--wraparguments preserve\n--wrapcollections preserve\n--wrapconditions preserve\n--wrapparameters preserve\n--wrapreturntype preserve\n--xcodeindentation disabled\n--yodaswap always' >> .swiftformat

// .swiftformat
--allman false
--assetliterals visual-width
--beforemarks 
--binarygrouping none
--categorymark "MARK: %c"
--classthreshold 0
--closingparen balanced
--commas always
--conflictmarkers reject
--decimalgrouping none
--elseposition same-line
--enumthreshold 0
--exponentcase lowercase
--exponentgrouping disabled
--extensionacl on-extension
--extensionlength 0
--extensionmark "MARK: - %t + %c"
--fractiongrouping disabled
--fragment false
--funcattributes preserve
--groupedextension "MARK: %c"
--guardelse auto
--header ignore
--hexgrouping 4,8
--hexliteralcase uppercase
--ifdef indent
--importgrouping alphabetized
--indent 4
--indentcase false
--lifecycle 
--linebreaks lf
--markextensions always
--marktypes always
--maxwidth none
--modifierorder 
--nevertrailing 
--nospaceoperators ...,..<
--nowrapoperators 
--octalgrouping none
--operatorfunc spaced
--organizetypes class,enum,struct
--patternlet hoist
--ranges spaced
--redundanttype inferred
--self remove
--selfrequired 
--semicolons inline
--shortoptionals always
--smarttabs enabled
--stripunusedargs closure-only
--structthreshold 0
--tabwidth unspecified
--trailingclosures 
--trimwhitespace always
--typeattributes preserve
--typemark "MARK: - %t"
--varattributes preserve
--voidtype void
--wraparguments preserve
--wrapcollections preserve
--wrapconditions preserve
--wrapparameters preserve
--wrapreturntype preserve
--xcodeindentation disabled
--yodaswap always

```
### 2. swiftlint - 代码规范检测

#### 2.1 Podfile添加依赖

```

pod 'SwiftLint'          ,'0.51.0'

```
#### 2.2 添加脚本

TARGETS -> Build Phases -> + -> New Run Script Phase

```
// /bin/sh

# 1.Pod方式
"${PODS_ROOT}/SwiftLint/swiftlint"
# 2.Homebrew方式
# if which swiftlint >/dev/null; then
#   swiftlint
# else
#   echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
# fi

```
#### 2.3 自定义规则

在Example根目录下创建.swiftlint.yml文件

```
~ touch .swiftlint.yml

~ echo 'included:                                       # 执行lint包含的路径\n#    - Example/Folder                            # 指定目录\n#    - Example/Folder/AppDelegate.swift         # 指定文件\n    - ../#{pod_name}/Classes                 # 指定lint需包含../#{pod_name}/Classes目录\n\nexcluded:                                       # 执行lint忽略的路径，优先级高于 `included`\n    - Pods                                      # 忽略Pods\n\nline_length:                                    # 单行代码长度,默认error 200\n    warning: 300 \n    error: 350\n\nfunction_parameter_count:                       # 函数参数个数\n    warning: 5\n    error: 7' >> .swiftlint.yml

// .swiftlint.yml
included:                                       # 执行lint包含的路径
#    - Example/Folder                           # 指定目录
#    - Example//Folder/AppDelegate.swift        # 指定文件
    - ../xxx/Classes               # 指定lint需包含../xxx/Classes目录

excluded:                                       # 执行lint忽略的路径，优先级高于 `included`
    - Pods                                      # 忽略Pods

#disabled_rules:                                 # 执行时排除掉的规则
#    - identifier_name                           # 驼峰命名检查,between 3 and 40
#    - trailing_whitespace                       # 空行不能有空格

#force_try: warning                              # 避免使用强制try

#force_cast: warning                             # 直接强解类型 eg: NSNumber() as! Int

#type_name: warning                              # 类型名称违规 eg：类型首字母需大写

#shorthand_operator: warning                     # 推荐使用简短操作符 eg：+= ， -=， *=， /=

function_parameter_count:                       # 函数参数个数
    warning: 5
    error: 7
  
function_body_length:                           # 函数体长度 40lines - 100lines
    warning: 150
    error: 200

cyclomatic_complexity:                          # 代码复杂度,默认为10
    warning: 40
    error: 50

large_tuple:                                     # 元组成员个数:2
    warning: 5
    error: 7
    
line_length:                                    # 单行代码长度,默认error 200
    warning: 300
    error: 350

#file_length:                                    # 文件长度
#    warning: 500
#    error: 1200

```
### 3. Git提交lint - commit前进行代码检测

#### 3.1 安装node

```
~ brew install node@16

~ echo 'export PATH="/opt/homebrew/opt/node@16/bin:$PATH"' >> ~/.zshrc

~ source ~/.zshrc

~ npm -v

```
#### 3.2 添加package.json

在项目根目录下创建package.json文件

```
~ touch package.json

~ echo '{\n  \"name\": \"lint\",\n  \"version\": \"1.0.0\",\n  \"private\": true,\n  \"devDependencies\": {\n\n  },\n  \"lint-staged\": {\n    \"*.swift\": [\n      \"Example/Pods/SwiftLint/swiftlint lint\"\n    ]\n  },\n  \"scripts\": {\n    \"commit\": \"git-cz\"\n  },\n  \"config\": {\n    \"commitizen\": {\n      \"path\": \"node_modules/cz-customizable\"\n    },\n    \"cz-customizable\": {\n      \"config\": \"cz-config.js\"\n    }\n  }\n}' >> package.json

// package.json
{
  "name": "lint",
  "version": "1.0.0",
  "private": true,
  "devDependencies": {
    "husky": "^8.0.3",
    "lint-staged": "^13.2.3"
  },
  "lint-staged": {
    "*.swift":["Example/Pods/SwiftLint/swiftlint lint"]
  }
}

```
#### 3.3 安装插件

```
~ npm install --save-dev lint-staged # 安装hulint-stagedsky
~ npm install husky --save-dev // 安装husky
~ npx husky install  // 手动启用husky
~ npx husky add .husky/pre-commit "npx lint-staged"

```
#### 3.4 编辑.husky/pre-commit

```
// pre-commit

#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
```
#### 3.5 编辑package.json

lint-staged 配置规则根据实际路径修改

"Example/Pods/SwiftLint/swiftlint lint" or "Pods/SwiftLint/swiftlint lint"

```
// package.json

{
  "name": "lint",
  "version": "1.0.0",
  "private": true,
  "devDependencies": {
    "husky": "^8.0.3",
    "lint-staged": "^13.2.3"
  },
  "lint-staged": {
    "*.swift":["Example/Pods/SwiftLint/swiftlint lint"]
  }
}

```
#### 3.6 Podfile添加插件校验

在Podfile中添加如下代码

```
## 检查是否安装插件
pre_install do |installer|
  # 插件路径
  sandbox_root = Pathname(installer.sandbox.root)
  ycroot = File.expand_path("../../", sandbox_root)
  # lint-staged
  node_module_lint_stage = File.expand_path("node_modules/lint-staged/",ycroot)
  has_lint_stage = File.exist?(node_module_lint_stage)
  # husky
  node_module_husky = File.expand_path("node_modules/husky",ycroot)
  has_husky = File.exist?(node_module_husky)
  # commitizen
  node_module_commitizen = File.expand_path("node_modules/commitizen",ycroot)
  has_commitizen = File.exist?(node_module_commitizen)
  # cz-conventional-changelog
  node_module_changelog = File.expand_path("node_modules/cz-conventional-changelog",ycroot)
  has_changelog = File.exist?(node_module_changelog)
  # cz-customizable
  node_module_customizable = File.expand_path("node_modules/cz-customizable",ycroot)
  has_customizable = File.exist?(node_module_customizable)
  # commitlint
  node_module_commitlint = File.expand_path("node_modules/@commitlint",ycroot)
  has_commitlint = File.exist?(node_module_commitlint)
  
  if has_husky && has_lint_stage && has_commitizen && node_module_changelog && has_customizable && has_commitlint
    Pod::UI.puts "lint staged，husky，commitizen，cz-conventional-changelog，cz-customizable，commitlint 已安装"
  else
    raise "warning error： lint staged，husky，commitizen，cz-conventional-changelog，cz-customizable，commitlint不存在，请使用以下命令安装: npm install --save-dev lint-staged; npm install husky --save-dev; npx husky install; npm install commitizen cz-conventional-changelog -D; npm i @commitlint/config-conventional @commitlint/cli -D; npm install cz-customizable -D;"
  end
end

```
### 4. git-cz - 使用提交规范

#### 4.1 安装git-cz
```

~ npm install commitizen cz-conventional-changelog -D

```
#### 4.2 配置

```
// package.json
{
  "scripts": {
      "commit": "git-cz"
  },
  "config": {
      "commitizen": {
        "path": "./node_modules/cz-conventional-changelog"
      }
  }
}

```
#### 4.3 使用

```

~ yarn commit 

```
### 5. commitlint - 验证提交规范
#### 5.1 安装commitlint

```

~ npm i @commitlint/config-conventional @commitlint/cli -D

```
#### 5.2 配置commitlint
```
// 项目根目录下
~ touch commitlint.config.js

~ echo 'module.exports = {\n  extends: [\"@commitlint/config-conventional\"]\n}' >> commitlint.config.js

// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional']
}

```
#### 5.3 使用 husky 生成 commit-msg 文件，验证提交信息
```

~ npx husky add .husky/commit-msg "npx --no-install commitlint --edit $1"

```
#### 5.4 如果某次提交想要禁用 husky，可以添加参数 --no-verify
```

~ git commit --no-verify -m "xxx"

```

### 6. cz-customizable - 自定义配置提交说明

#### 6.1 安装cz-customizable

```

~ npm install cz-customizable -D

```
#### 6.2 修改package.json

```
// package.json
 "config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    },
    "cz-customizable": {
      "config": "cz-config.js"
    }
  }
  
```
#### 6.3 添加 .cz-config.js

```

~ touch .cz-config.js

~ echo 'module.exports = {\ntypes: [\n  { value: \"feat\", name: \"feat: 新增功能\" },\n  { value: \"fix\", name: \"fix: 修复 bug\" },\n  { value: \"docs\", name: \"docs: 文档变更\" },\n  { value: \"style\", name: \"style: 代码格式（不影响功能，例如空格、分号等格式修正）\" },\n  { value: \"refactor\", name: \"refactor: 代码重构（不包括 bug 修复、功能新增）\" },\n  { value: \"perf\", name: \"perf: 性能优化\" },\n  { value: \"test\", name: \"test: 添加、修改测试用例\" },\n  { value: \"build\", name: \"build: 构建流程、外部依赖变更（如升级 npm 包、修改 webpack 配置等）\" },\n  { value: \"ci\", name: \"ci: 修改 CI 配置、脚本\" },\n  { value: \"chore\", name: \"chore: 对构建过程或辅助工具和库的更改（不影响源文件、测试用例）\" },\n  { value: \"revert\", name: \"revert: 回滚 commit\" }\n],\nscopes: [\n  [\"components\", \"组件相关\"],\n  [\"hooks\", \"hook 相关\"],\n  [\"utils\", \"utils 相关\"],\n  [\"styles\", \"样式相关\"],\n  [\"deps\", \"项目依赖\"],\n  [\"auth\", \"对 auth 修改\"],\n  [\"other\", \"其他修改\"],\n  [\"custom\", \"以上都不是？我要自定义\"]\n].map(([value, description]) => {\n  return {\n    value,\n    name: `${value.padEnd(30)} (${description})`\n  }\n}),\nmessages: {\n  type: \"请选择提交类型(必填)\",\n  scope: \"选择一个 scope (可选)\",\n  customScope: \"请输入文件修改范围(可选)\",\n  subject: \"请简要描述提交(必填)\",\n  body:\"请输入详细描述(可选)\",\n  breaking: \"列出任何BREAKING CHANGES(破坏性修改)(可选)\",\n  footer: \"请输入要关闭的issue(可选)\",\n  confirmCommit: \"确认提交？\"\n},\nallowBreakingChanges: [\"feat\", \"fix\"],\nsubjectLimit: 100,\nbreaklineChar: \"|\"\n  }' >> .cz-config.js

```
## 模版创建

### 修改setup -> TemplateConfigurator.rb 

```
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

```
### 修改templates -> swift -> Example -> Podfile

```
use_frameworks!

platform :ios, '10.0'

target '${POD_NAME}_Example' do
  pod '${POD_NAME}', :path => '../'
  pod 'SwiftFormat/CLI'    ,"0.50.1"
  pod 'SwiftLint'          ,'0.51.0'
  
  target '${POD_NAME}_Tests' do
    inherit! :search_paths

    ${INCLUDED_PODS}
  end
end

## 检查是否安装插件
pre_install do |installer|
  # 插件路径
  sandbox_root = Pathname(installer.sandbox.root)
  ycroot = File.expand_path("../../", sandbox_root)
  # lint-staged
  node_module_lint_stage = File.expand_path("node_modules/lint-staged/",ycroot)
  has_lint_stage = File.exist?(node_module_lint_stage)
  # husky
  node_module_husky = File.expand_path("node_modules/husky",ycroot)
  has_husky = File.exist?(node_module_husky)
  # commitizen
  node_module_commitizen = File.expand_path("node_modules/commitizen",ycroot)
  has_commitizen = File.exist?(node_module_commitizen)
  # cz-conventional-changelog
  node_module_changelog = File.expand_path("node_modules/cz-conventional-changelog",ycroot)
  has_changelog = File.exist?(node_module_changelog)
  # cz-customizable
  node_module_customizable = File.expand_path("node_modules/cz-customizable",ycroot)
  has_customizable = File.exist?(node_module_customizable)
  # commitlint
  node_module_commitlint = File.expand_path("node_modules/@commitlint",ycroot)
  has_commitlint = File.exist?(node_module_commitlint)
  
  if has_husky && has_lint_stage && has_commitizen && node_module_changelog && has_customizable && has_commitlint
    Pod::UI.puts "lint staged，husky，commitizen，cz-conventional-changelog，cz-customizable，commitlint 已安装"
  else
    raise "warning error： lint staged，husky，commitizen，cz-conventional-changelog，cz-customizable，commitlint不存在，请使用以下命令安装: npm install --save-dev lint-staged; npm install husky --save-dev; npx husky install; npm install commitizen cz-conventional-changelog -D; npm i @commitlint/config-conventional @commitlint/cli -D; npm install cz-customizable -D;"
  end
end

```

### 修改templates -> swift -> Example -> PROJECT.xcodeproj

#### 添加swiftformat脚本

TARGETS -> Build Phases -> + -> New Run Script Phase

```

// /bin/sh

# 1.Pod方式
# TARGETNAME - target名称   PROJECT-项目名称
"${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat" "../$(PROJECT)"
# 2.local方式
# if which swiftformat >/dev/null; then
#   swiftformat .
# else
#   echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
# fi

```

#### 添加swiftlint脚本


TARGETS -> Build Phases -> + -> New Run Script Phase

```
// /bin/sh

# 1.Pod方式
"${PODS_ROOT}/SwiftLint/swiftlint"
# 2.Homebrew方式
# if which swiftlint >/dev/null; then
#   swiftlint
# else
#   echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
# fi

```












