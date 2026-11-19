package com.hotpoint.braveManIII.views.wantedPanel
{
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class NewWantedPanel extends MovieClip
   {
      
      public static var itemsTooltip:ItemsTooltip;
      
      public static var xsrwPanel:MovieClip;
      
      public static var xsrw:NewWantedPanel;
      
      private static var loadData:ClassLoader;
      
      public static var CZXSOK:Boolean = false;
      
      public static var clickNum:Number = 0;
      
      public static var czNum:Number = 0;
      
      public static var click:Number = 0;
      
      public static var yeshu:Number = 1;
      
      public static var overNum:Number = 0;
      
      public static var JLOK:Boolean = false;
      
      private static var loadName:String = "NewWanted_v840.swf";
      
      private static var OpenYN:Boolean = false;
      
      public function NewWantedPanel()
      {
         super();
         itemsTooltip = new ItemsTooltip();
         itemsTooltip.visible = false;
      }
      
      private static function LoadSkin() : *
      {
         if(!xsrwPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("WantedShow") as Class;
         xsrwPanel = new _loc2_();
         xsrw.addChild(xsrwPanel);
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
         xsrw = new NewWantedPanel();
         LoadSkin();
         Main._stage.addChild(xsrw);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         xsrw = new NewWantedPanel();
         Main._stage.addChild(xsrw);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         if(!Main.wts)
         {
            Main.wts = WantedTaskSlot.creatWantedTaskSlot();
         }
         Main.allClosePanel();
         if(xsrwPanel)
         {
            if(Main.wts.getAccess() > -1)
            {
               clickNum = Main.wts.getAccess();
               yeshu = Math.ceil((Main.wts.getAccess() + 1) / 3);
            }
            Main.stopXX = true;
            xsrw.x = 0;
            xsrw.y = 0;
            addListener();
            xsrw.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(!Main.wts)
         {
            Main.wts = WantedTaskSlot.creatWantedTaskSlot();
         }
         if(xsrwPanel)
         {
            Main.stopXX = false;
            removeListener();
            xsrw.visible = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListener() : *
      {
         xsrwPanel["touming"].visible = false;
         xsrwPanel["msg_mc"].stop();
         xsrwPanel["msg_mc"].mouseEnabled = false;
         xsrwPanel["msg_mc"].visible = false;
         xsrwPanel["NoMoney_mc"].visible = false;
         xsrwPanel["lingqu_btn"].visible = false;
         xsrwPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         xsrwPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         xsrwPanel["shang_btn"].addEventListener(MouseEvent.CLICK,shang_btn);
         xsrwPanel["xia_btn"].addEventListener(MouseEvent.CLICK,xia_btn);
         xsrwPanel["lingqu_btn"].addEventListener(MouseEvent.CLICK,lingqu);
         xsrwPanel["closeP"].addEventListener(MouseEvent.CLICK,closeXS);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            xsrwPanel["kk" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,overDO);
            xsrwPanel["kk" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,outDO);
            xsrwPanel["cd" + _loc1_].addEventListener(MouseEvent.CLICK,lqReset);
            xsrwPanel["jq" + _loc1_].addEventListener(MouseEvent.CLICK,jiequ);
            xsrwPanel["fq" + _loc1_].addEventListener(MouseEvent.CLICK,fangqiRW);
            xsrwPanel["wc" + _loc1_].addEventListener(MouseEvent.CLICK,wanchengRW);
            xsrwPanel["number" + _loc1_].stop();
            xsrwPanel["time" + _loc1_].visible = false;
            xsrwPanel["yjq" + _loc1_].visible = false;
            _loc1_++;
         }
         panelShow();
      }
      
      public static function removeListener() : *
      {
         xsrwPanel["NoMoney_mc"]["yes_btn"].removeEventListener(MouseEvent.CLICK,closeNORMB);
         xsrwPanel["NoMoney_mc"]["addMoney_btn"].removeEventListener(MouseEvent.CLICK,addMoney_btn);
         xsrwPanel["shang_btn"].removeEventListener(MouseEvent.CLICK,shang_btn);
         xsrwPanel["xia_btn"].removeEventListener(MouseEvent.CLICK,xia_btn);
         xsrwPanel["lingqu_btn"].removeEventListener(MouseEvent.CLICK,lingqu);
         xsrwPanel["closeP"].removeEventListener(MouseEvent.CLICK,closeXS);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            xsrwPanel["kk" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,overDO);
            xsrwPanel["kk" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,outDO);
            xsrwPanel["cd" + _loc1_].removeEventListener(MouseEvent.CLICK,lqReset);
            xsrwPanel["jq" + _loc1_].removeEventListener(MouseEvent.CLICK,jiequ);
            xsrwPanel["fq" + _loc1_].removeEventListener(MouseEvent.CLICK,fangqiRW);
            xsrwPanel["wc" + _loc1_].removeEventListener(MouseEvent.CLICK,wanchengRW);
            _loc1_++;
         }
      }
      
      public static function outDO(param1:*) : *
      {
         xsrwPanel["msg_mc"].visible = false;
      }
      
      public static function overDO(param1:*) : *
      {
         click = param1.target.name.substr(2,1);
         xsrwPanel["msg_mc"].visible = true;
         xsrwPanel["msg_mc"].x = xsrwPanel.mouseX + 10;
         xsrwPanel["msg_mc"].y = 200;
         if(xsrwPanel.mouseX > 600)
         {
            xsrwPanel["msg_mc"].x -= 400;
         }
         click = Main.wts.getWantedTaskFromSlot(click + 3 * (yeshu - 1)).getFrame();
         xsrwPanel["msg_mc"].gotoAndStop(click);
      }
      
      public static function lqReset(param1:*) : *
      {
         czNum = param1.target.name.substr(2,1);
         czNum += (yeshu - 1) * 3;
         if(Main.player1.getBag().getOtherobjNum(63289) >= 3)
         {
            Main.player1.getBag().delOtherById(63289,3);
            Main.wts.delCD(czNum);
            panelShow();
         }
         else if(Boolean(Main.P1P2) && Main.player2.getBag().getOtherobjNum(63289) >= 3)
         {
            Main.player2.getBag().delOtherById(63289,3);
            Main.wts.delCD(czNum);
            panelShow();
         }
         else if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.chongzhirenwu.getValue());
            CZXSOK = true;
            xsrwPanel["touming"].visible = true;
         }
         else
         {
            xsrwPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function lqczOK() : *
      {
         if(CZXSOK)
         {
            xsrwPanel["touming"].visible = false;
            Main.wts.delCD(czNum);
            CZXSOK = false;
            panelShow();
         }
      }
      
      private static function closeNORMB(param1:*) : void
      {
         xsrwPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      public static function closeXS(param1:*) : *
      {
         close();
      }
      
      public static function shang_btn(param1:*) : *
      {
         if(yeshu > 1)
         {
            --yeshu;
         }
         panelShow();
      }
      
      public static function xia_btn(param1:*) : *
      {
         if(yeshu == 1 && Main.wts.wantedTaskTimesLV1() >= 10)
         {
            yeshu = 2;
         }
         else if(yeshu == 2 && Main.wts.wantedTaskTimesLV2() >= 10)
         {
            yeshu = 3;
         }
         else if(yeshu == 3 && Main.wts.wantedTaskTimesLV3() >= 10)
         {
            yeshu = 4;
         }
         else if(yeshu == 4 && Main.wts.wantedTaskTimesLV4() >= 10)
         {
            yeshu = 5;
         }
         else if(yeshu == 5 && Main.wts.wantedTaskTimesLV5() >= 10)
         {
            yeshu = 6;
         }
         else if(yeshu == 6 && Main.wts.wantedTaskTimesLV6() >= 10)
         {
            yeshu = 7;
         }
         else if(yeshu == 7 && Main.wts.wantedTaskTimesLV7() >= 10)
         {
            yeshu = 8;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"该等级完成次数不足，无法进入下一等级悬赏");
         }
         panelShow();
      }
      
      public static function wanchengRW(param1:*) : *
      {
         clickNum = param1.target.name.substr(2,1);
         clickNum += 3 * (yeshu - 1);
         if(Main.P1P2)
         {
            if(Main.player1.getBag().backSuppliesBagNum() > 1 && Main.player2.getBag().backSuppliesBagNum() > 1)
            {
               Main.wts.getWantedTaskFromSlot(clickNum).setState(3);
               panelShow();
               JLOK = true;
               xsrwPanel["touming"].visible = true;
               Main.Save();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足,奖励无法发放");
            }
         }
         else if(Main.player1.getBag().backSuppliesBagNum() > 1)
         {
            Main.wts.getWantedTaskFromSlot(clickNum).setState(3);
            panelShow();
            JLOK = true;
            xsrwPanel["touming"].visible = true;
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足,奖励无法发放");
         }
      }
      
      public static function getJiangLi() : *
      {
         if(JLOK)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backSuppliesBagNum() > 1 && Main.player2.getBag().backSuppliesBagNum() > 1)
               {
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21219));
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21220));
                  Main.player2.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21219));
                  Main.player2.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21220));
                  Main.wts.getWantedTaskFromSlot(clickNum).setState(3);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"奖励领取成功，请在背包查看");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
               if(Math.random() * 10 > 5)
               {
                  if(Main.player1.getBag().backGemBagNum() > 0)
                  {
                     Main.player1.getBag().addGemBag(GemFactory.creatGemById(Main.wts.getWantedTaskFromSlot(clickNum).getReward_1()));
                  }
               }
            }
            else
            {
               if(Main.player1.getBag().backSuppliesBagNum() > 1)
               {
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21219));
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21220));
                  Main.wts.getWantedTaskFromSlot(clickNum).setState(3);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"奖励领取成功，请在背包查看");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
               if(Math.random() * 10 > 5)
               {
                  if(Main.player1.getBag().backGemBagNum() > 0)
                  {
                     Main.player1.getBag().addGemBag(GemFactory.creatGemById(Main.wts.getWantedTaskFromSlot(clickNum).getReward_1()));
                  }
               }
            }
            JLOK = false;
            xsrwPanel["touming"].visible = false;
         }
      }
      
      public static function fangqiRW(param1:*) : *
      {
         clickNum = param1.target.name.substr(2,1);
         clickNum += 3 * (yeshu - 1);
         Main.wts.getWantedTaskFromSlot(clickNum).setState(0);
         panelShow();
      }
      
      public static function jiequ(param1:*) : *
      {
         overNum = param1.target.name.substr(2,1);
         overNum += 3 * (yeshu - 1);
         if(Main.P1P2)
         {
            if(Main.player1.getGold() >= 12000 && Main.player2.getGold() >= 12000)
            {
               if(Main.player1.getKillPoint() > 30 && Main.player2.getKillPoint() > 30)
               {
                  Main.player2.AddKillPoint(-30);
                  Main.player1.payGold(12000);
                  Main.player1.AddKillPoint(-30);
                  Main.player2.payGold(12000);
                  Main.wts.setWantedTaskSlot(overNum);
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"击杀点不足");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金币不足");
            }
         }
         else if(Main.player1.getGold() >= 12000)
         {
            if(Main.player1.getKillPoint() > 30)
            {
               Main.player1.payGold(12000);
               Main.player1.AddKillPoint(-30);
               Main.wts.setWantedTaskSlot(overNum);
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"击杀点不足");
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金币不足");
         }
         panelShow();
      }
      
      public static function lingqu(param1:*) : *
      {
         if(Main.wts.getJLTimes() < 1 && yeshu == 1)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63176));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63176));
                  Main.wts.addJLTimes();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"称号领取成功，已放入背包其他栏");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63176));
               Main.wts.addJLTimes();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"称号领取成功，已放入背包其他栏");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes2() < 1 && yeshu == 2)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63201));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63201));
                  Main.wts.addJLTimes2();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"称号领取成功，已放入背包其他栏");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63201));
               Main.wts.addJLTimes2();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"称号领取成功，已放入背包其他栏");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes3() < 1 && yeshu == 3)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63213));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63213));
                  Main.wts.addJLTimes3();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63213));
               Main.wts.addJLTimes3();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes4() < 1 && yeshu == 4)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63217));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63217));
                  Main.wts.addJLTimes4();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63217));
               Main.wts.addJLTimes4();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes5() < 1 && yeshu == 5)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63233));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63233));
                  Main.wts.addJLTimes5();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63233));
               Main.wts.addJLTimes5();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes6() < 1 && yeshu == 6)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63240));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63240));
                  Main.wts.addJLTimes6();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63240));
               Main.wts.addJLTimes6();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes7() < 1 && yeshu == 7)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63276));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63276));
                  Main.wts.addJLTimes7();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63276));
               Main.wts.addJLTimes7();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"背包空间不足");
            }
         }
         if(Main.wts.getJLTimes8() < 2 && yeshu == 8)
         {
            if(Main.P1P2)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1 && Main.player2.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63283));
                  Main.player2.getBag().addOtherobjBag(OtherFactory.creatOther(63283));
                  Main.wts.addJLTimes8();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63283));
               Main.wts.addJLTimes8();
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"背包空间不足");
            }
         }
         panelShow();
      }
      
      private static function xxShow(param1:int) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            if(_loc2_ < param1)
            {
               xsrwPanel["xx" + _loc2_].visible = true;
            }
            else
            {
               xsrwPanel["xx" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private static function panelShow() : *
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            xsrwPanel["fq" + _loc1_].visible = false;
            xsrwPanel["wc" + _loc1_].visible = false;
            xsrwPanel["cd" + _loc1_].visible = false;
            xsrwPanel["yjq" + _loc1_].visible = false;
            xsrwPanel["jq" + _loc1_].visible = true;
            xsrwPanel["number" + _loc1_].gotoAndStop(yeshu);
            xsrwPanel["tq" + _loc1_].gotoAndStop(Main.wts.getWantedTaskFromSlot(_loc1_ + 3 * (yeshu - 1)).getFrame());
            _loc1_++;
         }
         xsrwPanel["lingqu_btn"].visible = false;
         xsrwPanel._money_txt.text = Main.player1.getGold();
         xsrwPanel._kill_txt.text = Main.player1.getKillPoint();
         xsrwPanel._rmb_txt.text = Shop4399.moneyAll.getValue();
         if(yeshu == 1)
         {
            xxShow(Main.wts.wantedTaskTimesLV1());
         }
         else if(yeshu == 2)
         {
            xxShow(Main.wts.wantedTaskTimesLV2());
         }
         else if(yeshu == 3)
         {
            xxShow(Main.wts.wantedTaskTimesLV3());
         }
         else if(yeshu == 4)
         {
            xxShow(Main.wts.wantedTaskTimesLV4());
         }
         else if(yeshu == 5)
         {
            xxShow(Main.wts.wantedTaskTimesLV5());
         }
         else if(yeshu == 6)
         {
            xxShow(Main.wts.wantedTaskTimesLV6());
         }
         else if(yeshu == 7)
         {
            xxShow(Main.wts.wantedTaskTimesLV7());
         }
         else if(yeshu == 8)
         {
            xxShow(Main.wts.wantedTaskTimesLV8());
         }
         if(yeshu == 8 && Main.wts.wantedTaskTimesLV8() >= 10 && Main.wts.getJLTimes8() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 7 && Main.wts.wantedTaskTimesLV7() >= 10 && Main.wts.getJLTimes7() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 6 && Main.wts.wantedTaskTimesLV6() >= 10 && Main.wts.getJLTimes6() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 5 && Main.wts.wantedTaskTimesLV5() >= 10 && Main.wts.getJLTimes5() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 4 && Main.wts.wantedTaskTimesLV4() >= 10 && Main.wts.getJLTimes4() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 3 && Main.wts.wantedTaskTimesLV3() >= 10 && Main.wts.getJLTimes3() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 2 && Main.wts.wantedTaskTimesLV2() >= 10 && Main.wts.getJLTimes2() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(yeshu == 1 && Main.wts.wantedTaskTimesLV1() >= 10 && Main.wts.getJLTimes() < 1)
         {
            xsrwPanel["lingqu_btn"].visible = true;
         }
         if(Main.wts.getAccess() > -1)
         {
            if(yeshu * 3 - Main.wts.getAccess() > 0 && yeshu * 3 - Main.wts.getAccess() < 4)
            {
               xsrwPanel["yjq" + (Main.wts.getAccess() - 3 * (yeshu - 1))].visible = true;
               if(Main.wts.getWantedTaskFromSlot(Main.wts.getAccess()).getState() == 1)
               {
                  xsrwPanel["fq" + (Main.wts.getAccess() - 3 * (yeshu - 1))].visible = true;
               }
               if(Main.wts.getWantedTaskFromSlot(Main.wts.getAccess()).getState() == 2)
               {
                  xsrwPanel["wc" + (Main.wts.getAccess() - 3 * (yeshu - 1))].visible = true;
               }
            }
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               xsrwPanel["jq" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         if(Main.wts.getISCD() == -1)
         {
            xsrwPanel.removeEventListener(Event.ENTER_FRAME,cdTime);
         }
         else
         {
            xsrwPanel.addEventListener(Event.ENTER_FRAME,cdTime);
         }
      }
      
      public static function cdTime(param1:*) : *
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            if(Main.wts.getWantedTaskFromSlot(_loc2_ + 3 * (yeshu - 1)).getState() == 3)
            {
               if(Main.wts.getWantedTaskFromSlot(_loc2_ + 3 * (yeshu - 1)).nowCD() <= 0)
               {
                  panelShow();
               }
               else
               {
                  xsrwPanel["yjq" + _loc2_].visible = false;
                  xsrwPanel["cd" + _loc2_].visible = true;
                  xsrwPanel["jq" + _loc2_].visible = false;
                  xsrwPanel["time" + _loc2_].text = "冷却时间" + int(Main.wts.getWantedTaskFromSlot(_loc2_ + 3 * (yeshu - 1)).nowCD() / 60) + "分" + Main.wts.getWantedTaskFromSlot(_loc2_ + 3 * (yeshu - 1)).nowCD() % 60 + "秒";
                  xsrwPanel["time" + _loc2_].visible = true;
               }
            }
            else
            {
               xsrwPanel["cd" + _loc2_].visible = false;
               xsrwPanel["time" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         if(Main.wts.getISCD() == -1)
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               xsrwPanel["time" + _loc2_].visible = false;
               _loc2_++;
            }
            xsrwPanel.removeEventListener(Event.ENTER_FRAME,cdTime);
            panelShow();
         }
      }
   }
}

