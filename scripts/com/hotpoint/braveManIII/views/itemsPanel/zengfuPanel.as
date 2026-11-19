package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class zengfuPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var zfPanel:MovieClip;
      
      public static var zfp:zengfuPanel;
      
      public static var clickObj:MovieClip;
      
      private static var nameStr:String;
      
      public static var clickNum:Number;
      
      public static var strS:String;
      
      public static var skillId:Number;
      
      public static var oldNum:Number;
      
      private static var loadData:ClassLoader;
      
      public static var yeshu:Number = 0;
      
      public static var isPOne:Boolean = true;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_ZF_v892.swf";
      
      public function zengfuPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!zfPanel && !loadData)
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
            _loc3_ = zfPanel.getChildIndex(zfPanel["e" + _loc1_]);
            _loc2_.x = zfPanel["e" + _loc1_].x;
            _loc2_.y = zfPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            zfPanel.removeChild(zfPanel["e" + _loc1_]);
            zfPanel["e" + _loc1_] = _loc2_;
            zfPanel.addChild(_loc2_);
            zfPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = zfPanel.getChildIndex(zfPanel["s" + _loc1_]);
            _loc2_.x = zfPanel["s" + _loc1_].x;
            _loc2_.y = zfPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            zfPanel.removeChild(zfPanel["s" + _loc1_]);
            zfPanel["s" + _loc1_] = _loc2_;
            zfPanel.addChild(_loc2_);
            zfPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = zfPanel.getChildIndex(zfPanel["select"]);
         _loc2_.x = zfPanel["select"].x;
         _loc2_.y = zfPanel["select"].y;
         _loc2_.name = "select";
         zfPanel.removeChild(zfPanel["select"]);
         zfPanel["select"] = _loc2_;
         zfPanel.addChild(_loc2_);
         zfPanel.setChildIndex(_loc2_,_loc3_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("ZFShow") as Class;
         zfPanel = new _loc2_();
         zfp.addChild(zfPanel);
         InitIcon();
         if(OpenYN)
         {
            open(isPOne,strS,skillId,oldNum);
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         zfp = new zengfuPanel();
         LoadSkin();
         Main._stage.addChild(zfp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         zfp = new zengfuPanel();
         Main._stage.addChild(zfp);
         OpenYN = false;
      }
      
      public static function open(param1:Boolean, param2:String, param3:Number, param4:int) : void
      {
         Main.allClosePanel();
         Main.DuoKai_Fun();
         if(zfPanel)
         {
            Main.stopXX = true;
            zfp.x = 0;
            zfp.y = 0;
            isPOne = param1;
            zfPanel["zftxt"].text = param2;
            skillId = param3;
            oldNum = param4;
            addListenerP1();
            Main._stage.addChild(zfp);
            zfp.visible = true;
         }
         else
         {
            skillId = param3;
            oldNum = param4;
            isPOne = param1;
            strS = param2;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(zfPanel)
         {
            Main.stopXX = false;
            removeListenerP1();
            zfp.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         zfPanel["isZF"]["yesZF"].addEventListener(MouseEvent.CLICK,yesZF);
         zfPanel["isZF"]["noZF"].addEventListener(MouseEvent.CLICK,noZF);
         zfPanel["isZF"]["noZF2"].addEventListener(MouseEvent.CLICK,noZF);
         zfPanel["zf_btn"].addEventListener(MouseEvent.CLICK,doZF);
         zfPanel["close"].addEventListener(MouseEvent.CLICK,closeZF);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            zfPanel["e" + _loc1_].mouseChildren = false;
            zfPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            zfPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            zfPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            zfPanel["s" + _loc1_].mouseChildren = false;
            zfPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            zfPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            zfPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         zfPanel["select"].gotoAndStop(1);
         zfPanel["select"].visible = false;
         zfPanel["up_btn"].addEventListener(MouseEvent.CLICK,upGo);
         zfPanel["down_btn"].addEventListener(MouseEvent.CLICK,downGo);
         showAll();
         zfPanel["isZF"].visible = false;
         zfPanel["chose"].visible = false;
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
      
      public static function showAll() : *
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc1_:int = yeshu + 1;
         zfPanel["yeshu_txt"].text = _loc1_ + "/2";
         if(isPOne)
         {
            _loc2_ = 0;
            while(_loc2_ < 24)
            {
               zfPanel["e" + _loc2_].t_txt.text = "";
               if(Main.player1.getBag().getEquipFromBag(_loc2_ + 24 * yeshu) != null)
               {
                  zfPanel["e" + _loc2_].gotoAndStop(Main.player1.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getFrame());
                  zfPanel["e" + _loc2_].visible = true;
               }
               else
               {
                  zfPanel["e" + _loc2_].visible = false;
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
               zfPanel["s" + _loc2_].t_txt.text = "";
               if(Main.player1.getEquipSlot().getEquipFromSlot(_loc3_) != null)
               {
                  zfPanel["s" + _loc2_].gotoAndStop(Main.player1.getEquipSlot().getEquipFromSlot(_loc3_).getFrame());
                  zfPanel["s" + _loc2_].visible = true;
               }
               else
               {
                  zfPanel["s" + _loc2_].visible = false;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 24)
            {
               zfPanel["e" + _loc2_].t_txt.text = "";
               if(Main.player2.getBag().getEquipFromBag(_loc2_ + 24 * yeshu) != null)
               {
                  zfPanel["e" + _loc2_].gotoAndStop(Main.player2.getBag().getEquipFromBag(_loc2_ + 24 * yeshu).getFrame());
                  zfPanel["e" + _loc2_].visible = true;
               }
               else
               {
                  zfPanel["e" + _loc2_].visible = false;
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
               zfPanel["s" + _loc2_].t_txt.text = "";
               if(Main.player2.getEquipSlot().getEquipFromSlot(_loc3_) != null)
               {
                  zfPanel["s" + _loc2_].gotoAndStop(Main.player2.getEquipSlot().getEquipFromSlot(_loc3_).getFrame());
                  zfPanel["s" + _loc2_].visible = true;
               }
               else
               {
                  zfPanel["s" + _loc2_].visible = false;
               }
               _loc2_++;
            }
         }
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         zfPanel["isZF"]["yesZF"].removeEventListener(MouseEvent.CLICK,yesZF);
         zfPanel["isZF"]["noZF"].removeEventListener(MouseEvent.CLICK,noZF);
         zfPanel["isZF"]["noZF2"].removeEventListener(MouseEvent.CLICK,noZF);
         zfPanel["close"].removeEventListener(MouseEvent.CLICK,closeZF);
         zfPanel["zf_btn"].removeEventListener(MouseEvent.CLICK,doZF);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            zfPanel["e" + _loc1_].mouseChildren = false;
            zfPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            zfPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            zfPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            zfPanel["s" + _loc1_].mouseChildren = false;
            zfPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            zfPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            zfPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         zfPanel["up_btn"].removeEventListener(MouseEvent.CLICK,upGo);
         zfPanel["down_btn"].removeEventListener(MouseEvent.CLICK,downGo);
      }
      
      public static function closeZF(param1:*) : *
      {
         close();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         zfPanel.addChild(itemsTooltip);
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
         itemsTooltip.x = zfPanel.mouseX + 10;
         itemsTooltip.y = zfPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function yesZF(param1:*) : *
      {
         if(isPOne)
         {
            if(nameStr == "e")
            {
               Main.player1.getBag().getEquipFromBag(clickNum).setNewSkill(skillId);
            }
            else
            {
               Main.player1.getEquipSlot().getEquipFromSlot(clickNum).setNewSkill(skillId);
            }
            Main.player1.getBag().delGem(oldNum,1);
            AchData.setZfNum(1);
         }
         else
         {
            if(nameStr == "e")
            {
               Main.player2.getBag().getEquipFromBag(clickNum).setNewSkill(skillId);
            }
            else
            {
               Main.player2.getEquipSlot().getEquipFromSlot(clickNum).setNewSkill(skillId);
            }
            Main.player2.getBag().delGem(oldNum,1);
            AchData.setZfNum(2);
         }
         NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"装备增幅成功");
         close();
      }
      
      private static function noZF(param1:*) : *
      {
         zfPanel["isZF"].visible = false;
      }
      
      private static function doZF(param1:*) : *
      {
         if(isPOne)
         {
            if(nameStr == "e")
            {
               if(Main.player1.getBag().getEquipFromBag(clickNum).getNewSkill() == 0)
               {
                  Main.player1.getBag().getEquipFromBag(clickNum).setNewSkill(skillId);
                  Main.player1.getBag().delGem(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"装备增幅成功");
                  AchData.setZfNum(1);
                  close();
               }
               else
               {
                  zfPanel["isZF"].visible = true;
               }
            }
            else if(Main.player1.getEquipSlot().getEquipFromSlot(clickNum).getNewSkill() == 0)
            {
               Main.player1.getEquipSlot().getEquipFromSlot(clickNum).setNewSkill(skillId);
               Main.player1.getBag().delGem(oldNum,1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"装备增幅成功");
               AchData.setZfNum(1);
               close();
            }
            else
            {
               zfPanel["isZF"].visible = true;
            }
         }
         else if(nameStr == "e")
         {
            if(Main.player2.getBag().getEquipFromBag(clickNum).getNewSkill() == 0)
            {
               Main.player2.getBag().getEquipFromBag(clickNum).setNewSkill(skillId);
               Main.player2.getBag().delGem(oldNum,1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"装备增幅成功");
               AchData.setZfNum(2);
               close();
            }
            else
            {
               zfPanel["isZF"].visible = true;
            }
         }
         else if(Main.player2.getEquipSlot().getEquipFromSlot(clickNum).getNewSkill() == 0)
         {
            Main.player2.getEquipSlot().getEquipFromSlot(clickNum).setNewSkill(skillId);
            Main.player2.getBag().delGem(oldNum,1);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"装备增幅成功");
            AchData.setZfNum(2);
            close();
         }
         else
         {
            zfPanel["isZF"].visible = true;
         }
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         clickObj = param1.target as MovieClip;
         zfPanel["chose"].visible = true;
         zfPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         if(nameStr != "e" && (clickNum == 0 || clickNum == 1 || clickNum == 3 || clickNum == 4) && Main.water.getValue() != 1)
         {
            clickNum += 8;
         }
         if(nameStr == "e")
         {
            clickNum += yeshu * 24;
         }
         zfPanel["select"].gotoAndStop(clickObj.currentFrame);
         zfPanel["select"].visible = true;
      }
   }
}

