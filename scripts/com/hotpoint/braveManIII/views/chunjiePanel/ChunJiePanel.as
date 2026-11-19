package com.hotpoint.braveManIII.views.chunjiePanel
{
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class ChunJiePanel extends MovieClip
   {
      
      public static var fpp:ChunJiePanel;
      
      public static var cjPanel:MovieClip;
      
      private static var loadData:ClassLoader;
      
      public static var saveArr:Array = [0,7];
      
      public static var saveArr2:Array = [1,0,0,0];
      
      public static var save_OK:Boolean = false;
      
      public static var CJOK:Boolean = false;
      
      private static var loadName:String = "Chunjie.swf";
      
      private static var OpenYN:Boolean = false;
      
      public static var jifenTime:int = 0;
      
      public static var start:int = 0;
      
      public static var end:int = 0;
      
      public function ChunJiePanel()
      {
         super();
      }
      
      private static function LoadSkin() : *
      {
         if(!cjPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("ChunjieShow") as Class;
         cjPanel = new _loc2_();
         fpp.addChild(cjPanel);
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
         fpp = new ChunJiePanel();
         LoadSkin();
         Main._stage.addChild(fpp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         fpp = new ChunJiePanel();
         if(jifenTime <= 0)
         {
            fpp.addEventListener(Event.ENTER_FRAME,addZaiXianJiFen);
         }
         Main._stage.addChild(fpp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(cjPanel)
         {
            Main.stopXX = true;
            fpp.x = 0;
            fpp.y = 0;
            addListenerP1();
            fpp.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(cjPanel)
         {
            fpp.visible = false;
            Main.stopXX = false;
            removeListenerP1();
         }
         else
         {
            InitClose();
         }
      }
      
      public static function closeCP(param1:*) : *
      {
         close();
      }
      
      public static function initJiFen() : *
      {
         saveArr2[1] = saveArr2[2] = saveArr2[3] = 0;
      }
      
      public static function removeListenerP1() : *
      {
      }
      
      public static function addListenerP1() : *
      {
         if(saveArr2[0] != Main.serverTime.getValue())
         {
            initJiFen();
            saveArr2[0] = Main.serverTime.getValue();
         }
         cjPanel["baiju"].stop();
         cjPanel["lingqu"].visible = false;
         cjPanel["wenben"].visible = false;
         cjPanel["lingqu"].addEventListener(MouseEvent.CLICK,lingQu);
         cjPanel["shua"].addEventListener(MouseEvent.CLICK,shua);
         cjPanel["shua"].addEventListener(MouseEvent.MOUSE_OVER,shuaOVER);
         cjPanel["shua"].addEventListener(MouseEvent.MOUSE_OUT,shuaOUT);
         cjPanel["shuaRMB"].addEventListener(MouseEvent.CLICK,shuaRMB);
         cjPanel["close"].addEventListener(MouseEvent.CLICK,closeCP);
         show();
      }
      
      public static function show() : *
      {
         cjPanel["piaochong"]["jindu"].text = saveArr[0];
         cjPanel["mashua"].text = "魔法马刷:" + saveArr2[3] + "个";
         cjPanel["dianjuan"].text = "点卷:" + Shop4399.moneyAll.getValue();
         cjPanel["piaochong"].x = 405 + saveArr[0] - saveArr[0] / 10;
         if(saveArr[0] < 50)
         {
            cjPanel["baiju"].gotoAndStop(1);
         }
         else if(saveArr[0] >= 50 && saveArr[0] < 100)
         {
            cjPanel["baiju"].gotoAndStop(2);
         }
         else if(saveArr[0] >= 100 && saveArr[0] < 150)
         {
            cjPanel["baiju"].gotoAndStop(3);
         }
         else if(saveArr[0] >= 150 && saveArr[0] < 200)
         {
            cjPanel["baiju"].gotoAndStop(4);
         }
         else if(saveArr[0] >= 200 && saveArr[0] < 250)
         {
            cjPanel["baiju"].gotoAndStop(5);
         }
         else if(saveArr[0] >= 250 && saveArr[0] < 300)
         {
            cjPanel["baiju"].gotoAndStop(6);
         }
         else if(saveArr[0] >= 300 && saveArr[0] < 350)
         {
            cjPanel["baiju"].gotoAndStop(7);
         }
         else
         {
            cjPanel["baiju"].gotoAndStop(8);
         }
         if(saveArr[0] >= 50 && saveArr[1] > 6)
         {
            cjPanel["lingqu"].visible = true;
         }
         else if(saveArr[0] >= 100 && saveArr[1] > 5)
         {
            cjPanel["lingqu"].visible = true;
         }
         else if(saveArr[0] >= 150 && saveArr[1] > 4)
         {
            cjPanel["lingqu"].visible = true;
         }
         else if(saveArr[0] >= 200 && saveArr[1] > 3)
         {
            cjPanel["lingqu"].visible = true;
         }
         else if(saveArr[0] >= 250 && saveArr[1] > 2)
         {
            cjPanel["lingqu"].visible = true;
         }
         else if(saveArr[0] >= 300 && saveArr[1] > 1)
         {
            cjPanel["lingqu"].visible = true;
         }
         else if(saveArr[0] >= 350 && saveArr[1] > 0)
         {
            cjPanel["lingqu"].visible = true;
         }
         else
         {
            cjPanel["lingqu"].visible = false;
         }
      }
      
      public static function shuaRMB(param1:*) : *
      {
         if(saveArr[0] >= 350)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"清洁度已满！");
            return;
         }
         if(Shop4399.moneyAll.getValue() >= 9)
         {
            Api_4399_All.BuyObj(InitData.chunjie143.getValue());
            CJOK = true;
            cjPanel["shuaRMB"].visible = false;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"点卷不足！");
         }
      }
      
      public static function chunjieOK() : *
      {
         if(CJOK)
         {
            ++saveArr[0];
            cjPanel["dianjuan"].text = "点卷:" + Shop4399.moneyAll.getValue();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"购买成功");
            CJOK = false;
            cjPanel["shuaRMB"].visible = true;
            show();
         }
      }
      
      public static function shuaOVER(param1:*) : *
      {
         cjPanel["wenben"]["txt_1"].text = "在线获得:" + saveArr2[1] + "/15";
         cjPanel["wenben"]["txt_2"].text = "打boss获得:" + saveArr2[2] + "/35";
         cjPanel["wenben"].visible = true;
      }
      
      public static function shuaOUT(param1:*) : *
      {
         cjPanel["wenben"].visible = false;
      }
      
      public static function shua(param1:*) : *
      {
         if(saveArr2[3] > 0)
         {
            ++saveArr[0];
            --saveArr2[3];
         }
         show();
      }
      
      public static function rdmLQ() : *
      {
         var _loc1_:int = 0;
         if(Main.player1.getBag().backSuppliesBagNum() >= 2 && Main.player1.getBag().backGemBagNum() >= 1 && Main.player1.getBag().backOtherBagNum() >= 1)
         {
            _loc1_ = int(Math.random() * 9);
            if(_loc1_ == 0)
            {
               Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21223));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + SuppliesFactory.getSuppliesById(21223).getName());
            }
            else if(_loc1_ == 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63204).getName());
            }
            else if(_loc1_ == 2)
            {
               Main.player1.getBag().addGemBag(GemFactory.creatGemById(33213));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(33213).getName());
            }
            else if(_loc1_ == 3)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63138));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63138).getName());
            }
            else if(_loc1_ == 4)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63210).getName());
            }
            else if(_loc1_ == 5)
            {
               Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + SuppliesFactory.getSuppliesById(21221).getName());
            }
            else if(_loc1_ == 6)
            {
               Main.player1.getBag().addGemBag(GemFactory.creatGemById(33511));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(33511).getName());
            }
            else if(_loc1_ == 7)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63106));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63106).getName());
            }
            else if(_loc1_ == 8)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63100).getName());
            }
            --saveArr[1];
            show();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
      }
      
      public static function lingQu(param1:*) : *
      {
         cjPanel["lingqu"].visible = false;
         save_OK = true;
         Main.Save();
      }
      
      public static function lingQuOK() : *
      {
         if(save_OK)
         {
            if(saveArr[1] == 7)
            {
               if(Main.player1.getBag().backSuppliesBagNum() >= 2)
               {
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21223));
                  --saveArr[1];
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + SuppliesFactory.getSuppliesById(21223).getName());
                  show();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(saveArr[1] == 1)
            {
               if(Main.player1.getBag().backOtherBagNum() >= 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63266));
                  --saveArr[1];
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63266).getName());
                  show();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else
            {
               rdmLQ();
            }
            save_OK = false;
         }
      }
      
      public static function addZaiXianJiFen(param1:*) : *
      {
         var _loc2_:Date = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         ++jifenTime;
         if(jifenTime == 2)
         {
            _loc2_ = new Date();
            _loc3_ = _loc2_.getHours();
            _loc4_ = _loc2_.getMinutes();
            _loc5_ = _loc2_.getSeconds();
         }
         if(jifenTime / 12960 > 1)
         {
            _loc2_ = new Date();
            _loc3_ = _loc2_.getHours();
            _loc4_ = _loc2_.getMinutes();
            _loc5_ = _loc2_.getSeconds();
            end = (_loc3_ * 3600 + _loc4_ * 60 + _loc5_) * 27;
            if(jifenTime - (end - start) < 600 * 27)
            {
               if(saveArr2[1] < 15 && Main.serverTime.getValue() < 20140206)
               {
                  saveArr2[1] += 1;
                  saveArr2[3] += 1;
               }
            }
            jifenTime = 1;
         }
      }
      
      public static function addShaGuaiJiFen() : *
      {
         if(saveArr2[2] < 35 && Main.serverTime.getValue() < 20140206)
         {
            saveArr2[2] += 1;
            saveArr2[3] += 1;
         }
      }
   }
}

