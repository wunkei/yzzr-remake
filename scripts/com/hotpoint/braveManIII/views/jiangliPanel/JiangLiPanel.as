package com.hotpoint.braveManIII.views.jiangliPanel
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import flash.display.*;
   import flash.events.*;
   import src.*;
   
   public class JiangLiPanel extends MovieClip
   {
      
      public static var jlp:JiangLiPanel;
      
      public static var jlPanel:MovieClip;
      
      private static var loadData:ClassLoader;
      
      public static var LQtimes:VT = VT.createVT(0);
      
      private static var loadName:String = "LVJiangLi.swf";
      
      public function JiangLiPanel()
      {
         super();
      }
      
      private static function LoadSkin() : *
      {
         if(!jlPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("JiangLiShow") as Class;
         jlPanel = new _loc2_();
         jlp.addChild(jlPanel);
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
         jlp = new JiangLiPanel();
         LoadSkin();
         Main._stage.addChild(jlp);
         OpenYN = true;
      }
      
      private static function InitClose() : *
      {
         jlp = new JiangLiPanel();
         Main._stage.addChild(jlp);
         OpenYN = false;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         if(jlPanel)
         {
            Main.stopXX = true;
            jlp.x = 0;
            jlp.y = 0;
            addListenerP1();
            jlp.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(jlPanel)
         {
            jlp.visible = false;
            Main.stopXX = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function addListenerP1() : *
      {
         jlPanel["jiangli_mc"].stop();
         jlPanel["close"].addEventListener(MouseEvent.CLICK,closeJL);
         jlPanel["lingqu"].addEventListener(MouseEvent.CLICK,lingqu);
         show();
      }
      
      public static function closeJL(param1:*) : *
      {
         close();
      }
      
      public static function lingqu(param1:*) : *
      {
         if(LQtimes.getValue() == 0)
         {
            if(Main.player1.getBag().backequipBagNum() >= 1 && Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14610));
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63105));
               Main.player1.addGold(10000);
               if(Main.P1P2)
               {
                  Main.player2.addGold(10000);
               }
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 1)
         {
            if(Main.player1.getBag().backequipBagNum() >= 3)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14110));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14210));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14310));
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 2)
         {
            if(Main.player1.getBag().backequipBagNum() >= 1 && Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14670));
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63106));
               Main.player1.addGold(10000);
               if(Main.P1P2)
               {
                  Main.player2.addGold(10000);
               }
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 3)
         {
            if(Main.player1.getBag().backequipBagNum() >= 3)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14111));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14211));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14311));
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 4)
         {
            if(Main.player1.getBag().backequipBagNum() >= 1 && Main.player1.getBag().backOtherBagNum() >= 1 && Main.player1.getBag().backGemBagNum() >= 1)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14610));
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31214));
                  ++i;
               }
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 5)
         {
            if(Main.player1.getBag().backequipBagNum() >= 1 && Main.player1.getBag().backOtherBagNum() >= 1 && Main.player1.getBag().backGemBagNum() >= 1)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14670));
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31215));
                  ++i;
               }
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 6)
         {
            if(Main.player1.getBag().backequipBagNum() >= 3 && Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14112));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14212));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14312));
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 7)
         {
            if(Main.player1.getBag().backSuppliesBagNum() >= 3 && Main.player1.getBag().backOtherBagNum() >= 2 && Main.player1.getBag().backGemBagNum() >= 1)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ++i;
               }
               i = 0;
               while(i < 5)
               {
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31216));
                  ++i;
               }
               i = 0;
               while(i < 3)
               {
                  Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                  ++i;
               }
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         else if(LQtimes.getValue() == 8)
         {
            if(Main.player1.getBag().backequipBagNum() >= 3 && Main.player1.getBag().backOtherBagNum() >= 1)
            {
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14113));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14213));
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(14313));
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63234));
               LQtimes.setValue(LQtimes.getValue() + 1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功！");
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包已满，请整理背包！");
            }
         }
         show();
      }
      
      public static function show() : *
      {
         if(LQtimes.getValue() == 0)
         {
            if(Main.player1.getLevel() >= 1)
            {
               jlPanel["lingqu"].visible = true;
            }
            jlPanel["jiangli_mc"].gotoAndStop(1);
         }
         else if(LQtimes.getValue() == 1)
         {
            if(Main.player1.getLevel() >= 10)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(2);
         }
         else if(LQtimes.getValue() == 2)
         {
            if(Main.player1.getLevel() >= 20)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(3);
         }
         else if(LQtimes.getValue() == 3)
         {
            if(Main.player1.getLevel() >= 25)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(4);
         }
         else if(LQtimes.getValue() == 4)
         {
            if(Main.player1.getLevel() >= 30)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(5);
         }
         else if(LQtimes.getValue() == 5)
         {
            if(Main.player1.getLevel() >= 35)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(6);
         }
         else if(LQtimes.getValue() == 6)
         {
            if(Main.player1.getLevel() >= 40)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(7);
         }
         else if(LQtimes.getValue() == 7)
         {
            if(Main.player1.getLevel() >= 45)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(8);
         }
         else if(LQtimes.getValue() == 8)
         {
            if(Main.player1.getLevel() >= 50)
            {
               jlPanel["lingqu"].visible = true;
            }
            else
            {
               jlPanel["lingqu"].visible = false;
            }
            jlPanel["jiangli_mc"].gotoAndStop(9);
         }
         else if(LQtimes.getValue() == 9)
         {
            jlPanel["lingqu"].visible = false;
         }
      }
   }
}

