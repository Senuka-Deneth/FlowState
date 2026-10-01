#!/usr/bin/env python3
"""Generate the checked-in Xcode project with the Python standard library only."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
objects = {}


def identifier(name):
    return hashlib.sha256(name.encode()).hexdigest()[:24].upper()


def add(key_name, isa, **values):
    key = identifier(key_name)
    objects[key] = {"isa": isa, **values}
    return key


def configs(name, settings):
    items = []
    for mode in ("Debug", "Release"):
        options = dict(settings)
        options.update({
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone" if mode == "Debug" else "-O",
            "DEBUG_INFORMATION_FORMAT": "dwarf" if mode == "Debug" else "dwarf-with-dsym",
        })
        if mode == "Debug":
            options["ONLY_ACTIVE_ARCH"] = "YES"
            options["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = "DEBUG $(inherited)"
            options["ENABLE_TESTABILITY"] = "YES"
        else:
            options["CODE_SIGN_INJECT_BASE_ENTITLEMENTS"] = "NO"
        items.append(add(f"{name}-{mode}", "XCBuildConfiguration", name=mode, buildSettings=options))
    return add(f"{name}-configs", "XCConfigurationList", buildConfigurations=items,
               defaultConfigurationIsVisible=0, defaultConfigurationName="Release")


def sources(name, paths):
    refs, builds = [], []
    for path in paths:
        relative = str(path.relative_to(ROOT))
        ref = add(relative, "PBXFileReference", lastKnownFileType="sourcecode.swift",
                  path=relative, sourceTree="SOURCE_ROOT")
        refs.append(ref)
        builds.append(add(relative + "-build", "PBXBuildFile", fileRef=ref))
    group = add(name + "-sources", "PBXGroup", children=refs, name=name, sourceTree="<group>")
    phase = add(name + "-compile", "PBXSourcesBuildPhase", buildActionMask=2147483647,
                files=builds, runOnlyForDeploymentPostprocessing=0)
    return group, phase


app_group, app_sources = sources("Application", sorted((ROOT / "App").glob("*.swift")) +
                                sorted((ROOT / "Features").rglob("*.swift")))
test_group, test_sources = sources("UI Tests", sorted((ROOT / "Tests/UITests").glob("*.swift")))
products = []
for name, extension, kind in [("FlowState", "app", "wrapper.application"),
                               ("ScaffoldUITests", "xctest", "wrapper.cfbundle")]:
    products.append(add(name + "-product", "PBXFileReference", explicitFileType=kind,
                        path=f"{name}.{extension}", sourceTree="BUILT_PRODUCTS_DIR"))
product_group = add("products", "PBXGroup", name="Products", children=products, sourceTree="<group>")
config_refs = []
for file, kind in [("App/Info.plist", "text.plist.xml"), ("App/FlowState.entitlements", "text.plist.entitlements"),
                   ("App/PrivacyInfo.xcprivacy", "text.plist.xml")]:
    config_refs.append(add(file, "PBXFileReference", lastKnownFileType=kind, path=file, sourceTree="SOURCE_ROOT"))
config_group = add("configuration", "PBXGroup", name="Configuration", children=config_refs, sourceTree="<group>")
root_group = add("root", "PBXGroup", children=[app_group, test_group, config_group, product_group], sourceTree="<group>")
package_refs, package_products, package_builds = [], [], []
for package in ["FocusDomain", "FocusPersistence", "FocusAudio", "MacIntegration"]:
    ref = add(package + "-reference", "XCLocalSwiftPackageReference", relativePath=f"Packages/{package}")
    product = add(package + "-dependency", "XCSwiftPackageProductDependency", package=ref, productName=package)
    package_refs.append(ref)
    package_products.append(product)
    package_builds.append(add(package + "-link", "PBXBuildFile", productRef=product))
frameworks = add("frameworks", "PBXFrameworksBuildPhase", buildActionMask=2147483647,
                 files=package_builds, runOnlyForDeploymentPostprocessing=0)
privacy_build = add("privacy-build", "PBXBuildFile", fileRef=identifier("App/PrivacyInfo.xcprivacy"))
resources = add("resources", "PBXResourcesBuildPhase", buildActionMask=2147483647,
                files=[privacy_build], runOnlyForDeploymentPostprocessing=0)
common = {
    "MACOSX_DEPLOYMENT_TARGET": "15.0", "SDKROOT": "macosx", "SWIFT_VERSION": "6.0",
    "SWIFT_STRICT_CONCURRENCY": "complete", "CLANG_ENABLE_MODULES": "YES",
    "CODE_SIGN_IDENTITY": "-", "CODE_SIGN_STYLE": "Manual", "COMBINE_HIDPI_IMAGES": "YES",
    "SWIFT_TREAT_WARNINGS_AS_ERRORS": "YES",
}
# Preserve the installed app identity so its sandbox and preferences survive the product rename.
app_configs = configs("app", {
    **common, "PRODUCT_NAME": "FlowState", "PRODUCT_BUNDLE_IDENTIFIER": "dev.focusapp.scaffold",
    "INFOPLIST_FILE": "App/Info.plist", "CODE_SIGN_ENTITLEMENTS": "App/FlowState.entitlements",
    "ENABLE_APP_SANDBOX": "YES", "ENABLE_HARDENED_RUNTIME": "YES",
    "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/../Frameworks"],
})
app = add("app-target", "PBXNativeTarget", name="FlowState", productName="FlowState",
          productReference=products[0], productType="com.apple.product-type.application",
          buildConfigurationList=app_configs, buildPhases=[app_sources, frameworks, resources],
          buildRules=[], dependencies=[], packageProductDependencies=package_products)
proxy = add("app-proxy", "PBXContainerItemProxy", containerPortal=identifier("project"),
            proxyType=1, remoteGlobalIDString=app, remoteInfo="FlowState")
dependency = add("app-target-dependency", "PBXTargetDependency", target=app, targetProxy=proxy)
test_configs = configs("uitests", {
    **common, "PRODUCT_NAME": "ScaffoldUITests", "PRODUCT_BUNDLE_IDENTIFIER": "dev.flowstate.scaffold.uitests",
    "GENERATE_INFOPLIST_FILE": "YES", "TEST_TARGET_NAME": "FlowState",
    "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/../Frameworks", "@loader_path/../Frameworks"],
})
test = add("test-target", "PBXNativeTarget", name="ScaffoldUITests", productName="ScaffoldUITests",
           productReference=products[1], productType="com.apple.product-type.bundle.ui-testing",
           buildConfigurationList=test_configs, buildPhases=[test_sources], buildRules=[], dependencies=[dependency])
project = add("project", "PBXProject", attributes={"LastUpgradeCheck": "2700"},
              buildConfigurationList=configs("project", common), compatibilityVersion="Xcode 14.0",
              developmentRegion="en", knownRegions=["en", "Base"], mainGroup=root_group,
              productRefGroup=product_group, projectDirPath="", projectRoot="",
              targets=[app, test], packageReferences=package_refs)


def plist(value, depth=0):
    indent = "\t" * depth
    if isinstance(value, dict):
        return "{\n" + "".join(f"{indent}\t{json.dumps(k)} = {plist(v, depth + 1)};\n"
                                 for k, v in value.items()) + indent + "}"
    if isinstance(value, list):
        return "(" + ", ".join(plist(item, depth) for item in value) + ")"
    return str(value) if isinstance(value, int) else json.dumps(value)


directory = ROOT / "FlowState.xcodeproj"
directory.mkdir(exist_ok=True)
(directory / "project.pbxproj").write_text("// !$*UTF8*$!\n" + plist({
    "archiveVersion": 1, "classes": {}, "objectVersion": 56, "objects": objects, "rootObject": project,
}) + "\n")
scheme_dir = directory / "xcshareddata/xcschemes"
scheme_dir.mkdir(parents=True, exist_ok=True)


def buildable(target, name, product):
    return (f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{target}" '
            f'BuildableName="{product}" BlueprintName="{name}" ReferencedContainer="container:FlowState.xcodeproj"/>')


app_ref = buildable(app, "FlowState", "FlowState.app")
test_ref = buildable(test, "ScaffoldUITests", "ScaffoldUITests.xctest")
(scheme_dir / "FlowState.xcscheme").write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="2700" version="1.3">
  <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES">
    <BuildActionEntries>
      <BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{app_ref}</BuildActionEntry>
    </BuildActionEntries>
  </BuildAction>
  <TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES">
    <Testables><TestableReference skipped="NO">{test_ref}</TestableReference></Testables>
  </TestAction>
  <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" allowLocationSimulation="YES">
    <BuildableProductRunnable runnableDebuggingMode="0">{app_ref}</BuildableProductRunnable>
  </LaunchAction>
  <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app_ref}</BuildableProductRunnable></ProfileAction>
  <AnalyzeAction buildConfiguration="Debug"/>
  <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>
''')
workspace = directory / "project.xcworkspace"
workspace.mkdir(exist_ok=True)
(workspace / "contents.xcworkspacedata").write_text('<?xml version="1.0" encoding="UTF-8"?>\n<Workspace version="1.0"><FileRef location="self:"/></Workspace>\n')
print("Generated FlowState.xcodeproj")
