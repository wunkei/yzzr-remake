package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class HuanHuaPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var hhPanel:MovieClip;
      
      public static var hhp:HuanHuaPanel;
      
      public static var clickObj:MovieClip;
      
      public static var clickNum:Number;
      
      public static var myPlayer:PlayerData;
      
      public static var otherID:int;
      
      private static var className:String;
      
      private static var miaoshu:String;
      
      private static var nameStr:String;
      
      private static var loadData:ClassLoader;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_HH_v890.swf";
      
      public static var selbool:Boolean = false;
      
      public function HuanHuaPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!hhPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
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
            _loc3_ = hhPanel.getChildIndex(hhPanel["e" + _loc1_]);
            _loc2_.x = hhPanel["e" + _loc1_].x;
            _loc2_.y = hhPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            hhPanel.removeChild(hhPanel["e" + _loc1_]);
            hhPanel["e" + _loc1_] = _loc2_;
            hhPanel.addChild(_loc2_);
            hhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = hhPanel.getChildIndex(hhPanel["s" + _loc1_]);
            _loc2_.x = hhPanel["s" + _loc1_].x;
            _loc2_.y = hhPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            hhPanel.removeChild(hhPanel["s" + _loc1_]);
            hhPanel["s" + _loc1_] = _loc2_;
            hhPanel.addChild(_loc2_);
            hhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = hhPanel.getChildIndex(hhPanel["select"]);
         _loc2_.x = hhPanel["select"].x;
         _loc2_.y = hhPanel["select"].y;
         _loc2_.name = "select";
         hhPanel.removeChild(hhPanel["select"]);
         hhPanel["select"] = _loc2_;
         hhPanel.addChild(_loc2_);
         hhPanel.setChildIndex(_loc2_,_loc3_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("HHShow") as Class;
         hhPanel = new _loc2_();
         hhp.addChild(hhPanel);
         InitIcon();
         if(OpenYN)
         {
            open(myPlayer,otherID,miaoshu);
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         hhp = new HuanHuaPanel();
         LoadSkin();
         Main._stage.addChild(hhp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         hhp = new HuanHuaPanel();
         Main._stage.addChild(hhp);
         OpenYN = false;
      }
      
      public static function open(param1:PlayerData, param2:int, param3:String) : void
      {
         Main.allClosePanel();
         if(hhPanel)
         {
            Main.stopXX = true;
            hhp.x = 0;
            hhp.y = 0;
            myPlayer = param1;
            otherID = param2;
            miaoshu = param3;
            addListenerP1();
            Main._stage.addChild(hhp);
            hhp.visible = true;
         }
         else
         {
            myPlayer = param1;
            otherID = param2;
            miaoshu = param3;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(hhPanel)
         {
            selbool = false;
            Main.stopXX = false;
            removeListenerP1();
            hhp.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         hhPanel["us_btn"].addEventListener(MouseEvent.CLICK,doHH);
         hhPanel["close"].addEventListener(MouseEvent.CLICK,closeUS);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            hhPanel["e" + _loc1_].mouseChildren = false;
            hhPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            hhPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            hhPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            hhPanel["s" + _loc1_].mouseChildren = false;
            hhPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            hhPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            hhPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         hhPanel["select"].gotoAndStop(1);
         hhPanel["select"].visible = false;
         showAll();
         hhPanel["chose"].visible = false;
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         hhPanel["close"].removeEventListener(MouseEvent.CLICK,closeUS);
         hhPanel["us_btn"].removeEventListener(MouseEvent.CLICK,doHH);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            hhPanel["e" + _loc1_].mouseChildren = false;
            hhPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            hhPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            hhPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            hhPanel["s" + _loc1_].mouseChildren = false;
            hhPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            hhPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            hhPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         selbool = true;
         clickObj = param1.target as MovieClip;
         hhPanel["chose"].visible = true;
         hhPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         hhPanel["select"].gotoAndStop(clickObj.currentFrame);
         hhPanel["select"].visible = true;
      }
      
      public static function closeUS(param1:*) : *
      {
         close();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         hhPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         var _loc4_:String = _loc2_.name.substr(0,1);
         if(_loc4_ == "e")
         {
            if(myPlayer.getBag().getEquipFromBag(_loc3_) != null)
            {
               if(myPlayer.getBag().getEquipFromBag(_loc3_).getPosition() >= 5 && myPlayer.getBag().getEquipFromBag(_loc3_).getPosition() <= 7)
               {
                  itemsTooltip.equipTooltip(myPlayer.getBag().getEquipFromBag(_loc3_),1);
               }
            }
         }
         else if(myPlayer.getEquipSlot().getEquipFromSlot(_loc3_).getPosition() >= 5 && myPlayer.getEquipSlot().getEquipFromSlot(_loc3_).getPosition() <= 7)
         {
            itemsTooltip.slotTooltip(_loc3_,myPlayer.getEquipSlot());
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = hhPanel.mouseX + 10;
         itemsTooltip.y = hhPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function showAll() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < 24)
         {
            hhPanel["e" + _loc1_].t_txt.text = "";
            if(myPlayer.getBag().getEquipFromBag(_loc1_) != null)
            {
               if(myPlayer.getBag().getEquipFromBag(_loc1_).getPosition() >= 5 && myPlayer.getBag().getEquipFromBag(_loc1_).getPosition() <= 7)
               {
                  hhPanel["e" + _loc1_].gotoAndStop(myPlayer.getBag().getEquipFromBag(_loc1_).getFrame());
                  hhPanel["e" + _loc1_].visible = true;
               }
               else
               {
                  hhPanel["e" + _loc1_].visible = false;
               }
            }
            else
            {
               hhPanel["e" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < 8)
         {
            hhPanel["s" + _loc2_].t_txt.text = "";
            if(myPlayer.getEquipSlot().getEquipFromSlot(_loc2_) != null)
            {
               if(myPlayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() >= 5 && myPlayer.getEquipSlot().getEquipFromSlot(_loc2_).getPosition() <= 7)
               {
                  hhPanel["s" + _loc2_].gotoAndStop(myPlayer.getEquipSlot().getEquipFromSlot(_loc2_).getFrame());
                  hhPanel["s" + _loc2_].visible = true;
               }
               else
               {
                  hhPanel["s" + _loc2_].visible = false;
               }
            }
            else
            {
               hhPanel["s" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private static function doHH(param1:*) : *
      {
         if(selbool == false)
         {
            return;
         }
         if(otherID == 63300)
         {
            if(nameStr == "e")
            {
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 5)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(1,"剑金6",miaoshu);
               }
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 6)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(1,"杖金6",miaoshu);
               }
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 7)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(1,"拳金6",miaoshu);
               }
            }
            else
            {
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 5)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(1,"剑金6",miaoshu);
               }
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 6)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(1,"杖金6",miaoshu);
               }
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 7)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(1,"拳金6",miaoshu);
               }
            }
            myPlayer.getBag().delOtherById(63300);
            if(PK_UI.jiFenArr[7] > 0)
            {
               --PK_UI.jiFenArr[7];
            }
         }
         if(otherID == 63309)
         {
            if(nameStr == "e")
            {
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 5)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(2,"绿1",miaoshu);
               }
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 6)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(2,"绿1",miaoshu);
               }
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 7)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(2,"绿1",miaoshu);
               }
            }
            else
            {
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 5)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(2,"绿1",miaoshu);
               }
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 6)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(2,"绿1",miaoshu);
               }
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 7)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(2,"绿1",miaoshu);
               }
            }
            myPlayer.getBag().delOtherById(63309);
         }
         if(otherID == 63327)
         {
            if(nameStr == "e")
            {
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 5)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(3,"剑金7",miaoshu);
               }
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 6)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(3,"杖金7",miaoshu);
               }
               if(myPlayer.getBag().getEquipFromBag(clickNum).getPosition() == 7)
               {
                  myPlayer.getBag().getEquipFromBag(clickNum).setHuanHua(3,"拳金7",miaoshu);
               }
            }
            else
            {
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 5)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(3,"剑金7",miaoshu);
               }
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 6)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(3,"杖金7",miaoshu);
               }
               if(myPlayer.getEquipSlot().getEquipFromSlot(clickNum).getPosition() == 7)
               {
                  myPlayer.getEquipSlot().getEquipFromSlot(clickNum).setHuanHua(3,"拳金7",miaoshu);
               }
            }
            myPlayer.getBag().delOtherById(63327);
         }
         if(myPlayer == Main.player1)
         {
            Main.player_1.newSkin();
         }
         else
         {
            Main.player_2.newSkin();
         }
         NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"幻化成功");
         close();
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
   }
}

