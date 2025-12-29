# XCFolder

<p align="center">
  <img width="700" alt="image" src="https://github.com/user-attachments/assets/27df3d5c-0ad8-46aa-842d-10aaf0bbaeb0" /> <br/>
  <a href="https://github.com/tuist/awesome-tuist" target="_blank"><img src="https://awesome.re/badge.svg"/></a>
</p>

XCFolder is a powerful command-line tool that converts Xcode virtual groups into actual directories(associated folder), reorganizing your project structure to align with Xcode groups and enabling seamless integration with modern Xcode project generation tools like Tuist and XcodeGen.

## Key Features
- **Smart Group Conversion**: Intelligently transforms Xcode virtual groups into physical directories while preserving project structure
- **Perfect Synchronization**: Maintains 1:1 mapping between Xcode project navigator and filesystem directories
- **Automated Organization**: Eliminates manual folder management with automated synchronization
- **Migration Ready**: Prepares your project structure for modern build systems like Tuist and XcodeGen
- **Flexible Configuration**: Supports both `.yaml` and `.yml` configuration files
- **Space-Friendly Paths**: Handles project names and paths containing spaces correctly
- **Development Mode**: Optional safety check bypass for faster development workflows

![EXAMPLE](https://github.com/user-attachments/assets/aa099b5a-191b-42a0-b7f9-2005d5ca4b90)


## Usage
### Step 1. Clone this repo
```
git clone https://github.com/ZhgChgLi/XCFolder.git
```

#### Modify Configuration.yml if needed
`./Configuration.yaml`:

```yaml
# Paths to ignore when scanning for source files
ignorePaths:
- "Pods"
- "Frameworks"
- "Products"

# File types to ignore when scanning for source files
ignoreFileTypes:
- "wrapper.framework" # Frameworks
- "wrapper.pb-project" # Xcode project files
#- "wrapper.application" # Applications
#- "wrapper.cfbundle" # Bundles
#- "wrapper.plug-in" # Plug-ins
#- "wrapper.xpc-service" # XPC services
#- "wrapper.xctest" # XCTest bundles
#- "wrapper.app-extension" # App extensions

# Whether to move files only, without changing .xcodeproj settings
moveFileOnly: false

# Use git mv by default instead of filesystem move
gitMove: true
```

### Step 2. Run with Swift
```
cd ./XCFolder
swift run XCFolder YOUR_XCODEPROJ_FILE.xcodeproj ./Configuration.yaml
```
#### Non Interactive Mode
```
swift run XCFolder YOUR_XCODEPROJ_FILE.xcodeproj ./Configuration.yaml --is-non-interactive-mode
```

#### Skip Safety Check
If you want to run XCFolder without checking for uncommitted git changes (useful during development):
```
swift run XCFolder YOUR_XCODEPROJ_FILE.xcodeproj ./Configuration.yaml --skip-safety-check
```

#### Combined Flags
```
swift run XCFolder YOUR_XCODEPROJ_FILE.xcodeproj ./Configuration.yaml --is-non-interactive-mode --skip-safety-check
```
#### For example
```
swift run XCFolder ./TestProject/DCDeviceTest.xcodeproj ./Configuration.yaml
```

#### **⚠️ Please note before running:**
- **Ensure your project is backed up**, and if you’re using source control,**make sure there are no uncommitted changes** in Git, as the script may modify your project directory.
  - (The script will check for uncommitted changes and will throw an error `❌ Error: There are uncommitted changes in the repository`)
- By default, the `git mv` command will be used to move files to ensure the git file log is fully recorded.
  - If the move fails or if it's not a Git project, the FileSystem Move will be used instead.

### Step 3. Wait for the execution to complete.

![image](https://github.com/user-attachments/assets/e8e6a4fe-5bf7-40f5-8d17-521a42da97b4)

### Step 4: Done, Have a great day! 🚀🚀🚀

![image](https://github.com/user-attachments/assets/65025508-a309-4249-b63d-de5148f8203b)

#### **⚠️ Please note after running:**
- Check if there are any missing (red) files in the project directory.
  - If there are few, you can manually fix them.
  - If there are many, verify whether the settings for ignorePaths and ignoreFileTypes in Configuration.yaml are correct, or create an Issue to let me know.
- Check the relevant paths in Build Settings, e.g., `LIBRARY_SEARCH_PATHS`, to see if manual adjustments are needed.
- It's recommended to perform a Clean & Build again.
- If you don't want to bother with the current `.xcodeproj` XCode project file, you can directly use XCodeGen or Tuist to regenerate the project files.


## Recent Improvements

### Enhanced Path Handling
- **Fixed file path validation**: Now properly handles project names and paths containing spaces (e.g., "My Project.xcodeproj")
- **Improved configuration support**: Accepts both `.yaml` and `.yml` file extensions for configuration files

### New Command Line Options
- **`--skip-safety-check`**: Bypass git uncommitted changes check for faster development workflows
- **Better error handling**: More descriptive error messages for invalid paths

### Bug Fixes
- Fixed URL parsing issues that prevented XCFolder from working with file paths containing spaces
- Improved file path resolution using proper file URL handling instead of string-based URL parsing

## Technical Details

- [\[English\] The Development Story of XCFolder](https://en.zhgchg.li/posts/zrealm-dev/xcode-virtual-directory-issues-streamline-your-project-structure-with-open-source-tools-fd719053b376/) | [\[中文\] XCode 虛擬目錄萬年問題探究與我的開源工具解決方案](https://zhgchg.li/posts/zrealm-dev/xcode-%E8%99%9B%E6%93%AC%E7%9B%AE%E9%8C%84%E8%BD%89%E5%AF%A6%E9%AB%94%E7%9B%AE%E9%8C%84-%E8%A7%A3%E6%B1%BA%E5%B0%88%E6%A1%88%E7%B5%90%E6%A7%8B%E6%B7%B7%E4%BA%82%E8%88%87-xcodegen-tuist-%E6%95%B4%E5%90%88%E7%97%9B%E9%BB%9E-fd719053b376/)

The entire project is written in Swift and runs as an SPM command-line tool.

You can modify the source code by opening `Package.swift` if needed.

## Inspiration & Dependencies
- [synx](https://github.com/venmo/synx)
- [xcodeproj](https://github.com/tuist/xcodeproj)
- [Yams](https://github.com/jpsim/Yams)

## About
- [ZhgChg.Li](https://zhgchg.li/)
- [ZhgChgLi's Medium](https://blog.zhgchg.li/)

## Other works
### Swift Libraries
- [ZMarkupParser](https://github.com/ZhgChgLi/ZMarkupParser) is a pure-Swift library that helps you to convert HTML strings to NSAttributedString with customized style and tags.
- [ZPlayerCacher](https://github.com/ZhgChgLi/ZPlayerCacher) is a lightweight implementation of the AVAssetResourceLoaderDelegate protocol that enables AVPlayerItem to support caching streaming files.

### Integration Tools
- [ZReviewTender](https://github.com/ZhgChgLi/ZReviewTender) is a tool for fetching app reviews from the App Store and Google Play Console and integrating them into your workflow.
- [ZMediumToMarkdown](https://github.com/ZhgChgLi/ZMediumToMarkdown) is a powerful tool that allows you to effortlessly download and convert your Medium posts to Markdown format.
- [linkyee](https://github.com/ZhgChgLi/linkyee) is a fully customized, open-source LinkTree alternative deployed directly on GitHub Pages.



# Donate

[![Buy Me A Beer](https://github.com/user-attachments/assets/63f01edf-2aa5-4d91-8f8a-861e5b6b4feb)](https://www.paypal.com/ncp/payment/CMALMPT8UUTY2)

If you find this library helpful, please consider starring the repo or recommending it to your friends.

Feel free to open an issue or submit a fix/contribution via pull request. :)
