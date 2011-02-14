package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author YG
	 */
	public class GET extends Sprite 
	{	
		public const COOKIE_NAME:String = "Roboo_name_000000000000000000PLACEHOLDER";
		public const COOKIE_VALUE:String = "Roboo_value_00000000000000000PLACEHOLDER";
		public const COOKIE_VALIDITY:String = "Roboo_validity_00000000000000PLACEHOLDER";
		
		public function GET():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init)
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var script_js :XML = 
				<script>
					<![CDATA[
						function (cookie_name, cookie_value, cookie_validity) { 
								document.cookie=cookie_name + '=' + cookie_value + '; max-age=' + cookie_validity + '; path=/';
								window.location.reload();
						}
					]]>
				</script> 
			ExternalInterface.call(script_js, COOKIE_NAME, COOKIE_VALUE, COOKIE_VALIDITY);			
		}
	}
}