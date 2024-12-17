# ${POD_NAME}

[![CI Status](https://img.shields.io/travis/${USER_NAME}/${REPO_NAME}.svg?style=flat)](https://travis-ci.org/${USER_NAME}/${REPO_NAME})
[![Version](https://img.shields.io/cocoapods/v/${POD_NAME}.svg?style=flat)](https://cocoapods.org/pods/${POD_NAME})
[![License](https://img.shields.io/cocoapods/l/${POD_NAME}.svg?style=flat)](https://cocoapods.org/pods/${POD_NAME})
[![Platform](https://img.shields.io/cocoapods/p/${POD_NAME}.svg?style=flat)](https://cocoapods.org/pods/${POD_NAME})

## Use

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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

## Requirements

## Installation

${POD_NAME} is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod '${POD_NAME}'
```

## Author

${USER_NAME}, ${USER_EMAIL}

## License

${POD_NAME} is available under the MIT license. See the LICENSE file for more info.

## Add Lint

### 1. 修改Podfile
Example -> Podfile

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
### 2. add swiftformat

TARGETS -> Build Phases -> + -> New Run Script Phase

```
// /bin/sh

# 1.Pod方式
# TARGETNAME - target名称   PROJECT-项目名称
"${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat" "../${POD_NAME}"
# 2.local方式
# if which swiftformat >/dev/null; then
#   swiftformat .
# else
#   echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
# fi

```
### 3. add swiftlint

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

### 4. 安装插件
```
~ npm install --save-dev lint-staged
~ npm install husky --save-dev
~ npx husky install
~ npx husky add .husky/pre-commit "Example/Pods/SwiftFormat/CommandLineTool/swiftformat ../${POD_NAME}"
~ npx husky add .husky/pre-commit "npx lint-staged"
~ npm install commitizen cz-conventional-changelog -D
~ npm i @commitlint/config-conventional @commitlint/cli -D
~ npm install cz-customizable -D 
~ npx husky add .husky/commit-msg "npx --no-install commitlint --edit $1"

```

### 5. 修改.swiftlint.yml
将${PROJECT_NAME}替换为自己的项目名

```
included:                                       # 执行lint包含的路径
#    - Example/Folder                           # 指定目录
#    - Example//Folder/AppDelegate.swift        # 指定文件
    - ../${POD_NAME}/Classes                    # 指定lint需包含../HCYNetRequestKit/Classes目录
```

### 6. 添加文件
将package.json，commitlint.config.js，.cz-config.js,.swiftlint.yml,.gitignore放到项目根目录下
将.swiftlint.yml，.swiftformat 放在Example文件夹下

注： .swiftlint.yml 需要在根目录及Example都要放

### 7. 修改插件

将.husky -> commit-msg 文件删除 npm run test 测试句
