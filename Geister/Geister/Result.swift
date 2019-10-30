import Foundation
import RealmSwift
import UIKit

class Result: Object {
    // 商品名
    @objc dynamic var fieldResult = [[Int]]()
    // 数量
    @objc dynamic var turnResult = 0
    
    @objc dynamic var winresult = 0
}
