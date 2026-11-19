package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class DuWu_Interface extends MovieClip
   {
      
      public static var _this:DuWu_Interface;
      
      public var skin:MovieClip;
      
      public function DuWu_Interface()
      {
         super();
      }
      
      public static function Open() : *
      {
         var _loc1_:Class = null;
         if(!_this)
         {
            _this = new DuWu_Interface();
            _loc1_ = NewLoad.OtherData.getClass("DuWuMC") as Class;
            _this.skin = new _loc1_();
            _this.addChild(_this.skin);
            _this.skin.addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         }
         Main._stage.addChild(_this);
         _this.visible = true;
      }
      
      private static function onADDED_TO_STAGE(param1:*) : *
      {
         _this.skin.red_btn.addEventListener(MouseEvent.CLICK,Red);
         _this.skin.blue_btn.addEventListener(MouseEvent.CLICK,Blue);
         _this.skin.x_btn.addEventListener(MouseEvent.CLICK,XX);
         _this.skin.close_btn.addEventListener(MouseEvent.CLICK,Close);
      }
      
      private static function Red(param1:*) : *
      {
         var _loc2_:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-45276024.html");
         navigateToURL(_loc2_,"_blank");
      }
      
      private static function Blue(param1:*) : *
      {
         var _loc2_:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-37923939.html");
         navigateToURL(_loc2_,"_blank");
      }
      
      private static function XX(param1:*) : *
      {
         var _loc2_:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-45467169.html");
         navigateToURL(_loc2_,"_blank");
      }
      
      private static function Close(param1:*) : *
      {
         _this.visible = false;
      }
   }
}

