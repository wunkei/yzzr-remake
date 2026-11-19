package src
{
   import com.*;
   import com.efnx.fps.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class ChongZhi_Interface3 extends MovieClip
   {
      
      public static var _this:ChongZhi_Interface3;
      
      public static var request:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-41420207.html");
      
      public function ChongZhi_Interface3()
      {
         super();
         _this = this;
         close_btn.addEventListener(MouseEvent.CLICK,Close);
         lingqu_btn.addEventListener(MouseEvent.CLICK,lingQuFun);
      }
      
      public static function onENTER_FRAME(param1:*) : *
      {
         if(!openYn && Main.gameNum.getValue() == 0)
         {
            openYn = true;
            _this.x = _this.y = 0;
         }
      }
      
      public static function Close(param1:* = null) : *
      {
         if(!_this)
         {
            new ChongZhi_Interface3();
         }
         _this.x = _this.y = -5000;
      }
      
      public static function Open() : *
      {
         if(!_this)
         {
            new ChongZhi_Interface3();
         }
         _this.x = _this.y = 0;
         Main._this.addChild(_this);
      }
      
      public static function lingQuFun(param1:* = null) : *
      {
         navigateToURL(request,"_blank");
         Close();
      }
   }
}

