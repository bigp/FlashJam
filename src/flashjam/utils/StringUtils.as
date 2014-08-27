package flashjam.utils {
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class StringUtils {
		public static const COMPARE_LESSER_EQUAL:int =		0;
		public static const COMPARE_LESSER:int =			1;
		public static const COMPARE_GREATER:int =			2;
		public static const COMPARE_GREATER_EQUAL:int =		3;
		public static const COMPARE_EQUALS:int =			4;
		
		private static var _PADDING_HELPER:Vector.<String> = new Vector.<String>();
		
		/**
		 * Converts each characters of a string to a series of Char-Codes. Useful for BitmapFont file definition generation.
		 * @param	pString
		 * @param	pCandidate
		 * @return
		 */
		public static function toCharCodes(pString:String, pCandidate:Vector.<uint>):Vector.<uint> {
			if (!pString || pString.length == 0) {
				return null;
			}
			
			var c:int = 0, cLen:int = pString.length;
			var results:Vector.<uint>;
			if (pCandidate) {
				results = pCandidate;
				results.length =	cLen;
			} else {
				results = new Vector.<uint>(cLen);
			}
			
			for (; c<cLen; c++) {
				results[c] = pString.charCodeAt(c);
			}
			
			return results;
		}
		
		/**
		 * Finds each alphanumeric characters ONCE used in a string. Useful for determining necessary font glyphs
		 * in a BitmapFont.
		 * 
		 * @param	pString
		 * @param	pAlphabethical
		 * @return
		 */
		public static function uniq( pString:String, pAlphabethical:Boolean = true ):Array {
			var alphas:Array =	[];
			
			for (var a:int=0, aLen:int=pString.length; a<aLen; a++) {
				var char:String = pString.charAt(a);
				if (alphas.indexOf(char) == -1) {
					alphas.push(char);
				}
			}
			
			if (pAlphabethical) {
				return alphas.sort();
			}
			
			return alphas;
		}
		
		/**
		 * Repeats the given string ? times.
		 * @param	pString
		 * @param	pTimes
		 * @return
		 */
		public static function times(pString:String, pTimes:int):String {
			var results:String = "";
			for (var s:int = pTimes; --s >= 0; ) {
				results += pString;
			}
			
			return results;
		}
		
		/**
		 * Useful for score ranges (0-to-50=bronze, 51-to-80=silver, 81-to-100=gold).
		 * @param	pInput The value of the score
		 * @param	pValues The ranges max values
		 * @param	pStrings The string name for each of those ranges (in same order as pValues)
		 * @param	pCompareMethod The compare method, usually LESSER_EQUAL to the max values.
		 * @return	the corresponding name (ex: silver) for the given input value (ex: 60).
		 */
		public static function compare( pInput:Number, pValues:Array, pStrings:Array, pCompareMethod:int = 0):String {
			CONFIG::debug {
				if (pValues.length != pStrings.length) {
					throw new Error("The values must be the same length as the total of strings");
				}	
			}
			
			var a:int = 0, aLen:int = pValues.length, value:Number;
			switch( pCompareMethod ) {
				case COMPARE_GREATER:
					for (; a < aLen; a++) {
						value = pValues[a];
						if (pInput > value) {
							return pStrings[a];
						}
					}
					break;
				case COMPARE_GREATER_EQUAL:
					for (; a < aLen; a++) {
						value = pValues[a];
						if (pInput >= value) {
							return pStrings[a];
						}
					}
					break;
				case COMPARE_LESSER:
					for (; a < aLen; a++) {
						value = pValues[a];
						if (pInput < value) {
							return pStrings[a];
						}
					}
					break;
				case COMPARE_LESSER_EQUAL:
					for (; a < aLen; a++) {
						value = pValues[a];
						if (pInput <= value) {
							return pStrings[a];
						}
					}
					break;
				case COMPARE_EQUALS:
					for (; a < aLen; a++) {
						value = pValues[a];
						if (pInput == value) {
							return pStrings[a];
						}
					}
					break;
			}
			
			return null;
		}
		
		/**
		 * Useful for String Formatting by substituting $0, $1, $2 (etc...) to values in an array of replacements.
		 * @param	pMsg
		 * @param	pReplacements
		 * @return
		 */
		public static function replaceMany(pMsg:String, pReplacements:Array):String {
			if (!pReplacements || pReplacements.length == 0) {
				return pMsg;
			}
			
			for (var r:int=0, rLen:int=pReplacements.length; r<rLen; r++) {
				var regex:RegExp =	new RegExp("\\$" + r, "g");
				
				pMsg = pMsg.replace(regex, pReplacements[r]);
			}
			
			return pMsg;
		}
		
		public static function padAsBytes(pValue:uint, pBits:int=8):String {
			var valueStr:String =	pValue.toString(2);
			var valueLen:int =		valueStr.length;
			
			var output:Vector.<String> = _PADDING_HELPER;
			output.length = 0;
			
			while (pBits > 0) {
				if ((pBits % 4) == 0) {
					output[output.length] = " ";
				}
				
				output[output.length] = pBits > valueLen ? "0" : valueStr.charAt(valueLen - pBits);
				
				--pBits;
			}
			
			return output.join("");
		}
		
		public static function trim(pStr:String, pLeft:Boolean = true, pRight:Boolean = true, pWhiteSpaceChars:String=" \t\n\r"):String {
			var trimCounter:int = 0;
			if (pLeft) {
				while (pWhiteSpaceChars.indexOf(pStr.charAt(trimCounter)) > -1) {
					trimCounter++;
				}
				pStr = pStr.substr(trimCounter);
			}
			
			if (pRight) {
				trimCounter = pStr.length-1;
				while (pWhiteSpaceChars.indexOf(pStr.charAt(trimCounter)) > -1) {
					trimCounter--;
				}
				pStr = pStr.substr(0, trimCounter+1);
			}
			return pStr;
		}
		
	}

}