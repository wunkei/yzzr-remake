package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   import src.tool.*;
   
   public class QiangHuaPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var qhPanel:MovieClip;
      
      public static var qhp:QiangHuaPanel;
      
      public static var clickObj:MovieClip;
      
      private static var nameStr:String;
      
      public static var clickNum:Number;
      
      public static var starNum:Number;
      
      public static var oldNum:Number;
      
      private static var loadData:ClassLoader;
      
      public static var selbool:Boolean = false;
      
      public static var isPOne:Boolean = true;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_QHQC_v1.swf";
      
      public function QiangHuaPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!qhPanel && !loadData)
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
            _loc3_ = qhPanel.getChildIndex(qhPanel["e" + _loc1_]);
            _loc2_.x = qhPanel["e" + _loc1_].x;
            _loc2_.y = qhPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            qhPanel.removeChild(qhPanel["e" + _loc1_]);
            qhPanel["e" + _loc1_] = _loc2_;
            qhPanel.addChild(_loc2_);
            qhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = qhPanel.getChildIndex(qhPanel["s" + _loc1_]);
            _loc2_.x = qhPanel["s" + _loc1_].x;
            _loc2_.y = qhPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            qhPanel.removeChild(qhPanel["s" + _loc1_]);
            qhPanel["s" + _loc1_] = _loc2_;
            qhPanel.addChild(_loc2_);
            qhPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = qhPanel.getChildIndex(qhPanel["select"]);
         _loc2_.x = qhPanel["select"].x;
         _loc2_.y = qhPanel["select"].y;
         _loc2_.name = "select";
         qhPanel.removeChild(qhPanel["select"]);
         qhPanel["select"] = _loc2_;
         qhPanel.addChild(_loc2_);
         qhPanel.setChildIndex(_loc2_,_loc3_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("QHShow") as Class;
         qhPanel = new _loc2_();
         qhp.addChild(qhPanel);
         InitIcon();
         if(OpenYN)
         {
            open(isPOne,oldNum);
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         qhp = new QiangHuaPanel();
         LoadSkin();
         Main._stage.addChild(qhp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         qhp = new QiangHuaPanel();
         Main._stage.addChild(qhp);
         OpenYN = false;
      }
      
      public static function open(param1:Boolean, param2:int) : void
      {
         Main.allClosePanel();
         if(qhPanel)
         {
            oldNum = param2;
            Main.stopXX = true;
            qhp.x = 0;
            qhp.y = 0;
            isPOne = param1;
            addListenerP1();
            Main._stage.addChild(qhp);
            qhp.visible = true;
         }
         else
         {
            oldNum = param2;
            isPOne = param1;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(qhPanel)
         {
            selbool = false;
            Main.stopXX = false;
            removeListenerP1();
            qhp.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         var _loc1_:uint = 0;
         qhPanel["isQC"].visible = false;
         qhPanel["isQC"]["yesQC"].addEventListener(MouseEvent.CLICK,yesQC);
         qhPanel["isQC"]["noQC"].addEventListener(MouseEvent.CLICK,noQC);
         qhPanel["isQC"]["noQC2"].addEventListener(MouseEvent.CLICK,noQC);
         qhPanel["qc_btn"].addEventListener(MouseEvent.CLICK,doQH);
         qhPanel["close"].addEventListener(MouseEvent.CLICK,closeQH);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            qhPanel["e" + _loc1_].mouseChildren = false;
            qhPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            qhPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            qhPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            qhPanel["s" + _loc1_].mouseChildren = false;
            qhPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            qhPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            qhPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         qhPanel["select"].gotoAndStop(1);
         qhPanel["select"].visible = false;
         if(isPOne)
         {
            _loc1_ = 0;
            while(_loc1_ < 24)
            {
               qhPanel["e" + _loc1_].t_txt.text = "";
               if(Main.player1.getBag().getEquipFromBag(_loc1_) != null)
               {
                  if(Main.player1.getBag().getEquipFromBag(_loc1_).getReinforceLevel() > 0)
                  {
                     qhPanel["e" + _loc1_].gotoAndStop(Main.player1.getBag().getEquipFromBag(_loc1_).getFrame());
                     qhPanel["e" + _loc1_].visible = true;
                  }
                  else
                  {
                     qhPanel["e" + _loc1_].visible = false;
                  }
               }
               else
               {
                  qhPanel["e" + _loc1_].visible = false;
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < 8)
            {
               qhPanel["s" + _loc1_].t_txt.text = "";
               if(Main.player1.getEquipSlot().getEquipFromSlot(_loc1_) != null)
               {
                  if(Main.player1.getEquipSlot().getEquipFromSlot(_loc1_).getReinforceLevel() > 0)
                  {
                     qhPanel["s" + _loc1_].gotoAndStop(Main.player1.getEquipSlot().getEquipFromSlot(_loc1_).getFrame());
                     qhPanel["s" + _loc1_].visible = true;
                  }
                  else
                  {
                     qhPanel["s" + _loc1_].visible = false;
                  }
               }
               else
               {
                  qhPanel["s" + _loc1_].visible = false;
               }
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 24)
            {
               qhPanel["e" + _loc1_].t_txt.text = "";
               if(Main.player2.getBag().getEquipFromBag(_loc1_) != null)
               {
                  if(Main.player2.getBag().getEquipFromBag(_loc1_).getReinforceLevel() > 0)
                  {
                     qhPanel["e" + _loc1_].gotoAndStop(Main.player2.getBag().getEquipFromBag(_loc1_).getFrame());
                     qhPanel["e" + _loc1_].visible = true;
                  }
                  else
                  {
                     qhPanel["e" + _loc1_].visible = false;
                  }
               }
               else
               {
                  qhPanel["e" + _loc1_].visible = false;
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < 8)
            {
               qhPanel["s" + _loc1_].t_txt.text = "";
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc1_) != null)
               {
                  if(Main.player2.getEquipSlot().getEquipFromSlot(_loc1_).getReinforceLevel() > 0)
                  {
                     qhPanel["s" + _loc1_].gotoAndStop(Main.player2.getEquipSlot().getEquipFromSlot(_loc1_).getFrame());
                     qhPanel["s" + _loc1_].visible = true;
                  }
                  else
                  {
                     qhPanel["s" + _loc1_].visible = false;
                  }
               }
               else
               {
                  qhPanel["s" + _loc1_].visible = false;
               }
               _loc1_++;
            }
         }
         qhPanel["chose"].visible = false;
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         qhPanel["close"].removeEventListener(MouseEvent.CLICK,closeQH);
         qhPanel["qc_btn"].removeEventListener(MouseEvent.CLICK,doQH);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            qhPanel["e" + _loc1_].mouseChildren = false;
            qhPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            qhPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            qhPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            qhPanel["s" + _loc1_].mouseChildren = false;
            qhPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            qhPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            qhPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
      }
      
      public static function closeQH(param1:*) : *
      {
         close();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         qhPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         var _loc4_:String = _loc2_.name.substr(0,1);
         TiaoShi.txtShow(_loc2_.name);
         if(isPOne)
         {
            if(_loc4_ == "e")
            {
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
         itemsTooltip.x = qhPanel.mouseX + 10;
         itemsTooltip.y = qhPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function yesQC(param1:*) : *
      {
         if(selbool == false)
         {
            return;
         }
         if(isPOne)
         {
            if(nameStr == "e")
            {
               Main.player1.getBag().getEquipFromBag(clickNum).reinforceClear();
            }
            else
            {
               Main.player1.getEquipSlot().getEquipFromSlot(clickNum).reinforceClear();
            }
            Main.player1.getBag().delOtherobj(oldNum,1);
         }
         else
         {
            if(nameStr == "e")
            {
               Main.player2.getBag().getEquipFromBag(clickNum).reinforceClear();
            }
            else
            {
               Main.player2.getEquipSlot().getEquipFromSlot(clickNum).reinforceClear();
            }
            Main.player2.getBag().delOtherobj(oldNum,1);
         }
         qhPanel["isQC"].visible = false;
         NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
         close();
      }
      
      private static function noQC(param1:*) : *
      {
         qhPanel["isQC"].visible = false;
      }
      
      private static function doQH(param1:*) : *
      {
         qhPanel["isQC"].visible = true;
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         selbool = true;
         clickObj = param1.target as MovieClip;
         qhPanel["chose"].visible = true;
         qhPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         qhPanel["select"].gotoAndStop(clickObj.currentFrame);
         qhPanel["select"].visible = true;
      }
   }
}

