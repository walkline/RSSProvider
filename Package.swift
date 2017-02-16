import PackageDescription

let package = Package(
    name: "RSSProvider",
    dependencies: [
        .Package(url: "https://github.com/tadija/AEXML.git", majorVersion: 4)
    ]
)
