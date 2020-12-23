import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DefaultValuesTests.allTests),
        testCase(SQLiteStatementTests.allTests),
    ]
}
#endif
