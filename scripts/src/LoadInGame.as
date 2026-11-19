package src
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class LoadInGame extends MovieClip
   {
      
      private static var loder:ClassLoader;
      
      public static var loadingX:MovieClip = new LoadMovic();
      
      public function LoadInGame()
      {
         super();
      }
      
      public static function Open(param1:ClassLoader, param2:Boolean = true) : *
      {
         loder = param1;
         Main._stage.addChild(loadingX);
         loadingX.x = loadingX.y = -5000;
         loadingX.visible = false;
         if(param2)
         {
            loadingX.x = 0;
            loadingX.y = 0;
            loadingX.visible = true;
         }
         loadingX.addEventListener(Event.ENTER_FRAME,onLoading);
      }
      
      public static function Close() : *
      {
         loadingX.x = loadingX.y = -5000;
         loadingX.visible = false;
         loadingX.removeEventListener(Event.ENTER_FRAME,onLoading);
      }
      
      private static function onLoading(param1:*) : *
      {
         loadingX["pertxt"].text = loder.loadNum + "%";
         if(loder.loadNum >= 100)
         {
            Close();
         }
      }
   }
}

