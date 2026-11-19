package com.hotpoint.braveManIII.views.elvesPanel
{
   import com.hotpoint.braveManIII.models.player.PlayerData;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.net.*;
   import flash.text.*;
   import src.*;
   
   public class ElvesPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var elvesPanel:MovieClip;
      
      public static var elp:ElvesPanel;
      
      public static var myplayer:PlayerData;
      
      private static var loadData:ClassLoader;
      
      public static var CZJLOK:Boolean = false;
      
      public static var blueOK:Boolean = false;
      
      public static var pinkOK:Boolean = false;
      
      public static var goldOK:Boolean = false;
      
      public static var kuoOK:Boolean = false;
      
      public static var shengjiOK:Boolean = false;
      
      public static var clickNum:Number = 0;
      
      public static var realNum:Number = 0;
      
      public static var changeNum:Number = 1;
      
      public static var yeshu:int = 1;
      
      public static var typeTemp:Number = -1;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "Panel_JL_v870.swf";
      
      private static var request:URLRequest = new URLRequest("http://my.4399.com/forums-thread-tagid-81127-id-42946108.html");
      
      public function ElvesPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!elvesPanel && !loadData)
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
            _loc3_ = int(elvesPanel["equip_mc"].getChildIndex(elvesPanel["equip_mc"]["e" + _loc1_]));
            _loc2_.x = elvesPanel["equip_mc"]["e" + _loc1_].x;
            _loc2_.y = elvesPanel["equip_mc"]["e" + _loc1_].y;
            _loc2_.name = "e" + _loc1_;
            elvesPanel["equip_mc"].removeChild(elvesPanel["equip_mc"]["e" + _loc1_]);
            elvesPanel["equip_mc"]["e" + _loc1_] = _loc2_;
            elvesPanel["equip_mc"].addChild(_loc2_);
            elvesPanel["equip_mc"].setChildIndex(_loc2_,_loc3_);
            _loc1_++;
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("JLShow") as Class;
         elvesPanel = new _loc2_();
         elp.addChild(elvesPanel);
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
         elp = new ElvesPanel();
         LoadSkin();
         Main._stage.addChild(elp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         elp = new ElvesPanel();
         Main._stage.addChild(elp);
         OpenYN = false;
      }
      
      public static function open(param1:PlayerData) : void
      {
         Main.allClosePanel();
         if(elvesPanel)
         {
            Main.stopXX = true;
            elp.x = 0;
            elp.y = 0;
            myplayer = param1;
            addListenerP1();
            Main._stage.addChild(elp);
            elp.visible = true;
         }
         else
         {
            myplayer = param1;
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(elvesPanel)
         {
            Main.stopXX = false;
            removeListenerP1();
            elp.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function closeJL(param1:*) : *
      {
         close();
      }
      
      public static function closeEquip_mc(param1:*) : *
      {
         elvesPanel["equip_mc"].visible = false;
      }
      
      public static function addListenerP1() : *
      {
         var _loc2_:int = 0;
         elvesPanel["jnts"].visible = false;
         elvesPanel["sjts"].visible = false;
         elvesPanel["touming"].visible = false;
         elvesPanel["elvesTip"].visible = false;
         elvesPanel["NoMoney_mc"].visible = false;
         elvesPanel["blueRMB"].visible = false;
         elvesPanel["pinkRMB"].visible = false;
         elvesPanel["goldRMB"].visible = false;
         elvesPanel["czRMB"].visible = false;
         elvesPanel["isfangsheng"].visible = false;
         elvesPanel["fanhui"].visible = false;
         elvesPanel["equip_mc"].visible = false;
         elvesPanel["xishoutishi"].visible = false;
         elvesPanel["xishou_blue"].visible = false;
         elvesPanel["xishou_pink"].visible = false;
         elvesPanel["xishou_gold"].visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            elvesPanel["equip_mc"]["e" + _loc1_].mouseChildren = false;
            elvesPanel["equip_mc"]["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,tooltipOpen);
            elvesPanel["equip_mc"]["e" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,tooltipClose);
            elvesPanel["equip_mc"]["e" + _loc1_].addEventListener(MouseEvent.CLICK,selected);
            elvesPanel["equip_mc"]["e" + _loc1_].visible = false;
            _loc1_++;
         }
         elvesPanel["equip_mc"]["closeE"].addEventListener(MouseEvent.CLICK,closeEquip_mc);
         elvesPanel["isfangsheng"]["yes_btn"].addEventListener(MouseEvent.CLICK,fsYES);
         elvesPanel["isfangsheng"]["no_btn"].addEventListener(MouseEvent.CLICK,fsNO);
         elvesPanel["isfangsheng"]["no_btn2"].addEventListener(MouseEvent.CLICK,fsNO);
         elvesPanel["NoMoney_mc"]["no_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         elvesPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         elvesPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         elvesPanel["blueRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,blueYES);
         elvesPanel["blueRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,blueNO);
         elvesPanel["pinkRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,pinkYES);
         elvesPanel["pinkRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,pinkNO);
         elvesPanel["goldRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,goldYES);
         elvesPanel["goldRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,goldNO);
         elvesPanel["czRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,czYES);
         elvesPanel["czRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,czNO);
         elvesPanel["czRMB"]["no_btn2"].addEventListener(MouseEvent.CLICK,czNO);
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            elvesPanel["jl" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,tipClose);
            elvesPanel["jl" + _loc2_].addEventListener(MouseEvent.MOUSE_OVER,tipOpen);
            elvesPanel["jl" + _loc2_].addEventListener(MouseEvent.CLICK,choseElves);
            _loc2_++;
         }
         elvesPanel["chongzhi"].addEventListener(MouseEvent.CLICK,chongzhi);
         elvesPanel["xishou_blue"]["xishouNow"].addEventListener(MouseEvent.CLICK,xishouNow);
         elvesPanel["xishou_pink"]["xishouNow"].addEventListener(MouseEvent.CLICK,xishouNow);
         elvesPanel["xishou_gold"]["xishouNow"].addEventListener(MouseEvent.CLICK,xishouNow);
         elvesPanel["hp_btn"].addEventListener(MouseEvent.CLICK,hp_btn);
         elvesPanel["mp_btn"].addEventListener(MouseEvent.CLICK,mp_btn);
         elvesPanel["att_btn"].addEventListener(MouseEvent.CLICK,att_btn);
         elvesPanel["def_btn"].addEventListener(MouseEvent.CLICK,def_btn);
         elvesPanel["crit_btn"].addEventListener(MouseEvent.CLICK,crit_btn);
         elvesPanel["eInput"]["inputOK"].addEventListener(MouseEvent.CLICK,inputOK);
         elvesPanel["eInput"].visible = false;
         elvesPanel["blue"].addEventListener(MouseEvent.CLICK,blue);
         elvesPanel["pink"].addEventListener(MouseEvent.CLICK,pink);
         elvesPanel["gold"].addEventListener(MouseEvent.CLICK,gold);
         elvesPanel["kssj"].addEventListener(MouseEvent.CLICK,kuaisushengji);
         elvesPanel["blue"].addEventListener(MouseEvent.MOUSE_OUT,allOut);
         elvesPanel["pink"].addEventListener(MouseEvent.MOUSE_OUT,allOut);
         elvesPanel["gold"].addEventListener(MouseEvent.MOUSE_OUT,allOut);
         elvesPanel["blue"].addEventListener(MouseEvent.MOUSE_OVER,blueOver);
         elvesPanel["pink"].addEventListener(MouseEvent.MOUSE_OVER,pinkOver);
         elvesPanel["gold"].addEventListener(MouseEvent.MOUSE_OVER,goldOver);
         elvesPanel["tiaozhuan"].addEventListener(MouseEvent.CLICK,tiaozhuanOPEN);
         elvesPanel["zhaohuan"].addEventListener(MouseEvent.CLICK,zhaohuan);
         elvesPanel["zhaohui"].addEventListener(MouseEvent.CLICK,zhaohui);
         elvesPanel["fangsheng"].addEventListener(MouseEvent.CLICK,fangsheng);
         elvesPanel["close"].addEventListener(MouseEvent.CLICK,closeJL);
         _loc2_ = 1;
         while(_loc2_ < 4)
         {
            elvesPanel["jh_" + _loc2_].addEventListener(MouseEvent.CLICK,jihuoJN);
            elvesPanel["jh_" + _loc2_].addEventListener(MouseEvent.MOUSE_OVER,jihuoTiShi);
            elvesPanel["jh_" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,closeTiShi);
            elvesPanel["sj_" + _loc2_].addEventListener(MouseEvent.CLICK,shengjiJN);
            elvesPanel["sj_" + _loc2_].addEventListener(MouseEvent.MOUSE_OVER,shengjiTiShi);
            elvesPanel["sj_" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,closeTiShi);
            elvesPanel["jn_" + _loc2_].addEventListener(MouseEvent.MOUSE_OVER,jinengTiShi);
            elvesPanel["jn_" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,closeTiShi);
            _loc2_++;
         }
         elvesPanel["up_btn"].addEventListener(MouseEvent.CLICK,upDO);
         elvesPanel["down_btn"].addEventListener(MouseEvent.CLICK,downDO);
         if(!myplayer.playerJL_Data)
         {
         }
         showJL();
         showElvesAll();
      }
      
      public static function removeListenerP1() : *
      {
      }
      
      private static function upDO(param1:*) : *
      {
         if(yeshu > 1)
         {
            --yeshu;
         }
         showJL();
         showElvesAll();
      }
      
      private static function downDO(param1:*) : *
      {
         if(yeshu < 2)
         {
            ++yeshu;
         }
         showJL();
         showElvesAll();
      }
      
      private static function tooltipClose(param1:*) : *
      {
         itemsTooltip.visible = false;
      }
      
      private static function tooltipOpen(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         elvesPanel.addChild(itemsTooltip);
         var _loc3_:uint = uint(_loc2_.name.substr(1,2));
         var _loc4_:String = _loc2_.name.substr(0,1);
         if(_loc4_ == "e")
         {
            if(myplayer.getBag().getEquipFromBag(_loc3_) != null)
            {
               itemsTooltip.equipTooltip(myplayer.getBag().getEquipFromBag(_loc3_),1);
            }
         }
         itemsTooltip.visible = true;
         itemsTooltip.x = elvesPanel.mouseX + 30;
         itemsTooltip.y = elvesPanel.mouseY;
         itemsTooltip.setTooltipPoint();
      }
      
      public static function inputOK(param1:*) : *
      {
         var _loc2_:int = 0;
         if(elvesPanel["eInput"]["input"].text > 0 && elvesPanel["eInput"]["input"].text <= myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint())
         {
            _loc2_ = int(elvesPanel["eInput"]["input"].text);
            switch(typeTemp)
            {
               case 0:
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setHP(_loc2_);
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint(-_loc2_);
                  break;
               case 1:
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setMP(_loc2_);
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint(-_loc2_);
                  break;
               case 2:
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setATT(_loc2_);
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint(-_loc2_);
                  break;
               case 3:
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setDEF(_loc2_);
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint(-_loc2_);
                  break;
               case 4:
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setCRIT(_loc2_);
                  myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint(-_loc2_);
            }
         }
         elvesPanel["eInput"].visible = false;
         showElvesAll();
      }
      
      public static function hp_btn(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() > 0)
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() < 100)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setHP();
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint();
            }
            else
            {
               elvesPanel["eInput"].visible = true;
               typeTemp = 0;
            }
         }
         showElvesAll();
      }
      
      public static function mp_btn(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() > 0)
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() < 100)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setMP();
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint();
            }
            else
            {
               elvesPanel["eInput"].visible = true;
               typeTemp = 1;
            }
         }
         showElvesAll();
      }
      
      public static function att_btn(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() > 0)
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() < 100)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setATT();
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint();
            }
            else
            {
               elvesPanel["eInput"].visible = true;
               typeTemp = 2;
            }
         }
         showElvesAll();
      }
      
      public static function def_btn(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() > 0)
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() < 100)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setDEF();
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint();
            }
            else
            {
               elvesPanel["eInput"].visible = true;
               typeTemp = 3;
            }
         }
         showElvesAll();
      }
      
      public static function crit_btn(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() > 0)
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint() < 100)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setCRIT();
               myplayer.getElvesSlot().getElvesFromSlot(realNum).setAllPoint();
            }
            else
            {
               elvesPanel["eInput"].visible = true;
               typeTemp = 4;
            }
         }
         showElvesAll();
      }
      
      private static function tipClose(param1:*) : *
      {
         elvesPanel["elvesTip"].visible = false;
      }
      
      private static function tipOpen(param1:*) : *
      {
         var _loc2_:int = int(param1.target.name.substr(2,2));
         _loc2_ += (yeshu - 1) * 5;
         if(myplayer.getElvesSlot().getElvesFromSlot(_loc2_))
         {
            elvesPanel["elvesTip"]["str_name"].text = myplayer.getElvesSlot().getElvesFromSlot(_loc2_).getName();
            setColor(myplayer.getElvesSlot().getElvesFromSlot(_loc2_).getColor());
            elvesPanel["elvesTip"]["sudu"].text = myplayer.getElvesSlot().getElvesFromSlot(_loc2_).getTimeBuff() + "秒";
            elvesPanel["elvesTip"]["blue"].text = myplayer.getElvesSlot().getElvesFromSlot(_loc2_).getBlueNum() + "件";
            elvesPanel["elvesTip"]["pink"].text = myplayer.getElvesSlot().getElvesFromSlot(_loc2_).getPinkNum() + "件";
            elvesPanel["elvesTip"]["gold"].text = myplayer.getElvesSlot().getElvesFromSlot(_loc2_).getGoldNum() + "件";
            elvesPanel["elvesTip"].visible = true;
            elvesPanel.addChild(elvesPanel["elvesTip"]);
            elvesPanel["elvesTip"].x = elvesPanel.mouseX + 10;
            elvesPanel["elvesTip"].y = elvesPanel.mouseY;
         }
         else
         {
            elvesPanel["elvesTip"].visible = false;
         }
      }
      
      private static function setColor(param1:int) : void
      {
         if(param1 == 1)
         {
            ColorX(elvesPanel["elvesTip"]["str_name"],"0xffffff");
         }
         if(param1 == 2)
         {
            ColorX(elvesPanel["elvesTip"]["str_name"],"0x0066ff");
         }
         if(param1 == 3)
         {
            ColorX(elvesPanel["elvesTip"]["str_name"],"0xFF33FF");
         }
         if(param1 == 4)
         {
            ColorX(elvesPanel["elvesTip"]["str_name"],"0xFF9900");
         }
      }
      
      private static function ColorX(param1:*, param2:String) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2;
         param1.setTextFormat(_loc3_);
      }
      
      public static function showJL() : *
      {
         elvesPanel["yeshu_txt"].text = yeshu + "/" + 2;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ + (yeshu - 1) * 5 >= myplayer.getElvesSlot().getSlotNum())
            {
               elvesPanel["jl" + _loc1_].gotoAndStop(2);
            }
            else if(myplayer.getElvesSlot().getElvesFromSlot(_loc1_ + (yeshu - 1) * 5))
            {
               elvesPanel["jl" + _loc1_].gotoAndStop(myplayer.getElvesSlot().getElvesFromSlot(_loc1_ + (yeshu - 1) * 5).getFrame());
            }
            else
            {
               elvesPanel["jl" + _loc1_].gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      public static function showElvesAll() : *
      {
         var _loc1_:ColorMatrix = null;
         var _loc2_:ColorMatrixFilter = null;
         realNum = clickNum + (yeshu - 1) * 5;
         if(!myplayer.getElvesSlot().getElvesFromSlot(realNum))
         {
            showAllFalse();
            return;
         }
         myplayer.getElvesSlot().getElvesFromSlot(realNum).resetPoints();
         elvesPanel["hp_btn"].visible = true;
         elvesPanel["mp_btn"].visible = true;
         elvesPanel["att_btn"].visible = true;
         elvesPanel["def_btn"].visible = true;
         elvesPanel["crit_btn"].visible = true;
         elvesPanel["chongzhi"].visible = true;
         elvesPanel["blue"].visible = true;
         elvesPanel["pink"].visible = true;
         elvesPanel["gold"].visible = true;
         elvesPanel["hp_p"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getHP();
         elvesPanel["mp_p"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getMP();
         elvesPanel["att_p"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getATT();
         elvesPanel["def_p"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getDEF();
         elvesPanel["crit_p"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getCRIT();
         elvesPanel["allpoint"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getAllPoint();
         elvesPanel["hp"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getHP() * 13.3);
         elvesPanel["mp"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getMP() * 8.8);
         elvesPanel["att"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getATT());
         elvesPanel["def"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getDEF() * 1.9);
         elvesPanel["crit"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getCRIT() * 7.3);
         elvesPanel["mygold"].text = myplayer.getGold();
         elvesPanel["killP"].text = myplayer.getKillPoint();
         elvesPanel["chose"].x = elvesPanel["jl" + clickNum].x;
         elvesPanel["chose"].y = elvesPanel["jl" + clickNum].y;
         elvesPanel["chose"].visible = true;
         if(myplayer.playerJL_Data == myplayer.getElvesSlot().getElvesFromSlot(realNum))
         {
            elvesPanel["zhaohuan"].visible = false;
            elvesPanel["zhaohui"].visible = true;
         }
         else
         {
            elvesPanel["zhaohuan"].visible = true;
         }
         elvesPanel["fangsheng"].visible = true;
         elvesPanel["select"].visible = true;
         elvesPanel["select"].gotoAndStop(myplayer.getElvesSlot().getElvesFromSlot(realNum).getFrame());
         showLV(myplayer.getElvesSlot().getElvesFromSlot(realNum).getLevel());
         elvesPanel["jyt"]["zd"].scaleX = myplayer.getElvesSlot().getElvesFromSlot(realNum).getEXP() / (myplayer.getElvesSlot().getElvesFromSlot(realNum).getLevel() * 15);
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getLevel() >= 10)
         {
            elvesPanel["exp_txt"].text = "MAX";
            elvesPanel["kssj"].visible = false;
         }
         else
         {
            elvesPanel["kssj"].visible = true;
            elvesPanel["exp_txt"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getEXP() + "/" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getLevel() * 15;
         }
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1() > 0)
         {
            elvesPanel["sj_1"].visible = true;
            elvesPanel["jh_1"].visible = true;
            elvesPanel["jn_1"].gotoAndStop(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getFrame());
            if(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getSkillLevel() == 0)
            {
               _loc1_ = new ColorMatrix();
               _loc2_ = new ColorMatrixFilter();
               _loc1_.SetSaturationMatrix(0);
               _loc2_.matrix = _loc1_.GetFlatArray();
               elvesPanel["jn_1"].filters = [_loc2_];
               elvesPanel["lv_1"].visible = false;
            }
            else
            {
               elvesPanel["jn_1"].filters = [];
               elvesPanel["lv_1"].visible = true;
               elvesPanel["lv_1"].gotoAndStop(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getSkillLevel() + 1);
               elvesPanel["jh_1"].visible = false;
            }
            if(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getSkillLevel() == 5)
            {
               elvesPanel["jh_1"].visible = false;
               elvesPanel["sj_1"].visible = false;
            }
         }
         else
         {
            elvesPanel["jn_1"].filters = [];
            elvesPanel["jn_1"].gotoAndStop(1);
            elvesPanel["lv_1"].visible = false;
            elvesPanel["jh_1"].visible = false;
            elvesPanel["sj_1"].visible = false;
         }
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2() > 0)
         {
            elvesPanel["sj_2"].visible = true;
            elvesPanel["jh_2"].visible = true;
            elvesPanel["jn_2"].gotoAndStop(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getFrame());
            if(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getSkillLevel() == 0)
            {
               _loc1_ = new ColorMatrix();
               _loc2_ = new ColorMatrixFilter();
               _loc1_.SetSaturationMatrix(0);
               _loc2_.matrix = _loc1_.GetFlatArray();
               elvesPanel["jn_2"].filters = [_loc2_];
               elvesPanel["lv_2"].visible = false;
            }
            else
            {
               elvesPanel["jn_2"].filters = [];
               elvesPanel["lv_2"].visible = true;
               elvesPanel["lv_2"].gotoAndStop(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getSkillLevel() + 1);
               elvesPanel["jh_2"].visible = false;
            }
            if(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getSkillLevel() == 5)
            {
               elvesPanel["jh_2"].visible = false;
               elvesPanel["sj_2"].visible = false;
            }
         }
         else
         {
            elvesPanel["jn_2"].filters = [];
            elvesPanel["jn_2"].gotoAndStop(1);
            elvesPanel["lv_2"].visible = false;
            elvesPanel["jh_2"].visible = false;
            elvesPanel["sj_2"].visible = false;
         }
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3() > 0)
         {
            elvesPanel["sj_3"].visible = true;
            elvesPanel["jh_3"].visible = true;
            elvesPanel["jn_3"].gotoAndStop(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getFrame());
            if(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getSkillLevel() == 0)
            {
               _loc1_ = new ColorMatrix();
               _loc2_ = new ColorMatrixFilter();
               _loc1_.SetSaturationMatrix(0);
               _loc2_.matrix = _loc1_.GetFlatArray();
               elvesPanel["jn_3"].filters = [_loc2_];
               elvesPanel["lv_3"].visible = false;
            }
            else
            {
               elvesPanel["jn_3"].filters = [];
               elvesPanel["lv_3"].visible = true;
               elvesPanel["lv_3"].gotoAndStop(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getSkillLevel() + 1);
               elvesPanel["jh_3"].visible = false;
            }
            if(SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getSkillLevel() == 5)
            {
               elvesPanel["jh_3"].visible = false;
               elvesPanel["sj_3"].visible = false;
            }
         }
         else
         {
            elvesPanel["jn_3"].filters = [];
            elvesPanel["jn_3"].gotoAndStop(1);
            elvesPanel["lv_3"].visible = false;
            elvesPanel["jh_3"].visible = false;
            elvesPanel["sj_3"].visible = false;
         }
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3() > 0 && myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2() <= 0)
         {
            elvesPanel["jn_3"].x = 353.95;
            elvesPanel["jn_3"].y = 427;
            elvesPanel["lv_3"].x = 358;
            elvesPanel["lv_3"].y = 432.55;
            elvesPanel["jh_3"].x = 379.45;
            elvesPanel["jh_3"].y = 516.35;
            elvesPanel["sj_3"].x = 379.45;
            elvesPanel["sj_3"].y = 516.35;
            elvesPanel["jn_2"].x = 473.95;
            elvesPanel["jn_2"].y = 427;
            elvesPanel["lv_2"].x = 480;
            elvesPanel["lv_2"].y = 432.55;
            elvesPanel["jh_2"].x = 499.95;
            elvesPanel["jh_2"].y = 516.35;
            elvesPanel["sj_2"].x = 499.95;
            elvesPanel["sj_2"].y = 516.35;
         }
         else
         {
            elvesPanel["jn_2"].x = 353.95;
            elvesPanel["jn_2"].y = 427;
            elvesPanel["lv_2"].x = 358;
            elvesPanel["lv_2"].y = 432.55;
            elvesPanel["jh_2"].x = 379.45;
            elvesPanel["jh_2"].y = 516.35;
            elvesPanel["sj_2"].x = 379.45;
            elvesPanel["sj_2"].y = 516.35;
            elvesPanel["jn_3"].x = 473.95;
            elvesPanel["jn_3"].y = 427;
            elvesPanel["lv_3"].x = 480;
            elvesPanel["lv_3"].y = 432.55;
            elvesPanel["jh_3"].x = 499.95;
            elvesPanel["jh_3"].y = 516.35;
            elvesPanel["sj_3"].x = 499.95;
            elvesPanel["sj_3"].y = 516.35;
         }
         blueShow();
         pinkShow();
         goldShow();
      }
      
      public static function showAllFalse() : *
      {
         elvesPanel["kssj"].visible = false;
         elvesPanel["zhaohui"].visible = false;
         elvesPanel["zhaohuan"].visible = false;
         elvesPanel["fangsheng"].visible = false;
         elvesPanel["shiwei"].visible = false;
         elvesPanel["gewei"].visible = false;
         elvesPanel["select"].visible = false;
         elvesPanel["chose"].visible = false;
         elvesPanel["blue"].visible = false;
         elvesPanel["pink"].visible = false;
         elvesPanel["gold"].visible = false;
         elvesPanel["hp_btn"].visible = false;
         elvesPanel["mp_btn"].visible = false;
         elvesPanel["att_btn"].visible = false;
         elvesPanel["def_btn"].visible = false;
         elvesPanel["crit_btn"].visible = false;
         elvesPanel["chongzhi"].visible = false;
         elvesPanel["xishou_blue"].visible = false;
         elvesPanel["xishou_pink"].visible = false;
         elvesPanel["xishou_gold"].visible = false;
         var _loc1_:* = 1;
         while(_loc1_ < 4)
         {
            elvesPanel["jn_" + _loc1_].filters = [];
            elvesPanel["jn_" + _loc1_].gotoAndStop(1);
            elvesPanel["lv_" + _loc1_].visible = false;
            elvesPanel["jh_" + _loc1_].visible = false;
            elvesPanel["sj_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public static function kuozhanRMB() : *
      {
         if(Shop4399.moneyAll.getValue() >= 50)
         {
            Api_4399_All.BuyObj(InitData.cwSlot.getValue());
            kuoOK = true;
            elvesPanel["touming"].visible = true;
         }
         else
         {
            elvesPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function slotRMBOK() : *
      {
         if(kuoOK)
         {
            myplayer.getElvesSlot().addSlotNum(1);
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"成功扩展一个精灵槽");
            kuoOK = false;
            showJL();
            showElvesAll();
            elvesPanel["touming"].visible = false;
         }
      }
      
      public static function choseElves(param1:*) : *
      {
         if(param1.target is SimpleButton)
         {
            clickNum = uint(param1.target.parent.name.substr(2,2));
         }
         else
         {
            clickNum = uint(param1.target.name.substr(2,2));
         }
         if(clickNum + (yeshu - 1) * 5 >= myplayer.getElvesSlot().getSlotNum())
         {
            kuozhanRMB();
         }
         showElvesAll();
      }
      
      public static function selected(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:Number = uint(_loc2_.name.substr(1,2));
         if(changeNum == 1 && myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueEquip() == null && myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueEquipNum() > 0)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).setBlueEquip(myplayer.getBag().delEquip(_loc3_));
         }
         else if(changeNum == 2 && myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkEquip() == null && myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkEquipNum() > 0)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).setPinkEquip(myplayer.getBag().delEquip(_loc3_));
         }
         else if(changeNum == 3 && myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldEquip() == null && myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldEquipNum() > 0)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).setGoldEquip(myplayer.getBag().delEquip(_loc3_));
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"吸收装备已达到上限，无法继续吸收");
         }
         elvesPanel["equip_mc"].visible = false;
         showElvesAll();
      }
      
      private static function fsYES(param1:*) : *
      {
         if(myplayer == Main.player1)
         {
            if(Main.player_1.playerJL)
            {
               Main.player_1.playerJL.Close();
            }
         }
         if(myplayer == Main.player2)
         {
            if(Main.player_2.playerJL)
            {
               Main.player_2.playerJL.Close();
            }
         }
         myplayer.getElvesSlot().delElvesSlot(realNum);
         elvesPanel["chose"].visible = true;
         showJL();
         showElvesAll();
         elvesPanel["isfangsheng"].visible = false;
         if(myplayer.getElvesSlot().backElvesNum() == 0)
         {
            close();
         }
      }
      
      private static function fsNO(param1:*) : *
      {
         elvesPanel["isfangsheng"].visible = false;
      }
      
      private static function fangsheng(param1:*) : *
      {
         elvesPanel["isfangsheng"].visible = true;
      }
      
      private static function tiaozhuanOPEN(param1:*) : *
      {
         navigateToURL(request,"_blank");
      }
      
      private static function zhaohuan(param1:*) : *
      {
         if(myplayer == Main.player1)
         {
            Main.player_1.NewJL(myplayer.getElvesSlot().getElvesFromSlot(realNum));
         }
         else
         {
            Main.player_2.NewJL(myplayer.getElvesSlot().getElvesFromSlot(realNum));
         }
         showElvesAll();
      }
      
      private static function zhaohui(param1:*) : *
      {
         if(myplayer == Main.player1)
         {
            Main.player_1.playerJL.Close();
         }
         else
         {
            Main.player_2.playerJL.Close();
         }
         showElvesAll();
      }
      
      private static function allOut(param1:*) : *
      {
         elvesPanel["xishoutishi"].visible = false;
      }
      
      private static function blueOver(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum))
         {
            elvesPanel["xishoutishi"].x = 360;
            elvesPanel["xishoutishi"].y = 87;
            elvesPanel["xishoutishi"].visible = true;
            elvesPanel["xishoutishi"]["color_txt"].text = "蓝色";
            ColorX(elvesPanel["xishoutishi"]["color_txt"],"0x0066ff");
            elvesPanel["xishoutishi"]["limit_txt"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueEquipNum() + "件" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueLV() + "级";
            elvesPanel["xishoutishi"]["reward_txt"].text = "3点精灵点数。";
         }
      }
      
      private static function pinkOver(param1:*) : *
      {
         elvesPanel["xishoutishi"].x = 360;
         elvesPanel["xishoutishi"].y = 172;
         elvesPanel["xishoutishi"].visible = true;
         elvesPanel["xishoutishi"]["color_txt"].text = "粉色";
         ColorX(elvesPanel["xishoutishi"]["color_txt"],"0xFF33FF");
         elvesPanel["xishoutishi"]["limit_txt"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkEquipNum() + "件" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkLV() + "级";
         elvesPanel["xishoutishi"]["reward_txt"].text = "6点精灵点数。";
      }
      
      private static function goldOver(param1:*) : *
      {
         elvesPanel["xishoutishi"].x = 360;
         elvesPanel["xishoutishi"].y = 244;
         elvesPanel["xishoutishi"].visible = true;
         elvesPanel["xishoutishi"]["color_txt"].text = "金色";
         ColorX(elvesPanel["xishoutishi"]["color_txt"],"0xFF9900");
         elvesPanel["xishoutishi"]["limit_txt"].text = myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldEquipNum() + "件" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldLV() + "级";
         elvesPanel["xishoutishi"]["reward_txt"].text = "10点精灵点数。";
      }
      
      private static function blue(param1:*) : *
      {
         changeNum = 1;
         elvesPanel["equip_mc"].visible = true;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < 24)
         {
            if(Boolean(myplayer.getBag().getEquipFromBag(_loc3_)) && Boolean(myplayer.getBag().getEquipFromBag(_loc3_).getColor() == 2) && myplayer.getBag().getEquipFromBag(_loc3_).getDressLevel() >= myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueLV())
            {
               _loc2_++;
               elvesPanel["equip_mc"]["e" + _loc3_].visible = true;
               elvesPanel["equip_mc"]["e" + _loc3_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc3_).getFrame());
            }
            else
            {
               elvesPanel["equip_mc"]["e" + _loc3_].visible = false;
            }
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            elvesPanel["equip_mc"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"没有适合吸收的装备");
         }
         blueShow();
      }
      
      private static function blueShow() : *
      {
         elvesPanel["blue"].visible = true;
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueEquip() == null || myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueCD() < 1)
         {
            elvesPanel["xishou_blue"].visible = false;
         }
         else
         {
            elvesPanel["xishou_blue"].visible = true;
            elvesPanel["blue"].visible = false;
            elvesPanel.addEventListener(Event.ENTER_FRAME,blueTime);
         }
      }
      
      private static function blueTime(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum))
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueCD() < 0)
            {
               blueShow();
               showElvesAll();
               elvesPanel["xishou_blue"]["jindutiao"].x = -247;
               elvesPanel.removeEventListener(Event.ENTER_FRAME,blueTime);
            }
            else
            {
               elvesPanel["xishou_blue"]["time_txt"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueCD() / 60) + ":" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueCD() % 60;
               elvesPanel["xishou_blue"]["jindutiao"].x = -int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueCD() / (myplayer.getElvesSlot().getElvesFromSlot(realNum).getBlueTT() / 247));
            }
         }
      }
      
      private static function pink(param1:*) : *
      {
         changeNum = 2;
         elvesPanel["equip_mc"].visible = true;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < 24)
         {
            if(Boolean(myplayer.getBag().getEquipFromBag(_loc3_)) && Boolean(myplayer.getBag().getEquipFromBag(_loc3_).getColor() == 3) && myplayer.getBag().getEquipFromBag(_loc3_).getDressLevel() >= myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkLV())
            {
               _loc2_++;
               elvesPanel["equip_mc"]["e" + _loc3_].visible = true;
               elvesPanel["equip_mc"]["e" + _loc3_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc3_).getFrame());
            }
            else
            {
               elvesPanel["equip_mc"]["e" + _loc3_].visible = false;
            }
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            elvesPanel["equip_mc"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"没有适合吸收的装备");
         }
         pinkShow();
      }
      
      private static function pinkShow() : *
      {
         elvesPanel["pink"].visible = true;
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkEquip() == null || myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkCD() < 1)
         {
            elvesPanel["xishou_pink"].visible = false;
         }
         else
         {
            elvesPanel["pink"].visible = false;
            elvesPanel["xishou_pink"].visible = true;
            elvesPanel.addEventListener(Event.ENTER_FRAME,pinkTime);
         }
      }
      
      private static function pinkTime(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum))
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkCD() < 0)
            {
               pinkShow();
               showElvesAll();
               elvesPanel["xishou_pink"]["jindutiao"].x = -247;
               elvesPanel.removeEventListener(Event.ENTER_FRAME,pinkTime);
            }
            else
            {
               elvesPanel["xishou_pink"]["time_txt"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkCD() / 60) + ":" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkCD() % 60;
               elvesPanel["xishou_pink"]["jindutiao"].x = -int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkCD() / (myplayer.getElvesSlot().getElvesFromSlot(realNum).getPinkTT() / 247));
            }
         }
      }
      
      private static function gold(param1:*) : *
      {
         changeNum = 3;
         elvesPanel["equip_mc"].visible = true;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < 24)
         {
            if(Boolean(myplayer.getBag().getEquipFromBag(_loc3_)) && Boolean(myplayer.getBag().getEquipFromBag(_loc3_).getColor() >= 4) && myplayer.getBag().getEquipFromBag(_loc3_).getDressLevel() >= myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldLV())
            {
               _loc2_++;
               elvesPanel["equip_mc"]["e" + _loc3_].visible = true;
               elvesPanel["equip_mc"]["e" + _loc3_].gotoAndStop(myplayer.getBag().getEquipFromBag(_loc3_).getFrame());
            }
            else
            {
               elvesPanel["equip_mc"]["e" + _loc3_].visible = false;
            }
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            elvesPanel["equip_mc"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"没有适合吸收的装备");
         }
         goldShow();
      }
      
      private static function goldShow() : *
      {
         elvesPanel["gold"].visible = true;
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldEquip() == null || myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldCD() < 1)
         {
            elvesPanel["xishou_gold"].visible = false;
         }
         else
         {
            elvesPanel["gold"].visible = false;
            elvesPanel["xishou_gold"].visible = true;
            elvesPanel.addEventListener(Event.ENTER_FRAME,goldTime);
         }
      }
      
      private static function goldTime(param1:*) : *
      {
         if(myplayer.getElvesSlot().getElvesFromSlot(realNum))
         {
            if(myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldCD() < 0)
            {
               goldShow();
               showElvesAll();
               elvesPanel["xishou_gold"]["jindutiao"].x = -247;
               elvesPanel.removeEventListener(Event.ENTER_FRAME,goldTime);
            }
            else
            {
               elvesPanel["xishou_gold"]["time_txt"].text = int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldCD() / 60) + ":" + myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldCD() % 60;
               elvesPanel["xishou_gold"]["jindutiao"].x = -int(myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldCD() / (myplayer.getElvesSlot().getElvesFromSlot(realNum).getGoldTT() / 247));
            }
         }
      }
      
      private static function showLV(param1:Number) : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 < 10)
         {
            elvesPanel["shiwei"].gotoAndStop(param1);
            elvesPanel["gewei"].visible = false;
            elvesPanel["shiwei"].visible = true;
         }
         else
         {
            elvesPanel["shiwei"].visible = true;
            elvesPanel["gewei"].visible = true;
            _loc2_ = param1.toString();
            _loc3_ = int(_loc2_.substring(0,1));
            _loc4_ = int(_loc2_.substring(1,2));
            elvesPanel["shiwei"].gotoAndStop(_loc3_);
            if(_loc4_ == 0)
            {
               elvesPanel["gewei"].gotoAndStop(10);
            }
            else
            {
               elvesPanel["gewei"].gotoAndStop(_loc4_);
            }
         }
      }
      
      private static function closeNORMB(param1:*) : void
      {
         elvesPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      private static function xishouNow(param1:*) : *
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         var _loc3_:String = _loc2_.parent.name;
         if(_loc3_ == "xishou_blue")
         {
            if(myplayer.getBag().getOtherobjNum(63289) >= 1)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).overBlueEquip();
               showElvesAll();
               blueShow();
               myplayer.getBag().delOtherById(63289,1);
            }
            else if(Shop4399.moneyAll.getValue() >= 5)
            {
               Api_4399_All.BuyObj(InitData.blue.getValue());
               blueOK = true;
               elvesPanel["touming"].visible = true;
            }
            else
            {
               elvesPanel["NoMoney_mc"].visible = true;
            }
         }
         else if(_loc3_ == "xishou_pink")
         {
            if(myplayer.getBag().getOtherobjNum(63289) >= 2)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).overPinkEquip();
               showElvesAll();
               pinkShow();
               myplayer.getBag().delOtherById(63289,2);
            }
            else if(Shop4399.moneyAll.getValue() >= 8)
            {
               Api_4399_All.BuyObj(InitData.pink.getValue());
               pinkOK = true;
               elvesPanel["touming"].visible = true;
            }
            else
            {
               elvesPanel["NoMoney_mc"].visible = true;
            }
         }
         else if(_loc3_ == "xishou_gold")
         {
            if(myplayer.getBag().getOtherobjNum(63289) >= 3)
            {
               myplayer.getElvesSlot().getElvesFromSlot(realNum).overGoldEquip();
               myplayer.getBag().delOtherById(63289,3);
               showElvesAll();
               goldShow();
            }
            else if(Shop4399.moneyAll.getValue() >= 12)
            {
               Api_4399_All.BuyObj(InitData.gold.getValue());
               goldOK = true;
               elvesPanel["touming"].visible = true;
            }
            else
            {
               elvesPanel["NoMoney_mc"].visible = true;
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"吸收装备已达到上限，无法继续吸收");
         }
      }
      
      private static function chongzhi(param1:*) : *
      {
         elvesPanel["czRMB"].visible = true;
      }
      
      private static function czYES(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 18)
         {
            Api_4399_All.BuyObj(InitData.BuyNum_50.getValue());
            CZJLOK = true;
            elvesPanel["czRMB"].visible = false;
            elvesPanel["touming"].visible = true;
         }
         else
         {
            elvesPanel["NoMoney_mc"].visible = true;
         }
      }
      
      private static function czNO(param1:*) : *
      {
         elvesPanel["czRMB"].visible = false;
      }
      
      public static function chongzhiOK() : *
      {
         if(CZJLOK)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).resetAllPoint();
            CZJLOK = false;
            showElvesAll();
            elvesPanel["touming"].visible = false;
         }
      }
      
      private static function blueYES(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 18)
         {
            Api_4399_All.BuyObj(InitData.blue.getValue());
            blueOK = true;
            elvesPanel["blueRMB"].visible = false;
            elvesPanel["touming"].visible = true;
         }
         else
         {
            elvesPanel["NoMoney_mc"].visible = true;
         }
      }
      
      private static function blueNO(param1:*) : *
      {
         elvesPanel["blueRMB"].visible = false;
      }
      
      public static function blueXSOK() : *
      {
         if(blueOK)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).overBlueEquip();
            blueOK = false;
            showElvesAll();
            blueShow();
            elvesPanel["touming"].visible = false;
         }
      }
      
      private static function pinkYES(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 36)
         {
            Api_4399_All.BuyObj(InitData.pink.getValue());
            pinkOK = true;
            elvesPanel["pinkRMB"].visible = false;
            elvesPanel["touming"].visible = true;
         }
         else
         {
            elvesPanel["NoMoney_mc"].visible = true;
         }
      }
      
      private static function pinkNO(param1:*) : *
      {
         elvesPanel["pinkRMB"].visible = false;
      }
      
      public static function pinkXSOK() : *
      {
         if(pinkOK)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).overPinkEquip();
            pinkOK = false;
            showElvesAll();
            pinkShow();
            elvesPanel["touming"].visible = false;
         }
      }
      
      private static function goldYES(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 80)
         {
            Api_4399_All.BuyObj(InitData.gold.getValue());
            goldOK = true;
            elvesPanel["goldRMB"].visible = false;
            elvesPanel["touming"].visible = true;
         }
         else
         {
            elvesPanel["NoMoney_mc"].visible = true;
         }
      }
      
      private static function goldNO(param1:*) : *
      {
         elvesPanel["goldRMB"].visible = false;
      }
      
      public static function goldXSOK() : *
      {
         if(goldOK)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).overGoldEquip();
            goldOK = false;
            showElvesAll();
            goldShow();
            elvesPanel["touming"].visible = false;
         }
      }
      
      private static function kuaisushengji(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.jlexp.getValue());
            shengjiOK = true;
            elvesPanel["touming"].visible = true;
         }
         else
         {
            elvesPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function kssjOK() : *
      {
         if(shengjiOK)
         {
            myplayer.getElvesSlot().getElvesFromSlot(realNum).addExp(99999);
            shengjiOK = false;
            showElvesAll();
            elvesPanel["touming"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"升级成功！！");
         }
      }
      
      private static function jihuoJN(param1:*) : *
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         var _loc3_:Number = uint(_loc2_.name.substr(3,1));
         if(_loc3_ == 1)
         {
            if(myplayer.getBag().getOtherobjNum(63290) >= SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getskillLevelUp())
            {
               myplayer.getBag().delOtherById(63290,SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getskillLevelUp());
               myplayer.getElvesSlot().getElvesFromSlot(realNum).upSKILL1();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"激活成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵之光数量不足");
            }
         }
         if(_loc3_ == 2)
         {
            if(myplayer.getBag().getOtherobjNum(63290) >= SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getskillLevelUp())
            {
               myplayer.getBag().delOtherById(63290,SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getskillLevelUp());
               myplayer.getElvesSlot().getElvesFromSlot(realNum).upSKILL2();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"激活成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵之光数量不足");
            }
         }
         if(_loc3_ == 3)
         {
            if(myplayer.getBag().getOtherobjNum(63290) >= SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getskillLevelUp())
            {
               myplayer.getBag().delOtherById(63290,SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getskillLevelUp());
               myplayer.getElvesSlot().getElvesFromSlot(realNum).upSKILL3();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"激活成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵之光数量不足");
            }
         }
         showElvesAll();
         if(myplayer == Main.player1)
         {
            if(Main.player_1.playerJL)
            {
               Main.player_1.playerJL.getID();
            }
         }
         else if(Main.player_2.playerJL)
         {
            Main.player_2.playerJL.getID();
         }
      }
      
      private static function shengjiJN(param1:*) : *
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         var _loc3_:Number = uint(_loc2_.name.substr(3,1));
         if(_loc3_ == 1)
         {
            if(myplayer.getBag().getOtherobjNum(63290) >= SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getskillLevelUp())
            {
               myplayer.getBag().delOtherById(63290,SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getskillLevelUp());
               myplayer.getElvesSlot().getElvesFromSlot(realNum).upSKILL1();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"升级成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵之光数量不足");
            }
         }
         if(_loc3_ == 2)
         {
            if(myplayer.getBag().getOtherobjNum(63290) >= SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getskillLevelUp())
            {
               myplayer.getBag().delOtherById(63290,SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getskillLevelUp());
               myplayer.getElvesSlot().getElvesFromSlot(realNum).upSKILL2();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"升级成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵之光数量不足");
            }
         }
         if(_loc3_ == 3)
         {
            if(myplayer.getBag().getOtherobjNum(63290) >= SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getskillLevelUp())
            {
               myplayer.getBag().delOtherById(63290,SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getskillLevelUp());
               myplayer.getElvesSlot().getElvesFromSlot(realNum).upSKILL3();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"升级成功");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵之光数量不足");
            }
         }
         showElvesAll();
         if(myplayer == Main.player1)
         {
            if(Main.player_1.playerJL)
            {
               Main.player_1.playerJL.getID();
            }
         }
         else if(Main.player_2.playerJL)
         {
            Main.player_2.playerJL.getID();
         }
      }
      
      private static function jihuoTiShi(param1:*) : *
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         var _loc3_:Number = uint(_loc2_.name.substr(3,1));
         elvesPanel["sjts"].visible = true;
         elvesPanel["sjts"].x = elvesPanel.mouseX + 5;
         elvesPanel["sjts"].y = elvesPanel.mouseY - 70;
         if(_loc3_ == 1)
         {
            elvesPanel["sjts"]["txt"].text = "激活此圣物需要" + SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getskillLevelUp() + "个精灵之光，您背包中还有" + myplayer.getBag().getOtherobjNum(63290) + "个，精灵之光可在排行榜的暗黑宝箱中获得！";
         }
         if(_loc3_ == 2)
         {
            elvesPanel["sjts"]["txt"].text = "激活此圣物需要" + SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getskillLevelUp() + "个精灵之光，您背包中还有" + myplayer.getBag().getOtherobjNum(63290) + "个，精灵之光可在排行榜的暗黑宝箱中获得！";
         }
         if(_loc3_ == 3)
         {
            elvesPanel["sjts"]["txt"].text = "激活此圣物需要" + SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getskillLevelUp() + "个精灵之光，您背包中还有" + myplayer.getBag().getOtherobjNum(63290) + "个，精灵之光可在排行榜的暗黑宝箱中获得！";
         }
      }
      
      private static function shengjiTiShi(param1:*) : *
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         var _loc3_:Number = uint(_loc2_.name.substr(3,1));
         elvesPanel["sjts"].visible = true;
         elvesPanel["sjts"].x = elvesPanel.mouseX + 5;
         elvesPanel["sjts"].y = elvesPanel.mouseY - 70;
         if(_loc3_ == 1)
         {
            elvesPanel["sjts"]["txt"].text = "升级此圣物需要" + SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getskillLevelUp() + "个精灵之光，您背包中还有" + myplayer.getBag().getOtherobjNum(63290) + "个，精灵之光可在排行榜的暗黑宝箱中获得！";
         }
         if(_loc3_ == 2)
         {
            elvesPanel["sjts"]["txt"].text = "升级此圣物需要" + SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getskillLevelUp() + "个精灵之光，您背包中还有" + myplayer.getBag().getOtherobjNum(63290) + "个，精灵之光可在排行榜的暗黑宝箱中获得！";
         }
         if(_loc3_ == 3)
         {
            elvesPanel["sjts"]["txt"].text = "升级此技能需要" + SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getskillLevelUp() + "个精灵之光，您背包中还有" + myplayer.getBag().getOtherobjNum(63290) + "个，精灵之光可在排行榜的暗黑宝箱中获得！";
         }
      }
      
      private static function jinengTiShi(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:Number = uint(_loc2_.name.substr(3,1));
         if(_loc2_.currentFrame > 1)
         {
            elvesPanel["jnts"].visible = true;
            elvesPanel["jnts"].x = elvesPanel.mouseX + 5;
            elvesPanel["jnts"].y = elvesPanel.mouseY - 70;
            if(_loc3_ == 1)
            {
               elvesPanel["jnts"]["txt"].text = SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL1()).getIntroduction();
            }
            if(_loc3_ == 2)
            {
               elvesPanel["jnts"]["txt"].text = SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL2()).getIntroduction();
            }
            if(_loc3_ == 3)
            {
               elvesPanel["jnts"]["txt"].text = SkillFactory.getSkillById(myplayer.getElvesSlot().getElvesFromSlot(realNum).getSKILL3()).getIntroduction();
            }
         }
      }
      
      private static function closeTiShi(param1:*) : *
      {
         elvesPanel["sjts"].visible = false;
         elvesPanel["jnts"].visible = false;
      }
   }
}

