.PHONY: icons codegen

icons:
	flutter pub run flutter_launcher_icons:main

codegen:
	flutter pub run build_runner build --delete-conflicting-outputs
