package src.npc
{
   import com.hotpoint.braveManIII.views.equipShopPanel.*;
   import com.hotpoint.braveManIII.views.skillPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.*;
   
   public class 星冰界面 extends MovieClip
   {
      
      private static var only:星冰界面;
      
      public var close2:SimpleButton;
      
      public function 星冰界面()
      {
         super();
         close2.addEventListener(MouseEvent.CLICK,CloseXX);
      }
      
      public static function Open(param1:int = 0, param2:int = 0) : *
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         MusicBox.MusicPlay2("m14");
         if(!only)
         {
            _loc3_ = All_Npc.loadData.getClass("src.npc.星冰界面") as Class;
            _loc4_ = new _loc3_();
            only = _loc4_;
         }
         Main._stage.addChild(only);
         only.x = param1;
         only.y = param2;
         only.visible = true;
      }
      
      public static function Close() : *
      {
         if(only)
         {
            only.x = 5000;
            only.y = 5000;
            only.visible = false;
         }
      }
      
      private function CloseXX(param1:*) : *
      {
         Close();
      }
   }
}

