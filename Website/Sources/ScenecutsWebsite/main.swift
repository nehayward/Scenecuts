import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct ScenecutsWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case pages
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://nehayward.github.io/scenecuts")!
    var name = "Scenecuts"
    var description = "A simple menu bar app to control HomeKit"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try ScenecutsWebsite().publish(
     withTheme: .foundation,
     deployedUsing: .gitHub("nehayward/scenecuts", useSSH: false)
)
