import XCTest

@MainActor
final class ScaffoldUITests: XCTestCase {
    func testOnboardingNavigationAndLocalTuning() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()
        defer { app.terminate() }
        let explore = app.buttons["onboarding.continue"]
        XCTAssertTrue(explore.waitForExistence(timeout: 15))
        explore.click()
        XCTAssertTrue(app.staticTexts["Ready to focus"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["Start focus"].isEnabled)
        let screenshot = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        screenshot.name = "Dashboard"
        screenshot.lifetime = .keepAlways
        add(screenshot)

        app.staticTexts["Sound Library"].firstMatch.click()
        let apply = app.buttons["tuning.apply"]
        XCTAssertTrue(apply.waitForExistence(timeout: 5))
        apply.click()
        XCTAssertTrue(app.staticTexts["Tuning saved on this Mac."].waitForExistence(timeout: 5))

        app.staticTexts["Insights"].firstMatch.click()
        XCTAssertTrue(app.staticTexts["Your focus, over time"].exists)
        app.staticTexts["History"].firstMatch.click()
        XCTAssertTrue(app.staticTexts["No sessions yet"].exists)

        app.typeKey(",", modifierFlags: .command)
        XCTAssertTrue(app.staticTexts["Privacy & Mac integration"].waitForExistence(timeout: 5))
        app.terminate()
    }

    func testTuningAndOnboardingSurviveAppRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launchEnvironment["FLOWSTATE_TEST_RUN_ID"] = UUID().uuidString
        app.launch()
        defer { app.terminate() }
        let explore = app.buttons["onboarding.continue"]
        XCTAssertTrue(explore.waitForExistence(timeout: 15))
        explore.click()
        app.staticTexts["Sound Library"].firstMatch.click()
        let slider = app.sliders["tuning.structure"]
        XCTAssertTrue(slider.waitForExistence(timeout: 5))
        let percentage = app.textFields["tuning.structurePercentage"]
        percentage.click()
        percentage.typeKey("a", modifierFlags: .command)
        percentage.typeText("75%")
        percentage.typeKey(.return, modifierFlags: [])
        let soundScreenshot = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        soundScreenshot.name = "Sound tuning"
        soundScreenshot.lifetime = .keepAlways
        add(soundScreenshot)
        let savedValue = try XCTUnwrap(slider.value as? NSNumber).doubleValue
        XCTAssertEqual(savedValue, 0.75, accuracy: 0.001)
        app.buttons["tuning.apply"].click()
        XCTAssertTrue(app.staticTexts["Tuning saved on this Mac."].waitForExistence(timeout: 5))
        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["Ready to focus"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["onboarding.continue"].exists)
        app.staticTexts["Sound Library"].firstMatch.click()
        XCTAssertTrue(slider.waitForExistence(timeout: 5))
        XCTAssertEqual(try XCTUnwrap(slider.value as? NSNumber).doubleValue, savedValue)
        app.typeKey("w", modifierFlags: .command)
        XCTAssertEqual(app.windows.count, 0)
        XCTAssertNotEqual(app.state, .notRunning)
        app.terminate()
    }
}
