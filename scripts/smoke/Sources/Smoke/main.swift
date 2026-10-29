import TALibKit

guard TA_Initialize() == TA_SUCCESS else { fatalError("TA_Initialize failed") }

let input: [Double] = [1, 2, 3, 4, 5]
var begIdx: Int32 = 0
var outCount: Int32 = 0
var output = [Double](repeating: 0, count: input.count)

let rc = TA_SMA(0, Int32(input.count - 1), input, 3, &begIdx, &outCount, &output)
let sma = Array(output.prefix(Int(outCount)))

guard rc == TA_SUCCESS, begIdx == 2, sma == [2, 3, 4] else {
    fatalError("TA_SMA returned \(rc), begIdx \(begIdx), values \(sma)")
}
print("TALibKit OK, TA-Lib \(String(cString: TA_GetVersionString()))")
