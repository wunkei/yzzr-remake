package com.hotpoint.braveManIII.views.stampPanel
{
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class StampPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var qnPanel:MovieClip;
      
      public static var sp:StampPanel;
      
      public static var myplayer:PlayerData;
      
      public static var clickNum:Number;
      
      private static var loadData:ClassLoader;
      
      public static var TYOK:Boolean = false;
      
      public static var yeNum:Number = 1;
      
      public static var slotNum:Number = 1;
      
      private static var mygem:Boolean = false;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_QN_v2.swf";
      
      public function StampPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!qnPanel && !loadData)
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
            _loc3_ = qnPanel.getChildIndex(qnPanel["e" + _loc1_]);
            _loc2_.x = qnPanel["e" + _loc1_].x;
            _loc2_.y = qnPanel["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            qnPanel.removeChild(qnPanel["e" + _loc1_]);
            qnPanel["e" + _loc1_] = _loc2_;
            qnPanel.addChild(_loc2_);
            qnPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = qnPanel.getChildIndex(qnPanel["s1_" + _loc1_]);
            _loc2_.x = qnPanel["s1_" + _loc1_].x;
            _loc2_.y = qnPanel["s1_" + _loc1_].y;
            _loc2_.name = "s1_" + _loc1_;
            qnPanel.removeChild(qnPanel["s1_" + _loc1_]);
            qnPanel["s1_" + _loc1_] = _loc2_;
            qnPanel.addChild(_loc2_);
            qnPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = qnPanel.getChildIndex(qnPanel["s2_" + _loc1_]);
            _loc2_.x = qnPanel["s2_" + _loc1_].x;
            _loc2_.y = qnPanel["s2_" + _loc1_].y;
            _loc2_.name = "s2_" + _loc1_;
            qnPanel.removeChild(qnPanel["s2_" + _loc1_]);
            qnPanel["s2_" + _loc1_] = _loc2_;
            qnPanel.addChild(_loc2_);
            qnPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new Shop_picNEW();
            _loc3_ = qnPanel.getChildIndex(qnPanel["s3_" + _loc1_]);
            _loc2_.x = qnPanel["s3_" + _loc1_].x;
            _loc2_.y = qnPanel["s3_" + _loc1_].y;
            _loc2_.name = "s3_" + _loc1_;
            qnPanel.removeChild(qnPanel["s3_" + _loc1_]);
            qnPanel["s3_" + _loc1_] = _loc2_;
            qnPanel.addChild(_loc2_);
            qnPanel.setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("QNShow") as Class;
         qnPanel = new _loc2_();
         sp.addChild(qnPanel);
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
      
      private static function InitOpen() : *
      {
         sp = new StampPanel();
         LoadSkin();
         Main._stage.addChild(sp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         sp = new StampPanel();
         Main._stage.addChild(sp);
         OpenYN = false;
      }
      
      public static function open(param1:PlayerData) : void
      {
         Main.allClosePanel();
         Main.DuoKai_Fun();
         if(qnPanel)
         {
            Main.stopXX = true;
            sp.x = 0;
            sp.y = 0;
            myplayer = param1;
            yeNum = 1;
            addListenerP1();
            Main._stage.addChild(sp);
            sp.visible = true;
         }
         else
         {
            myplayer = param1;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(qnPanel)
         {
            Main.stopXX = false;
            removeListenerP1();
            sp.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         qnPanel["djPoint"].visible = true;
         qnPanel["qnRMB"].visible = false;
         qnPanel["touming"].visible = false;
         qnPanel["qnRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,yes_btn);
         qnPanel["qnRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,no_btn);
         qnPanel["qnRMB"]["no_btn2"].addEventListener(MouseEvent.CLICK,no_btn);
         qnPanel["NoMoney_mc"].visible = false;
         qnPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         qnPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            qnPanel["yz" + _loc1_].buttonMode = true;
            qnPanel["zy" + _loc1_].buttonMode = true;
            qnPanel["yz" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,upShow);
            qnPanel["zy" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,downShow);
            qnPanel["yz" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,closeShow);
            qnPanel["zy" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,closeShow);
            qnPanel["yz" + _loc1_].addEventListener(MouseEvent.CLICK,upDo);
            qnPanel["zy" + _loc1_].addEventListener(MouseEvent.CLICK,downDo);
            qnPanel["zd" + _loc1_].addEventListener(MouseEvent.CLICK,rmbDo);
            qnPanel["ty" + _loc1_].addEventListener(MouseEvent.CLICK,tongyongDo);
            qnPanel["s1_" + _loc1_].mouseChildren = qnPanel["s1_" + _loc1_].mouseEnabled = false;
            qnPanel["s2_" + _loc1_].mouseChildren = qnPanel["s2_" + _loc1_].mouseEnabled = false;
            qnPanel["s3_" + _loc1_].mouseChildren = qnPanel["s3_" + _loc1_].mouseEnabled = false;
            _loc1_++;
         }
         qnPanel["shang_btn"].addEventListener(MouseEvent.CLICK,shangDo);
         qnPanel["xia_btn"].addEventListener(MouseEvent.CLICK,xiaDo);
         qnPanel["closePanel"].addEventListener(MouseEvent.CLICK,closePanel);
         var _loc2_:uint = 0;
         while(_loc2_ < 24)
         {
            qnPanel["e" + _loc2_].mouseChildren = false;
            qnPanel["e" + _loc2_].stop();
            qnPanel["e" + _loc2_].addEventListener(MouseEvent.CLICK,choseDo);
            qnPanel["e" + _loc2_].addEventListener(MouseEvent.MOUSE_MOVE,tipOpen);
            qnPanel["e" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,tipClose);
            _loc2_++;
         }
         qnPanel["strengTip"].visible = false;
         showRMB();
         showPanel();
         showGem();
      }
      
      private static function tipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         qnPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         if(myplayer.getBag().getGemFromBag(_loc3_) != null)
         {
            itemsTooltip.gemTooltip(myplayer.getBag().getGemFromBag(_loc3_),1);
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = qnPanel.mouseX + 10;
         itemsTooltip.y = qnPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      private static function tipClose(param1:MouseEvent) : void
      {
         itemsTooltip.visible = false;
      }
      
      public static function closePanel(param1:*) : *
      {
         close();
      }
      
      public static function tongyongDo(param1:*) : *
      {
         clickNum = param1.target.name.substr(2,1);
         if(myplayer.getStampSlot().getSlot11(clickNum))
         {
            mygem = true;
            if(myplayer.getBag().backGemBagNum() > 0)
            {
               myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot11(clickNum));
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
            }
         }
         else
         {
            mygem = false;
         }
         showRMB();
         showPanel();
         qnPanel["k3_" + clickNum].visible = true;
         slotNum = 11;
         showAllGem();
      }
      
      public static function yes_btn(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.tongyongjiesuo.getValue());
            TYOK = true;
            qnPanel["qnRMB"].visible = false;
            qnPanel["touming"].visible = true;
         }
         else
         {
            qnPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function no_btn(param1:*) : *
      {
         qnPanel["qnRMB"].visible = false;
      }
      
      private static function closeNORMB(param1:*) : void
      {
         qnPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      public static function rmbDo(param1:*) : *
      {
         qnPanel["qnRMB"].visible = true;
      }
      
      public static function tyKeyOK() : *
      {
         if(TYOK)
         {
            myplayer.getStampSlot().setKeySlot11();
            showRMB();
            TYOK = false;
            qnPanel["touming"].visible = false;
         }
      }
      
      public static function showRMB() : *
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            qnPanel["s3_" + _loc1_].visible = false;
            qnPanel["k3_" + _loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(myplayer.getStampSlot().getSlot11_key(_loc1_) == 1)
            {
               qnPanel["zd" + _loc1_].visible = false;
               if(myplayer.getStampSlot().getSlot11(_loc1_))
               {
                  qnPanel["s3_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot11(_loc1_).getFrame());
                  qnPanel["s3_" + _loc1_].visible = true;
               }
            }
            else
            {
               qnPanel["zd" + _loc1_].visible = true;
            }
            _loc1_++;
         }
         qnPanel["djPoint"].text = Shop4399.moneyAll.getValue();
      }
      
      public static function showAllGem() : *
      {
         var _loc1_:uint = 0;
         if(myplayer.getBag().backGemBagNum() > 0 || mygem == false)
         {
            qnPanel["zhedang"].gotoAndStop(2);
            qnPanel["zhedang"].visible = true;
            _loc1_ = 0;
            while(_loc1_ < 24)
            {
               qnPanel["e" + _loc1_].visible = false;
               if(Boolean(myplayer.getBag().getGemFromBag(_loc1_)) && Boolean(myplayer.getBag().getGemFromBag(_loc1_).getType() >= 7) && myplayer.getBag().getGemFromBag(_loc1_).getType() <= 16)
               {
                  qnPanel["zhedang"].visible = false;
                  qnPanel["e" + _loc1_].visible = true;
                  qnPanel["e" + _loc1_].gotoAndStop(myplayer.getBag().getGemFromBag(_loc1_).getFrame());
               }
               _loc1_++;
            }
         }
         else
         {
            qnPanel["zhedang"].gotoAndStop(3);
            qnPanel["zhedang"].visible = true;
         }
      }
      
      public static function showGem(param1:int = -1) : *
      {
         var _loc2_:uint = 0;
         if(param1 == -1)
         {
            qnPanel["zhedang"].gotoAndStop(1);
         }
         if(param1 > -1)
         {
            qnPanel["zhedang"].gotoAndStop(2);
         }
         if(myplayer.getBag().backGemBagNum() > 0 || mygem == false)
         {
            qnPanel["zhedang"].visible = true;
            _loc2_ = 0;
            while(_loc2_ < 24)
            {
               qnPanel["e" + _loc2_].visible = false;
               if(Boolean(myplayer.getBag().getGemFromBag(_loc2_)) && myplayer.getBag().getGemFromBag(_loc2_).getType() == param1)
               {
                  qnPanel["zhedang"].visible = false;
                  qnPanel["e" + _loc2_].visible = true;
                  qnPanel["e" + _loc2_].gotoAndStop(myplayer.getBag().getGemFromBag(_loc2_).getFrame());
               }
               _loc2_++;
            }
         }
         else
         {
            qnPanel["zhedang"].gotoAndStop(3);
            qnPanel["zhedang"].visible = true;
         }
      }
      
      public static function showPanel() : *
      {
         var _loc1_:uint = 0;
         qnPanel["yeshu"].text = yeNum + "/5";
         qnPanel["color_mc"].gotoAndStop(yeNum);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            qnPanel["yz" + _loc1_].gotoAndStop(yeNum * 2 - 1);
            qnPanel["zy" + _loc1_].gotoAndStop(yeNum * 2);
            qnPanel["k1_" + _loc1_].visible = false;
            qnPanel["k2_" + _loc1_].visible = false;
            qnPanel["s1_" + _loc1_].visible = false;
            qnPanel["s2_" + _loc1_].visible = false;
            _loc1_++;
         }
         if(yeNum == 1)
         {
            qnPanel["txt_1"].text = "魔力印章(使用魔法药效果提高+" + Math.round(myplayer.getStampSlot().getValueSlot1() * 100) + "%)";
            qnPanel["txt_2"].text = "体力印章(使用体力药效果提高+" + Math.round(myplayer.getStampSlot().getValueSlot2() * 100) + "%)";
         }
         else if(yeNum == 2)
         {
            qnPanel["txt_1"].text = "攻击印章(攻击力提高+" + Number(myplayer.getStampSlot().getValueSlot3() * 100).toFixed(1) + "%)";
            qnPanel["txt_2"].text = "防御印章(防御力提高+" + Number(myplayer.getStampSlot().getValueSlot4() * 100).toFixed(1) + "%)";
         }
         else if(yeNum == 3)
         {
            qnPanel["txt_1"].text = "生命印章(提高固定生命值+" + Math.round(myplayer.getStampSlot().getValueSlot5()) + ")";
            qnPanel["txt_2"].text = "力量印章(提高固定攻击力+" + Math.round(myplayer.getStampSlot().getValueSlot6()) + ")";
         }
         else if(yeNum == 4)
         {
            qnPanel["txt_1"].text = "速度印章(提高固定移动力+" + Math.round(myplayer.getStampSlot().getValueSlot7()) + ")";
            qnPanel["txt_2"].text = "石肤印章(角色所受伤害减少+" + Number(myplayer.getStampSlot().getValueSlot8() * 100).toFixed(1) + "%)";
         }
         else if(yeNum == 5)
         {
            qnPanel["txt_1"].text = "未开启";
            qnPanel["txt_2"].text = "未开启";
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(yeNum == 1 && Boolean(myplayer.getStampSlot().getSlot1(_loc1_)))
            {
               qnPanel["s1_" + _loc1_].visible = true;
               qnPanel["s1_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot1(_loc1_).getFrame());
            }
            if(yeNum == 1 && Boolean(myplayer.getStampSlot().getSlot2(_loc1_)))
            {
               qnPanel["s2_" + _loc1_].visible = true;
               qnPanel["s2_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot2(_loc1_).getFrame());
            }
            if(yeNum == 2 && Boolean(myplayer.getStampSlot().getSlot3(_loc1_)))
            {
               qnPanel["s1_" + _loc1_].visible = true;
               qnPanel["s1_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot3(_loc1_).getFrame());
            }
            if(yeNum == 2 && Boolean(myplayer.getStampSlot().getSlot4(_loc1_)))
            {
               qnPanel["s2_" + _loc1_].visible = true;
               qnPanel["s2_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot4(_loc1_).getFrame());
            }
            if(yeNum == 3 && Boolean(myplayer.getStampSlot().getSlot5(_loc1_)))
            {
               qnPanel["s1_" + _loc1_].visible = true;
               qnPanel["s1_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot5(_loc1_).getFrame());
            }
            if(yeNum == 3 && Boolean(myplayer.getStampSlot().getSlot6(_loc1_)))
            {
               qnPanel["s2_" + _loc1_].visible = true;
               qnPanel["s2_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot6(_loc1_).getFrame());
            }
            if(yeNum == 4 && Boolean(myplayer.getStampSlot().getSlot7(_loc1_)))
            {
               qnPanel["s1_" + _loc1_].visible = true;
               qnPanel["s1_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot7(_loc1_).getFrame());
            }
            if(yeNum == 4 && Boolean(myplayer.getStampSlot().getSlot8(_loc1_)))
            {
               qnPanel["s2_" + _loc1_].visible = true;
               qnPanel["s2_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot8(_loc1_).getFrame());
            }
            if(yeNum == 5 && Boolean(myplayer.getStampSlot().getSlot9(_loc1_)))
            {
               qnPanel["s1_" + _loc1_].visible = true;
               qnPanel["s1_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot9(_loc1_).getFrame());
            }
            if(yeNum == 5 && Boolean(myplayer.getStampSlot().getSlot10(_loc1_)))
            {
               qnPanel["s2_" + _loc1_].visible = true;
               qnPanel["s2_" + _loc1_].gotoAndStop(myplayer.getStampSlot().getSlot10(_loc1_).getFrame());
            }
            _loc1_++;
         }
      }
      
      public static function removeListenerP1() : *
      {
         qnPanel["qnRMB"]["yes_btn"].removeEventListener(MouseEvent.CLICK,yes_btn);
         qnPanel["qnRMB"]["no_btn"].removeEventListener(MouseEvent.CLICK,no_btn);
         qnPanel["NoMoney_mc"]["yes_btn"].removeEventListener(MouseEvent.CLICK,closeNORMB);
         qnPanel["NoMoney_mc"]["addMoney_btn"].removeEventListener(MouseEvent.CLICK,addMoney_btn);
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            qnPanel["yz" + _loc1_].removeEventListener(MouseEvent.CLICK,upDo);
            qnPanel["zy" + _loc1_].removeEventListener(MouseEvent.CLICK,downDo);
            qnPanel["zd" + _loc1_].removeEventListener(MouseEvent.CLICK,rmbDo);
            qnPanel["ty" + _loc1_].removeEventListener(MouseEvent.CLICK,tongyongDo);
            _loc1_++;
         }
         qnPanel["shang_btn"].addEventListener(MouseEvent.CLICK,shangDo);
         qnPanel["xia_btn"].addEventListener(MouseEvent.CLICK,xiaDo);
         qnPanel["closePanel"].addEventListener(MouseEvent.CLICK,closePanel);
         var _loc2_:uint = 0;
         while(_loc2_ < 24)
         {
            qnPanel["e" + _loc2_].removeEventListener(MouseEvent.CLICK,choseDo);
            qnPanel["e" + _loc2_].removeEventListener(MouseEvent.MOUSE_MOVE,tipOpen);
            qnPanel["e" + _loc2_].removeEventListener(MouseEvent.MOUSE_OUT,tipClose);
            _loc2_++;
         }
      }
      
      public static function choseDo(param1:*) : *
      {
         var _loc2_:int = int(uint(param1.target.name.substr(1,2)));
         if(slotNum == 1)
         {
            myplayer.getStampSlot().setSlot1(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 2)
         {
            myplayer.getStampSlot().setSlot2(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 3)
         {
            myplayer.getStampSlot().setSlot3(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 4)
         {
            myplayer.getStampSlot().setSlot4(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 5)
         {
            myplayer.getStampSlot().setSlot5(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 6)
         {
            myplayer.getStampSlot().setSlot6(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 7)
         {
            myplayer.getStampSlot().setSlot7(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 8)
         {
            myplayer.getStampSlot().setSlot8(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 9)
         {
            myplayer.getStampSlot().setSlot9(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 10)
         {
            myplayer.getStampSlot().setSlot10(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         else if(slotNum == 11)
         {
            myplayer.getStampSlot().setSlot11(myplayer.getBag().delGem(_loc2_,1),clickNum);
         }
         showGem();
         showPanel();
         showRMB();
      }
      
      public static function xiaDo(param1:*) : *
      {
         if(yeNum < 5)
         {
            ++yeNum;
         }
         showGem();
         showPanel();
      }
      
      public static function shangDo(param1:*) : *
      {
         if(yeNum > 1)
         {
            --yeNum;
         }
         showGem();
         showPanel();
      }
      
      public static function upShow(param1:*) : *
      {
         qnPanel["strengTip"].visible = true;
         qnPanel["strengTip"].x = qnPanel.mouseX + 10;
         qnPanel["strengTip"].y = qnPanel.mouseY;
         if(yeNum == 1)
         {
            qnPanel["strengTip"]["str_txt"].text = "魔力印章 嵌入到潜能印章中可以得到以下效果：使用MP药水后额外获得5%的回复加成。";
         }
         else if(yeNum == 2)
         {
            qnPanel["strengTip"]["str_txt"].text = "攻击印章 嵌入到潜能印章中可以得到以下效果：额外增幅角色攻击力1.2%";
         }
         else if(yeNum == 3)
         {
            qnPanel["strengTip"]["str_txt"].text = "生命印章 嵌入到潜能印章中可以得到以下效果：额外增幅角色生命值1000点。";
         }
         else if(yeNum == 4)
         {
            qnPanel["strengTip"]["str_txt"].text = "速度印章 嵌入到潜能印章中可以得到以下效果：额外增幅角色移动速度0.5点。";
         }
         else if(yeNum == 5)
         {
            qnPanel["strengTip"]["str_txt"].text = "尚未开放";
         }
      }
      
      public static function downShow(param1:*) : *
      {
         qnPanel["strengTip"].visible = true;
         qnPanel["strengTip"].x = qnPanel.mouseX + 10;
         qnPanel["strengTip"].y = qnPanel.mouseY;
         if(yeNum == 1)
         {
            qnPanel["strengTip"]["str_txt"].text = "体力印章 嵌入到潜能印章中可以得到以下效果：使用HP药水后额外获得5%的回复加成。";
         }
         else if(yeNum == 2)
         {
            qnPanel["strengTip"]["str_txt"].text = "防御印章 嵌入到潜能印章中可以得到以下效果：额外增幅角色防御力1.2%";
         }
         else if(yeNum == 3)
         {
            qnPanel["strengTip"]["str_txt"].text = "力量印章 嵌入到潜能印章中可以得到以下效果：额外增幅角色攻击力100点。";
         }
         else if(yeNum == 4)
         {
            qnPanel["strengTip"]["str_txt"].text = "石肤印章 嵌入到潜能印章中可以得到以下效果：角色所受伤害减少2.5%";
         }
         else if(yeNum == 5)
         {
            qnPanel["strengTip"]["str_txt"].text = "尚未开放";
         }
      }
      
      public static function closeShow(param1:*) : *
      {
         qnPanel["strengTip"].visible = false;
      }
      
      public static function upDo(param1:*) : *
      {
         clickNum = param1.target.name.substr(2,1);
         if(yeNum == 1)
         {
            if(myplayer.getStampSlot().getSlot1(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot1(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 2)
         {
            if(myplayer.getStampSlot().getSlot3(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot3(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 3)
         {
            if(myplayer.getStampSlot().getSlot5(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot5(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 4)
         {
            if(myplayer.getStampSlot().getSlot7(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot7(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 5)
         {
            if(myplayer.getStampSlot().getSlot9(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot9(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         showPanel();
         showRMB();
         qnPanel["k1_" + clickNum].visible = true;
         slotNum = yeNum * 2 - 1;
         showGem(slotNum + 6);
      }
      
      public static function downDo(param1:*) : *
      {
         clickNum = param1.target.name.substr(2,1);
         if(yeNum == 1)
         {
            if(myplayer.getStampSlot().getSlot2(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot2(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 2)
         {
            if(myplayer.getStampSlot().getSlot4(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot4(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 3)
         {
            if(myplayer.getStampSlot().getSlot6(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot6(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 4)
         {
            if(myplayer.getStampSlot().getSlot8(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot8(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         else if(yeNum == 5)
         {
            if(myplayer.getStampSlot().getSlot10(clickNum))
            {
               mygem = true;
               if(myplayer.getBag().backGemBagNum() > 0)
               {
                  myplayer.getBag().addGemBag(myplayer.getStampSlot().delSlot10(clickNum));
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宝石栏空间不足，无法卸下");
               }
            }
            else
            {
               mygem = false;
            }
         }
         showPanel();
         showRMB();
         qnPanel["k2_" + clickNum].visible = true;
         slotNum = yeNum * 2;
         showGem(slotNum + 6);
      }
   }
}

