package src
{
   import com.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class SelMap extends MovieClip
   {
      
      public static var skin:MovieClip;
      
      public static var loadData:ClassLoader;
      
      public static var selMapX:SelMap;
      
      public static var pageNum:int = 1;
      
      public static var tiaoZanType:Boolean = false;
      
      private static var tiaoZhanYN:Boolean = false;
      
      public var tiaoZhan_mc:MovieClip;
      
      public var M0:SimpleButton;
      
      public var M1:MovieClip;
      
      public var M2:MovieClip;
      
      public var M3:MovieClip;
      
      public var M4:MovieClip;
      
      public var M5:MovieClip;
      
      public var M6:MovieClip;
      
      public var M7:MovieClip;
      
      public var M8:MovieClip;
      
      public var M9:MovieClip;
      
      public var M10:MovieClip;
      
      public var M11:MovieClip;
      
      public var M12:MovieClip;
      
      public var M13:MovieClip;
      
      public var M14:MovieClip;
      
      public var M15:MovieClip;
      
      public var M16:MovieClip;
      
      public var M17:MovieClip;
      
      public var M18:MovieClip;
      
      public var M19:MovieClip;
      
      public var M20:MovieClip;
      
      public var M51:MovieClip;
      
      public var M52:MovieClip;
      
      public var M53:MovieClip;
      
      public var M54:MovieClip;
      
      public var M55:MovieClip;
      
      public var M56:MovieClip;
      
      public var M57:MovieClip;
      
      public var M58:MovieClip;
      
      public var M59:MovieClip;
      
      public var M60:MovieClip;
      
      public var M61:MovieClip;
      
      public var M62:MovieClip;
      
      public var M81:MovieClip;
      
      public var next_提示_mc:MovieClip;
      
      public var tiaozhan_loading:MovieClip;
      
      public var NanDu_mc_1:MovieClip;
      
      public var NanDu_mc_2:MovieClip;
      
      public var NanDu_mc_3:MovieClip;
      
      public var NanDu_mc_4:MovieClip;
      
      public var btn:SimpleButton;
      
      public var btn2:SimpleButton;
      
      public var tiaoZhan_btn:SimpleButton;
      
      public var back_btn:SimpleButton;
      
      public var next_btn:SimpleButton;
      
      public var Sel_nanDu_mc:MovieClip;
      
      public var Sel_nanDu_mc2:MovieClip;
      
      public var Sel_nanDu_mc3:MovieClip;
      
      public var Sel_nanDu_mc4:MovieClip;
      
      public var guanKaMax:int = 62;
      
      public function SelMap()
      {
         super();
         selMapX = this;
         MapYN();
      }
      
      private static function TiaoZhan(param1:*) : *
      {
         if(tiaoZanType)
         {
            tiaoZanType = false;
         }
         else
         {
            tiaoZanType = true;
         }
         TiaoZhan_mc_Show();
         setTimeout(selMapX.OpenMapNum,500);
      }
      
      private static function TiaoZhan_mc_Show() : *
      {
         if(!selMapX.tiaoZhan_mc)
         {
            return;
         }
         if(tiaoZanType && Boolean(selMapX.tiaoZhan_mc))
         {
            selMapX.tiaoZhan_mc.gotoAndStop(pageNum);
            selMapX.tiaoZhan_mc.visible = true;
         }
         else if(selMapX.tiaoZhan_mc)
         {
            selMapX.tiaoZhan_mc.visible = false;
         }
      }
      
      public static function Open(param1:int = 0, param2:int = 0, param3:uint = 1, param4:int = 1) : *
      {
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         if(!selMapX)
         {
            _loc5_ = loadData.getClass("src.SelMap") as Class;
            _loc6_ = new _loc5_();
         }
         Main._this.addChild(selMapX);
         selMapX.x = param1;
         selMapX.y = param2;
         selMapX.visible = true;
         Main.allClosePanel();
         selMapX.MapYN();
         pageNum = param4;
         if(param3 == 2)
         {
            selMapX.x = selMapX.y = -2000;
            (selMapX["Sel_nanDu_mc"] as Sel_NanDu).Open(2000,2000,2);
         }
         if(Main.gameNum2.getValue() == 4)
         {
            selMapX.gotoAndStop(3);
            pageNum = 3;
         }
         else
         {
            selMapX.gotoAndStop(pageNum);
         }
         selMapX.tiaozhan_loading.visible = false;
         selMapX.tiaoZhan_btn.addEventListener(MouseEvent.CLICK,TiaoZhan);
         if(TiaoZhan_Interface.loadingOK == 2 && selMapX.tiaoZhan_btn.visible)
         {
            TiaoZhan_Interface.Close();
         }
         else if(selMapX.tiaoZhan_btn.visible)
         {
            selMapX.tiaozhan_loading.visible = true;
         }
         TiaoZhan_mc_Show();
         Play_Interface.Close();
      }
      
      public static function Close() : *
      {
         var _loc1_:Class = null;
         var _loc2_:MovieClip = null;
         if(!selMapX)
         {
            _loc1_ = loadData.getClass("src.SelMap") as Class;
            _loc2_ = new _loc1_();
         }
         Main._this.addChild(selMapX);
         selMapX.x = 5000;
         selMapX.y = 5000;
         selMapX.visible = false;
         TiaoZhan_Interface.Close();
      }
      
      private function MapYN() : *
      {
         setTimeout(OpenMapNum,500);
      }
      
      private function Next_map(param1:*) : *
      {
         if(pageNum < 2)
         {
            ++pageNum;
            gotoAndStop(pageNum);
            MapYN();
            TiaoZhan_mc_Show();
         }
      }
      
      private function Back_map(param1:*) : *
      {
         if(pageNum > 1)
         {
            --pageNum;
            gotoAndStop(pageNum);
            MapYN();
            TiaoZhan_mc_Show();
         }
      }
      
      private function OpenMapNum() : *
      {
         if(this["M0"])
         {
            M0.addEventListener(MouseEvent.CLICK,MouseIn2);
         }
         btn.addEventListener(MouseEvent.CLICK,MouseIn2);
         btn2.addEventListener(MouseEvent.CLICK,MouseIn3);
         this["next_btn"].addEventListener(MouseEvent.CLICK,Next_map);
         this["back_btn"].addEventListener(MouseEvent.CLICK,Back_map);
         this["next_btn"].visible = true;
         this["back_btn"].visible = true;
         if(currentFrame == 1)
         {
            this["back_btn"].visible = false;
            if(!Main.guanKa[9] || Main.guanKa[9] == 0)
            {
               this["next_btn"].visible = false;
            }
         }
         else if(currentFrame == 2)
         {
            this["next_btn"].visible = false;
         }
         if(Main.guanKa[1] == null || Main.guanKa[1] == false || Main.guanKa[1] == 0)
         {
            Main.guanKa[1] = 2;
         }
         var _loc1_:int = 1;
         while(_loc1_ < 17)
         {
            if(Boolean(this["M" + _loc1_]) && (Main.guanKa[_loc1_] != 0 || _loc1_ == 1))
            {
               this["M" + _loc1_].gotoAndStop(2);
               this["M" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
               this["M" + _loc1_].addEventListener(MouseEvent.ROLL_OUT,MouseOut);
               this["M" + _loc1_].addEventListener(MouseEvent.CLICK,sel_NanDu_Open);
            }
            _loc1_++;
         }
         _loc1_ = 51;
         while(_loc1_ <= guanKaMax)
         {
            if(Boolean(this["M" + _loc1_]) && (Main.guanKa[_loc1_] != 0 || _loc1_ == 51))
            {
               this["M" + _loc1_].gotoAndStop(2);
               this["M" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
               this["M" + _loc1_].addEventListener(MouseEvent.ROLL_OUT,MouseOut);
               this["M" + _loc1_].addEventListener(MouseEvent.CLICK,sel_NanDu_Open);
            }
            _loc1_++;
         }
         if(this["M17"])
         {
            this["M17"].gotoAndStop(2);
            this["M17"].addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
            this["M17"].addEventListener(MouseEvent.ROLL_OUT,MouseOut);
            this["M17"].addEventListener(MouseEvent.CLICK,GameGo);
         }
         if(this["M18"])
         {
            this["M18"].gotoAndStop(2);
            this["M18"].addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
            this["M18"].addEventListener(MouseEvent.ROLL_OUT,MouseOut);
            this["M18"].addEventListener(MouseEvent.CLICK,sel_GuanKaXX_Open);
         }
         if(this["M81"])
         {
            this["M81"].gotoAndStop(2);
            this["M81"].addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
            this["M81"].addEventListener(MouseEvent.ROLL_OUT,MouseOut);
            this["M81"].addEventListener(MouseEvent.CLICK,sel_GuanKaXX_Open2);
         }
         if(Boolean(this["M17"]) && Boolean(this["M18"]))
         {
            if(tiaoZanType)
            {
               this["M17"].visible = false;
            }
            else
            {
               this["M17"].visible = true;
               this["M18"].visible = true;
            }
         }
         if(this["M81"])
         {
            if(tiaoZanType)
            {
               this["M81"].visible = false;
            }
            else
            {
               this["M81"].visible = true;
            }
         }
      }
      
      private function MouseIn2(param1:*) : *
      {
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(0);
         Main._this.GameStart();
         Close();
      }
      
      private function MouseIn3(param1:*) : *
      {
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(4);
         Main._this.Loading();
         Close();
      }
      
      private function sel_NanDu_Open(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.currentTarget.name as String).substr(1,2));
         Main.gameNum.setValue(_loc2_);
         if(tiaoZanType)
         {
            TiaoZhan_Interface.Open();
         }
         else
         {
            (Sel_nanDu_mc as Sel_NanDu).Open();
         }
      }
      
      private function sel_GuanKaXX_Open(param1:MouseEvent) : *
      {
         (Sel_nanDu_mc2 as Sel_NanDu2).Open();
      }
      
      private function sel_GuanKaXX_Open2(param1:MouseEvent) : *
      {
         (Sel_nanDu_mc3 as Sel_NanDu3).Open();
      }
      
      private function GameGo(param1:*) : *
      {
         (Sel_nanDu_mc4 as Sel_NanDu4).Open();
      }
      
      private function MouseIn(param1:*) : *
      {
         param1.currentTarget.gotoAndStop(3);
      }
      
      private function MouseOut(param1:*) : *
      {
         param1.currentTarget.gotoAndStop(2);
      }
   }
}

