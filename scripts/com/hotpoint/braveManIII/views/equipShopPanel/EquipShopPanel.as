package com.hotpoint.braveManIII.views.equipShopPanel
{
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.equipShop.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import src.*;
   
   public class EquipShopPanel extends MovieClip
   {
      
      public static var equipShopPanel:MovieClip;
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var dragObj:MovieClip;
      
      public static var clickObj:MovieClip;
      
      private static var pointx:Number;
      
      private static var pointy:Number;
      
      private static var oldNum:Number;
      
      public static var esp:EquipShopPanel;
      
      public static var myPlayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      private static var ee:Equip;
      
      private static var arr:Array = [];
      
      public static var isDown:Boolean = false;
      
      public static var noRMBOK:Boolean = false;
      
      public static var equipShopOK:Boolean = false;
      
      public static var returnx:Number = 0;
      
      public static var returny:Number = 0;
      
      private static var yeshu:int = 1;
      
      private static var clickTime:int = 0;
      
      private static var myMenu:ContextMenu = new ContextMenu();
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "NewEquipShop_v3.swf";
      
      public function EquipShopPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!equipShopPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function InitIcon() : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = equipShopPanel.getChildIndex(equipShopPanel["s1_" + _loc1_]);
            _loc2_.x = equipShopPanel["s1_" + _loc1_].x;
            _loc2_.y = equipShopPanel["s1_" + _loc1_].y;
            _loc2_.name = "s1_" + _loc1_;
            equipShopPanel.removeChild(equipShopPanel["s1_" + _loc1_]);
            equipShopPanel["s1_" + _loc1_] = _loc2_;
            equipShopPanel.addChild(_loc2_);
            equipShopPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc2_ = new Shop_picNEW();
         _loc2_.x = equipShopPanel["getZB"]["showPic"].x;
         _loc2_.y = equipShopPanel["getZB"]["showPic"].y;
         _loc2_.name = "showPic";
         equipShopPanel["getZB"].removeChild(equipShopPanel["getZB"]["showPic"]);
         equipShopPanel["getZB"]["showPic"] = _loc2_;
         equipShopPanel["getZB"].addChild(_loc2_);
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("EquipShopShow") as Class;
         equipShopPanel = new _loc2_();
         esp.addChild(equipShopPanel);
         InitIcon();
         if(OpenYN)
         {
            open();
         }
         else
         {
            close();
         }
      }
      
      private static function InitOpen() : *
      {
         esp = new EquipShopPanel();
         LoadSkin();
         Main._stage.addChild(esp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         esp = new EquipShopPanel();
         Main._stage.addChild(esp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(equipShopPanel)
         {
            Main.stopXX = true;
            esp.x = 0;
            esp.y = 0;
            myPlayer = Main.player1;
            addListenerP1();
            esp.visible = true;
            JiHua_Interface.ppp1_12 = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(equipShopPanel)
         {
            esp.visible = false;
            Main.stopXX = false;
            removeListenerP1();
         }
         else
         {
            InitClose();
         }
      }
      
      private static function CloseYP(param1:MouseEvent) : void
      {
         close();
      }
      
      public static function addListenerP1() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            equipShopPanel["s1_" + _loc1_].mouseChildren = false;
            equipShopPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            equipShopPanel["s1_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            equipShopPanel["s1_" + _loc1_].addEventListener(MouseEvent.CLICK,menuOpen);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            equipShopPanel["se_" + _loc2_]["buy_btn"].addEventListener(MouseEvent.MOUSE_OVER,BuyOVER);
            equipShopPanel["se_" + _loc2_]["buy_btn"].addEventListener(MouseEvent.MOUSE_OUT,BuyOUT);
            equipShopPanel["se_" + _loc2_]["buy_btn"].addEventListener(MouseEvent.CLICK,BuyEquip);
            equipShopPanel["se_" + _loc2_].mouseEnabled = false;
            _loc2_++;
         }
         equipShopPanel["mySell"]["sell_btn"].addEventListener(MouseEvent.CLICK,sellEquip);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            equipShopPanel["se_" + _loc2_].stop();
            _loc2_++;
         }
         if(Main.P1P2)
         {
            equipShopPanel["bag1"].visible = true;
            equipShopPanel["bag2"].visible = true;
            equipShopPanel["xbag1"].visible = true;
            equipShopPanel["xbag2"].visible = true;
            equipShopPanel["bag1"].addEventListener(MouseEvent.CLICK,changeToOne);
            equipShopPanel["bag2"].addEventListener(MouseEvent.CLICK,changeToTwo);
         }
         else
         {
            equipShopPanel["bag1"].visible = false;
            equipShopPanel["bag2"].visible = false;
            equipShopPanel["xbag1"].visible = false;
            equipShopPanel["xbag2"].visible = false;
         }
         equipShopPanel["NoMoney_mc"]["no_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         equipShopPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         equipShopPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         equipShopPanel["leftPage"].addEventListener(MouseEvent.CLICK,upPage);
         equipShopPanel["rightPage"].addEventListener(MouseEvent.CLICK,downPage);
         equipShopPanel["closeYP"].addEventListener(MouseEvent.CLICK,CloseYP);
         equipShopPanel["mySell"].visible = false;
         equipShopPanel["getZB"].visible = false;
         equipShopPanel["getZB"].mouseChildren = false;
         equipShopPanel["getZB"].mouseEnabled = false;
         equipShopPanel["NoMoney_mc"].visible = false;
         equipShopPanel["touming"].visible = false;
         equipShopPanel["goumaitishi"].mouseEnabled = false;
         equipShopPanel["npc_mc"].stop();
         allShow();
      }
      
      public static function removeListenerP1() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            equipShopPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            equipShopPanel["s1_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            equipShopPanel["s1_" + _loc1_].removeEventListener(MouseEvent.CLICK,menuOpen);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            equipShopPanel["se_" + _loc2_]["buy_btn"].removeEventListener(MouseEvent.MOUSE_OVER,BuyOVER);
            equipShopPanel["se_" + _loc2_]["buy_btn"].removeEventListener(MouseEvent.MOUSE_OUT,BuyOUT);
            equipShopPanel["se_" + _loc2_]["buy_btn"].removeEventListener(MouseEvent.CLICK,BuyEquip);
            _loc2_++;
         }
         equipShopPanel["mySell"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sellEquip);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            equipShopPanel["se_" + _loc2_].stop();
            _loc2_++;
         }
         if(Main.P1P2)
         {
            equipShopPanel["bag1"].removeEventListener(MouseEvent.CLICK,changeToOne);
            equipShopPanel["bag2"].removeEventListener(MouseEvent.CLICK,changeToTwo);
         }
         equipShopPanel["leftPage"].removeEventListener(MouseEvent.CLICK,upPage);
         equipShopPanel["rightPage"].removeEventListener(MouseEvent.CLICK,downPage);
         equipShopPanel["closeYP"].removeEventListener(MouseEvent.CLICK,CloseYP);
      }
      
      private static function closeNORMB(param1:*) : void
      {
         equipShopPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      private static function BuyOVER(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.target.parent.name.substr(3,2));
         var _loc3_:int = _loc2_ + (yeshu - 1) * 6 + 1;
         for(i in equipShopFactory.allData)
         {
            if(equipShopFactory.allData[i][1] == _loc3_)
            {
               equipShopPanel["goumaitishi"].visible = true;
               equipShopPanel["goumaitishi"].x = equipShopPanel.mouseX + 10;
               equipShopPanel["goumaitishi"].y = equipShopPanel.mouseY;
               equipShopPanel["goumaitishi"]["rmb_txt"].text = "金币不足时可用" + equipShopFactory.allData[i][4] + "点卷购买";
               break;
            }
         }
      }
      
      private static function BuyOUT(param1:MouseEvent) : void
      {
         equipShopPanel["goumaitishi"].visible = false;
      }
      
      private static function changeToOne(param1:*) : *
      {
         myPlayer = Main.player1;
         allShow();
      }
      
      private static function changeToTwo(param1:*) : *
      {
         myPlayer = Main.player2;
         allShow();
      }
      
      private static function upPage(param1:*) : *
      {
         if(yeshu > 1)
         {
            --yeshu;
         }
         allShow();
      }
      
      private static function downPage(param1:*) : *
      {
         if(yeshu < Math.ceil(equipShopPanel["se_0"].totalFrames / 6))
         {
            ++yeshu;
         }
         allShow();
      }
      
      public static function allShow() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 0)
         {
            equipShopPanel["npc_mc"].gotoAndStop(1);
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 3)
         {
            equipShopPanel["npc_mc"].gotoAndStop(2);
         }
         else if(Main.gameNum.getValue() == 0 && Main.gameNum2.getValue() == 4)
         {
            equipShopPanel["npc_mc"].gotoAndStop(3);
         }
         if(Main.P1P2)
         {
            if(myPlayer == Main.player1)
            {
               equipShopPanel["bag1"].visible = false;
               equipShopPanel["bag2"].visible = true;
            }
            else
            {
               equipShopPanel["bag1"].visible = true;
               equipShopPanel["bag2"].visible = false;
            }
         }
         equipShopPanel["gold_txt"].text = myPlayer.getGold();
         equipShopPanel["kill_txt"].text = myPlayer.getKillPoint();
         equipShopPanel["rmb_txt"].text = Shop4399.moneyAll.getValue();
         myPlayer.getBag().zhengliBag();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            equipShopPanel["s1_" + _loc1_]["t_txt"].visible = false;
            if(myPlayer.getBag().getEquipFromBag(_loc1_) != null)
            {
               equipShopPanel["s1_" + _loc1_].gotoAndStop(myPlayer.getBag().getEquipFromBag(_loc1_).getFrame());
               equipShopPanel["s1_" + _loc1_].visible = true;
            }
            else
            {
               equipShopPanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         equipShopPanel["pageNum"].text = yeshu + "/" + Math.ceil(equipShopPanel["se_0"].totalFrames / 6);
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = _loc1_ + (yeshu - 1) * 6 + 1;
            if(_loc2_ <= equipShopPanel["se_0"].totalFrames)
            {
               equipShopPanel["se_" + _loc1_].visible = true;
               equipShopPanel["se_" + _loc1_].gotoAndStop(_loc2_);
            }
            else
            {
               equipShopPanel["se_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private static function menuOpen(param1:MouseEvent) : void
      {
         itemsTooltip.visible = false;
         clickObj = param1.target as MovieClip;
         equipShopPanel.addChild(equipShopPanel["mySell"]);
         equipShopPanel["mySell"].visible = true;
         equipShopPanel["mySell"].x = clickObj.x + 50;
         equipShopPanel["mySell"].y = clickObj.y + 60;
      }
      
      private static function sellEquip(param1:MouseEvent) : void
      {
         var _loc2_:int = int(clickObj.name.substr(3,2));
         var _loc3_:String = clickObj.name.substr(0,2);
         if(_loc3_ == "s1")
         {
            myPlayer.addGold(myPlayer.getBag().getEquipFromBag(_loc2_).getPrice());
            myPlayer.getBag().delEquip(_loc2_);
         }
         equipShopPanel["mySell"].visible = false;
         allShow();
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         equipShopPanel["mySell"].visible = false;
         equipShopPanel.addChild(itemsTooltip);
         var _loc2_:uint = uint(param1.target.name.substr(3,2));
         var _loc3_:String = param1.target.name.substr(0,2);
         itemsTooltip.x = equipShopPanel.mouseX;
         itemsTooltip.y = equipShopPanel.mouseY + 20;
         if(equipShopPanel.mouseX > 770)
         {
            itemsTooltip.x -= 250;
         }
         if(equipShopPanel.mouseY > 400)
         {
            itemsTooltip.y -= 400;
         }
         if(_loc3_ == "s1")
         {
            if(myPlayer.getBag().getEquipFromBag(_loc2_) != null)
            {
               itemsTooltip.equipTooltip(myPlayer.getBag().getEquipFromBag(_loc2_),1);
            }
         }
         itemsTooltip.visible = true;
      }
      
      private static function tooltipClose(param1:MouseEvent) : void
      {
         itemsTooltip.visible = false;
      }
      
      private static function BuyEquip(param1:*) : *
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(param1.target.parent.name.substr(3,2));
         var _loc3_:int = _loc2_ + (yeshu - 1) * 6 + 1;
         arr = [];
         for(i in equipShopFactory.allData)
         {
            if(equipShopFactory.allData[i][1] == _loc3_)
            {
               arr.push(equipShopFactory.allData[i]);
            }
         }
         _loc4_ = int(Math.random() * (arr as Array).length);
         ee = EquipFactory.createEquipByID(arr[_loc4_][0]);
         if(myPlayer.getBag().backequipBagNum() > 0)
         {
            if(myPlayer.getGold() >= arr[_loc4_][2])
            {
               myPlayer.payGold(arr[_loc4_][2]);
               noRMBOK = true;
               Main.Save();
            }
            else if(Shop4399.moneyAll.getValue() >= arr[_loc4_][4])
            {
               Api_4399_All.BuyObj(arr[_loc4_][3]);
               equipShopOK = true;
               equipShopPanel["touming"].visible = true;
            }
            else
            {
               equipShopPanel["NoMoney_mc"].visible = true;
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
         }
         allShow();
      }
      
      public static function equipShopRMBOK() : *
      {
         if(equipShopOK)
         {
            myPlayer.getBag().addEquipBag(ee);
            equipShopPanel["getZB"].alpha = 1;
            equipShopPanel["getZB"].visible = true;
            equipShopPanel.addChild(equipShopPanel["getZB"]);
            equipShopPanel["getZB"]["showPic"].gotoAndStop(ee.getFrame());
            equipShopPanel.addEventListener(Event.ENTER_FRAME,jianbian);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            equipShopOK = false;
            allShow();
            equipShopPanel["touming"].visible = false;
         }
      }
      
      public static function equipShopNoRMBOK() : *
      {
         if(noRMBOK)
         {
            myPlayer.getBag().addEquipBag(ee);
            equipShopPanel["getZB"].alpha = 1;
            equipShopPanel["getZB"].visible = true;
            equipShopPanel.addChild(equipShopPanel["getZB"]);
            equipShopPanel["getZB"]["showPic"].gotoAndStop(ee.getFrame());
            equipShopPanel.addEventListener(Event.ENTER_FRAME,jianbian);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            noRMBOK = false;
            allShow();
            equipShopPanel["touming"].visible = false;
         }
      }
      
      private static function jianbian(param1:*) : *
      {
         equipShopPanel["getZB"].alpha -= 0.02;
         if(equipShopPanel["getZB"].alpha < 0.02)
         {
            equipShopPanel["getZB"].visible = false;
            equipShopPanel.removeEventListener(Event.ENTER_FRAME,jianbian);
         }
      }
   }
}

