package com.hotpoint.braveManIII.views.petPanel
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.models.pet.Pet;
   import com.hotpoint.braveManIII.models.petEquip.*;
   import com.hotpoint.braveManIII.models.petGem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.pet.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   
   public class NewPetPanel extends MovieClip
   {
      
      public static var tempXM:PetGem;
      
      public static var bag:PetBag;
      
      public static var npp:NewPetPanel;
      
      public static var ccc:ClassLoader;
      
      public static var petPanel:MovieClip;
      
      private static var loadData:ClassLoader;
      
      private static var myplayer:Player;
      
      public static var XueMai:PetGem = PetGem.creatPetGem(0);
      
      public static var XGkey:VT = VT.createVT(0);
      
      public static var LVkey:VT = VT.createVT(0);
      
      public static var chosed:int = 0;
      
      public static var yeshu:int = 1;
      
      public static var clickNum:int = 0;
      
      public static var yeshu_bag:int = 0;
      
      private static var loadName:String = "NewPet_v931.swf";
      
      public static var jnNum:int = 0;
      
      private static var tempT:int = 0;
      
      public static var guanbi:Boolean = true;
      
      public static var xsjnOK:Boolean = false;
      
      public static var FHOK:Boolean = false;
      
      public static var WXOK:Boolean = false;
      
      public static var JNOK:Boolean = false;
      
      public static var SJOK:Boolean = false;
      
      public static var XGOK:Boolean = false;
      
      public static var slotOK:Boolean = false;
      
      public static var bagOK:Boolean = false;
      
      private static var OpenKey:int = 0;
      
      public static var bool:Boolean = false;
      
      public static var temp:int = 0;
      
      public static var tempFood:int = 0;
      
      public function NewPetPanel()
      {
         super();
      }
      
      private static function LoadSkin() : *
      {
         if(!petPanel && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
         }
         if(OpenKey == 1)
         {
            LoadInGame.Open(loadData);
         }
      }
      
      private static function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("NewPetShow") as Class;
         petPanel = new _loc2_();
         npp.addChild(petPanel);
         if(OpenKey == 0)
         {
            close();
         }
         else if(OpenKey == 1)
         {
            open();
         }
         else if(OpenKey == 2)
         {
            openLoad();
         }
      }
      
      private static function InitOpen() : *
      {
         if(!bag)
         {
            bag = PetBag.createPetBag();
         }
         npp = new NewPetPanel();
         LoadSkin();
         Main._stage.addChild(npp);
      }
      
      private static function InitClose() : *
      {
         if(!bag)
         {
            bag = PetBag.createPetBag();
         }
         npp = new NewPetPanel();
         Main._stage.addChild(npp);
         OpenKey = 0;
      }
      
      public static function open() : void
      {
         Main.allClosePanel();
         chosePetNum();
         bag.zhengliBag();
         OpenKey = 1;
         if(petPanel)
         {
            Main.stopXX = true;
            npp.x = 0;
            npp.y = 0;
            addListenerP1();
            npp.visible = true;
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function openLoad() : void
      {
         Main.allClosePanel();
         chosePetNum();
         bag.zhengliBag();
         OpenKey = 2;
         if(petPanel)
         {
            Main.stopXX = true;
            npp.x = 0;
            npp.y = 0;
            addListenerP1();
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function close() : void
      {
         if(petPanel)
         {
            npp.visible = false;
            Main.stopXX = false;
         }
         else
         {
            InitClose();
         }
      }
      
      public static function closeP(param1:*) : *
      {
         close();
         petPanel["b1"].visible = false;
         petPanel["b2"].visible = true;
         petPanel["b3"].visible = true;
         yeshu_bag = 0;
      }
      
      public static function doUP(param1:*) : *
      {
         if(yeshu > 1)
         {
            --yeshu;
         }
         showPetList();
         showPetAll();
      }
      
      public static function doDOWN(param1:*) : *
      {
         if(yeshu < 3)
         {
            ++yeshu;
         }
         showPetList();
         showPetAll();
      }
      
      public static function chosePetNum() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < Main.player1.getPetSlot().getPetSlotNum())
         {
            if(Boolean(Main.player1.getPetSlot().getPetFromSlot(_loc1_)) && Boolean(Main.player_1.playerCW))
            {
               if(Main.player1.getPetSlot().getPetFromSlot(_loc1_) == Main.player_1.playerCW.data)
               {
                  if(_loc1_ < 5)
                  {
                     yeshu = 1;
                     chosed = _loc1_;
                  }
                  else if(_loc1_ >= 5 && _loc1_ < 10)
                  {
                     yeshu = 2;
                     chosed = _loc1_;
                     chosed = _loc1_ - 5;
                  }
                  else
                  {
                     yeshu = 3;
                     chosed = _loc1_ - 10;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public static function tiaoshi() : *
      {
         myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).addExp(9999);
      }
      
      public static function testSkillxx() : *
      {
         myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).testSkill();
      }
      
      public static function kssj(param1:*) : *
      {
         petPanel["out_rmb_sj20"].visible = true;
      }
      
      public static function yesSJ(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.cwShengJi.getValue());
            SJOK = true;
            petPanel["out_rmb_sj20"].visible = false;
            petPanel["touming"].visible = true;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noSJ(param1:*) : *
      {
         petPanel["out_rmb_sj20"].visible = false;
      }
      
      public static function sjRMB() : *
      {
         if(SJOK)
         {
            myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).addExp(9999);
            petPanel["touming"].visible = false;
            showPetAll();
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
            SJOK = false;
         }
      }
      
      public static function shuaWX(param1:*) : *
      {
         petPanel["out_rmb_wx20"].visible = true;
      }
      
      public static function yesWX(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.cwWuXing.getValue());
            WXOK = true;
            petPanel["touming"].visible = true;
            petPanel["out_rmb_wx20"].visible = false;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noWX(param1:*) : *
      {
         petPanel["out_rmb_wx20"].visible = false;
      }
      
      public static function wxRMB() : *
      {
         if(WXOK)
         {
            myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setWX();
            showPetAll();
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            petPanel["touming"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
            WXOK = false;
         }
      }
      
      public static function ljfh(param1:*) : *
      {
         if(myplayer.data.getBag().getOtherobjNum(63289) >= 10)
         {
            myplayer.data.getPetSlot().addPetSlot(PetFactory.creatPet(myplayer.data.getPetSlot().delPetSlot(chosed + (yeshu - 1) * 5).getLink()));
            showPetList();
            showPetAll();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"立即孵化成功，宠物已进入宠物栏");
            myplayer.data.getBag().delOtherById(63289,10);
         }
         else if(Shop4399.moneyAll.getValue() >= 15)
         {
            Api_4399_All.BuyObj(InitData.fuHua.getValue());
            FHOK = true;
            petPanel["touming"].visible = true;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function yesFH(param1:*) : *
      {
         if(myplayer.data.getBag().getOtherobjNum(63289) >= 10)
         {
            myplayer.data.getPetSlot().addPetSlot(PetFactory.creatPet(myplayer.data.getPetSlot().delPetSlot(chosed + (yeshu - 1) * 5).getLink()));
            showPetList();
            showPetAll();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"立即孵化成功，宠物已进入宠物栏");
            myplayer.data.getBag().delOtherById(63289,10);
         }
         else if(Shop4399.moneyAll.getValue() >= 15)
         {
            Api_4399_All.BuyObj(InitData.fuHua.getValue());
            FHOK = true;
            petPanel["touming"].visible = true;
            petPanel["out_rmb15"].visible = false;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noFH(param1:*) : *
      {
         petPanel["out_rmb15"].visible = false;
      }
      
      public static function fhRMB() : *
      {
         if(FHOK)
         {
            myplayer.data.getPetSlot().addPetSlot(PetFactory.creatPet(myplayer.data.getPetSlot().delPetSlot(chosed + (yeshu - 1) * 5).getLink()));
            showPetList();
            showPetAll();
            petPanel["touming"].visible = false;
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"立即孵化成功，宠物已进入宠物栏");
            FHOK = false;
         }
      }
      
      public static function slotRMB() : *
      {
         if(slotOK)
         {
            myplayer.data.getPetSlot().addPetSlotNum(1);
            showPetList();
            showPetAll();
            petPanel["touming"].visible = false;
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
            slotOK = false;
         }
      }
      
      public static function yesCAO(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 50)
         {
            Api_4399_All.BuyObj(InitData.cwSlot.getValue());
            slotOK = true;
            petPanel["touming"].visible = true;
            petPanel["out_rmb50"].visible = false;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noCAO(param1:*) : *
      {
         petPanel["out_rmb50"].visible = false;
      }
      
      public static function shuaJN(param1:*) : *
      {
         var _loc2_:Array = null;
         jnNum = int(param1.target.name.substr(2,1));
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            _loc2_ = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetSkill();
            if(_loc2_[jnNum] > 0)
            {
               petPanel["out_rmb_lw20"].visible = true;
            }
         }
      }
      
      public static function yesShuaJN(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.cwJiNeng.getValue());
            JNOK = true;
            petPanel["out_rmb_lw20"].visible = false;
            petPanel["touming"].visible = true;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noShuaJN(param1:*) : *
      {
         petPanel["out_rmb_lw20"].visible = false;
      }
      
      public static function jnRMB() : *
      {
         if(JNOK)
         {
            myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setSkill(jnNum);
            showPetAll();
            petPanel["touming"].visible = false;
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
            JNOK = false;
         }
      }
      
      public static function shuaXG(param1:*) : *
      {
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            if(XGkey.getValue() > 0)
            {
               petPanel["out_jzxg"].visible = true;
            }
            else
            {
               petPanel["out_rmb_xg20"].visible = true;
            }
         }
      }
      
      public static function yesXGK(param1:*) : *
      {
         XGkey.setValue(XGkey.getValue() - 1);
         myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setXingge();
         showPetAll();
         showPetList();
         petPanel["out_jzxg"].visible = false;
      }
      
      public static function noXGK(param1:*) : *
      {
         petPanel["out_jzxg"].visible = false;
      }
      
      public static function yesShuaXG(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 20)
         {
            Api_4399_All.BuyObj(InitData.cwXingGe.getValue());
            XGOK = true;
            petPanel["out_rmb_xg20"].visible = false;
            petPanel["touming"].visible = true;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noShuaXG(param1:*) : *
      {
         petPanel["out_rmb_xg20"].visible = false;
      }
      
      public static function xgRMB() : *
      {
         if(XGOK)
         {
            myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setXingge();
            showPetAll();
            showPetList();
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            petPanel["touming"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
            XGOK = false;
         }
      }
      
      public static function addBagSpace(param1:*) : *
      {
         petPanel["out_ifadd"].visible = true;
      }
      
      public static function yesKuoBag(param1:*) : *
      {
         if(Shop4399.moneyAll.getValue() >= 98)
         {
            Api_4399_All.BuyObj(InitData.cwBag.getValue());
            bagOK = true;
            petPanel["out_ifadd"].visible = false;
            petPanel["touming"].visible = true;
         }
         else
         {
            petPanel["NoMoney_mc"].visible = true;
         }
      }
      
      public static function noKuoBag(param1:*) : *
      {
         petPanel["out_ifadd"].visible = false;
      }
      
      public static function bagRMB() : *
      {
         if(bagOK)
         {
            if(bag.getLimit() == 18)
            {
               bag.setLimit2();
               yeshu_bag = 1;
               petPanel["b1"].visible = true;
               petPanel["b2"].visible = false;
               petPanel["b3"].visible = true;
            }
            else if(bag.getLimit() == 36)
            {
               bag.setLimit3();
               yeshu_bag = 2;
               petPanel["b1"].visible = true;
               petPanel["b2"].visible = true;
               petPanel["b3"].visible = false;
            }
            petPanel["bagkc"].visible = false;
            showPetBag();
            petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
            petPanel["touming"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
            bagOK = false;
         }
      }
      
      public static function setFood(param1:*) : *
      {
         if(myplayer.data.getBag().getOtherobjNum(63148) > 0)
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getFood() < 500)
            {
               myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setFood(OtherFactory.creatOther(63148).getValue_1());
               myplayer.data.getBag().delOtherById(63148,1);
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物口粮不足，可在击杀点商城购买");
         }
         showPetAll();
      }
      
      private static function lingwu(param1:*) : *
      {
         var _loc3_:int = 0;
         var _loc2_:Array = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetSkill();
         for(_loc3_ in _loc2_)
         {
            if(_loc2_[_loc3_] == 0)
            {
               petPanel["out_isLW"].visible = true;
            }
         }
      }
      
      public static function yesLW(param1:*) : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(myplayer.data.getGold() >= 100000)
         {
            _loc2_ = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetSkill();
            for(_loc3_ in _loc2_)
            {
               if(_loc2_[_loc3_] == 0)
               {
                  myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setSkill(_loc3_);
                  petPanel["out_isLW"].visible = false;
                  petPanel["touming"].visible = true;
                  xsjnOK = true;
               }
            }
            myplayer.data.payGold(100000);
            Main.Save();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金币不足");
         }
      }
      
      public static function xianshiJN() : *
      {
         if(xsjnOK)
         {
            petPanel["touming"].visible = false;
            showPetAll();
         }
      }
      
      public static function noLW(param1:*) : *
      {
         petPanel["out_isLW"].visible = false;
      }
      
      public static function tscz(param1:*) : *
      {
         var _loc2_:int = 0;
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getType() == 3)
            {
               _loc2_ = 30 - myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getLvLimit();
               if(LVkey.getValue() > 0)
               {
                  if(Math.random() * 10 < _loc2_)
                  {
                     myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).addLvLimit();
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"提升成功~！");
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"提升失败~！");
                  }
                  LVkey.setValue(LVkey.getValue() - 1);
                  petPanel["chengzhang"]["txt_num"].text = LVkey.getValue();
                  showPetAll();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"缺少成长之书！");
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"需要最终进化才能进行等级上限提升");
            }
         }
      }
      
      public static function czOVER(param1:*) : *
      {
         petPanel["chengzhang"].visible = true;
         petPanel["chengzhang"]["txt_num"].text = LVkey.getValue();
         petPanel["chengzhang"].x = petPanel.mouseX - 5;
         petPanel["chengzhang"].y = petPanel.mouseY;
         if(petPanel["chengzhang"].y >= 320)
         {
            petPanel["chengzhang"].y = 320;
         }
      }
      
      public static function czOUT(param1:*) : *
      {
         petPanel["chengzhang"].visible = false;
      }
      
      private static function yesFS(param1:*) : *
      {
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5) == myplayer.data.playerCW_Data)
         {
            myplayer.playerCW.Close();
         }
         myplayer.data.getPetSlot().delPetSlot(chosed + (yeshu - 1) * 5);
         showPetList();
         showPetAll();
         petPanel["out_isFS"].visible = false;
      }
      
      private static function noFS(param1:*) : *
      {
         petPanel["out_isFS"].visible = false;
      }
      
      private static function fangsheng(param1:*) : *
      {
         petPanel["out_isFS"].visible = true;
      }
      
      private static function zhaohuan(param1:*) : *
      {
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getFood() > 0)
         {
            myplayer.NewCW(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5));
            myplayer.data.getPetSlot().setJilu(chosed + (yeshu - 1) * 5);
            petPanel["zhaohuan"].visible = false;
            petPanel["zhaohui"].visible = true;
            showPetAll();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"饱食度不足，请喂食后再召唤！");
         }
      }
      
      private static function zhaohui(param1:*) : *
      {
         myplayer.data.getPetSlot().setJilu(-1);
         myplayer.playerCW.Close();
         petPanel["zhaohuan"].visible = true;
         showPetAll();
      }
      
      private static function jinhua(param1:*) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Pet = null;
         if(myplayer.data.getBag().getOtherobjNum(63160) > 1)
         {
            myplayer.data.getBag().delOtherById(63160,2);
            _loc2_ = myplayer.data.getPetSlot().delPetSlot(chosed + (yeshu - 1) * 5);
            _loc3_ = PetFactory.creatPet(_loc2_.getEvolution());
            _loc3_.setXingge(_loc2_.getXingge());
            _loc3_.setPetEquip(_loc2_.getPetEquip());
            myplayer.data.getPetSlot().addPetSlot(_loc3_);
            if(_loc2_ == myplayer.data.playerCW_Data)
            {
               myplayer.playerCW.Close();
            }
            showPetList();
            showPetAll();
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"需要2个生命之源才能进化，可在击杀点商城的特殊购买栏获得");
         }
      }
      
      private static function closeNORMB(param1:*) : void
      {
         petPanel["NoMoney_mc"].visible = false;
      }
      
      private static function addMoney_btn(param1:*) : void
      {
         if(Main.serviceHold)
         {
            PayMoneyVar.instance.money = 100;
            Main.serviceHold.payMoney_As3(PayMoneyVar.instance);
         }
      }
      
      private static function openXG(param1:*) : void
      {
         petPanel["xg_txt"].x = petPanel.mouseX + 10;
         petPanel["xg_txt"].y = petPanel.mouseY;
         petPanel["xg_txt"].visible = true;
      }
      
      private static function closeXG(param1:*) : void
      {
         petPanel["xg_txt"].visible = false;
      }
      
      private static function openTip(param1:*) : void
      {
         var _loc2_:int = 0;
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            petPanel["jntip"].x = petPanel.mouseX + 10;
            petPanel["jntip"].y = petPanel.mouseY;
            _loc2_ = int(param1.target.name.substr(2,1));
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetSkillNum(_loc2_))
            {
               petPanel["jntip"].visible = true;
               petPanel["jntip"]["str_name"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetSkillNum(_loc2_).getSkillName();
               petPanel["jntip"]["str_text"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetSkillNum(_loc2_).getIntroduction();
            }
         }
      }
      
      private static function closeTip(param1:*) : void
      {
         petPanel["jntip"].visible = false;
      }
      
      private static function ZhuDong(param1:*) : void
      {
         petPanel["gensui"].visible = true;
         petPanel["zhudong"].visible = false;
         if(myplayer.playerCW)
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5) == myplayer.playerCW.data)
            {
               myplayer.playerCW.goEnemy = true;
               myplayer.data.getPetSlot().setMode(true);
            }
         }
      }
      
      private static function GenSui(param1:*) : void
      {
         petPanel["zhudong"].visible = true;
         petPanel["gensui"].visible = false;
         if(myplayer.playerCW)
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5) == myplayer.playerCW.data)
            {
               myplayer.playerCW.goEnemy = false;
               myplayer.data.getPetSlot().setMode(false);
            }
         }
      }
      
      public static function addListenerP1() : *
      {
         var _loc1_:uint = 0;
         petPanel.addEventListener(Event.ENTER_FRAME,timeFunction);
         petPanel["kssj"].addEventListener(MouseEvent.CLICK,kssj);
         petPanel["sxwx"].addEventListener(MouseEvent.CLICK,shuaWX);
         petPanel["setFood"].addEventListener(MouseEvent.CLICK,setFood);
         petPanel["tscz"].addEventListener(MouseEvent.CLICK,tscz);
         petPanel["ljfh"].addEventListener(MouseEvent.CLICK,ljfh);
         petPanel["fangsheng"].addEventListener(MouseEvent.CLICK,fangsheng);
         petPanel["close"].addEventListener(MouseEvent.CLICK,closeP);
         petPanel["up_btn"].addEventListener(MouseEvent.CLICK,doUP);
         petPanel["down_btn"].addEventListener(MouseEvent.CLICK,doDOWN);
         petPanel["zhaohuan"].addEventListener(MouseEvent.CLICK,zhaohuan);
         petPanel["zhaohui"].addEventListener(MouseEvent.CLICK,zhaohui);
         petPanel["NoMoney_mc"]["yes_btn"].addEventListener(MouseEvent.CLICK,closeNORMB);
         petPanel["NoMoney_mc"]["addMoney_btn"].addEventListener(MouseEvent.CLICK,addMoney_btn);
         petPanel["rongluMC"].stop();
         petPanel["rongluMC"].visible = false;
         petPanel["rongluMC"]["dj1"].stop();
         petPanel["rongluMC"]["dj2"].stop();
         petPanel["rongluMC"]["close"].addEventListener(MouseEvent.CLICK,closeRL);
         petPanel["rongluMC"]["chongsu_btn"].addEventListener(MouseEvent.CLICK,chongsuDO);
         petPanel["rongluMC"]["ronglian_btn"].addEventListener(MouseEvent.CLICK,ronglianDO);
         petPanel["tscz"].addEventListener(MouseEvent.MOUSE_OVER,czOVER);
         petPanel["tscz"].addEventListener(MouseEvent.MOUSE_OUT,czOUT);
         petPanel["NoMoney_mc"].visible = false;
         petPanel["touming"].visible = false;
         petPanel["NoMoney_mc"].visible = false;
         petPanel["tscz"].visible = true;
         petPanel["gensui"].addEventListener(MouseEvent.CLICK,GenSui);
         petPanel["zhudong"].addEventListener(MouseEvent.CLICK,ZhuDong);
         petPanel["xg_txt"].visible = false;
         petPanel["jntip"].visible = false;
         petPanel["out_jzxg"].visible = false;
         petPanel["out_sellequip"].visible = false;
         petPanel["out_rmb50"].visible = false;
         petPanel["out_rmb_sj20"].visible = false;
         petPanel["out_rmb15"].visible = false;
         petPanel["out_ifadd"].visible = false;
         petPanel["out_rmb_lw20"].visible = false;
         petPanel["out_rmb_wx20"].visible = false;
         petPanel["out_rmb_xg20"].visible = false;
         petPanel["out_isLW"].visible = false;
         petPanel["out_isFS"].visible = false;
         petPanel["xueJN_mc"].visible = false;
         petPanel["b1"].visible = false;
         petPanel["b2"].visible = true;
         petPanel["b3"].visible = true;
         petPanel["shuxing"].visible = false;
         petPanel["out_jzxg"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesXGK);
         petPanel["out_jzxg"]["no_btn"].addEventListener(MouseEvent.CLICK,noXGK);
         petPanel["out_ifadd"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesKuoBag);
         petPanel["out_ifadd"]["no_btn"].addEventListener(MouseEvent.CLICK,noKuoBag);
         petPanel["out_sellequip"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesSell);
         petPanel["out_sellequip"]["no_btn"].addEventListener(MouseEvent.CLICK,noSell);
         petPanel["out_rmb_xg20"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesShuaXG);
         petPanel["out_rmb_xg20"]["no_btn"].addEventListener(MouseEvent.CLICK,noShuaXG);
         petPanel["out_rmb_lw20"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesShuaJN);
         petPanel["out_rmb_lw20"]["no_btn"].addEventListener(MouseEvent.CLICK,noShuaJN);
         petPanel["out_rmb_wx20"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesWX);
         petPanel["out_rmb_wx20"]["no_btn"].addEventListener(MouseEvent.CLICK,noWX);
         petPanel["out_rmb_sj20"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesSJ);
         petPanel["out_rmb_sj20"]["no_btn"].addEventListener(MouseEvent.CLICK,noSJ);
         petPanel["out_rmb15"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesFH);
         petPanel["out_rmb15"]["no_btn"].addEventListener(MouseEvent.CLICK,noFH);
         petPanel["out_rmb50"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesCAO);
         petPanel["out_rmb50"]["no_btn"].addEventListener(MouseEvent.CLICK,noCAO);
         petPanel["out_isLW"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesLW);
         petPanel["out_isLW"]["no_btn"].addEventListener(MouseEvent.CLICK,noLW);
         petPanel["out_isFS"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesFS);
         petPanel["out_isFS"]["no_btn"].addEventListener(MouseEvent.CLICK,noFS);
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            petPanel["k" + _loc1_].stop();
            petPanel["k" + _loc1_].mouseEnabled = true;
            petPanel["k" + _loc1_].mouseChildren = false;
            petPanel["k" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,listOver);
            petPanel["k" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,listOut);
            petPanel["k" + _loc1_].addEventListener(MouseEvent.CLICK,listClick);
            petPanel["cw" + _loc1_].stop();
            petPanel["xg" + _loc1_].stop();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 18)
         {
            petPanel["z" + _loc1_].mouseChildren = false;
            petPanel["z" + _loc1_].stop();
            petPanel["z" + _loc1_].addEventListener(MouseEvent.CLICK,openmenu);
            petPanel["z" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,showZB);
            petPanel["z" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,closeZB);
            _loc1_++;
         }
         petPanel["jinhua"].addEventListener(MouseEvent.CLICK,jinhua);
         petPanel["outlist2"]["chongsu"].addEventListener(MouseEvent.CLICK,chongsu);
         petPanel["outlist2"]["ronglian"].addEventListener(MouseEvent.CLICK,ronglian);
         petPanel["outlist2"]["sell"].addEventListener(MouseEvent.CLICK,sellDo);
         petPanel["outlist"]["wear"].addEventListener(MouseEvent.CLICK,wearDo);
         petPanel["outlist"]["sell"].addEventListener(MouseEvent.CLICK,sellDo);
         petPanel["pe1"].addEventListener(MouseEvent.CLICK,takeOff);
         petPanel["pe1"].addEventListener(MouseEvent.MOUSE_OVER,showOver);
         petPanel["pe1"].addEventListener(MouseEvent.MOUSE_OUT,showOut);
         petPanel["pe2"].addEventListener(MouseEvent.MOUSE_OVER,showOver2);
         petPanel["pe2"].addEventListener(MouseEvent.MOUSE_OUT,showOut2);
         petPanel["pe1"].stop();
         petPanel["pe2"].stop();
         petPanel["b1"].addEventListener(MouseEvent.CLICK,bgChange);
         petPanel["b2"].addEventListener(MouseEvent.CLICK,bgChange);
         petPanel["b3"].addEventListener(MouseEvent.CLICK,bgChange);
         petPanel["bagkc"].addEventListener(MouseEvent.CLICK,addBagSpace);
         petPanel["bagkc"].visible = false;
         petPanel["lingwu"].addEventListener(MouseEvent.CLICK,lingwu);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            petPanel["lw" + _loc1_].stop();
            petPanel["jn" + _loc1_].stop();
            petPanel["jn" + _loc1_].buttonMode = true;
            petPanel["jn" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,openTip);
            petPanel["jn" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,closeTip);
            petPanel["jn" + _loc1_].addEventListener(MouseEvent.CLICK,shuaJN);
            petPanel["jn" + _loc1_].mouseChildren = false;
            _loc1_++;
         }
         petPanel["pet_xg"].buttonMode = true;
         petPanel["pet_xg"].addEventListener(MouseEvent.CLICK,shuaXG);
         petPanel["pet_xg"].addEventListener(MouseEvent.MOUSE_OVER,openXG);
         petPanel["pet_xg"].addEventListener(MouseEvent.MOUSE_OUT,closeXG);
         petPanel["pet_xg"].stop();
         petPanel["select"].stop();
         if(Main.P1P2)
         {
            if(!myplayer)
            {
               myplayer = Main.player_1;
            }
            petPanel["p1_btn"].visible = false;
            petPanel["p2_btn"].visible = true;
            petPanel["p1_back"].visible = true;
            petPanel["p2_back"].visible = true;
            petPanel["cw_list"].visible = false;
            petPanel["p1_btn"].addEventListener(MouseEvent.CLICK,to2P);
            petPanel["p2_btn"].addEventListener(MouseEvent.CLICK,to1P);
         }
         else
         {
            if(!myplayer)
            {
               myplayer = Main.player_1;
            }
            petPanel["p1_btn"].visible = false;
            petPanel["p2_btn"].visible = false;
            petPanel["p1_back"].visible = false;
            petPanel["p2_back"].visible = false;
            petPanel["cw_list"].visible = true;
         }
         petPanel["point_txt"].text = Shop4399.moneyAll.getValue();
         showPetList();
         showPetAll();
         showPetBag();
      }
      
      private static function openmenu(param1:*) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         clickNum = int(_loc2_.name.substr(1,2));
         if(bag.getFromPetBag(clickNum + yeshu_bag * 18))
         {
            if(bag.getFromPetBag(clickNum + yeshu_bag * 18) is PetEquip)
            {
               petPanel["outlist"].visible = true;
               petPanel["outlist"].x = _loc2_.x + 20;
               petPanel["outlist"].y = _loc2_.y + 35;
               petPanel["shuxing"].visible = false;
            }
            else if(bag.getFromPetBag(clickNum + yeshu_bag * 18) is PetGem)
            {
               petPanel["outlist2"].visible = true;
               petPanel["outlist2"].x = _loc2_.x + 20;
               petPanel["outlist2"].y = _loc2_.y + 35;
               petPanel["shuxing"].visible = false;
            }
         }
      }
      
      private static function ColorX(param1:*, param2:String) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2;
         param1.setTextFormat(_loc3_);
      }
      
      private static function setColor(param1:int) : *
      {
         if(param1 == 1)
         {
            ColorX(petPanel["shuxing"]["txt1"],"0xffffff");
         }
         if(param1 == 2)
         {
            ColorX(petPanel["shuxing"]["txt1"],"0x0066ff");
         }
         if(param1 == 3)
         {
            ColorX(petPanel["shuxing"]["txt1"],"0xFF33FF");
         }
         if(param1 == 4)
         {
            ColorX(petPanel["shuxing"]["txt1"],"0xFF9900");
         }
         if(param1 == 5)
         {
            ColorX(petPanel["shuxing"]["txt1"],"0xCC3300");
         }
         if(param1 == 6)
         {
            ColorX(petPanel["shuxing"]["txt1"],"0xCC3300");
         }
      }
      
      private static function setColorXM(param1:int) : *
      {
         if(param1 == 1)
         {
            ColorX(petPanel["xuemaiSX"]["txt0"],"0xffffff");
         }
         if(param1 == 2)
         {
            ColorX(petPanel["xuemaiSX"]["txt0"],"0x0066ff");
         }
         if(param1 == 3)
         {
            ColorX(petPanel["xuemaiSX"]["txt0"],"0xFF33FF");
         }
         if(param1 == 4)
         {
            ColorX(petPanel["xuemaiSX"]["txt0"],"0xFF9900");
         }
         if(param1 == 5)
         {
            ColorX(petPanel["xuemaiSX"]["txt0"],"0xCC3300");
         }
         if(param1 == 6)
         {
            ColorX(petPanel["xuemaiSX"]["txt0"],"0xCC3300");
         }
      }
      
      private static function showZB(param1:*) : void
      {
         var _loc4_:PetGem = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:int = int(_loc2_.name.substr(1,2));
         petPanel["outlist"].visible = false;
         petPanel["outlist2"].visible = false;
         if(bag.getFromPetBag(_loc3_ + yeshu_bag * 18) is PetEquip)
         {
            petPanel["shuxing"].visible = true;
            petPanel["shuxing"]["txt1"].text = (bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetEquip).getName();
            setColor((bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetEquip).getColor());
            petPanel["shuxing"]["txt2"].text = (bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetEquip).getXinggeTxT();
            petPanel["shuxing"]["txt3"].text = (bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetEquip).getSkillDescript();
            petPanel["shuxing"]["txt4"].text = (bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetEquip).getDescript();
            petPanel["shuxing"]["txt5"].text = (bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetEquip).getPrice();
            petPanel["shuxing"].x = petPanel.mouseX - 5;
            petPanel["shuxing"].y = petPanel.mouseY;
            if(petPanel["shuxing"].y >= 320)
            {
               petPanel["shuxing"].y = 320;
            }
         }
         else if(bag.getFromPetBag(_loc3_ + yeshu_bag * 18) is PetGem)
         {
            _loc4_ = bag.getFromPetBag(_loc3_ + yeshu_bag * 18) as PetGem;
            petPanel["xuemaiCL"].visible = true;
            petPanel["xuemaiCL"]["txt0"].text = _loc4_.getName();
            setColor(_loc4_.getColor());
            if(_loc4_.isHaveSX(1))
            {
               petPanel["xuemaiCL"]["txt1"].text = "咆哮 角色攻击额外增加200点";
            }
            else if(_loc4_.isHaveSX(2))
            {
               petPanel["xuemaiCL"]["txt1"].text = "守护 角色防御额外增加100点";
            }
            else if(_loc4_.isHaveSX(3))
            {
               petPanel["xuemaiCL"]["txt1"].text = "嵐音 攻击伤害增加5%";
            }
            else if(_loc4_.isHaveSX(4))
            {
               petPanel["xuemaiCL"]["txt1"].text = "硬化 被击伤害减免5%";
            }
            else if(_loc4_.isHaveSX(5))
            {
               petPanel["xuemaiCL"]["txt1"].text = "魔溢 角色魔力额外增加400点";
            }
            else if(_loc4_.isHaveSX(6))
            {
               petPanel["xuemaiCL"]["txt1"].text = "风行 角色移动速度+1";
            }
            else if(_loc4_.isHaveSX(7))
            {
               petPanel["xuemaiCL"]["txt1"].text = "抵御 角色魔抗额外增加20点";
            }
            else if(_loc4_.isHaveSX(8))
            {
               petPanel["xuemaiCL"]["txt1"].text = "穿透 角色破魔额外增加20点";
            }
            else if(_loc4_.isHaveSX(9))
            {
               petPanel["xuemaiCL"]["txt1"].text = "感知 角色暴击额外增加300点";
            }
            else if(_loc4_.isHaveSX(10))
            {
               petPanel["xuemaiCL"]["txt1"].text = "命锁 角色生命额外增加700点";
            }
            else if(_loc4_.isHaveSX(11))
            {
               petPanel["xuemaiCL"]["txt1"].text = "圣光 角色每20秒回复500生命";
            }
            else if(_loc4_.isHaveSX(12))
            {
               petPanel["xuemaiCL"]["txt1"].text = "魔耀 角色每20秒回复200魔法";
            }
            petPanel["xuemaiCL"]["txt_d"].text = _loc4_.getDescript();
            petPanel["xuemaiCL"]["txt_g"].text = _loc4_.getPrice();
            petPanel["xuemaiCL"].x = petPanel.mouseX - 5;
            petPanel["xuemaiCL"].y = petPanel.mouseY;
            if(petPanel["xuemaiCL"].y >= 320)
            {
               petPanel["xuemaiCL"].y = 320;
            }
         }
      }
      
      private static function showDJ1(param1:*) : void
      {
         if(tempXM)
         {
            petPanel["xuemaiCL"].visible = true;
            petPanel["xuemaiCL"]["txt0"].text = tempXM.getName();
            setColor(tempXM.getColor());
            if(tempXM.isHaveSX(1))
            {
               petPanel["xuemaiCL"]["txt1"].text = "咆哮 角色攻击额外增加200点";
            }
            else if(tempXM.isHaveSX(2))
            {
               petPanel["xuemaiCL"]["txt1"].text = "守护 角色防御额外增加100点";
            }
            else if(tempXM.isHaveSX(3))
            {
               petPanel["xuemaiCL"]["txt1"].text = "嵐音 攻击伤害增加5%";
            }
            else if(tempXM.isHaveSX(4))
            {
               petPanel["xuemaiCL"]["txt1"].text = "硬化 被击伤害减免5%";
            }
            else if(tempXM.isHaveSX(5))
            {
               petPanel["xuemaiCL"]["txt1"].text = "魔溢 角色魔力额外增加400点";
            }
            else if(tempXM.isHaveSX(6))
            {
               petPanel["xuemaiCL"]["txt1"].text = "风行 角色移动速度+1";
            }
            else if(tempXM.isHaveSX(7))
            {
               petPanel["xuemaiCL"]["txt1"].text = "抵御 角色魔抗额外增加20点";
            }
            else if(tempXM.isHaveSX(8))
            {
               petPanel["xuemaiCL"]["txt1"].text = "穿透 角色破魔额外增加20点";
            }
            else if(tempXM.isHaveSX(9))
            {
               petPanel["xuemaiCL"]["txt1"].text = "感知 角色暴击额外增加300点";
            }
            else if(tempXM.isHaveSX(10))
            {
               petPanel["xuemaiCL"]["txt1"].text = "命锁 角色生命额外增加700点";
            }
            else if(tempXM.isHaveSX(11))
            {
               petPanel["xuemaiCL"]["txt1"].text = "圣光 角色每20秒回复500生命";
            }
            else if(tempXM.isHaveSX(12))
            {
               petPanel["xuemaiCL"]["txt1"].text = "魔耀 角色每20秒回复200魔法";
            }
            petPanel["xuemaiCL"]["txt_d"].text = tempXM.getDescript();
            petPanel["xuemaiCL"]["txt_g"].text = tempXM.getPrice();
            petPanel["xuemaiCL"].x = petPanel.mouseX - 5;
            petPanel["xuemaiCL"].y = petPanel.mouseY;
            if(petPanel["xuemaiCL"].y >= 320)
            {
               petPanel["xuemaiCL"].y = 320;
            }
         }
      }
      
      private static function closeZB(param1:*) : void
      {
         petPanel["xuemaiCL"].visible = false;
         petPanel["xuemaiSX"].visible = false;
         petPanel["shuxing"].visible = false;
      }
      
      private static function showOver2(param1:*) : void
      {
         petPanel["outlist"].visible = false;
         petPanel["outlist2"].visible = false;
         if(XueMai)
         {
            petPanel["xuemaiSX"].visible = true;
            petPanel["xuemaiSX"]["txt0"].text = XueMai.getName();
            setColorXM(XueMai.getColor());
            if(XueMai.isHaveSX(1))
            {
               petPanel["xuemaiSX"]["txt1"].text = "咆哮 角色攻击额外增加200点";
               ColorX(petPanel["xuemaiSX"]["txt1"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt1"].text = "咆哮 未激活";
               ColorX(petPanel["xuemaiSX"]["txt1"],"0x999999");
            }
            if(XueMai.isHaveSX(2))
            {
               petPanel["xuemaiSX"]["txt2"].text = "守护 角色防御额外增加100点";
               ColorX(petPanel["xuemaiSX"]["txt2"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt2"].text = "守护 未激活";
               ColorX(petPanel["xuemaiSX"]["txt2"],"0x999999");
            }
            if(XueMai.isHaveSX(3))
            {
               petPanel["xuemaiSX"]["txt3"].text = "嵐音 攻击伤害增加5%";
               ColorX(petPanel["xuemaiSX"]["txt3"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt3"].text = "嵐音 未激活";
               ColorX(petPanel["xuemaiSX"]["txt3"],"0x999999");
            }
            if(XueMai.isHaveSX(4))
            {
               petPanel["xuemaiSX"]["txt4"].text = "硬化 被击伤害减免5%";
               ColorX(petPanel["xuemaiSX"]["txt4"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt4"].text = "硬化 未激活";
               ColorX(petPanel["xuemaiSX"]["txt4"],"0x999999");
            }
            if(XueMai.isHaveSX(5))
            {
               petPanel["xuemaiSX"]["txt5"].text = "魔溢 角色魔力额外增加400点";
               ColorX(petPanel["xuemaiSX"]["txt5"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt5"].text = "魔溢 未激活";
               ColorX(petPanel["xuemaiSX"]["txt5"],"0x999999");
            }
            if(XueMai.isHaveSX(6))
            {
               petPanel["xuemaiSX"]["txt6"].text = "风行 角色移动速度+1";
               ColorX(petPanel["xuemaiSX"]["txt6"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt6"].text = "风行 未激活";
               ColorX(petPanel["xuemaiSX"]["txt6"],"0x999999");
            }
            if(XueMai.isHaveSX(7))
            {
               petPanel["xuemaiSX"]["txt7"].text = "抵御 角色魔抗额外增加20点";
               ColorX(petPanel["xuemaiSX"]["txt7"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt7"].text = "抵御 未激活";
               ColorX(petPanel["xuemaiSX"]["txt7"],"0x999999");
            }
            if(XueMai.isHaveSX(8))
            {
               petPanel["xuemaiSX"]["txt8"].text = "穿透 角色破魔额外增加20点";
               ColorX(petPanel["xuemaiSX"]["txt8"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt8"].text = "穿透 未激活";
               ColorX(petPanel["xuemaiSX"]["txt8"],"0x999999");
            }
            if(XueMai.isHaveSX(9))
            {
               petPanel["xuemaiSX"]["txt9"].text = "感知 角色暴击额外增加300点";
               ColorX(petPanel["xuemaiSX"]["txt9"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt9"].text = "感知 未激活";
               ColorX(petPanel["xuemaiSX"]["txt9"],"0x999999");
            }
            if(XueMai.isHaveSX(10))
            {
               petPanel["xuemaiSX"]["txt10"].text = "命锁 角色生命额外增加700点";
               ColorX(petPanel["xuemaiSX"]["txt10"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt10"].text = "命锁 未激活";
               ColorX(petPanel["xuemaiSX"]["txt10"],"0x999999");
            }
            if(XueMai.isHaveSX(11))
            {
               petPanel["xuemaiSX"]["txt11"].text = "圣光 角色每20秒回复500生命";
               ColorX(petPanel["xuemaiSX"]["txt11"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt11"].text = "圣光 未激活";
               ColorX(petPanel["xuemaiSX"]["txt11"],"0x999999");
            }
            if(XueMai.isHaveSX(12))
            {
               petPanel["xuemaiSX"]["txt12"].text = "魔耀 角色每20秒回复200魔法";
               ColorX(petPanel["xuemaiSX"]["txt12"],"0x66CCFF");
            }
            else
            {
               petPanel["xuemaiSX"]["txt12"].text = "魔耀 未激活";
               ColorX(petPanel["xuemaiSX"]["txt12"],"0x999999");
            }
            petPanel["xuemaiSX"]["txt_d"].text = XueMai.getDescript();
            petPanel["xuemaiSX"].x = petPanel.mouseX - 5;
            petPanel["xuemaiSX"].y = petPanel.mouseY;
            if(petPanel["xuemaiSX"].y >= 250)
            {
               petPanel["xuemaiSX"].y = 250;
            }
         }
      }
      
      private static function showOut2(param1:*) : void
      {
         petPanel["xuemaiSX"].visible = false;
      }
      
      private static function showOver(param1:*) : void
      {
         petPanel["outlist"].visible = false;
         petPanel["outlist2"].visible = false;
         if(Boolean(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5)) && Boolean(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip()))
         {
            petPanel["shuxing"].visible = true;
            petPanel["shuxing"]["txt1"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getName();
            setColor(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getColor());
            petPanel["shuxing"]["txt2"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getXinggeTxT();
            petPanel["shuxing"]["txt3"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getSkillDescript();
            petPanel["shuxing"]["txt4"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getDescript();
            petPanel["shuxing"]["txt5"].text = "售价:" + myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getPrice();
            petPanel["shuxing"].x = petPanel.mouseX - 5;
            petPanel["shuxing"].y = petPanel.mouseY;
            if(petPanel["shuxing"].y >= 320)
            {
               petPanel["shuxing"].y = 320;
            }
         }
      }
      
      private static function showOut(param1:*) : void
      {
         petPanel["shuxing"].visible = false;
      }
      
      private static function takeOff(param1:*) : void
      {
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip())
            {
               if(bag.backPetBagNum() > 0)
               {
                  bag.addPetBag(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip());
                  myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setPetEquip();
               }
            }
         }
         showPetBag();
         showPetAll();
      }
      
      private static function wearDo(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:PetEquip = null;
         if(Boolean(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5)) && myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getType() >= 2)
         {
            _loc2_ = (bag.getFromPetBag(clickNum + yeshu_bag * 18) as PetEquip).getXingge();
            _loc3_ = false;
            for(i in _loc2_)
            {
               if(_loc2_[i] == myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getXingge())
               {
                  _loc3_ = true;
               }
            }
            if(_loc3_)
            {
               if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip() == null)
               {
                  myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setPetEquip(bag.delPetBag(clickNum + yeshu_bag * 18));
               }
               else
               {
                  _loc4_ = bag.delPetBag(clickNum + yeshu_bag * 18);
                  bag.addPetBag(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip());
                  myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).setPetEquip(_loc4_);
               }
            }
            else
            {
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"性格不符合，无法装备");
            }
         }
         showPetBag();
         showPetAll();
         petPanel["outlist"].visible = false;
         petPanel["outlist2"].visible = false;
      }
      
      private static function chongsu(param1:*) : void
      {
         petPanel["rongluMC"].visible = true;
         petPanel["outlist2"].visible = false;
         petPanel["rongluMC"]["chongsu_btn"].visible = true;
         petPanel["rongluMC"]["ronglian_btn"].visible = false;
         petPanel["rongluMC"]["dj1"].gotoAndStop((bag.getFromPetBag(clickNum + yeshu_bag * 18) as PetGem).getFrame());
         petPanel["rongluMC"]["dj2"].gotoAndStop(1);
         tempXM = bag.getFromPetBag(clickNum + yeshu_bag * 18);
         petPanel["rongluMC"]["tm1"].addEventListener(MouseEvent.MOUSE_OVER,showDJ1);
         petPanel["rongluMC"]["tm1"].addEventListener(MouseEvent.MOUSE_OUT,closeZB);
         petPanel["rongluMC"]["tm2"].removeEventListener(MouseEvent.MOUSE_OVER,showOver2);
         petPanel["rongluMC"]["tm2"].removeEventListener(MouseEvent.MOUSE_OUT,showOut2);
         petPanel["rongluMC"]["tm2"].removeEventListener(MouseEvent.MOUSE_OVER,showDJ1);
         petPanel["rongluMC"]["tm2"].removeEventListener(MouseEvent.MOUSE_OUT,closeZB);
         showPetBag();
         petPanel["z" + clickNum].gotoAndStop(1);
      }
      
      private static function chongsuDO(param1:*) : void
      {
         petPanel["rongluMC"]["tm1"].visible = false;
         petPanel["rongluMC"]["tm2"].visible = false;
         petPanel["rongluMC"]["chongsu_btn"].visible = false;
         petPanel["rongluMC"].gotoAndPlay(2);
         petPanel.addEventListener(Event.ENTER_FRAME,showChongSuMC);
         guanbi = false;
      }
      
      private static function showChongSuMC(param1:*) : void
      {
         if(petPanel["rongluMC"].currentFrame > 12 && petPanel["rongluMC"].currentFrame < 118)
         {
            petPanel["rongluMC"]["dj1"].visible = false;
         }
         if(petPanel["rongluMC"].currentFrame == 64)
         {
            if(Math.random() * 10 > 5)
            {
               bool = true;
               tempXM.chongSuXueMai();
            }
            else
            {
               bool = false;
               bag.delPetGemBag(tempXM);
            }
            Main.Save();
         }
         if(petPanel["rongluMC"].currentFrame == 65)
         {
            petPanel["rongluMC"].stop();
         }
         if(petPanel["rongluMC"].currentFrame > 118)
         {
            petPanel["rongluMC"]["tm1"].visible = true;
            petPanel["rongluMC"]["tm2"].visible = true;
            if(bool)
            {
               petPanel["rongluMC"]["dj1"].visible = true;
               petPanel["rongluMC"]["dj2"].gotoAndStop(tempXM.getFrame());
               petPanel["rongluMC"]["dj1"].gotoAndStop(1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"重塑成功！");
               petPanel["rongluMC"]["tm2"].addEventListener(MouseEvent.MOUSE_OVER,showDJ1);
               petPanel["rongluMC"]["tm2"].addEventListener(MouseEvent.MOUSE_OUT,closeZB);
            }
            else
            {
               petPanel["rongluMC"]["dj1"].visible = true;
               petPanel["rongluMC"]["dj1"].gotoAndStop(1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"重塑失败！");
            }
            petPanel["rongluMC"]["tm1"].removeEventListener(MouseEvent.MOUSE_OVER,showDJ1);
            petPanel["rongluMC"]["tm1"].removeEventListener(MouseEvent.MOUSE_OUT,closeZB);
            guanbi = true;
            petPanel.removeEventListener(Event.ENTER_FRAME,showChongSuMC);
            showPetBag();
         }
      }
      
      private static function showRongLianMC(param1:*) : void
      {
         if(petPanel["rongluMC"].currentFrame > 12 && petPanel["rongluMC"].currentFrame < 118)
         {
            petPanel["rongluMC"]["dj1"].visible = false;
         }
         if(petPanel["rongluMC"].currentFrame == 64)
         {
            if(Math.random() * 10 > 5)
            {
               bool = true;
               XueMai.RongLianXueMai(tempXM);
            }
            else
            {
               bool = false;
            }
            bag.delPetGemBag(tempXM);
            Main.Save();
         }
         if(petPanel["rongluMC"].currentFrame == 65)
         {
            petPanel["rongluMC"].stop();
         }
         if(petPanel["rongluMC"].currentFrame > 118)
         {
            petPanel["rongluMC"]["tm1"].visible = true;
            petPanel["rongluMC"]["tm2"].visible = true;
            if(bool)
            {
               petPanel["rongluMC"]["dj1"].visible = true;
               petPanel["rongluMC"]["dj2"].gotoAndStop(XueMai.getFrame());
               petPanel["rongluMC"]["dj1"].gotoAndStop(1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"熔炼成功！获得" + XueMai.getName());
            }
            else
            {
               petPanel["rongluMC"]["dj1"].visible = true;
               petPanel["rongluMC"]["dj1"].gotoAndStop(1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"熔炼失败！");
            }
            guanbi = true;
            petPanel.removeEventListener(Event.ENTER_FRAME,showRongLianMC);
            showPetBag();
            showPetAll();
            tempXM = null;
         }
      }
      
      public static function saveShowRL() : *
      {
         if(petPanel)
         {
            if(petPanel["rongluMC"].currentFrame == 65)
            {
               petPanel["rongluMC"].gotoAndPlay(66);
            }
         }
      }
      
      private static function ronglianDO(param1:*) : void
      {
         if(XueMai.isRongLian(tempXM))
         {
            petPanel["rongluMC"]["tm1"].visible = false;
            petPanel["rongluMC"]["tm2"].visible = false;
            guanbi = false;
            petPanel["rongluMC"]["ronglian_btn"].visible = false;
            petPanel["rongluMC"].gotoAndPlay(2);
            petPanel.addEventListener(Event.ENTER_FRAME,showRongLianMC);
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"已拥有此属性，无需熔炼，可选择重塑新属性");
         }
      }
      
      private static function closeRL(param1:*) : void
      {
         if(guanbi == true)
         {
            petPanel["rongluMC"].visible = false;
            showPetBag();
         }
      }
      
      private static function ronglian(param1:*) : void
      {
         petPanel["rongluMC"].visible = true;
         petPanel["outlist2"].visible = false;
         petPanel["rongluMC"]["chongsu_btn"].visible = false;
         petPanel["rongluMC"]["ronglian_btn"].visible = true;
         petPanel["rongluMC"]["dj1"].gotoAndStop((bag.getFromPetBag(clickNum + yeshu_bag * 18) as PetGem).getFrame());
         petPanel["rongluMC"]["dj2"].gotoAndStop(XueMai.getFrame());
         tempXM = bag.getFromPetBag(clickNum + yeshu_bag * 18);
         showPetBag();
         petPanel["rongluMC"]["tm2"].removeEventListener(MouseEvent.MOUSE_OVER,showDJ1);
         petPanel["rongluMC"]["tm2"].removeEventListener(MouseEvent.MOUSE_OUT,closeZB);
         petPanel["rongluMC"]["tm1"].addEventListener(MouseEvent.MOUSE_OVER,showDJ1);
         petPanel["rongluMC"]["tm1"].addEventListener(MouseEvent.MOUSE_OUT,closeZB);
         petPanel["rongluMC"]["tm2"].addEventListener(MouseEvent.MOUSE_OVER,showOver2);
         petPanel["rongluMC"]["tm2"].addEventListener(MouseEvent.MOUSE_OUT,showOut2);
         petPanel["z" + clickNum].gotoAndStop(1);
      }
      
      private static function sellDo(param1:*) : void
      {
         petPanel["out_sellequip"].visible = true;
         petPanel["outlist"].visible = false;
         petPanel["outlist2"].visible = false;
      }
      
      private static function yesSell(param1:*) : void
      {
         var _loc2_:PetEquip = null;
         var _loc3_:PetGem = null;
         if(bag.getFromPetBag(clickNum + yeshu_bag * 18) is PetEquip)
         {
            _loc2_ = bag.delPetBag(clickNum + yeshu_bag * 18);
            myplayer.data.addGold(_loc2_.getPrice());
         }
         else if(bag.getFromPetBag(clickNum + yeshu_bag * 18) is PetGem)
         {
            _loc3_ = bag.delPetBag(clickNum + yeshu_bag * 18);
            myplayer.data.addGold(_loc3_.getPrice());
         }
         showPetBag();
         petPanel["out_sellequip"].visible = false;
      }
      
      private static function noSell(param1:*) : void
      {
         petPanel["out_sellequip"].visible = false;
      }
      
      public static function listOver(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(int(_loc2_.name.substr(1,1)));
         if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_ + (yeshu - 1) * 5))
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_ + (yeshu - 1) * 5).getType() == 3)
            {
               petPanel["cwtip"]["str_text"].text = "该宠物已完全进化";
            }
            if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_ + (yeshu - 1) * 5).getType() == 2 && myplayer.data.getPetSlot().getPetFromSlot(_loc3_ + (yeshu - 1) * 5).getEvolutionLV() == 20)
            {
               petPanel["cwtip"]["str_text"].text = "该宠物可以进化";
            }
            if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_ + (yeshu - 1) * 5).getType() == 2 && myplayer.data.getPetSlot().getPetFromSlot(_loc3_ + (yeshu - 1) * 5).getEvolutionLV() == -1)
            {
               petPanel["cwtip"]["str_text"].text = "该宠物暂不能进化";
            }
            petPanel["cwtip"].visible = true;
            petPanel["cwtip"].x = petPanel.mouseX + 10;
            petPanel["cwtip"].y = petPanel.mouseY;
         }
         _loc2_.gotoAndStop(2);
      }
      
      public static function listOut(param1:*) : *
      {
         petPanel["cwtip"].visible = false;
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(int(_loc2_.name.substr(1,1)));
         if(_loc3_ == chosed)
         {
            _loc2_.gotoAndStop(3);
         }
         else
         {
            _loc2_.gotoAndStop(1);
         }
      }
      
      public static function listClick(param1:*) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:uint = uint(int(_loc2_.name.substr(1,1)));
         chosed = _loc3_;
         var _loc4_:uint = 0;
         while(_loc4_ < 5)
         {
            petPanel["k" + _loc4_].gotoAndStop(1);
            _loc4_++;
         }
         _loc2_.gotoAndStop(3);
         showPetAll();
         if(chosed + (yeshu - 1) * 5 >= myplayer.data.getPetSlot().getPetSlotNum())
         {
            petPanel["out_rmb50"].visible = true;
         }
      }
      
      public static function bgChange(param1:*) : *
      {
         var _loc2_:SimpleButton = param1.target as SimpleButton;
         var _loc3_:uint = uint(int(_loc2_.name.substr(1,1)));
         if(_loc3_ == 1)
         {
            yeshu_bag = 0;
            petPanel["b1"].visible = false;
            petPanel["b2"].visible = true;
            petPanel["b3"].visible = true;
            petPanel["bagkc"].visible = false;
            petPanel["outlist"].visible = false;
            petPanel["outlist2"].visible = false;
         }
         if(_loc3_ == 2)
         {
            yeshu_bag = 1;
            petPanel["b1"].visible = true;
            petPanel["b2"].visible = false;
            petPanel["b3"].visible = true;
            petPanel["outlist"].visible = false;
            petPanel["outlist2"].visible = false;
            if(bag.getLimit() <= 18)
            {
               petPanel["bagkc"].visible = true;
            }
            else
            {
               petPanel["bagkc"].visible = false;
            }
         }
         if(_loc3_ == 3)
         {
            yeshu_bag = 2;
            petPanel["b1"].visible = true;
            petPanel["b2"].visible = true;
            petPanel["b3"].visible = false;
            petPanel["outlist"].visible = false;
            petPanel["outlist2"].visible = false;
            if(bag.getLimit() <= 36)
            {
               petPanel["bagkc"].visible = true;
            }
            else
            {
               petPanel["bagkc"].visible = false;
            }
         }
         showPetBag();
      }
      
      public static function to2P(param1:*) : *
      {
         myplayer = Main.player_1;
         petPanel["p1_btn"].visible = false;
         petPanel["p2_btn"].visible = true;
         petPanel["p1_back"].visible = true;
         petPanel["p2_back"].visible = true;
         showPetList();
         showPetAll();
      }
      
      public static function to1P(param1:*) : *
      {
         myplayer = Main.player_2;
         petPanel["p1_btn"].visible = true;
         petPanel["p2_btn"].visible = false;
         petPanel["p1_back"].visible = true;
         petPanel["p2_back"].visible = true;
         showPetList();
         showPetAll();
      }
      
      public static function showPetList() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            petPanel["k" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         petPanel["k" + chosed].gotoAndStop(3);
         petPanel["yeshu_txt"].text = yeshu + "/3";
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ + (yeshu - 1) * 5 >= myplayer.data.getPetSlot().getPetSlotNum())
            {
               petPanel["cw" + _loc1_].gotoAndStop(1);
               petPanel["xg" + _loc1_].visible = false;
            }
            else if(myplayer.data.getPetSlot().getPetFromSlot(_loc1_ + (yeshu - 1) * 5))
            {
               petPanel["cw" + _loc1_].gotoAndStop(myplayer.data.getPetSlot().getPetFromSlot(_loc1_ + (yeshu - 1) * 5).getFrame());
               petPanel["xg" + _loc1_].gotoAndStop(myplayer.data.getPetSlot().getPetFromSlot(_loc1_ + (yeshu - 1) * 5).getXingge());
               petPanel["xg" + _loc1_].visible = true;
               if(myplayer.data.getPetSlot().getPetFromSlot(_loc1_ + (yeshu - 1) * 5).getType() == 1)
               {
                  petPanel["xg" + _loc1_].visible = false;
               }
            }
            else
            {
               petPanel["cw" + _loc1_].gotoAndStop(2);
               petPanel["xg" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private static function timeFunction(param1:*) : void
      {
         var _loc2_:Pet = null;
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            _loc2_ = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5);
            if(_loc2_.getType() == 1)
            {
               petPanel["time_txt"].text = "孵化剩余时间:" + int(_loc2_.time_fh / 60) + "分" + _loc2_.time_fh % 60 + "秒";
            }
            else
            {
               petPanel["time_txt"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getName();
            }
         }
         else
         {
            petPanel["time_txt"].text = "";
         }
         var _loc3_:uint = 0;
         while(_loc3_ < myplayer.data.getPetSlot().getPetSlotNum())
         {
            if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_))
            {
               if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_).getType() == 1)
               {
                  ++temp;
                  if(temp >= 27)
                  {
                     --myplayer.data.getPetSlot().getPetFromSlot(_loc3_).time_fh;
                     temp = 0;
                     if(myplayer.data.getPetSlot().getPetFromSlot(_loc3_).time_fh <= 0)
                     {
                        myplayer.data.getPetSlot().addPetSlot(PetFactory.creatPet(myplayer.data.getPetSlot().delPetSlot(_loc3_).getLink()));
                        showPetList();
                     }
                  }
               }
            }
            _loc3_++;
         }
         ++tempFood;
         if(tempFood % 1134 == 0)
         {
            if(Main.player1.playerCW_Data)
            {
               if(Boolean(Main.player_1.playerCW.goEnemy) && Main.gameNum.getValue() != 0)
               {
                  Main.player1.playerCW_Data.setFood(-5);
               }
               else
               {
                  Main.player1.playerCW_Data.setFood(-1);
               }
               if(Main.player1.playerCW_Data.getFood() <= 0)
               {
                  Main.player_1.playerCW.Close();
               }
            }
            if(Boolean(Main.P1P2) && Boolean(Main.player2.playerCW_Data))
            {
               if(Boolean(Main.player_2.playerCW.goEnemy) && Main.gameNum.getValue() != 0)
               {
                  Main.player2.playerCW_Data.setFood(-5);
               }
               else
               {
                  Main.player2.playerCW_Data.setFood(-1);
               }
               if(Main.player2.playerCW_Data.getFood() <= 0)
               {
                  Main.player_2.playerCW.Close();
               }
            }
            if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
            {
               petPanel["food"].text = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getFood() + "/500";
            }
         }
      }
      
      public static function showPetBag() : *
      {
         var _loc2_:int = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 18)
         {
            _loc2_ = _loc1_ + yeshu_bag * 18;
            if(bag.getFromPetBag(_loc2_))
            {
               if(bag.getFromPetBag(_loc2_) is PetEquip)
               {
                  petPanel["z" + _loc1_].gotoAndStop((bag.getFromPetBag(_loc2_) as PetEquip).getFrame());
               }
               if(bag.getFromPetBag(_loc2_) is PetGem)
               {
                  petPanel["z" + _loc1_].gotoAndStop((bag.getFromPetBag(_loc2_) as PetGem).getFrame());
               }
            }
            else
            {
               petPanel["z" + _loc1_].gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      public static function showPetAll() : *
      {
         var _loc1_:Pet = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5))
         {
            _loc1_ = myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5);
            if(_loc1_.getType() >= 2)
            {
               petPanel["ljfh"].visible = false;
               petPanel["setFood"].visible = true;
               petPanel["time_txt"].visible = false;
               petPanel["zhaohuan"].visible = true;
               petPanel["zhaohui"].visible = true;
               if(myplayer.playerCW)
               {
                  if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5) == myplayer.playerCW.data)
                  {
                     if(myplayer.playerCW.goEnemy)
                     {
                        petPanel["gensui"].visible = true;
                        petPanel["zhudong"].visible = false;
                     }
                     else
                     {
                        petPanel["gensui"].visible = false;
                        petPanel["zhudong"].visible = true;
                     }
                  }
                  else
                  {
                     petPanel["gensui"].visible = false;
                     petPanel["zhudong"].visible = false;
                  }
               }
               else
               {
                  petPanel["gensui"].visible = false;
                  petPanel["zhudong"].visible = false;
               }
               if(_loc1_.getLv() < _loc1_.getLvLimit())
               {
                  petPanel["kssj"].visible = true;
               }
               else
               {
                  petPanel["kssj"].visible = false;
               }
               petPanel["fangsheng"].visible = true;
               if(Main.P1P2)
               {
                  if(_loc1_ == Main.player1.playerCW_Data || _loc1_ == Main.player2.playerCW_Data)
                  {
                     petPanel["zhaohuan"].visible = false;
                  }
                  else
                  {
                     petPanel["zhaohuan"].visible = true;
                  }
               }
               else if(_loc1_ == Main.player1.playerCW_Data)
               {
                  petPanel["zhaohuan"].visible = false;
               }
               else
               {
                  petPanel["zhaohuan"].visible = true;
               }
               petPanel["lw0"].visible = false;
               petPanel["lw1"].visible = false;
               petPanel["lw2"].visible = false;
               petPanel["lw3"].visible = false;
               if(_loc1_.getWX() > 0)
               {
                  petPanel["lingwu"].visible = true;
                  _loc2_ = _loc1_.getPetSkill();
                  for(_loc3_ in _loc2_)
                  {
                     if(_loc2_[_loc3_] == 0)
                     {
                        petPanel["xueJN_mc"].visible = true;
                        petPanel["lw" + _loc3_].visible = true;
                     }
                     else
                     {
                        petPanel["xueJN_mc"].visible = false;
                        petPanel["lw" + _loc3_].visible = false;
                     }
                     if(_loc2_[_loc3_] > 0)
                     {
                        petPanel["jn" + _loc3_].visible = true;
                        petPanel["jn" + _loc3_].gotoAndStop(SkillFactory.getSkillById(_loc2_[_loc3_]).getFrame());
                     }
                     else
                     {
                        petPanel["jn" + _loc3_].gotoAndStop(1);
                     }
                  }
                  if(_loc2_[3] > 0)
                  {
                     petPanel["lingwu"].visible = false;
                  }
               }
               else
               {
                  _loc3_ = 0;
                  while(_loc3_ < 4)
                  {
                     petPanel["jn" + _loc3_].gotoAndStop(1);
                     _loc3_++;
                  }
                  petPanel["lingwu"].visible = false;
                  petPanel["gensui"].visible = false;
                  petPanel["zhudong"].visible = false;
               }
               if(_loc1_.getWX() > 0 && _loc1_.getWX() < 4)
               {
                  petPanel["sxwx"].visible = true;
               }
               else
               {
                  petPanel["sxwx"].visible = false;
               }
               petPanel["xgkey"].text = "x" + XGkey.getValue();
               petPanel["name_txt"].text = "LV:" + _loc1_.getLv() + " " + _loc1_.getName();
               petPanel["food"].text = _loc1_.getFood() + "/500";
               petPanel["wx_txt"].text = _loc1_.getWX();
               petPanel["lv_txt"].text = _loc1_.getLv() + "/" + _loc1_.getLvLimit();
               petPanel["exp"].text = _loc1_.getExp() + "/" + PetFactory.all_LVData_vt[_loc1_.getLv()].getValue();
               petPanel["txt_att"].text = "为玩家增加攻击力" + (_loc1_.getAtt() * 100).toFixed(2) + "%";
               petPanel["txt_def"].text = "为玩家增加防御力" + (_loc1_.getDef() * 100).toFixed(2) + "%";
               petPanel["txt_crit"].text = "为玩家增加暴击率" + (_loc1_.getCrit() * 100).toFixed(2) + "%";
               petPanel["txt_life"].text = "为玩家增加血量" + (_loc1_.getLife() * 100).toFixed(2) + "%";
               petPanel["pet_xg"].visible = true;
               petPanel["pet_xg"].gotoAndStop(_loc1_.getXingge());
               petPanel["select"].gotoAndStop(_loc1_.getFrame());
               petPanel["pe2"].gotoAndStop(XueMai.getFrame());
               if(_loc1_.getLvLimit() >= 30)
               {
                  petPanel["tscz"].visible = false;
               }
               else
               {
                  petPanel["tscz"].visible = true;
               }
               if(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip())
               {
                  petPanel["pe1"].gotoAndStop(myplayer.data.getPetSlot().getPetFromSlot(chosed + (yeshu - 1) * 5).getPetEquip().getFrame());
               }
               else
               {
                  petPanel["pe1"].gotoAndStop(1);
               }
               if(_loc1_.getEvolutionLV() != -1 && _loc1_.getLv() >= _loc1_.getEvolutionLV())
               {
                  petPanel["jinhua"].visible = true;
               }
               else
               {
                  petPanel["jinhua"].visible = false;
               }
            }
            else
            {
               petPanel["name_txt"].text = "LV:" + _loc1_.getLv() + " " + _loc1_.getName();
               petPanel["select"].gotoAndStop(_loc1_.getFrame());
               petPanel["pet_xg"].visible = false;
               petPanel["ljfh"].visible = true;
               petPanel["gensui"].visible = false;
               petPanel["zhudong"].visible = false;
               petPanel["setFood"].visible = false;
               petPanel["time_txt"].visible = true;
               petPanel["zhaohuan"].visible = false;
               petPanel["zhaohui"].visible = false;
               petPanel["kssj"].visible = false;
               petPanel["fangsheng"].visible = true;
               petPanel["lingwu"].visible = false;
               petPanel["jinhua"].visible = false;
               petPanel["food"].text = "未知";
               petPanel["lv_txt"].text = "未知";
               petPanel["wx_txt"].text = "未知";
               petPanel["exp"].text = "未知";
               petPanel["txt_att"].text = "未知";
               petPanel["txt_def"].text = "未知";
               petPanel["txt_crit"].text = "未知";
               petPanel["txt_life"].text = "未知";
               petPanel["setFood"].visible = false;
               petPanel["kssj"].visible = false;
               petPanel["sxwx"].visible = false;
               petPanel["tscz"].visible = false;
               petPanel["lw0"].visible = false;
               petPanel["lw1"].visible = false;
               petPanel["lw2"].visible = false;
               petPanel["lw3"].visible = false;
               petPanel["jn0"].gotoAndStop(1);
               petPanel["jn1"].gotoAndStop(1);
               petPanel["jn2"].gotoAndStop(1);
               petPanel["jn3"].gotoAndStop(1);
               petPanel["pe1"].gotoAndStop(1);
               petPanel["pe2"].gotoAndStop(XueMai.getFrame());
            }
         }
         else
         {
            petPanel["jinhua"].visible = false;
            petPanel["food"].text = "未知";
            petPanel["lv_txt"].text = "未知";
            petPanel["wx_txt"].text = "未知";
            petPanel["exp"].text = "未知";
            petPanel["txt_att"].text = "未知";
            petPanel["txt_def"].text = "未知";
            petPanel["txt_crit"].text = "未知";
            petPanel["txt_life"].text = "未知";
            petPanel["name_txt"].text = "";
            petPanel["setFood"].visible = false;
            petPanel["kssj"].visible = false;
            petPanel["sxwx"].visible = false;
            petPanel["tscz"].visible = false;
            petPanel["ljfh"].visible = false;
            petPanel["zhaohui"].visible = false;
            petPanel["zhaohuan"].visible = false;
            petPanel["gensui"].visible = false;
            petPanel["zhudong"].visible = false;
            petPanel["fangsheng"].visible = false;
            petPanel["lingwu"].visible = false;
            petPanel["pet_xg"].visible = false;
            petPanel["lw0"].visible = false;
            petPanel["lw1"].visible = false;
            petPanel["lw2"].visible = false;
            petPanel["lw3"].visible = false;
            petPanel["jn0"].gotoAndStop(1);
            petPanel["jn1"].gotoAndStop(1);
            petPanel["jn2"].gotoAndStop(1);
            petPanel["jn3"].gotoAndStop(1);
            petPanel["select"].gotoAndStop(1);
            petPanel["pe1"].gotoAndStop(1);
            petPanel["pe2"].gotoAndStop(XueMai.getFrame());
         }
      }
   }
}

