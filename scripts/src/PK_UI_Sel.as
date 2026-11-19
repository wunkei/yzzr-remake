package src
{
   import com.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class PK_UI_Sel extends MovieClip
   {
      
      public static var _this:PK_UI_Sel;
      
      public static var OtherData:ClassLoader;
      
      public static var openYN:Boolean = false;
      
      public function PK_UI_Sel()
      {
         super();
         sel_1_btn.addEventListener(MouseEvent.CLICK,In_JingJiPaiHang);
         close_btn.addEventListener(MouseEvent.CLICK,Close);
      }
      
      public static function Open() : *
      {
         var _loc1_:Class = null;
         var _loc2_:MovieClip = null;
         if(!NewLoad.Other_YN)
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"加载中,请稍候...");
            return;
         }
         if(!_this)
         {
            _this = new PK_UI_Sel();
         }
         if(!openYN)
         {
            Main.allClosePanel();
            _this.visible = true;
            _this.x = _this.y = 0;
            Main._stage.addChild(_this);
            TiaoShi.txtShow("PK_UI =========> TaskPanel.TiShi_PK_UI()");
            _loc1_ = NewLoad.OtherData.getClass("_PK_UI") as Class;
            _loc2_ = new _loc1_();
            _this.skin_mc.addChild(_loc2_);
            openYN = true;
         }
      }
      
      public static function Close(param1:* = null) : *
      {
         if(!_this)
         {
            return;
         }
         _this.visible = false;
         _this.x = _this.y = 5000;
         openYN = false;
      }
      
      private function In_JingJiPaiHang(param1:*) : *
      {
         PK_UI.Open();
      }
   }
}

