# Harness Detection

Use this file when identifying how the target is tested.

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
