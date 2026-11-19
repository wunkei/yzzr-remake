package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class xilianPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var xlPanel:MovieClip;
      
      public static var xlp:xilianPanel;
      
      public static var clickObj:MovieClip;
      
      private static var nameStr:String;
      
      public static var myplayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      public static var clickNum:Number = 100;
      
      public static var tempTime:Number = 0;
      
      public static var isPOne:Boolean = true;
      
      public static var moneyOK:int = 0;
      
      public static var yeshu:Number = 0;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_XL_v892.swf";
      
      public function xilianPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!xlPanel && !loadData)
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
            _loc3_ = xlPanel.getChildIndex(xlPanel["e" + _loc1_]);
            _loc2_.x = xlPanel["e" + _loc1_].x;
            _loc2_.y = xlPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            xlPanel.removeChild(xlPanel["e" + _loc1_]);
            xlPanel["e" + _loc1_] = _loc2_;
            xlPanel.addChild(_loc2_);
            xlPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = xlPanel.getChildIndex(xlPanel["s" + _loc1_]);
            _loc2_.x = xlPanel["s" + _loc1_].x;
            _loc2_.y = xlPanel["s" + _loc1_].y;
            _loc2_.name = "s" + _loc1_;
            xlPanel.removeChild(xlPanel["s" + _loc1_]);
            xlPanel["s" + _loc1_] = _loc2_;
            xlPanel.addChild(_loc2_);
            xlPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc3_ = xlPanel.getChildIndex(xlPanel["select"]);
         _loc2_.x = xlPanel["select"].x;
         _loc2_.y = xlPanel["select"].y;
         _loc2_.name = "select";
         xlPanel.removeChild(xlPanel["select"]);
         xlPanel["select"] = _loc2_;
         xlPanel.addChild(_loc2_);
         xlPanel.setChildIndex(_loc2_,_loc3_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("XLShow") as Class;
         xlPanel = new _loc2_();
         xlp.addChild(xlPanel);
         InitIcon();
         if(OpenYN)
         {
            open(isPOne);
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         xlp = new xilianPanel();
         LoadSkin();
         Main._stage.addChild(xlp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         xlp = new xilianPanel();
         Main._stage.addChild(xlp);
         OpenYN = false;
      }
      
      public static function open(param1:Boolean) : void
      {
         Main.allClosePanel();
         Main.DuoKai_Fun();
         if(xlPanel)
         {
            noShow();
            Main.stopXX = true;
            xlp.x = 0;
            xlp.y = 0;
            isPOne = param1;
            myplayer = Main.player1;
            addListenerP1();
            Main._stage.addChild(xlp);
            xlp.visible = true;
         }
         else
         {
            isPOne = param1;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(xlPanel)
         {
            Main.stopXX = false;
            removeListenerP1();
            xlp.visible = false;
            clickObj = null;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         xlPanel["waiting"].visible = false;
         xlPanel["xl_btn"].addEventListener(MouseEvent.CLICK,doXL);
         xlPanel["xl_btn"].addEventListener(MouseEvent.MOUSE_OVER,doOVER);
         xlPanel["xl_btn"].addEventListener(MouseEvent.MOUSE_OUT,doOUT);
         xlPanel["close"].addEventListener(MouseEvent.CLICK,closeXL);
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            xlPanel["e" + _loc1_].mouseChildren = false;
            xlPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            xlPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            xlPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            xlPanel["s" + _loc1_].mouseChildren = false;
            xlPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            xlPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            xlPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         xlPanel["s1_mc"].stop();
         xlPanel["select"].gotoAndStop(1);
         xlPanel["select"].visible = false;
         xlPanel["tishi_mc"].visible = false;
         xlPanel["up_btn"].addEventListener(MouseEvent.CLICK,upGo);
         xlPanel["down_btn"].addEventListener(MouseEvent.CLICK,downGo);
         if(Main.P1P2)
         {
            xlPanel["pb_0"].visible = true;
            xlPanel["pb_1"].visible = true;
            xlPanel["back_btn"].visible = true;
            xlPanel["pb_0"].addEventListener(MouseEvent.CLICK,toP1);
            xlPanel["pb_1"].addEventListener(MouseEvent.CLICK,toP2);
         }
         else
         {
            xlPanel["pb_0"].visible = false;
            xlPanel["pb_1"].visible = false;
            xlPanel["back_btn"].visible = false;
         }
         showAll();
      }
      
      public static function toP1(param1:*) : *
      {
         myplayer = Main.player1;
         xlPanel["pb_0"].visible = false;
         xlPanel["pb_1"].visible = true;
         showAll();
      }
      
      public static function toP2(param1:*) : *
      {
         myplayer = Main.player2;
         xlPanel["pb_0"].visible = true;
         xlPanel["pb_1"].visible = false;
         showAll();
      }
      
      public static function showAll() : *
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc1_:int = yeshu + 1;
         xlPanel["yeshu_txt"].text = _loc1_ + "/2";
         _loc2_ = 0;
         while(_loc2_ < 24)
         {
            xlPanel["e" + _loc2_].t_txt.text = "";
            if(myplayer.getBag().getEquipFromBag(_loc2_ + yeshu * 24) != null && (myplayer.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getPosition() <= 7 || myplayer.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getPosition() >= 10))
            {
               xlPanel["e" + _loc2_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc2_ + yeshu * 24).getFrame());
               xlPanel["e" + _loc2_].visible = true;
            }
            else
            {
               xlPanel["e" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            _loc3_ = int(_loc2_);
            if(Main.water.getValue() != 1 && (_loc3_ == 0 || _loc3_ == 1 || _loc3_ == 3 || _loc3_ == 4))
            {
               _loc3_ += 8;
            }
            xlPanel["s" + _loc2_].t_txt.text = "";
            if(myplayer.getEquipSlot().getEquipFromSlot(_loc3_) != null)
            {
               xlPanel["s" + _loc2_].gotoAndStop(myplayer.getEquipSlot().getEquipFromSlot(_loc3_).getFrame());
               xlPanel["s" + _loc2_].visible = true;
            }
            else
            {
               xlPanel["s" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         xlPanel["chose"].visible = false;
         xlPanel.point_txt.text = Shop4399.moneyAll.getValue();
      }
      
      public static function removeListenerP1() : *
      {
         var _loc1_:uint = 0;
         xlPanel["close"].removeEventListener(MouseEvent.CLICK,closeXL);
         xlPanel["xl_btn"].removeEventListener(MouseEvent.CLICK,doXL);
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            xlPanel["e" + _loc1_].mouseChildren = false;
            xlPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            xlPanel["e" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            xlPanel["e" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            xlPanel["s" + _loc1_].mouseChildren = false;
            xlPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            xlPanel["s" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            xlPanel["s" + _loc1_].removeEventListener(MouseEvent.CLICK,selected);
            _loc1_++;
         }
         xlPanel["up_btn"].removeEventListener(MouseEvent.CLICK,upGo);
         xlPanel["down_btn"].removeEventListener(MouseEvent.CLICK,downGo);
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
      
      public static function closeXL(param1:*) : *
      {
         close();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         xlPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         var _loc4_:String = _loc2_.name.substr(0,1);
         if(_loc4_ == "e")
         {
            _loc3_ += 24 * yeshu;
            if(myplayer.getBag().getEquipFromBag(_loc3_) != null)
            {
               itemsTooltip.equipTooltip(myplayer.getBag().getEquipFromBag(_loc3_),1);
            }
         }
         else
         {
            itemsTooltip.slotTooltip(_loc3_,myplayer.getEquipSlot());
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = xlPanel.mouseX + 10;
         itemsTooltip.y = xlPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function doOVER(param1:*) : *
      {
         xlPanel["tishi_mc"].visible = true;
         xlPanel["tishi_mc"]["juan_num"].text = "当前拥有" + myplayer.getBag().getOtherobjNum(63210) + "张洗练卷";
      }
      
      private static function doOUT(param1:*) : *
      {
         xlPanel["tishi_mc"].visible = false;
      }
      
      private static function doXL(param1:*) : *
      {
         var _loc2_:uint = 0;
         if(clickObj)
         {
            xlPanel["xl_btn"].visible = false;
            if(myplayer.getBag().getOtherobjNum(63210) > 0)
            {
               xlPanel["waiting"].visible = true;
               moneyOK = 2;
               myplayer.getBag().delOtherById(63210,1);
               Main.Save();
               return;
            }
            if(Shop4399.moneyAll.getValue() >= 18)
            {
               Api_4399_All.BuyObj(InitData.XiLian_Money.getValue());
               moneyOK = 1;
               xlPanel["waiting"].visible = true;
               _loc2_ = 0;
               while(_loc2_ < 24)
               {
                  xlPanel["e" + _loc2_].removeEventListener(MouseEvent.CLICK,selected);
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < 6)
               {
                  xlPanel["s" + _loc2_].removeEventListener(MouseEvent.CLICK,selected);
                  _loc2_++;
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"缺少洗炼卷或点卷");
            }
         }
      }
      
      public static function xlOK() : *
      {
         var _loc1_:uint = 0;
         if(xilianPanel.xlPanel)
         {
            xilianPanel.xlPanel["xl_btn"].visible = true;
         }
         if(moneyOK > 0)
         {
            if(nameStr == "e")
            {
               myplayer.getBag().addEquipBag(myplayer.getBag().delEquip(clickNum).reCreatEquip(),clickNum);
               showAttrib2(myplayer.getBag().getEquipFromBag(clickNum));
            }
            else
            {
               myplayer.getEquipSlot().addToSlot(myplayer.getEquipSlot().delSlot(clickNum).reCreatEquip(),clickNum);
               showAttrib2(myplayer.getEquipSlot().getEquipFromSlot(clickNum));
            }
            _loc1_ = 0;
            while(_loc1_ < 24)
            {
               xlPanel["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               xlPanel["s" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
               _loc1_++;
            }
            JiHua_Interface.ppp4_10 = true;
            if(moneyOK == 2)
            {
               xlPanel["xl_btn"].visible = true;
            }
            xlPanel["waiting"].visible = false;
            xlPanel["s1_mc"].gotoAndPlay(2);
            tempTime = 0;
            moneyOK = 0;
         }
      }
      
      private static function noShow() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 8)
         {
            xlPanel["txt_" + _loc1_].visible = false;
            xlPanel["txtb_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private static function showAttrib(param1:Equip) : *
      {
         noShow();
         var _loc2_:Array = param1.showBaseAttrib();
         var _loc3_:uint = 0;
         var _loc4_:uint = 4;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc2_[_loc5_][0] == 1)
            {
               xlPanel["txt_" + _loc3_].text = _loc2_[_loc5_][1];
               xlPanel["txt_" + _loc3_].visible = true;
               _loc3_++;
            }
            else
            {
               xlPanel["txt_" + _loc4_].text = _loc2_[_loc5_][1];
               xlPanel["txt_" + _loc4_].visible = true;
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      private static function showAttrib2(param1:Equip) : *
      {
         var _loc2_:Array = param1.showBaseAttrib();
         var _loc3_:uint = 0;
         var _loc4_:uint = 4;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc2_[_loc5_][0] == 1)
            {
               xlPanel["txtb_" + _loc3_].text = _loc2_[_loc5_][1];
               xlPanel["txtb_" + _loc3_].visible = true;
               _loc3_++;
            }
            else
            {
               xlPanel["txtb_" + _loc4_].text = _loc2_[_loc5_][1];
               xlPanel["txtb_" + _loc4_].visible = true;
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function selected(param1:MouseEvent) : void
      {
         xlPanel["xl_btn"].visible = true;
         clickObj = param1.target as MovieClip;
         xlPanel["chose"].visible = true;
         xlPanel["chose"].x = clickObj.x - 2;
         --clickObj.y;
         clickNum = uint(clickObj.name.substr(1,2));
         nameStr = clickObj.name.substr(0,1);
         if(nameStr != "e" && Main.water.getValue() != 1 && (clickNum == 0 || clickNum == 1 || clickNum == 3 || clickNum == 4))
         {
            clickNum += 8;
         }
         if(nameStr == "e")
         {
            clickNum += 24 * yeshu;
         }
         xlPanel["select"].gotoAndStop(clickObj.currentFrame);
         xlPanel["select"].visible = true;
         if(nameStr == "e")
         {
            showAttrib(myplayer.getBag().getEquipFromBag(clickNum));
         }
         else
         {
            showAttrib(myplayer.getEquipSlot().getEquipFromSlot(clickNum));
         }
      }
   }
}

