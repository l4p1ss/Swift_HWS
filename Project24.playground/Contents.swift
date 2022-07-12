import UIKit

// CHALLENGE 1

extension String {
  func withPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return String(prefix+self) }
    return self
  }
}
var str = "pet"
str.withPrefix("car")

// CHALLENGE 2

extension String {
    var isNumeric: Bool {
        guard Double(self) == nil else { return true }
        return false
    }
}

"456".isNumeric
"xcv".isNumeric
"2.13".isNumeric
"alpha".isNumeric

// CHALLENGE 3

extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

var testString = "this\nis\na\ntest"
testString.lines
