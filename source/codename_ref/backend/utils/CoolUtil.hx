package codename.backend.utils;

class CoolUtil
{
	/**
	 * Add several zeros at the beginning of a string, so that `2` becomes `02`.
	 * @param str String to add zeros
	 * @param num The length required
	 */
	public static inline function addZeros(str:String, num:Int) {
		while(str.length < num) str = '0${str}';
		return str;
	}
}