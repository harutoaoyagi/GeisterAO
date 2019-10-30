import UIKit

class AI {
    var AIFieldC : [[Int]] = [[0,0,0,0,0,0],
                              [0,0,0,0,0,0],
                              [0,0,0,0,0,0],
                              [0,0,0,0,0,0],
                              [0,0,0,0,0,0],
                              [0,0,0,0,0,0]]
    
    var AIFieldPrediction : [[Int]] = [[0,0,0,0,0,0],
                                       [0,0,0,0,0,0],
                                       [0,0,0,0,0,0],
                                       [0,0,0,0,0,0],
                                       [0,0,0,0,0,0],
                                       [0,0,0,0,0,0]]
    
    var AIPointField : [[Int]] = [[0,0],[0,0]]
    //配置決め
    func komaAIPlace() -> [[Int]] {
        
        let placeRandam = random(lower: 1, upper: 5)
        
        switch placeRandam {
        case 1:
            AIFieldC[1][0] = 4
            AIFieldC[2][0] = 4
            AIFieldC[3][0] = 4
            AIFieldC[4][0] = 3
            AIFieldC[1][1] = 3
            AIFieldC[2][1] = 4
            AIFieldC[3][1] = 3
            AIFieldC[4][1] = 3
        case 2:
            AIFieldC[1][0] = 4
            AIFieldC[2][0] = 3
            AIFieldC[3][0] = 3
            AIFieldC[4][0] = 3
            AIFieldC[1][1] = 4
            AIFieldC[2][1] = 4
            AIFieldC[3][1] = 4
            AIFieldC[4][1] = 3
        case 3:
            AIFieldC[1][0] = 4
            AIFieldC[2][0] = 3
            AIFieldC[3][0] = 3
            AIFieldC[4][0] = 4
            AIFieldC[1][1] = 4
            AIFieldC[2][1] = 3
            AIFieldC[3][1] = 3
            AIFieldC[4][1] = 4
        case 4:
            AIFieldC[1][0] = 4
            AIFieldC[2][0] = 3
            AIFieldC[3][0] = 4
            AIFieldC[4][0] = 3
            AIFieldC[1][1] = 4
            AIFieldC[2][1] = 3
            AIFieldC[3][1] = 4
            AIFieldC[4][1] = 3
        case 5:
            AIFieldC[1][0] = 4
            AIFieldC[2][0] = 4
            AIFieldC[3][0] = 4
            AIFieldC[4][0] = 4
            AIFieldC[1][1] = 3
            AIFieldC[2][1] = 3
            AIFieldC[3][1] = 3
            AIFieldC[4][1] = 3
            
        default:break
        }
        return AIFieldC
    }
    //AIの移動
    func move(field: [[Int]],turn: Int,userRed: Int,userBlue: Int) -> [[Int]] {
        AIFieldC = field
        
        var cX = 0
        var cY = 0
        var komaColor = 0
        var pointA = 0
        
        var komaTypeA = [(x: Int,y: Int,komaColor: Int,point: Int)]()
        var komaTypeB = [(x: Int,y: Int,komaColor: Int,point: Int)]()
        
        var checkplace = [0]
        //動けるコマを探す
        for i in 0..<6 {
            for j in 0..<6 {
                switch field[i][j] {
                case 3:
                    checkplace = checkPlace(field: field, x: i, y: j, color: 0)
                    if checkplace.reduce(0, { (a: Int, b: Int) -> Int in a + b }) >= 1 {
                        cX = i
                        cY = j
                        komaColor = 3
                        pointA = komaPointCheck(field: field, x: i,y: j,turn: turn,userRed: userRed)
                        komaTypeA.append((x: cX,y: cY,komaColor: komaColor,point: pointA))
                    }
                case 4:
                    checkplace = checkPlace(field: field, x: i, y: j, color: 0)
                    if checkplace.reduce(0, { (a: Int, b: Int) -> Int in a + b }) >= 1 {
                        cX = i
                        cY = j
                        komaColor = 4
                        pointA = komaPointCheck(field: field, x: i,y: j,turn: turn,userRed: userRed)
                        komaTypeA.append((x: cX,y: cY,komaColor: komaColor,point: pointA))
                    }
                default:break
                }
            }
        }
        print(komaTypeA)
        var maxvalue1 = 0
        var maxindex1 = 0
        //最高点検索
        for i in 0 ..< komaTypeA.count {
            if komaTypeA[i].point > maxvalue1 {
                maxvalue1 = komaTypeA[i].point
                maxindex1 = i
            }
        }
        //最高点と同じ点を代入
        for i in 0..<komaTypeA.count {
            if maxvalue1 == komaTypeA[i].point {
                komaTypeB.append(komaTypeA[i])
            }else{
                komaTypeB.append(komaTypeA[maxindex1])
            }
        }
        print(komaTypeB)
        let typeRandom = random(lower: 0, upper: UInt32(komaTypeB.count))
        
        var goodPlaceX = 0
        var goodPlaceY = 0
        var color = 0
        
        goodPlaceX = komaTypeB[typeRandom].x
        goodPlaceY = komaTypeB[typeRandom].y
        color = komaTypeB[typeRandom].komaColor
        
        let goodPlaceA = checkPlace(field: field, x: goodPlaceX, y: goodPlaceY,color: color)
        
        let goodPlaceB = goodPointCheck(field: field,place: goodPlaceA, userRed: userRed, userBlue: userBlue)
        
        switch goodPlaceB {
        case 1,5:
            AIFieldC[goodPlaceX + 1][goodPlaceY] = color
        case 2,6:
            AIFieldC[goodPlaceX][goodPlaceY + 1] = color
        case 3,7:
            AIFieldC[goodPlaceX - 1][goodPlaceY] = color
        case 4,8:
            AIFieldC[goodPlaceX][goodPlaceY - 1] = color
        case 9:
            AIFieldC[0][1] = 5
            print(AIFieldC)
            return AIFieldC
        case 10:
            AIFieldC[1][1] = 5
            print(AIFieldC)
            return AIFieldC
        default:break
        }
        AIFieldC[goodPlaceX][goodPlaceY] = 0
        print(AIFieldC)
        return AIFieldC 
    }
    //空いているか、敵がいるか確認
    func checkPlace(field: [[Int]],x: Int,y: Int,color: Int) -> [Int] {
        
        var canPutPlace = [0]
        //右
        if x < 5 && field[x + 1][y] == 0 {
            canPutPlace.append(1)
        }else if x < 5 && field[x + 1][y] == 1 {
            canPutPlace.append(5)
        }
        //下
        if y < 5 && field[x][y + 1] == 0 {
            canPutPlace.append(2)
        }else if y < 5 && field[x][y + 1] == 1 {
            canPutPlace.append(6)
        }
        //左
        if x > 0 && field[x - 1][y] == 0 {
            canPutPlace.append(3)
        }else if x > 0 && field[x - 1][y] == 1 {
            canPutPlace.append(7)
        }
        //上
        if y > 0 && field[x][y - 1] == 0 {
            canPutPlace.append(4)
        }else if y > 0 && field[x][y - 1] == 1 {
            canPutPlace.append(8)
        }
        //脱出ができる場合
        if color == 4{
            if field[0][5] == 4 {
                canPutPlace.append(9)
            }
            
            if field[5][5] == 4 {
                canPutPlace.append(10)
            }
        }
        return canPutPlace
    }
    //動かせるコマを点数化
    func komaPointCheck(field: [[Int]],x: Int,y: Int,turn: Int,userRed: Int) -> Int {
        var point = 0
        //確実に勝てる
        if field[x][y] == 4 && (x == 0 && y == 5) {
            point = 100
            return point
        }else if field[x][y] == 4 && (x == 5 && y == 5) {
            point = 100
            return point
        }
        //相手の赤のコマ数でさ基本点を変更
        if userRed == 4 || userRed == 3 {
            if field[x][y] == 3 {
                point = 50
            }else if field[x][y] == 4 {
                point = 45
            }
            
        }else if userRed == 2 || userRed == 1 {
            if field[x][y] == 3 {
                point = 45
            }else if field[x][y] == 4 {
                point = 50
            }
        }
        //Y軸３から上に敵がいる場合加点
        for i in 0..<6 {
            for j in 0..<4 {
                if field[i][j] == 1 && j <= 2 {
                    //X軸３より右に敵がいた場合加点
                    if i >= 3 && x >= 3 {
                        if y == 0 {
                            point += 10
                        }else if y == 1 {
                            point += 8
                        }else if y == 2 {
                            point += 5
                        }
                    //X軸２より左に敵がいた場合加点
                    }else if i <= 2 && x <= 2 {
                        if y == 0 {
                            point += 10
                        }else if y == 1 {
                            point += 8
                        }else if y == 2 {
                            point += 5
                        }
                    }
                }
            }
        }
        
        print(point)
        return point
    }
    //おける場所を点数化
    func goodPointCheck(field: [[Int]],place: [Int],userRed: Int,userBlue: Int) -> Int {
        var point = 0
        var putPlace = [(komaColor: Int,point2: Int)]()
        var putPlaceSub = [(komaColor: Int,point2: Int)]()
        let total = userRed + userBlue
        //初期の点数固定
        for i in 0..<place.count{
            switch place[i] {
            case 1,2,3:
                point = 45
            case 4:
                point = 40
            case 5,6,7,8:
                point = 50
            case 9,10:
                point = 100
                print(place[i])
                return place[i]
            default:break
            }
            //Y軸３から上に敵がいる場合加点
            for j in 0..<6{
                for k in 0..<6{
                    if field[j][k] == 1{
                        //X軸２より右に敵がいた場合加点
                        if j <= 2 && k <= 2{
                            switch place[i] {
                            case 3,4,7,8:
                                point += 10
                            default:break
                            }
                        //X軸３より左に敵がいた場合加点
                        }else if j >= 3 && k <= 2{
                            switch place[i] {
                            case 1,4,5,8:
                                point += 10
                            default:break
                            }
                        }
                    }
                }
            }
            //敵の赤が３つ、合計６個になった場合加点
            if total <= 6 && userRed <= 3{
                switch place[i] {
                case 2:
                    point += 5
                default:break
                }
            }
            //敵の赤が２以下になった場合減点
            if userRed <= 2{
                switch place[i] {
                case 5,6,7,8:
                    point -= 5
                default:break
                }
            }
            
            putPlace.append((komaColor: place[i],point2: point))
        }
        print(putPlace)
        
        var maxindex1 = 1
        var maxvalue1 = 0
        //最高点を検索
        for i in 0 ..< putPlace.count {
            if putPlace[i].point2 > maxvalue1 {
                maxvalue1 = putPlace[i].point2
                maxindex1 = i
            }
            
        }
        //最高点と同じ値を代入
        for i in 0..<putPlace.count{
            if maxvalue1 == putPlace[i].point2{
                putPlaceSub.append(putPlace[i])
            }else{
                putPlaceSub.append(putPlace[maxindex1])
            }
        }
        
        let putRandom = random(lower: 1, upper: UInt32(putPlaceSub.count))
        
        let pointlast = putPlaceSub[putRandom].komaColor
        
        return pointlast
    }
}
//乱数
func random(lower: UInt32, upper: UInt32) -> Int {
    guard upper >= lower else {
        return 0
    }
    
    return Int(arc4random_uniform(upper - lower) + lower)
}
