package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class UpgradePanel extends MovieClip
   {
      
      public static var myplayer:PlayerData;
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var ugPanel:MovieClip;
      
      public static var ugp:UpgradePanel;
      
      public static var clickObj:MovieClip;
      
      private static var nameStr:String;
      
      public static var clickNum:Number;
      
      private static var loadData:ClassLoader;
      
      private static var ee:Equip = null;
      
      private static var ee_over:Equip = null;
      
      public static var arr_cl:Array = [];
      
      public static var yeshu:Number = 0;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "panel_ZBJH_v892.swf";
      
      public static var arr:Array = [[1,63202,1],[1,63138,3],[1,63100,3],[1,63156,50],[2,63202,1],[2,63138,3],[2,63100,3],[2,63156,50],[3,63202,1],[3,63138,3],[3,63100,3],[3,63156,50],[4,63202,1],[4,63138,3],[4,63100,3],[4,63156,50]];
      
      public function UpgradePanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!ugPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("JJShow") as Class;
         ugPanel = new _loc2_();
         ugp.addChild(ugPanel);
         InitIcon();
         if(OpenYN)
         {
            open(myplayer);
         }
         else
         {
            close();
         }
      }
      
      private static function InitIcon() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = ugPanel.getChildIndex(ugPanel["e" + _loc1_]);
            _loc2_.x = ugPanel["e" + _loc1_].x;
            _loc2_.y = ugPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            ugPanel.removeChild(ugPanel["e" + _loc1_]);
            ugPanel["e" + _loc1_] = _loc2_;
            ugPanel.addChild(_loc2_);
            ugPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = ugPanel.getChildIndex(ugPanel["s" + _loc1_]);
            _loc2_.x = ugPanel["s" + _loc1_].x;
            _loc2_.y = ugPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            ugPanel.removeChild(ugPanel["s" + _loc1_]);
            ugPanel["s" + _loc1_] = _loc2_;
            ugPanel.addChild(_loc2_);
            ugPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = ugPanel.getChildIndex(ugPanel["x" + _loc1_]);
            _loc2_.x = ugPanel["x" + _loc1_].x;
            _loc2_.y = ugPanel["x" + _loc1_].y;
            _loc2_.name = "x" + _loc1_;
            ugPanel.removeChild(ugPanel["x" + _loc1_]);
            ugPanel["x" + _loc1_] = _loc2_;
            ugPanel.addChild(_loc2_);
            ugPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = ugPanel.getChildIndex(ugPanel["chosed"]);
         _loc2_.x = ugPanel["chosed"].x;
         _loc2_.y = ugPanel["chosed"].y;
         _loc2_.name = "chosed";
         ugPanel.removeChild(ugPanel["chosed"]);
         ugPanel["chosed"] = _loc2_;
         ugPanel.addChild(_loc2_);
         ugPanel.setChildIndex(_loc2_,_loc3_);
         var _loc4_:MovieClip = new Shop_picNEW();
         var _loc5_:int = ugPanel.getChildIndex(ugPanel["jh_over"]);
         _loc4_.x = ugPanel["jh_over"].x;
         _loc4_.y = ugPanel["jh_over"].y;
         _loc4_.name = "jh_over";
         ugPanel.removeChild(ugPanel["jh_over"]);
         ugPanel["jh_over"] = _loc4_;
         ugPanel.addChild(_loc4_);
         ugPanel.setChildIndex(_loc4_,_loc5_);
      }
      
      private static function InitOpen() : *
      {
         ugp = new UpgradePanel();
         LoadSkin();
         Main._stage.addChild(ugp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         ugp = new UpgradePanel();
         Main._stage.addChild(ugp);
         OpenYN = false;
      }
      
      public static function open(param1:PlayerData) : void
      {
         Main.allClosePanel();
         if(ugPanel)
         {
            myplayer = param1;
            Main.stopXX = true;
            ugp.x = 0;
            ugp.y = 0;
            addListenerP1();
            Main._stage.addChild(ugp);
            ugp.visible = true;
         }
         else
         {
            myplayer = param1;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(ugPanel)
         {
            ee_over = null;
            ee = null;
            Main.stopXX = false;
            removeListenerP1();
            ugp.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         ugPanel["us_btn"].addEventListener(MouseEvent.CLICK,doUS);
         ugPanel["close"].addEventListener(MouseEvent.CLICK,closeUS);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            ugPanel["e" + _loc1_].mouseChildren = false;
            ugPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            ugPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            ugPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            ugPanel["s" + _loc1_].mouseChildren = false;
            ugPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            ugPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            ugPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         ugPanel["up_btn"].addEventListener(MouseEvent.CLICK,upGo);
         ugPanel["down_btn"].addEventListener(MouseEvent.CLICK,downGo);
         ugPanel["chosed"].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
         ugPanel["chosed"].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
         ugPanel["jh_over"].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
         ugPanel["jh_over"].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
         ugPanel["jh_over"].mouseEnabled = false;
         ugPanel["chosed"].mouseChildren = false;
         ugPanel["chosed"].gotoAndStop(1);
         ugPanel["chosed"].visible = false;
         ugPanel["tishi"].visible = false;
         ugPanel["tishi"]["yes_btn"].addEventListener(MouseEvent.CLICK,doUSING);
         ugPanel["tishi"]["no_btn"].addEventListener(MouseEvent.CLICK,closeTiShi);
         ugPanel["tishi"]["no_btn2"].addEventListener(MouseEvent.CLICK,closeTiShi);
         showEE();
         noShowCL();
         ugPanel["chose"].visible = false;
      }
      
      public static function upGo(param1:*) : *
      {
         yeshu = 0;
         showEE();
      }
      
      public static function downGo(param1:*) : *
      {
         yeshu = 1;
         showEE();
      }
      
      public static function showEE() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:int = yeshu + 1;
         ugPanel["yeshu_txt"].text = _loc1_ + "/2";
         _loc2_ = 0;
         while(_loc2_ < 24)
         {
            ugPanel["e" + _loc2_].t_txt.text = "";
            if(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu) != null)
            {
               if(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getSuitId() >= 21 && myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getSuitId() <= 25)
               {
                  ugPanel["e" + _loc2_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getFrame());
                  ugPanel["e" + _loc2_].visible = true;
               }
               else
               {
                  ugPanel["e" + _loc2_].visible = false;
               }
            }
            else
            {
               ugPanel["e" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            ugPanel["s" + _loc2_].t_txt.text = "";
            if(myplayer.getEquipSlot().getEquipFromSlot(_loc2_) != null)
            {
               if(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getSuitId() >= 21 && myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getSuitId() <= 25)
               {
                  ugPanel["s" + _loc2_].gotoAndStop(myplayer.getEquipSlot().getEquipFromSlot(_loc2_).getFrame());
                  ugPanel["s" + _loc2_].visible = true;
               }
               else
               {
                  ugPanel["s" + _loc2_].visible = false;
               }
            }
            else
            {
               ugPanel["s" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         ugPanel["close"].removeEventListener(MouseEvent.CLICK,closeUS);
         ugPanel["us_btn"].removeEventListener(MouseEvent.CLICK,doUS);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            ugPanel["e" + _loc1_].mouseChildren = false;
            ugPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            ugPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            ugPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            ugPanel["s" + _loc1_].mouseChildren = false;
            ugPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            ugPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            ugPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         ugPanel["up_btn"].removeEventListener(MouseEvent.CLICK,upGo);
         ugPanel["down_btn"].removeEventListener(MouseEvent.CLICK,downGo);
         ugPanel["chosed"].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
         ugPanel["chosed"].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
         ugPanel["jh_over"].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
         ugPanel["jh_over"].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
      }
      
      public static function closeUS(param1:*) : *
      {
         close();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         ugPanel.addChild(itemsTooltip);
         if(_loc2_)
         {
            _loc3_ = uint(_loc2_.name.substr(1,2));
            _loc4_ = _loc2_.name.substr(0,1);
            if(_loc4_ == "e")
            {
               _loc3_ += yeshu * 24;
               if(myplayer.getBag().getEquipFromBag(_loc3_) != null)
               {
                  itemsTooltip.equipTooltip(myplayer.getBag().getEquipFromBag(_loc3_),1);
               }
            }
            else if(_loc4_ == "s")
            {
               itemsTooltip.slotTooltip(_loc3_,myplayer.getEquipSlot());
            }
            else if(_loc4_ == "c")
            {
               itemsTooltip.equipTooltip(ee,1);
            }
            else if(_loc4_ == "j")
            {
               itemsTooltip.equipTooltip(ee_over,1);
            }
            itemsTooltip.visible = true;
            itemsTooltip.x = ugPanel.mouseX + 10;
            itemsTooltip.y = ugPanel.mouseY;
            itemsTooltip.setTooltipPoint();
         }
      }
      
      private static function doUS(param1:*) : *
      {
         ugPanel["tishi"].visible = true;
      }
      
      private static function closeTiShi(param1:*) : *
      {
         ugPanel["tishi"].visible = false;
      }
      
      private static function doUSING(param1:*) : *
      {
         if(nameStr == "e")
         {
            myplayer.getBag().delEquip(clickNum);
            myplayer.getBag().addEquipBag(ee_over);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"进化成功，在装备栏查看");
         }
         else
         {
            myplayer.getEquipSlot().delSlot(clickNum);
            myplayer.getEquipSlot().addToSlot(ee_over,clickNum);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"进化成功，在装备栏查看");
         }
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            myplayer.getBag().delOtherById(arr_cl[_loc2_][1],arr_cl[_loc2_][2]);
            _loc2_++;
         }
         ugPanel["tishi"].visible = false;
         ugPanel["us_btn"].visible = false;
         showEE();
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         clickObj = param1.target as MovieClip;
         ugPanel["chose"].visible = true;
         ugPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         if(nameStr == "e")
         {
            clickNum += yeshu * 24;
            ee = myplayer.getBag().getEquipFromBag(clickNum);
         }
         else
         {
            ee = myplayer.getEquipSlot().getEquipFromSlot(clickNum);
         }
         ugPanel["chosed"].gotoAndStop(ee.getFrame());
         ugPanel["chosed"].visible = true;
         showCL();
      }
      
      private static function showCL() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         arr_cl = [];
         count = 0;
         _loc1_ = 0;
         while(_loc1_ < arr.length)
         {
            if(arr[_loc1_][0] == ee.getPosition())
            {
               arr_cl.push(arr[_loc1_]);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = Number(arr_cl[_loc1_][1]);
            ugPanel["x" + _loc1_].gotoAndStop(OtherFactory.getFrame(_loc2_));
            ugPanel["x" + _loc1_].visible = true;
            ugPanel["n" + _loc1_].text = arr_cl[_loc1_][2];
            ugPanel["c" + _loc1_].visible = true;
            ugPanel["n" + _loc1_].visible = true;
            if(myplayer.getBag().getOtherobjNum(_loc2_) >= arr_cl[_loc1_][2])
            {
               ugPanel["c" + _loc1_].text = arr_cl[_loc1_][2];
               ColorX(ugPanel["c" + _loc1_],"0xFFFF00");
               ++count;
            }
            else
            {
               ugPanel["c" + _loc1_].text = myplayer.getBag().getOtherobjNum(_loc2_);
               ColorX(ugPanel["c" + _loc1_],"0xFF0000");
            }
            _loc1_++;
         }
         if(count >= 4)
         {
            ugPanel["us_btn"].visible = true;
         }
         else
         {
            ugPanel["us_btn"].visible = false;
         }
         ee_over = ee.jinhuaEquip();
         ugPanel["jh_over"].gotoAndStop(ee_over.getFrame());
         ugPanel["jh_over"].visible = true;
      }
      
      private static function ColorX(param1:*, param2:String) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2;
         param1.setTextFormat(_loc3_);
      }
      
      private static function noShowCL() : *
      {
         var _loc1_:uint = 0;
         if(!ee)
         {
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
               ugPanel["x" + _loc1_].visible = false;
               ugPanel["n" + _loc1_].visible = false;
               ugPanel["c" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         ugPanel["jh_over"].visible = false;
         ugPanel["us_btn"].visible = false;
         ugPanel["chosed"].visible = false;
      }
   }
}

