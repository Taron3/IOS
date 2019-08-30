//
//  main.swift
//  TicTacToe
//
//  Created by 3 on 8/26/19.
//  Copyright © 2019 Taron. All rights reserved.
//

struct Matrix<T> {
    let row: Int
    let column: Int
    var matrix: [T?]
    
    init(_ row: Int, _ column: Int, defaultValue: T? = nil) {
        self.row = row
        self.column = column
        
        matrix = Array(repeating: defaultValue, count: row * column)
    }
    
    subscript(i: Int, j: Int) -> T? {
        get {
            return matrix[j + column * i]
        }
        set {
            matrix[j + column * i] = newValue
        }
    }
}

struct TicTacToe {
    enum BoardSize: Int {
        case small = 3
        case medium = 10
        case large = 30
        
        var side: Int {
            return self.rawValue
        }
    }
    
    var board: Matrix<Character>
    var isFirstPlayer = true
    
    init(boardSize: BoardSize) {
        board = Matrix<Character>(boardSize.side, boardSize.side)
    }
    
    mutating func game() -> Bool {
        let coordinates = readCoordinates()
        guard let i = coordinates?.rowCoordinate, let j = coordinates?.columnCoordinate else {
            fatalError()
        }
        
        if isFirstPlayer && board[i, j] == nil {
            print("\nO's Turn")
            isFirstPlayer = false
            board[i, j] = "X"
            if isWinner(rowCoordinate: i, columnCoordinate: j, char: "X") {
                print("\n\n\nCongratulation 🥇\nX Wins!\n\n")
                return true
            }
        } else if !isFirstPlayer && board[i, j] == nil {
            print("\nX's Turn")
            isFirstPlayer = true
            board[i, j] = "O"
            if isWinner(rowCoordinate: i, columnCoordinate: j, char: "O") {
                print("\n\n\nCongratulation 🥇\nO Wins!\n\n")
                return true
            }
        }
        return false
    }
  
    func isWinner(rowCoordinate i: Int, columnCoordinate j: Int, char: Character) -> Bool {
        var winingRow: Int { return board.row == 3 ? 3 : 5 }

        var boardResultBuffer = [Character]()
        
        //fill row
        for n in j - (winingRow - 1)...j + (winingRow - 1) {
            if n < 0 || n > board.row - 1 {
                continue
            }

            if let boardResult = board[i, n] {
                boardResultBuffer.append(boardResult)
            } else {
                boardResultBuffer.append(" ")
            }
        }
        if boardResultBuffer.hasSubsequence(of: char, count: winingRow) {
            return true
        }
        
        boardResultBuffer = []
        // fill diagonal
        for m in -(winingRow - 1)...(winingRow - 1) {
            if i + m < 0 || i + m > board.row - 1
            || j + m < 0 || j + m > board.row - 1 {
                continue
            }

            if let boardResult = board[i + m, j + m] {
                boardResultBuffer.append(boardResult)
            } else {
                boardResultBuffer.append(" ")
            }
        }
        if boardResultBuffer.hasSubsequence(of: char, count: winingRow) {
            return true
        }
        
        boardResultBuffer = []
        // fill column
        for m in i - (winingRow - 1)...i + (winingRow - 1) {
            if m < 0 || m > board.row - 1 {
                continue
            }

            if let boardResult = board[m, j] {
                boardResultBuffer.append(boardResult)
            } else {
                boardResultBuffer.append(" ")
            }
        }
        if boardResultBuffer.hasSubsequence(of: char, count: winingRow) {
            return true
        }
        
        boardResultBuffer = []
        // fill antidiagonal
        for m in -(winingRow - 1)...(winingRow - 1) {
            if i + m < 0 || i + m > board.row - 1
            || j - m < 0 || j - m > board.row - 1 {
                continue
            }
            
            if let boardResult = board[i + m, j - m] {
                boardResultBuffer.append(boardResult)
            } else {
                boardResultBuffer.append(" ")
            }
        }
        
        return boardResultBuffer.hasSubsequence(of: char, count: winingRow)
    }
    
    
    
}


extension Array where Element == Character {
    func hasSubsequence(of character: Character, count: Int) -> Bool {
        let splits = (self.count - count) <= 0 ? 1 : self.count // abs(self.count - count) + 1
        
        let splitted = self.split(maxSplits: splits, omittingEmptySubsequences: false) { $0 != character }
        return splitted.first { $0.count >= count } != nil
    }
}

extension String {
    mutating func replaceCharacter(at index: Int, with character: String) {
        let idx = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(idx...idx, with: String(character))
    }
}

func matrixOutline(row: Int, column: Int) -> [String] {
    let firstLine = "┏━━━━━" + String(repeating: "┳━━━━━", count: column - 1) + "━━┓"
    let verticalSpacingLine = String(repeating: "┃     ", count: column) + "  ┃"
    let verticalSeparatingLine = "┣━━━━━" + String(repeating: "╋━━━━━", count: column - 1) + "━━┫"
    let lastLine = "┗━━━━━" + String(repeating: "┻━━━━━", count: column - 1) + "━━┛"
    
    var lines = [firstLine]
    
    for _ in 0..<row - 1 {
        lines += [verticalSpacingLine, verticalSeparatingLine]
    }
    lines += [verticalSpacingLine, lastLine]
    return lines
}

extension TicTacToe: CustomStringConvertible {
    var description: String {
        var lines = matrixOutline(row: board.row, column: board.column)
        var str = ""
        for i in 0..<board.row {
            for j in 0..<board.column {
                if let boardResult = board[i, j] {
                    lines[i + (i + 1)].replaceCharacter(at: 3 + 6 * j, with: String(boardResult)) // at: 2 + 4 * j
                    
                    str = lines.joined(separator: "\n")
                } else {
                    lines[i + (i + 1)].replaceCharacter(at: 3 + 6 * j, with: String(i))
                    lines[i + (i + 1)].replaceCharacter(at: 5 + 6 * j, with: String(j))
                    str = lines.joined(separator: "\n")
                }
            }
        }
        return str
    }
}


func readCoordinates() -> (rowCoordinate: Int, columnCoordinate: Int)? {
    var input: String?
    repeat {
        print("Input coordinates  i. j: ", terminator: "")
        input = readLine(strippingNewline: true)
        if let input = input, let coordinates = getCoordinates(from: input) {
            return coordinates
        }
    } while input != nil
    
    return nil
}

func getCoordinates(from str: String) -> (Int, Int)? {
    let components = str.filter { !$0.isWhitespace }.split(separator: ".")
    guard components.count >= 2, let rowCoordinate = Int(components[0]), let columnCoordinate = Int(components[1]) else {
        return nil
    }
    
    return (rowCoordinate, columnCoordinate)
}


var ticTacToe = TicTacToe(boardSize: .medium)
gameLoop: while true {
    print(ticTacToe)
    if ticTacToe.game() {
        break gameLoop
    }
}

