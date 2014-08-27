package flashjam.utils {
	import flash.utils.getQualifiedClassName
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ClassUtils {
		
		private static var _RECURSIONS:int =		0;
		private static var _HELPER_ARRAY:Array =	[];
		
		private static var _CACHED_NAMES:Dictionary = new Dictionary();
		private static var _CACHED_CLASS_PROPERTIES:Dictionary = new Dictionary();
		private static var _CACHED_DESC:Dictionary =			new Dictionary();
		private static var _CACHED_LOOKUPS:Dictionary =			new Dictionary();
		
		public static var SERIALIZE_ON_SINGLE_LINE:Boolean = false;
		
		public static function nameOf( obj:Object ):String {
			if (_CACHED_NAMES[obj]) return _CACHED_NAMES[obj];
			if (obj == null) {
				return "*null*";
			}
			var clazz:Class;
			if (obj is Class) {
				clazz = obj as Class;
			} else {
				clazz =	obj.constructor;
			}
			
			var theName:String = _CACHED_NAMES[clazz] = String(String(clazz).split(" ")[1]).substr(0, -1);
			return theName;
		}
		
		public static function nameOfEach( arr:Array, pResults:Array=null ):Array {
			var names:Array = pResults || [];
			for (var a:int=0, aLen:int=arr.length; a<aLen; a++) {
				names[a] = nameOf( arr[a] );
			}
			
			return names;
		}
		
		public static function isType(pType:Class, pImplementClass:Class, pQuickInst:Boolean=false):Boolean {
			if (pType === pImplementClass) return true;
			if (pQuickInst) {
				var nameA:String = nameOf(pType);
				var nameB:String = nameOf(pImplementClass);
				var nameCombo:String = nameA + nameB;
				var existing:Boolean = _CACHED_LOOKUPS[nameCombo]!=null;
				if ( existing ) return _CACHED_LOOKUPS[nameCombo];
				
				var inst:* = new pType();
				return (_CACHED_LOOKUPS[nameCombo] = inst is pImplementClass);
			}
			
			throw new Error("No longer used. Use the QuickInst (3rd) parameter instead.");
			
			/*
			var fullQName:String =		getQualifiedClassName(pImplementClass);
			var xDesc:XML =				_CACHED_DESC[pType] || (_CACHED_DESC[pType] = describeType(pType));
			var xExtends:XMLList =		xDesc.factory.extendsClass;
			//trace("EXTENDS " + pType + " : " + xExtends.length());
			xExtends +=					xDesc.factory.implementsInterface;
			//trace("EXTENDS " + pType + " : " + xExtends.length());
			var xTypes:XMLList =		xExtends.@type;
			
			for each(var typeName:String in xTypes) {
				if (fullQName == typeName) {
					return true;
				}
			}
			*/
			return false;
		}
		
		public static function serialize(obj:Object, properties:String = null, pShortNames:int = 0, pRecursive:Boolean = false):String {
			if (obj == null) return "*null*";
			
			_RECURSIONS++;
			
			var tabs:String =	StringUtils.times( "\t", _RECURSIONS );
			var tabs2:String =	StringUtils.times( "\t", _RECURSIONS-1 );
			
			var props:Array;
			if (!properties) {
				props = _HELPER_ARRAY;
				props.length =	0;
				
				if (obj is Array) {
					var objArray:Array = obj as Array;
					for (var f:int=0, fLen:int=objArray.length; f<fLen; f++) {
						props[props.length] = f;	
					}
				} else {
					for (var i:String in obj) {
						props[props.length] = i;
					}
				}
			} else {
				props = properties.split(",");
			}
			
			var output:Array =	[];
			var p:int = 0, pLen:int = props.length, prop:String, value:Object;
			
			if(pShortNames<=0) {
				for (; p<pLen; p++) {
					prop =	props[p];
					
					CONFIG::debug {
						try {
							value =	obj[prop];
						} catch (e:Error) { trace(obj + " does not support property: " + prop); }
					}
					CONFIG::release {
						value =	obj[prop];
					}
					
					if (value == null) {
						continue;
					}
					
					if (pRecursive && !(value is Number) && !(value is Boolean) && !(value is String) && !(value is XML) && !(value is XMLList) && !(value is RegExp)) {
						output.push( prop + ": " + serialize( value, null, pShortNames, pRecursive ));
					} else {
						output.push( prop + ": " + (value is String ? "\"" + value + "\"" : value));
					}
				}
			} else {
				for (; p<pLen; p++) {
					prop =	props[p];
					value =	obj[prop];
					
					output.push( prop.substr(0, pShortNames) + ":" + value);
				}
			}
			
			_RECURSIONS--;
			var nameCls:String =	nameOf(obj);
			
			if (SERIALIZE_ON_SINGLE_LINE) {
				if (nameCls == "Object") {
					return "{ " + output.join(", ") + " }";
				} else if (nameCls == "Array") {
					return "[" + output.join(", ") + "]";
				}
				
				return nameOf(obj) + " {" + output.join(", ") + "}";
			} else {
				if (nameCls == "Object") {
					return "{\n" + tabs + output.join(",\n" + tabs) + "\n" + tabs2 + "}";
				} else if (nameCls == "Array") {
					return "[\n" + tabs + output.join(",\n" + tabs) + "\n" + tabs2 + "]";
				}
				
				return nameOf(obj) + " {\n" + tabs + output.join(",\n" + tabs) + "\n" + tabs2 + "}";
			}
			
			
		}
		
		/**
		 * Returns all the properties specific to this particular object.
		 * 
		 * @param	pClass
		 * @return
		 */
		public static function getPropertiesOf(pClass:*, pInstanceOnly:Boolean=false, pOmittedTypes:Array=null):Array {
			if (pClass == null) {
				return null;
			}
			
			if (!(pClass is Class)) {
				pClass = pClass.constructor;
			}
			
			var fullClassName:String =	getQualifiedClassName(pClass);
			var results:Array =		_CACHED_CLASS_PROPERTIES[fullClassName];
			
			if(!results) {
				var xDefinition:XML =	_CACHED_DESC[pClass] || (_CACHED_DESC[pClass] = describeType(pClass));
				var xVars:XMLList, xVar:XML, prop:String;
				
				xVars =		xDefinition.factory..variable;
				xVars +=	xDefinition.factory..accessor;
				xVars +=	xDefinition.factory..constant;
				
				if (!pInstanceOnly) {
					xVars +=	xDefinition..variable;
					xVars +=	xDefinition..accessor;
					xVars +=	xDefinition..constant;
				}
				
				results = [];
				
				if (pOmittedTypes) {
					for each(xVar in xVars) {
						if (xVar.@access == "readonly" || pOmittedTypes.indexOf(String(xVar.@type)) > -1) {
							continue;
						}
						
						prop =	xVar.@name.toString();
						if(prop != "prototype") {
							results.push(prop);
						}
					}
				} else {
					for each(xVar in xVars) {
						if (xVar.@access == "readonly") {
							continue;
						}
						
						prop =	xVar.@name.toString();
						if(prop != "prototype") {
							results.push(prop);
						}
					}
				}
				
				
				_CACHED_CLASS_PROPERTIES[fullClassName] = results;
			}
			
			return results;
		}
		
		public static function clearProperties(pClass:Class, pExceptionPrefix:String="__"):void {
			var prop:String, properties:Array = getPropertiesOf(pClass);
			
			if (pExceptionPrefix == null || pExceptionPrefix.length == 0) {
				for each(prop in properties) {
					//Nullify every single properties (getters/setters too? ... not sure)
					pClass[prop] = null;
				}
			} else {
				for each(prop in properties) {
					if (prop.indexOf(pExceptionPrefix) == 0) {
						continue;
					}
					pClass[prop] = null;
				}
			}
		}
		
	}
}