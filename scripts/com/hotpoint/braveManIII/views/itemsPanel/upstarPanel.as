package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class upstarPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var usPanel:MovieClip;
      
      public static var usp:upstarPanel;
      
      public static var clickObj:MovieClip;
      
      private static var nameStr:String;
      
      public static var clickNum:Number;
      
      public static var starNum:Number;
      
      public static var oldNum:Number;
      
      public static var strS:String;
      
      private static var loadData:ClassLoader;
      
      public static var yeshu:Number = 0;
      
      public static var selbool:Boolean = false;
      
      public static var isPOne:Boolean = true;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_US_v892.swf";
      
      public function upstarPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!usPanel && !loadData)
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
            _loc3_ = usPanel.getChildIndex(usPanel["e" + _loc1_]);
            _loc2_.x = usPanel["e" + _loc1_].x;
            _loc2_.y = usPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            usPanel.removeChild(usPanel["e" + _loc1_]);
            usPanel["e" + _loc1_] = _loc2_;
            usPanel.addChild(_loc2_);
            usPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = usPanel.getChildIndex(usPanel["s" + _loc1_]);
            _loc2_.x = usPanel["s" + _loc1_].x;
            _loc2_.y = usPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            usPanel.removeChild(usPanel["s" + _loc1_]);
            usPanel["s" + _loc1_] = _loc2_;
            usPanel.addChild(_loc2_);
            usPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = usPanel.getChildIndex(usPanel["select"]);
         _loc2_.x = usPanel["select"].x;
         _loc2_.y = usPanel["select"].y;
         _loc2_.name = "select";
         usPanel.removeChild(usPanel["select"]);
         usPanel["select"] = _loc2_;
         usPanel.addChild(_loc2_);
         usPanel.setChildIndex(_loc2_,_loc3_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("USShow") as Class;
         usPanel = new _loc2_();
         usp.addChild(usPanel);
         InitIcon();
         if(OpenYN)
         {
            open(isPOne,strS,starNum,oldNum);
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         usp = new upstarPanel();
         LoadSkin();
         Main._stage.addChild(usp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         usp = new upstarPanel();
         Main._stage.addChild(usp);
         OpenYN = false;
      }
      
      public static function open(param1:Boolean, param2:String, param3:Number, param4:int) : void
      {
         Main.allClosePanel();
         if(usPanel)
         {
            Main.stopXX = true;
            usp.x = 0;
            usp.y = 0;
            isPOne = param1;
            usPanel["txt"].text = param2;
            starNum = param3 - 1;
            oldNum = param4;
            addListenerP1();
            Main._stage.addChild(usp);
            usp.visible = true;
         }
         else
         {
            starNum = param3;
            oldNum = param4;
            isPOne = param1;
            strS = param2;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(usPanel)
         {
            Main.stopXX = false;
            removeListenerP1();
            usp.visible = false;
            selbool = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         usPanel["us_btn"].addEventListener(MouseEvent.CLICK,doUS);
         usPanel["close"].addEventListener(MouseEvent.CLICK,closeUS);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            usPanel["e" + _loc1_].mouseChildren = false;
            usPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            usPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            usPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            usPanel["s" + _loc1_].mouseChildren = false;
            usPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            usPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            usPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         usPanel["up_btn"].addEventListener(MouseEvent.CLICK,upGo);
         usPanel["down_btn"].addEventListener(MouseEvent.CLICK,downGo);
         usPanel["select"].gotoAndStop(1);
         usPanel["select"].visible = false;
         showAll();
         usPanel["chose"].visible = false;
      }
      
      public static function showAll() : *
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc1_:int = yeshu + 1;
         usPanel["yeshu_txt"].text = _loc1_ + "/2";
         if(isPOne)
         {
            _loc2_ = 0;
            while(_loc2_ < 24)
            {
               usPanel["e" + _loc2_].t_txt.text = "";
               if(Main.player1.getBag().getEquipFromBag(_loc2_ + yeshu * 24) != null)
               {
                  if(Main.player1.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getStar() == starNum)
                  {
                     usPanel["e" + _loc2_].gotoAndStop(Main.player1.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getFrame());
                     usPanel["e" + _loc2_].visible = true;
                  }
                  else
                  {
                     usPanel["e" + _loc2_].visible = false;
                  }
               }
               else
               {
                  usPanel["e" + _loc2_].visible = false;
               }
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               usPanel["s" + _loc2_].t_txt.text = "";
               _loc3_ = int(_loc2_);
               if((_loc2_ == 0 || _loc2_ == 1 || _loc2_ == 3 || _loc2_ == 4) && Main.water.getValue() != 1)
               {
                  _loc3_ += 8;
               }
               if(Main.player1.getEquipSlot().getEquipFromSlot(_loc3_) != null)
               {
                  if(Main.player1.getEquipSlot().getEquipFromSlot(_loc3_).getStar() == starNum)
                  {
                     usPanel["s" + _loc2_].gotoAndStop(Main.player1.getEquipSlot().getEquipFromSlot(_loc3_).getFrame());
                     usPanel["s" + _loc2_].visible = true;
                  }
                  else
                  {
                     usPanel["s" + _loc2_].visible = false;
                  }
               }
               else
               {
                  usPanel["s" + _loc2_].visible = false;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 24)
            {
               usPanel["e" + _loc2_].t_txt.text = "";
               if(Main.player2.getBag().getEquipFromBag(_loc2_ + yeshu * 24) != null)
               {
                  if(Main.player2.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getStar() == starNum)
                  {
                     usPanel["e" + _loc2_].gotoAndStop(Main.player2.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getFrame());
                     usPanel["e" + _loc2_].visible = true;
                  }
                  else
                  {
                     usPanel["e" + _loc2_].visible = false;
                  }
               }
               else
               {
                  usPanel["e" + _loc2_].visible = false;
               }
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc3_ = int(_loc2_);
               if((_loc2_ == 0 || _loc2_ == 1 || _loc2_ == 3 || _loc2_ == 4) && Main.water.getValue() != 1)
               {
                  _loc3_ += 8;
               }
               usPanel["s" + _loc2_].t_txt.text = "";
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc3_) != null)
               {
                  if(Main.player2.getEquipSlot().getEquipFromSlot(_loc3_).getStar() == starNum)
                  {
                     usPanel["s" + _loc2_].gotoAndStop(Main.player2.getEquipSlot().getEquipFromSlot(_loc3_).getFrame());
                     usPanel["s" + _loc2_].visible = true;
                  }
                  else
                  {
                     usPanel["s" + _loc2_].visible = false;
                  }
               }
               else
               {
                  usPanel["s" + _loc2_].visible = false;
               }
               _loc2_++;
            }
         }
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         usPanel["close"].removeEventListener(MouseEvent.CLICK,closeUS);
         usPanel["us_btn"].removeEventListener(MouseEvent.CLICK,doUS);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            usPanel["e" + _loc1_].mouseChildren = false;
            usPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            usPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            usPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            usPanel["s" + _loc1_].mouseChildren = false;
            usPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            usPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            usPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         usPanel["up_btn"].removeEventListener(MouseEvent.CLICK,upGo);
         usPanel["down_btn"].removeEventListener(MouseEvent.CLICK,downGo);
      }
      
      public static function closeUS(param1:*) : *
      {
         close();
      }
      
      public static function upGo(param1:*) : *
      {
         yeshu = 0;
         showAll();
      }
      
      public static function downGo(param1:*) : *
      {
         yeshu = 1;
         showAll();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         usPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         var _loc4_:String = _loc2_.name.substr(0,1);
         if(isPOne)
         {
            if(_loc4_ == "e")
            {
               _loc3_ += 24 * yeshu;
               if(Main.player1.getBag().getEquipFromBag(_loc3_) != null)
               {
                  itemsTooltip.equipTooltip(Main.player1.getBag().getEquipFromBag(_loc3_),1);
               }
            }
            else
            {
               itemsTooltip.slotTooltip(_loc3_,Main.player1.getEquipSlot());
            }
         }
         else if(_loc4_ == "e")
         {
            _loc3_ += 24 * yeshu;
            if(Main.player2.getBag().getEquipFromBag(_loc3_) != null)
            {
               itemsTooltip.equipTooltip(Main.player2.getBag().getEquipFromBag(_loc3_),2);
            }
         }
         else
         {
            itemsTooltip.slotTooltip(_loc3_,Main.player2.getEquipSlot());
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = usPanel.mouseX + 10;
         itemsTooltip.y = usPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function doUS(param1:*) : *
      {
         if(selbool == false)
         {
            return;
         }
         if(isPOne)
         {
            if(nameStr == "e")
            {
               Main.player1.getBag().addEquipBag(Main.player1.getBag().delEquip(clickNum).upStarEquip());
            }
            else
            {
               Main.player1.getEquipSlot().addToSlot(Main.player1.getEquipSlot().delSlot(clickNum).upStarEquip(),clickNum);
            }
            Main.player1.getBag().delGem(oldNum,1);
         }
         else
         {
            if(nameStr == "e")
            {
               Main.player2.getBag().addEquipBag(Main.player2.getBag().delEquip(clickNum).upStarEquip());
            }
            else
            {
               Main.player2.getEquipSlot().addToSlot(Main.player2.getEquipSlot().delSlot(clickNum).upStarEquip(),clickNum);
            }
            Main.player2.getBag().delGem(oldNum,1);
         }
         NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
         close();
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         selbool = true;
         clickObj = param1.target as MovieClip;
         usPanel["chose"].visible = true;
         usPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         if(nameStr != "e" && (clickNum == 0 || clickNum == 1 || clickNum == 3 || clickNum == 4) && Main.water.getValue() != 1)
         {
            clickNum += 8;
         }
         if(nameStr == "e")
         {
            clickNum += 24 * yeshu;
         }
         usPanel["select"].gotoAndStop(clickObj.currentFrame);
         usPanel["select"].visible = true;
      }
   }
}

