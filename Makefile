.PHONY: icons codegen

stable:
	flutter channel stable

dev:
	flutter channel dev

icons:
	flutter pub run flutter_launcher_icons:main

codegen: stable
	flutter pub run build_runner build --delete-conflicting-outputs
