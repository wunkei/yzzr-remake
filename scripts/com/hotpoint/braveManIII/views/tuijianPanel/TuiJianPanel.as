package com.hotpoint.braveManIII.views.tuijianPanel
{
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.repository.tuijianShop.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class TuiJianPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var tjp:TuiJianPanel;
      
      public static var tjPanel:MovieClip;
      
      public static var myplayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      private static var clickNum:int;
      
      public static var arrSave:Array = [0,0,0,0,0];
      
      private static var suitOK:Boolean = false;
      
      private static var wqOK:Boolean = false;
      
      private static var otherOK:Boolean = false;
      
      private static var choseNum:int = 1;
      
      private static var lvNum:int = 10;
      
      private static var loadName:String = "ZBTJPanel_v2.swf";
      
      private static var OpenYN:Boolean = false;
      
      private static var OpenFrist:Boolean = false;
      
      private static var DayChange:Boolean = true;
      
      public static var arrOther:Array = [];
      
      public static var arrWQ:Array = [];
      
      public static var arrSuit:Array = [];
      
      public function TuiJianPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.mouseEnabled = false;
         itemsTooltip.visible = false;
      }
      
      public static function openLV() : *
      {
         if(OpenFrist)
         {
            if((Main.player1.getLevel() >= 10 || Boolean(Main.P1P2) && Main.player2.getLevel() >= 10) && arrSave[0] == 0)
            {
               open();
               arrSave[0] = 1;
            }
            if((Main.player1.getLevel() >= 20 || Boolean(Main.P1P2) && Main.player2.getLevel() >= 20) && arrSave[1] == 0)
            {
               open();
               arrSave[1] = 1;
            }
            if((Main.player1.getLevel() >= 30 || Boolean(Main.P1P2) && Main.player2.getLevel() >= 30) && arrSave[2] == 0)
            {
               open();
               arrSave[2] = 1;
            }
            if((Main.player1.getLevel() >= 40 || Boolean(Main.P1P2) && Main.player2.getLevel() >= 40) && arrSave[3] == 0)
            {
               open();
               arrSave[3] = 1;
            }
            if((Main.player1.getLevel() >= 50 || Boolean(Main.P1P2) && Main.player2.getLevel() >= 50) && arrSave[4] == 0)
            {
               open();
               arrSave[4] = 1;
            }
         }
         else
         {
            OpenFrist = true;
         }
      }
      
      private static function LoadSkin() : *
      {
         if(!tjPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("ZBTJshow") as Class;
         tjPanel = new _loc2_();
         tjp.addChild(tjPanel);
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
      
      private static function InitIcon() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = tjPanel.getChildIndex(tjPanel["e" + _loc1_]);
            _loc3_ = new Shop_picNEW();
            _loc3_.x = tjPanel["e" + _loc1_].x;
            _loc3_.y = tjPanel["e" + _loc1_].y;
            _loc3_.name = "e" + _loc1_;
            tjPanel.removeChild(tjPanel["e" + _loc1_]);
            tjPanel["e" + _loc1_] = _loc3_;
            tjPanel.addChild(_loc3_);
            tjPanel.setChildIndex(_loc3_,_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = tjPanel.getChildIndex(tjPanel["s" + _loc1_]);
            _loc3_ = new Shop_picNEW();
            _loc3_.x = tjPanel["s" + _loc1_].x;
            _loc3_.y = tjPanel["s" + _loc1_].y;
            _loc3_.name = "s" + _loc1_;
            tjPanel.removeChild(tjPanel["s" + _loc1_]);
            tjPanel["s" + _loc1_] = _loc3_;
            tjPanel.addChild(_loc3_);
            tjPanel.setChildIndex(_loc3_,_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = tjPanel.getChildIndex(tjPanel["w" + _loc1_]);
            _loc3_ = new Shop_picNEW();
            _loc3_.x = tjPanel["w" + _loc1_].x;
            _loc3_.y = tjPanel["w" + _loc1_].y;
            _loc3_.name = "w" + _loc1_;
            tjPanel.removeChild(tjPanel["w" + _loc1_]);
            tjPanel["w" + _loc1_] = _loc3_;
            tjPanel.addChild(_loc3_);
            tjPanel.setChildIndex(_loc3_,_loc2_);
            _loc1_++;
         }
      }
      
      private static function InitOpen() : *
      {
         tjp = new TuiJianPanel();
         LoadSkin();
         Main._stage.addChild(tjp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         tjp = new TuiJianPanel();
         Main._stage.addChild(tjp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(tjPanel)
         {
            Main.stopXX = true;
            tjp.x = 0;
            tjp.y = 0;
            myplayer = Main.player1;
            if(Main.player_1.visible == false)
            {
               myplayer = Main.player2;
            }
            addListenerP1();
            tjp.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(tjPanel)
         {
            tjp.visible = false;
            Main.stopXX = false;
            removeListenerP1();
         }
         else
         {
            InitClose();
         }
      }
      
      public static function closeP(param1:*) : *
      {
         close();
      }
      
      public static function addRMB(param1:*) : *
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      private static function closeNORMB(param1:*) : void
      {
         tjPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      public static function changeTo1(param1:*) : *
      {
         myplayer = Main.player1;
         tjPanel["buy2"].visible = true;
         tjPanel["buy1"].visible = false;
         getLV();
         showSuit();
         showWQ();
         showOther();
      }
      
      public static function changeTo2(param1:*) : *
      {
         myplayer = Main.player2;
         tjPanel["buy1"].visible = true;
         tjPanel["buy2"].visible = false;
         getLV();
         showSuit();
         showWQ();
         showOther();
      }
      
      public static function addListenerP1() : *
      {
         var _loc1_:uint = 0;
         if(Main.P1P2)
         {
            if(myplayer == Main.player1)
            {
               tjPanel["buy2"].visible = true;
               tjPanel["buy1"].visible = false;
            }
            else
            {
               tjPanel["buy1"].visible = true;
               tjPanel["buy2"].visible = false;
            }
            tjPanel["buy1"].addEventListener(MouseEvent.CLICK,changeTo1);
            tjPanel["buy2"].addEventListener(MouseEvent.CLICK,changeTo2);
         }
         else
         {
            tjPanel["buy1"].visible = false;
            tjPanel["buy2"].visible = false;
         }
         tjPanel["title"].stop();
         tjPanel["close"].addEventListener(MouseEvent.CLICK,closeP);
         tjPanel["congzhi"].addEventListener(MouseEvent.CLICK,addRMB);
         tjPanel["taozhuang"].stop();
         tjPanel["touming"].visible = false;
         tjPanel["NoMoney_mc"].visible = false;
         tjPanel["NoMoney_mc"]["no_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         tjPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         tjPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            tjPanel["c" + _loc1_].addEventListener(MouseEvent.CLICK,choseSuit);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            tjPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,c_over);
            tjPanel["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,c_out);
            tjPanel["e" + _loc1_].mouseChildren = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            tjPanel["w" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,w_over);
            tjPanel["w" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,c_out);
            tjPanel["w" + _loc1_].mouseChildren = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            tjPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,s_over);
            tjPanel["s" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,c_out);
            tjPanel["s" + _loc1_].mouseChildren = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            tjPanel["m" + _loc1_].addEventListener(MouseEvent.CLICK,buyRMB);
            tjPanel["g" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,g_over);
            tjPanel["g" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,g_out);
            _loc1_++;
         }
         tjPanel["huodetishi"].mouseEnabled = false;
         getLV();
         showSuit();
         showWQ();
         showOther();
      }
      
      public static function removeListenerP1() : *
      {
      }
      
      public static function getLV() : *
      {
         if(myplayer.getLevel() >= 10 && myplayer.getLevel() < 20)
         {
            lvNum = 10;
            tjPanel["title"].gotoAndStop(1);
            tjPanel["taozhuang"].gotoAndStop(1);
         }
         else if(myplayer.getLevel() >= 20 && myplayer.getLevel() < 30)
         {
            lvNum = 20;
            tjPanel["title"].gotoAndStop(2);
            tjPanel["taozhuang"].gotoAndStop(2);
         }
         else if(myplayer.getLevel() >= 30 && myplayer.getLevel() < 40)
         {
            lvNum = 30;
            tjPanel["title"].gotoAndStop(3);
            tjPanel["taozhuang"].gotoAndStop(3);
         }
         else if(myplayer.getLevel() >= 40 && myplayer.getLevel() < 50)
         {
            lvNum = 40;
            tjPanel["title"].gotoAndStop(4);
            tjPanel["taozhuang"].gotoAndStop(4);
         }
         else if(myplayer.getLevel() >= 50)
         {
            lvNum = 50;
            tjPanel["title"].gotoAndStop(5);
            tjPanel["taozhuang"].gotoAndStop(5);
         }
      }
      
      public static function showWQ() : *
      {
         var _loc1_:int = 1;
         arrWQ = [];
         if(myplayer._pickSkillArr[0])
         {
            for(i in tuijianFactory.allData)
            {
               if(tuijianFactory.allData[i][1] == lvNum && tuijianFactory.allData[i][7] == 1)
               {
                  arrWQ.push(tuijianFactory.allData[i]);
               }
            }
         }
         if(myplayer._pickSkillArr[1])
         {
            for(i in tuijianFactory.allData)
            {
               if(tuijianFactory.allData[i][1] == lvNum && tuijianFactory.allData[i][7] == 2)
               {
                  arrWQ.push(tuijianFactory.allData[i]);
               }
            }
         }
         if(myplayer._pickSkillArr[2])
         {
            for(i in tuijianFactory.allData)
            {
               if(tuijianFactory.allData[i][1] == lvNum && tuijianFactory.allData[i][7] == 3)
               {
                  arrWQ.push(tuijianFactory.allData[i]);
               }
            }
         }
         for(i in arrWQ)
         {
            if(Boolean(arrWQ[i]) && arrWQ[i][6] == 1)
            {
               tjPanel["w" + i].gotoAndStop(EquipFactory.createEquipByID(arrWQ[i][0]).getFrame());
               tjPanel["f" + i].text = EquipFactory.createEquipByID(arrWQ[i][0]).getName();
               _loc1_ = int(EquipFactory.createEquipByID(arrWQ[i][0]).getColor());
               tjPanel["wuqi" + i].text = arrWQ[i][5] + "点卷";
               if(_loc1_ == 1)
               {
                  ColorX(tjPanel["f" + i],"0xffffff");
               }
               if(_loc1_ == 2)
               {
                  ColorX(tjPanel["f" + i],"0x0066ff");
               }
               if(_loc1_ == 3)
               {
                  ColorX(tjPanel["f" + i],"0xFF33FF");
               }
               if(_loc1_ == 4)
               {
                  ColorX(tjPanel["f" + i],"0xFF9900");
               }
               if(_loc1_ == 5)
               {
                  ColorX(tjPanel["f" + i],"0xFF9900");
               }
               if(_loc1_ == 6)
               {
                  ColorX(tjPanel["f" + i],"0xCC3300");
               }
            }
         }
      }
      
      public static function showOther() : *
      {
         var _loc1_:int = 1;
         arrOther = [];
         for(i in tuijianFactory.allData)
         {
            if(tuijianFactory.allData[i][1] == lvNum && tuijianFactory.allData[i][3] == 1)
            {
               arrOther.push(tuijianFactory.allData[i]);
            }
         }
         for(i in arrOther)
         {
            if(Boolean(arrOther[i]) && arrOther[i][6] == 1)
            {
               tjPanel["s" + i].gotoAndStop(EquipFactory.createEquipByID(arrOther[i][0]).getFrame());
               tjPanel["h" + i].text = EquipFactory.createEquipByID(arrOther[i][0]).getName();
               _loc1_ = int(EquipFactory.createEquipByID(arrOther[i][0]).getColor());
               tjPanel["other" + i].text = arrOther[i][5] + "点卷";
            }
            if(Boolean(arrOther[i]) && arrOther[i][6] == 2)
            {
               tjPanel["s" + i].gotoAndStop(SuppliesFactory.getSuppliesById(arrOther[i][0]).getFrame());
               tjPanel["h" + i].text = SuppliesFactory.getSuppliesById(arrOther[i][0]).getName();
               _loc1_ = int(SuppliesFactory.getSuppliesById(arrOther[i][0]).getColor());
               tjPanel["other" + i].text = arrOther[i][5] + "点卷";
            }
            if(Boolean(arrOther[i]) && arrOther[i][6] == 3)
            {
               tjPanel["s" + i].gotoAndStop(GemFactory.creatGemById(arrOther[i][0]).getFrame());
               tjPanel["h" + i].text = GemFactory.creatGemById(arrOther[i][0]).getName();
               _loc1_ = int(GemFactory.creatGemById(arrOther[i][0]).getColor());
               tjPanel["other" + i].text = arrOther[i][5] + "点卷";
            }
            if(Boolean(arrOther[i]) && arrOther[i][6] == 4)
            {
               tjPanel["s" + i].gotoAndStop(OtherFactory.creatOther(arrOther[i][0]).getFrame());
               tjPanel["h" + i].text = OtherFactory.creatOther(arrOther[i][0]).getName();
               _loc1_ = int(OtherFactory.creatOther(arrOther[i][0]).getColor());
               tjPanel["other" + i].text = arrOther[i][5] + "点卷";
            }
            if(_loc1_ == 1)
            {
               ColorX(tjPanel["h" + i],"0xffffff");
            }
            if(_loc1_ == 2)
            {
               ColorX(tjPanel["h" + i],"0x0066ff");
            }
            if(_loc1_ == 3)
            {
               ColorX(tjPanel["h" + i],"0xFF33FF");
            }
            if(_loc1_ == 4)
            {
               ColorX(tjPanel["h" + i],"0xFF9900");
            }
            if(_loc1_ == 5)
            {
               ColorX(tjPanel["h" + i],"0xFF9900");
            }
            if(_loc1_ == 6)
            {
               ColorX(tjPanel["h" + i],"0xCC3300");
            }
         }
      }
      
      public static function showSuit() : *
      {
         tjPanel["point_txt"].text = Shop4399.moneyAll.getValue();
         tjPanel["chose"].x = tjPanel["c" + (choseNum - 1)].x;
         tjPanel["chose"].y = tjPanel["c" + (choseNum - 1)].y;
         arrSuit = [];
         var _loc1_:int = 1;
         for(i in tuijianFactory.allData)
         {
            if(tuijianFactory.allData[i][1] == lvNum && tuijianFactory.allData[i][2] == choseNum)
            {
               arrSuit.push(tuijianFactory.allData[i]);
            }
         }
         for(i in arrSuit)
         {
            if(Boolean(arrSuit[i]) && arrSuit[i][6] == 1)
            {
               tjPanel["e" + i].gotoAndStop(EquipFactory.createEquipByID(arrSuit[i][0]).getFrame());
               tjPanel["n" + i].text = EquipFactory.createEquipByID(arrSuit[i][0]).getName();
               _loc1_ = int(EquipFactory.createEquipByID(arrSuit[i][0]).getColor());
               tjPanel["suit" + i].text = arrSuit[i][5] + "点卷";
               if(_loc1_ == 1)
               {
                  ColorX(tjPanel["n" + i],"0xffffff");
               }
               if(_loc1_ == 2)
               {
                  ColorX(tjPanel["n" + i],"0x0066ff");
               }
               if(_loc1_ == 3)
               {
                  ColorX(tjPanel["n" + i],"0xFF33FF");
               }
               if(_loc1_ == 4)
               {
                  ColorX(tjPanel["n" + i],"0xFF9900");
               }
               if(_loc1_ == 5)
               {
                  ColorX(tjPanel["n" + i],"0xFF9900");
               }
               if(_loc1_ == 6)
               {
                  ColorX(tjPanel["n" + i],"0xCC3300");
               }
            }
         }
      }
      
      private static function choseSuit(param1:*) : *
      {
         choseNum = int((param1.target as MovieClip).name.substr(1,1)) + 1;
         showSuit();
      }
      
      private static function s_over(param1:*) : *
      {
         tjPanel.addChild(itemsTooltip);
         var _loc2_:uint = uint(int(param1.target.name.substr(1,1)));
         var _loc3_:uint = 1;
         itemsTooltip.x = tjPanel.mouseX;
         itemsTooltip.y = tjPanel.mouseY - 100;
         if(tjPanel.mouseX > 770)
         {
            itemsTooltip.x -= 250;
         }
         if(myplayer == Main.player2)
         {
            _loc3_ = 2;
         }
         if(arrOther[_loc2_][6] == 1)
         {
            itemsTooltip.equipTooltip(EquipFactory.createEquipByID(arrOther[_loc2_][0]),_loc3_);
         }
         if(arrOther[_loc2_][6] == 2)
         {
            itemsTooltip.suppliesTooltip(SuppliesFactory.getSuppliesById(arrOther[_loc2_][0]),_loc3_);
         }
         if(arrOther[_loc2_][6] == 3)
         {
            itemsTooltip.gemTooltip(GemFactory.creatGemById(arrOther[_loc2_][0]),_loc3_);
         }
         if(arrOther[_loc2_][6] == 4)
         {
            itemsTooltip.otherTooltip(OtherFactory.creatOther(arrOther[_loc2_][0]));
         }
         itemsTooltip.visible = true;
      }
      
      private static function w_over(param1:*) : *
      {
         tjPanel.addChild(itemsTooltip);
         var _loc2_:uint = uint(int(param1.target.name.substr(1,1)));
         itemsTooltip.x = tjPanel.mouseX;
         itemsTooltip.y = tjPanel.mouseY - 100;
         if(tjPanel.mouseX > 770)
         {
            itemsTooltip.x -= 250;
         }
         itemsTooltip.equipTooltip(EquipFactory.createEquipByID(arrWQ[_loc2_][0]),1);
         itemsTooltip.visible = true;
      }
      
      private static function c_over(param1:*) : *
      {
         tjPanel.addChild(itemsTooltip);
         var _loc2_:uint = uint(int(param1.target.name.substr(1,1)));
         itemsTooltip.x = tjPanel.mouseX;
         itemsTooltip.y = tjPanel.mouseY;
         if(tjPanel.mouseX > 770)
         {
            itemsTooltip.x -= 250;
         }
         if(tjPanel.mouseY > 400)
         {
            itemsTooltip.y -= 200;
         }
         itemsTooltip.equipTooltip(EquipFactory.createEquipByID(arrSuit[_loc2_][0]),1);
         itemsTooltip.visible = true;
      }
      
      private static function c_out(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function g_over(param1:*) : *
      {
         var _loc2_:uint = uint(int(param1.target.name.substr(1,1)));
         tjPanel["huodetishi"].x = tjPanel.mouseX - 100;
         tjPanel["huodetishi"].y = tjPanel.mouseY;
         tjPanel["huodetishi"].visible = true;
         if(_loc2_ <= 3)
         {
            tjPanel["huodetishi"]["asd_txt"].text = arrSuit[_loc2_][8];
         }
         else if(_loc2_ > 3 && _loc2_ <= 5)
         {
            tjPanel["huodetishi"]["asd_txt"].text = arrWQ[_loc2_ - 4][8];
         }
         else
         {
            tjPanel["huodetishi"]["asd_txt"].text = arrOther[_loc2_ - 6][8];
         }
      }
      
      private static function g_out(param1:*) : *
      {
         tjPanel["huodetishi"].visible = false;
      }
      
      private static function buyRMB(param1:*) : *
      {
         clickNum = int(param1.target.name.substr(1,1));
         if(clickNum <= 3)
         {
            if(myplayer.getBag().backequipBagNum() > 0)
            {
               if(Shop4399.moneyAll.getValue() >= arrSuit[clickNum][5])
               {
                  Api_4399_All.BuyObj(arrSuit[clickNum][4]);
                  suitOK = true;
                  tjPanel["touming"].visible = true;
               }
               else
               {
                  tjPanel["NoMoney_mc"].visible = true;
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
            }
         }
         else if(clickNum > 3 && clickNum <= 5)
         {
            if(myplayer.getBag().backequipBagNum() > 0)
            {
               if(Shop4399.moneyAll.getValue() >= arrWQ[clickNum - 4][5])
               {
                  Api_4399_All.BuyObj(arrWQ[clickNum - 4][4]);
                  wqOK = true;
                  tjPanel["touming"].visible = true;
               }
               else
               {
                  tjPanel["NoMoney_mc"].visible = true;
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
            }
         }
         else
         {
            if(arrOther[clickNum - 6][6] == 1)
            {
               if(myplayer.getBag().backequipBagNum() > 0)
               {
                  if(Shop4399.moneyAll.getValue() >= arrOther[clickNum - 6][5])
                  {
                     Api_4399_All.BuyObj(arrOther[clickNum - 6][4]);
                     otherOK = true;
                     tjPanel["touming"].visible = true;
                  }
                  else
                  {
                     tjPanel["NoMoney_mc"].visible = true;
                  }
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
               }
            }
            if(arrOther[clickNum - 6][6] == 2)
            {
               if(myplayer.getBag().backSuppliesBagNum() > 0)
               {
                  if(Shop4399.moneyAll.getValue() >= arrOther[clickNum - 6][5])
                  {
                     Api_4399_All.BuyObj(arrOther[clickNum - 6][4]);
                     otherOK = true;
                     tjPanel["touming"].visible = true;
                  }
                  else
                  {
                     tjPanel["NoMoney_mc"].visible = true;
                  }
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
               }
            }
            if(arrOther[clickNum - 6][6] == 3)
            {
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  if(Shop4399.moneyAll.getValue() >= arrOther[clickNum - 6][5])
                  {
                     Api_4399_All.BuyObj(arrOther[clickNum - 6][4]);
                     otherOK = true;
                     tjPanel["touming"].visible = true;
                  }
                  else
                  {
                     tjPanel["NoMoney_mc"].visible = true;
                  }
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
               }
            }
            if(arrOther[clickNum - 6][6] == 4)
            {
               if(myplayer.getBag().backOtherBagNum() > 0)
               {
                  if(Shop4399.moneyAll.getValue() >= arrOther[clickNum - 6][5])
                  {
                     Api_4399_All.BuyObj(arrOther[clickNum - 6][4]);
                     otherOK = true;
                     tjPanel["touming"].visible = true;
                  }
                  else
                  {
                     tjPanel["NoMoney_mc"].visible = true;
                  }
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满");
               }
            }
         }
      }
      
      public static function goumaiOK() : *
      {
         if(suitOK)
         {
            myplayer.getBag().addEquipBag(EquipFactory.createEquipByID(arrSuit[clickNum][0]));
            suitOK = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            tjPanel["touming"].visible = false;
            showSuit();
         }
         if(wqOK)
         {
            myplayer.getBag().addEquipBag(EquipFactory.createEquipByID(arrWQ[clickNum - 4][0]));
            wqOK = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            tjPanel["touming"].visible = false;
            showSuit();
         }
         if(otherOK)
         {
            if(arrOther[clickNum - 6][6] == 1)
            {
               myplayer.getBag().addEquipBag(EquipFactory.createEquipByID(arrOther[clickNum - 6][0]));
            }
            if(arrOther[clickNum - 6][6] == 2)
            {
               myplayer.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(arrOther[clickNum - 6][0]));
            }
            if(arrOther[clickNum - 6][6] == 3)
            {
               myplayer.getBag().addGemBag(GemFactory.creatGemById(arrOther[clickNum - 6][0]));
            }
            if(arrOther[clickNum - 6][6] == 4)
            {
               myplayer.getBag().addOtherobjBag(OtherFactory.creatOther(arrOther[clickNum - 6][0]));
            }
            otherOK = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            tjPanel["touming"].visible = false;
            showSuit();
         }
      }
      
      private static function ColorX(param1:*, param2:String) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2;
         param1.setTextFormat(_loc3_);
      }
   }
}

