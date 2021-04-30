import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DefaultValuesTests.allTests),
        testCase(SQLiteStatement_AlterContextTests.allTests),
        testCase(SQLiteStatement_CreateContextTests.allTests),
        testCase(SQLiteStatement_DeleteContextTests.allTests),
        testCase(SQLiteStatement_InsertContextTests.allTests),
        testCase(SQLiteStatement_SelectContextTests.allTests),
        testCase(SQLiteStatement_UpdateContextTests.allTests),
    ]
}
#endif
