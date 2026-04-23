# Harness Detection

Use this file when identifying how the target is tested.

Start by checking source imports and the test action output. A target can mix
XCTest and Swift Testing files, but filters still need the generated test
identifier that Xcode reports.

```bash
rg -n 'import (XCTest|Testing)|XCTestCase|@Test|@Suite' <test-path>
```

## XCTest

- Files import `XCTest`
- Test types subclass `XCTestCase`
- Methods are named `test...`
- Filter shape:

```text
-only-testing:MyTargetTests/MyClass/testMethod
```

## Swift Testing

- Files import `Testing`
- Tests use `@Test` and optional `@Suite`
- Assertions use `#expect` and `#require`
- Filter shape:

```text
-only-testing:MyTargetTests/MySuite/myTest()
```

Both harnesses still run through `xcodebuild test` against the visionOS
simulator unless the project deliberately split them into separate schemes.

## Result Clues

- XCTest failures usually report a class and method.
- Swift Testing failures usually report a suite and test function or generated
  display name.
- If `-only-testing:` reports no matching tests, copy the identifier from the
  last successful discovery or result report before changing code.
