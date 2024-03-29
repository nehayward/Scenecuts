import Foundation

final class SceneStatusBarItem: Identifiable, Equatable, Hashable, ObservableObject {

    var id: UUID = UUID()
    let name: String
    let shortcut: String
    let actionType: ActionSet.ActionType
    var sortPosition: Int? = nil

    @Published var iconName: String {
        didSet {
            StatusBarController.shared.updateMenuItems()
            store(value: iconName, forKey: .iconName)
        }
    }
    
    @Published var isInMenuBar: Bool {
        didSet {
            store(value: isInMenuBar, forKey: .isInMenuBar)
            if isInMenuBar {
                StatusBarController.shared.statusItems[name] = StatusBarController.shared.createStatusItem(from: self)
            } else {
                StatusBarController.shared.statusItems.removeValue(forKey: name)
            }
        }
    }
    
    @Published var showInMenuList: Bool {
        didSet {
            store(value: showInMenuList, forKey: .showInMenuList)
            if showInMenuList {
                StatusBarController.shared.updateMenuItems()
            } else {
                StatusBarController.shared.removeMenuItem(with: name)
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(iconName)
        hasher.combine(isInMenuBar)
        hasher.combine(showInMenuList)
    }
    
    static func == (lhs: SceneStatusBarItem, rhs: SceneStatusBarItem) -> Bool {
        lhs.name == rhs.name &&
        lhs.iconName == rhs.iconName &&
        lhs.shortcut == rhs.shortcut &&
        lhs.isInMenuBar == rhs.isInMenuBar &&
        lhs.showInMenuList == rhs.showInMenuList
    }
    
    internal init(id: UUID = UUID(), name: String, iconName: String, shortcut: String, actionType: ActionSet.ActionType, isInMenuBar: Bool, showInMenuList: Bool) {
        self.id = id
        self.name = name
        self.shortcut = shortcut
        self.actionType = actionType
        self.iconName = iconName
        self.isInMenuBar = isInMenuBar
        self.showInMenuList = showInMenuList
    }
}

extension SceneStatusBarItem {
    func store<T>(value: T, forKey key: Keys) {
        UserDefaults.standard.setValue(value, forKey: "\(name).\(key.rawValue)")
    }
    
    static func value<T>(name: String, forKey key: Keys) -> T? {
        UserDefaults.standard.value(forKey: "\(name).\(key.rawValue)") as? T
    }
    
    enum Keys: String {
        case iconName
        case isInMenuBar
        case showInMenuList
    }
}
