haxelib install lime 8.1.3 && haxelib set lime 8.1.3
haxelib install openfl 9.2.2 && haxelib set openfl 9.2.2
haxelib install flixel 5.6.2 && haxelib set flixel 5.6.2
haxelib install flixel-addons 3.2.0 && haxelib set flixel-addons 3.2.0
haxelib install flixel-ui 2.5.0 && haxelib set flixel-ui 2.5.0
haxelib install hxCodec 2.5.1 && haxelib set hxCodec 2.5.1
rm -rf ~/haxelib/hxCodec/2,5,1/lib/vlc/lib/Linux/*

haxelib run lime setup flixel
haxelib run lime setup
haxelib install hxvlc
haxelib install hscript
haxelib install hxcpp-debug-server

haxelib git hxcpp https://github.com/moxie-coder/hxcpp-compiled
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git hscript-improved https://github.com/CodenameCrew/hscript-improved