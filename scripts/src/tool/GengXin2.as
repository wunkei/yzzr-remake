package src.tool
{
   import com.adobe.serialization.json.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class GengXin2 extends MovieClip
   {
      
      public function GengXin2()
      {
         super();
         yes_btn.addEventListener(MouseEvent.CLICK,OK);
         no_btn.addEventListener(MouseEvent.CLICK,OK);
      }
      
      private function OK(param1:*) : *
      {
         GengXin.reGame();
      }
   }
}

