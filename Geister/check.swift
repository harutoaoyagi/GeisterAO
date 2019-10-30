import UIKit

class Check {
    //
    func komaCheck(field: [[Int]],x: Int,y: Int) -> Int {
        var komaType = 0
        //オバケの種類確認 1:ユーザー青オバケ,2:ユーザー赤オバケ,3:AI赤オバケ,4:AI青オバケ
        switch field[x][y] {
        case 1:
            komaType = 1
        case 2:
            komaType = 2
        default:break
        }
        return komaType
    }
    //コマの色とtag調べる
    func komaCoordinate(field: [[Int]]) -> [(color: Int,tag: Int)] {
        var komaType : [(color: Int,tag: Int)] = []
        
        var ghostBCoordinateA = 0
        var ghostRCoordinateA = 0
        var ghostBCoordinateU = 0
        var ghostRCoordinateU = 0
        var ghostcolor = 0
        
        for i in 0..<6 {
            for j in 0..<6 {
                switch field[i][j] {
                case 1:
                    ghostcolor = 1
                    ghostBCoordinateU = ((i + 1) * 10 + (j + 2))
                    komaType.append((color:ghostcolor,tag:ghostBCoordinateU))
                case 2:
                    ghostcolor = 2
                    ghostRCoordinateU = ((i + 1) * 10 + (j + 2))
                    komaType.append((color:ghostcolor,tag:ghostRCoordinateU))
                case 3:
                    ghostcolor = 3
                    ghostRCoordinateA = ((i + 1) * 10 + (j + 2))
                    komaType.append((color:ghostcolor,tag:ghostRCoordinateA))
                case 4:
                    ghostcolor = 4
                    ghostBCoordinateA = ((i + 1) * 10 + (j + 2))
                    komaType.append((color:ghostcolor,tag:ghostBCoordinateA))
                default:break
                }
            }
        }
        return komaType
    }
    //オバケの周囲４方向のtag確認
    func checkTag(field: [[Int]],x: Int,y: Int,order: Int,turn: Int) -> ( Right: Int, Down: Int, Left: Int, Up: Int) {
        
        var fieldTagR = 0
        var fieldTagD = 0
        var fieldTagL = 0
        var fieldTagU = 0
        var exportResult = 0
        
        exportResult = exportCheck(field: field, x: x, y: y, order: order, turn: turn)
        
        switch exportResult {
        case 1:
            fieldTagU = 11
        case 2:
            fieldTagU = 61
        default:break
        }
        //右
        if x < 5 && field[x + 1][y] == 0 {
            fieldTagR = (x + 2) * 10 + (y + 2)
        }else if (x < 5 && (field[x + 1][y] == 3 || field[x + 1][y] == 4)) && (order + turn) % 2 == 1 {
            fieldTagR = (x + 2) * 10 + (y + 2)
        }
        //下
        if y < 5 && field[x][y + 1] == 0 {
            fieldTagD = (x + 1) * 10 + (y + 3)
        }else if (y < 5 && (field[x][y + 1] == 3 || field[x][y + 1] == 4)) && (order + turn) % 2 == 1 {
            fieldTagD = (x + 1) * 10 + (y + 3)
        }
        //左
        if x > 0 && field[x - 1][y] == 0 {
            fieldTagL = x * 10 + (y + 2)
        }else if (x > 0 && (field[x - 1][y] == 3 || field[x - 1][y] == 4)) && (order + turn) % 2 == 1 {
            fieldTagL = x * 10 + (y + 2)
        }
        //上
        if y > 0 && field[x][y - 1] == 0 {
            fieldTagU = (x + 1) * 10 + (y + 1)
        }else if (y > 0 && (field[x][y - 1] == 3 || field[x][y - 1] == 4)) && (order + turn) % 2 == 1 {
            fieldTagU = (x + 1) * 10 + (y + 1)
        }
        return (fieldTagR,fieldTagD,fieldTagL,fieldTagU)
    }
    //脱出前の確認
    func exportCheck(field: [[Int]],x: Int,y: Int,order: Int,turn: Int) -> Int {
        var pointKoma = 0
        
        if ((x == 0 && y == 0) && field[x][y] == 1) && (order + turn) % 2 == 1 {
            pointKoma = 1
        }else if ((x == 5 && y == 0) && field[x][y] == 1) && (order + turn) % 2 == 1 {
            pointKoma = 2
        }else{
            pointKoma = 0
        }
        return pointKoma
    }
    //グリーン背景消去
    func removeBack(mathView: UIView) {
        for subview in mathView.subviews {
            if subview.tag >= 100 && subview.tag <= 103 {
                subview.removeFromSuperview()
            }
        }
    }
    //オバケの数を確認
    func komaCount(field: [[Int]]) -> (blueI: Int,redI: Int,blueE: Int,redE: Int) {
        
        var komaBlue_u = 0
        var komaRed_u = 0
        var komaRed_a = 0
        var komaBlue_a = 0
        
        for i in 0..<6 {
            for j in 0..<6 {
                switch field[i][j] {
                case 1:
                    komaBlue_u += 1
                case 2:
                    komaRed_u += 1
                case 3:
                    komaRed_a += 1
                case 4:
                    komaBlue_a += 1
                default:
                    break
                }
            }
        }
        return (komaBlue_u,komaRed_u,komaRed_a,komaBlue_a)
    }
    //勝敗判定
    func judge(komaTotal: (Int,Int,Int,Int),exportField: [[Int]]) -> Int {
        
        var judgeKind = 0
        //1:ユーザーの勝ち,2:AIの勝ち
        //コマ数勝敗
        if komaTotal.0 == 0 {
            judgeKind = 2
        }else if komaTotal.1 == 0 {
            judgeKind = 1
        }else if komaTotal.2 == 0 {
            judgeKind = 2
        }else if komaTotal.3 == 0 {
            judgeKind = 1
        }
        //脱出勝敗
        for i in 0..<2 {
            for j in 0..<2 {
                if exportField[i][j] == 1 {
                    judgeKind = 1
                }else if exportField[i][j] == 4 {
                    judgeKind = 2
                }
            }
        }
        return judgeKind
    }
}
