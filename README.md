# XCFolder

<p align="center">
  <img width="700" alt="image" src="https://github.com/user-attachments/assets/27df3d5c-0ad8-46aa-842d-10aaf0bbaeb0" />
</p>

XCFolder is a powerful tool that converts Xcode virtual groups into actual directories (associated folder), enabling seamless integration with modern xcode project gen tools like Tuist and XcodeGen.

By ensuring perfect synchronization between your Xcode project structure and the filesystem, XCFolder simplifies project organization, enhances maintainability, and improves workflow efficiency.

## Key Features
- **Smart Group Conversion**: Intelligently transforms Xcode virtual groups into physical directories while preserving project structure
- **Perfect Synchronization**: Maintains 1:1 mapping between Xcode project navigator and filesystem directories
- **Automated Organization**: Eliminates manual folder management with automated synchronization
- **Migration Ready**: Prepares your project structure for modern build systems like Tuist and XcodeGen

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

# Whether to move files only, without changing .xcodeproj settings
moveFileOnly: false
```

### Step 2. Run with Swift
```
cd ./XCFolder
swift run XCFolder YOUR_XCODEPROJ_FILE.xcodeproj ./Configuration.yaml
```
#### For example
```
swift run XCFolder ./TestProject/DCDeviceTest.xcodeproj ./Configuration.yaml
```

### Step 3. Wait for the execution to complete.

![image](https://github.com/user-attachments/assets/e8e6a4fe-5bf7-40f5-8d17-521a42da97b4)

### Step 4: Done, Have a great day! 🚀🚀🚀

![image](https://github.com/user-attachments/assets/65025508-a309-4249-b63d-de5148f8203b)

## Technical Details
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
- [ZNSTextAttachment](https://github.com/ZhgChgLi/ZNSTextAttachment) enables NSTextAttachment to download images from remote URLs, support both UITextView and UILabel.

### Integration Tools
- [ZReviewTender](https://github.com/ZhgChgLi/ZReviewTender) is a tool for fetching app reviews from the App Store and Google Play Console and integrating them into your workflow.
- [ZMediumToMarkdown](https://github.com/ZhgChgLi/ZMediumToMarkdown) is a powerful tool that allows you to effortlessly download and convert your Medium posts to Markdown format.
- [linkyee](https://github.com/ZhgChgLi/linkyee) is a fully customized, open-source LinkTree alternative deployed directly on GitHub Pages.



# Donate

[![Buy Me A Coffe](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20beer!&emoji=%F0%9F%8D%BA&slug=zhgchgli&button_colour=FFDD00&font_colour=000000&font_family=Bree&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/zhgchgli)

If you find this library helpful, please consider starring the repo or recommending it to your friends.

Feel free to open an issue or submit a fix/contribution via pull request. :)
