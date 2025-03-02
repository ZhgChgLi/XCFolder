# XCFolder

<p align="center">
  <img width="700" alt="image" src="https://github.com/user-attachments/assets/82da28b2-5161-4379-90f0-4ba331f76b88" />
</p>

XCFolder is a powerful utility that converts Xcode virtual folders (group) into real filesystem directories (folder), facilitating seamless migration to modern build systems like Tuist or XcodeGen.

This tool ensures perfect synchronization between your Xcode project structure and the actual filesystem organization, making project maintenance more intuitive and efficient.

## Key Features
- **Smart Group Conversion**: Intelligently transforms Xcode virtual groups into physical directories while preserving project structure
- **Perfect Synchronization**: Maintains 1:1 mapping between Xcode project navigator and filesystem directories
- **Automated Organization**: Eliminates manual folder management with automated synchronization
- **Migration Ready**: Prepares your project structure for modern build systems like Tuist and XcodeGen

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

# Allowed file types to include when scanning
allowFileTypes:
- "sourcecode.swift"      # Swift source code files
- "sourcecode.c.objc"     # Objective-C source code files
- "sourcecode.cpp.objcpp" # Objective-C++ source code files  
- "sourcecode.c.h"        # C/Objective-C header files
- "file.xib"             # Interface Builder XIB files
- "file.storyboard"      # Interface Builder Storyboard files
- "folder.assetcatalog"  # Asset catalog containing images and resources
- "text.json.xcstrings"  # Localized strings in JSON format
- "text.plist.strings"   # Localized strings in plist format

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
<img width="700" alt="image" src="https://github.com/user-attachments/assets/778c6edc-28df-465c-9c96-7fa866943cc1" />


### Step 4: Done, Have a great day! 🚀🚀🚀
<img width="700" alt="image" src="https://github.com/user-attachments/assets/615acad8-647e-41f5-aee6-ebf7280d30c5" />

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
