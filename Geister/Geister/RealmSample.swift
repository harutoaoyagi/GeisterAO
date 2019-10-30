import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var name = "" // dynamicはとりあえずつける. objcから使うため?
    @objc dynamic var age  = 0
    @objc dynamic var sex  = ""
}
