package src.tool
{
   import com.adobe.serialization.json.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class GengXin1 extends MovieClip
   {
      
      public function GengXin1()
      {
         super();
         yes_btn.addEventListener(MouseEvent.CLICK,OK);
         no_btn.addEventListener(MouseEvent.CLICK,Close);
         no_btn2.addEventListener(MouseEvent.CLICK,Close);
      }
      
      private function OK(param1:*) : *
      {
         GengXin.reGame();
      }
      
      private function Close(param1:*) : *
      {
         this.x = this.y = -5000;
      }
   }
}

