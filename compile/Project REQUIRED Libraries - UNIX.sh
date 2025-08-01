echo "This contains all required libraries for this project."
echo "While the workflows uses haxe 4.3.4, It would work anyways with 4.2.5."

haxelib install hxCodec 2.5.1 && haxelib set hxCodec 2.5.1
haxelib install flixel 5.5.0 && haxelib set flixel 5.5.0
haxelib install flixel-addons 3.2.0 && haxelib set flixel-addons 3.2.0
haxelib install flixel-ui 2.5.0 && haxelib set flixel-ui 2.5.0
haxelib install lime 8.1.2 && haxelib set lime
haxelib install openfl 9.2.2 && haxelib set openfl 9.2.2
haxelib install lime 8.1.3 && haxelib set lime 8.1.3

haxelib install hscript

haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git hxcpp https://github.com/moxie-coder/hxcpp-compiled
haxelib git hscript-improved https://github.com/CodenameCrew/hscript-improved

haxelib list
haxelib run lime setup

exit
