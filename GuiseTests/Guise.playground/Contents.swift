//: Playground - noun: a place where people can play

import Cocoa
import Guise

protocol Zing: class {}
class Watusi: Zing {}

let watusi = Watusi()
_ = Guise.register{ [weak watusi] in watusi as Zing? }
if Guise.exists(type: Zing?.self, name: Name.default, container: Name.default), let w = Guise.resolve()! as Zing? {
    w
}

// Register a bunch of plugins anonymously in Container.plugin.
_ = Guise.register(name: UUID(), container: Container.plugin, metadata: PluginType.editor) { Plugin1() as Plugin }
_ = Guise.register(name: UUID(), container: Container.plugin, metadata: PluginType.viewer) { Plugin2() as Plugin }
let key = Guise.register(name: UUID(), container: Container.plugin, metadata: PluginType.viewer) { Plugin3() as Plugin }

Guise.metadata(for: key) as PluginType?

var viewerKeys = Guise.filter(type: Plugin.self, container: Container.plugin, metadata: PluginType.viewer)

let viewers = Guise.resolve(keys: viewerKeys) as [Plugin]

let pluginKeys = Guise.filter(container: Container.plugin)
Guise.unregister(keys: pluginKeys)
Guise.filter(container: Container.plugin).count

