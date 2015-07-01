case "$1" in
	"-1" )
		echo "Switch 5.1"
		cd lua/lua-5.1.5 && sudo make install && cd ../../
		;;
	"-2" )
		echo "Switch 5.2"
		cd lua/lua-5.2.3 && sudo make install && cd ../../
		;;
	"-3" )
		echo "Switch 5.3"
		cd lua/lua-5.3.0 && sudo make install && cd ../../
		;; 
	*)
		echo "make lib"
		cd 3rd/lua-map/&& make clean && make macosx && cd ../../
		;;
esac