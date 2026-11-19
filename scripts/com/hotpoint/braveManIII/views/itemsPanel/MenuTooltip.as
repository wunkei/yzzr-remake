package com.hotpoint.braveManIII.views.itemsPanel
{
   import com.hotpoint.braveManIII.events.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.models.gem.Gem;
   import com.hotpoint.braveManIII.models.other.Otherobj;
   import com.hotpoint.braveManIII.models.supplies.Supplies;
   import com.hotpoint.braveManIII.repository.elves.*;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.pet.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.repository.title.*;
   import com.hotpoint.braveManIII.views.composePanel.*;
   import com.hotpoint.braveManIII.views.makePanel.*;
   import com.hotpoint.braveManIII.views.strPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   import src.tool.*;
   
   public class MenuTooltip extends MovieClip
   {
      
      public static var selectType:uint;
      
      public static var oldNum:uint;
      
      public static var colorNum:uint;
      
      public static var whichDo:uint;
      
      public static var cwOK:Boolean = false;
      
      public static var cwOK_2:Boolean = false;
      
      public static var moneyOK:Boolean = false;
      
      public static var moneyOK2:Boolean = false;
      
      private static var menuTooltip:MovieClip = new MenuShow();
      
      private static var timetemp:int = 0;
      
      private var su:Supplies;
      
      private var amount:VT = VT.createVT(1);
      
      private var equipSlot:EquipSlot = new EquipSlot();
      
      private var skillSlot:EquipSkillSlot = new EquipSkillSlot();
      
      public function MenuTooltip()
      {
         super();
      }
      
      public static function lijifuhua() : *
      {
         var _loc1_:int = 0;
         if(moneyOK)
         {
            _loc1_ = int(ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum).getValue_1());
            ItemsPanel.myplayer.data.getPetSlot().addPetSlot(PetFactory.creatPet(PetFactory.creatPet(_loc1_).getLink()));
            BagItemsShow.otherobjShow();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"孵化成功！新宠物已加入宠物栏");
            menuTooltip["menu_9"]["fuhuaNow"].visible = true;
            moneyOK = false;
         }
      }
      
      public static function isFJ(param1:MouseEvent) : *
      {
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getDressLevel() >= 50)
         {
            if(selectType == 1)
            {
               if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor() <= 3)
               {
                  doFenJie();
                  ItemsPanel.myplayer.data.getBag().delEquip(oldNum);
               }
               else
               {
                  ItemsPanel.itemsPanel["isFenJie"].visible = true;
                  ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isFenJie"]);
                  ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["mouseFJ"]);
               }
               BagItemsShow.equipShow();
               BagItemsShow.informationShow();
               JiHua_Interface.ppp3_14 = true;
            }
         }
         else
         {
            NewMC.Open("文字提示",ItemsPanel.itemsPanel,400,400,30,0,true,2,"装备等级不足50级");
         }
      }
      
      public static function heChengOpen(param1:MouseEvent) : *
      {
         ComPosePanel.open();
      }
      
      public static function qiangHuaOpen(param1:MouseEvent) : *
      {
         StrPanel.open();
      }
      
      public static function xiLianOpen(param1:MouseEvent) : *
      {
         xilianPanel.open(true);
      }
      
      public static function xiangQianOpen(param1:MouseEvent) : *
      {
         XiangQianPanel.open();
      }
      
      private static function ColorX(param1:*, param2:String) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2;
         param1.setTextFormat(_loc3_);
      }
      
      private static function jianbian(param1:*) : *
      {
         ++timetemp;
         ItemsPanel.itemsPanel["getFJ"].alpha -= 0.02;
         if(timetemp > 50)
         {
            ItemsPanel.itemsPanel["getFJ"].visible = false;
            ItemsPanel.itemsPanel.removeEventListener(Event.ENTER_FRAME,jianbian);
         }
      }
      
      private static function showPicAndNum(param1:Otherobj, param2:int) : *
      {
         timetemp = 0;
         ItemsPanel.itemsPanel["getFJ"].alpha = 1;
         ItemsPanel.itemsPanel["getFJ"].visible = true;
         ItemsPanel.itemsPanel.addEventListener(Event.ENTER_FRAME,jianbian);
         ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["getFJ"]);
         ItemsPanel.itemsPanel["getFJ"]["showPic"].gotoAndStop(param1.getFrame());
         ItemsPanel.itemsPanel["getFJ"]["showPic"]["t_txt"].text = param2;
      }
      
      private static function getColor1() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = Math.random() * 4;
         switch(_loc2_)
         {
            case 0:
               _loc1_ = 0;
               while(_loc1_ < 3)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63132.getValue()));
                  _loc1_++;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63132.getValue()),3);
               break;
            case 1:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63133.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63133.getValue()),1);
               break;
            case 2:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63134.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63134.getValue()),1);
               break;
            case 3:
               _loc1_ = 0;
               while(_loc1_ < 3)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63135.getValue()));
                  _loc1_++;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63135.getValue()),3);
         }
      }
      
      private static function getColor2() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = Math.random() * 4;
         switch(_loc2_)
         {
            case 0:
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63132.getValue()));
                  _loc1_++;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63132.getValue()),6);
               break;
            case 1:
               _loc1_ = 0;
               while(_loc1_ < 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63133.getValue()));
                  _loc1_++;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63133.getValue()),2);
               break;
            case 2:
               _loc1_ = 0;
               while(_loc1_ < 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63134.getValue()));
                  _loc1_++;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63134.getValue()),2);
               break;
            case 3:
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63135.getValue()));
                  _loc1_++;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63135.getValue()),6);
         }
      }
      
      private static function getColor3() : *
      {
         var _loc1_:int = Math.random() * 4;
         switch(_loc1_)
         {
            case 0:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63133.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63133.getValue()),1);
               break;
            case 1:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63134.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63134.getValue()),1);
               break;
            case 2:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63136.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63136.getValue()),1);
               break;
            case 3:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63137.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63137.getValue()),1);
         }
      }
      
      private static function getColor4() : *
      {
         var _loc1_:int = Math.random() * 3;
         switch(_loc1_)
         {
            case 0:
               i = 0;
               while(i < 15)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63136.getValue()));
                  ++i;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63136.getValue()),15);
               break;
            case 1:
               i = 0;
               while(i < 15)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63137.getValue()));
                  ++i;
               }
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63137.getValue()),15);
               break;
            case 2:
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63138.getValue()));
               showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63138.getValue()),1);
         }
      }
      
      private static function getColor6() : *
      {
         ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.BuyNum_63138.getValue()));
         showPicAndNum(OtherFactory.creatOther(InitData.BuyNum_63138.getValue()),1);
      }
      
      public static function doFenJie() : *
      {
         switch(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor())
         {
            case 1:
               getColor1();
               break;
            case 2:
               getColor2();
               break;
            case 3:
               getColor3();
               break;
            case 4:
               getColor4();
               break;
            case 5:
               getColor4();
               break;
            case 6:
               getColor6();
         }
      }
      
      public static function xufeiRMB() : *
      {
         if(moneyOK2)
         {
            ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(oldNum).setRemainingTimeNow();
            ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(oldNum).setSysTime(Main.serverTime);
            ItemsPanel.open();
            moneyOK2 = false;
         }
      }
      
      public static function getChongWu() : *
      {
         var _loc1_:int = 0;
         if(cwOK)
         {
            _loc1_ = int(Math.random() * 12);
            if(_loc1_ == 0)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63150));
            }
            else if(_loc1_ == 1)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
            }
            else if(_loc1_ == 2)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
            }
            else if(_loc1_ == 3)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
            }
            else if(_loc1_ == 4)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63237));
            }
            else if(_loc1_ == 5)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63237));
            }
            else if(_loc1_ == 6)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
            }
            else if(_loc1_ == 7)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
            }
            else if(_loc1_ == 8)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63267));
            }
            else if(_loc1_ == 9)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63271));
            }
            else if(_loc1_ == 10)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63271));
            }
            else if(_loc1_ == 11)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63271));
            }
            BagItemsShow.otherobjShow();
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得宠物蛋");
            cwOK = false;
         }
      }
      
      public static function getChongWu2() : *
      {
         var _loc1_:int = 0;
         if(cwOK_2)
         {
            _loc1_ = int(Math.random() * 5);
            if(_loc1_ == 0)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63266));
            }
            else if(_loc1_ == 1)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63267));
            }
            else if(_loc1_ == 2)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63251));
            }
            else if(_loc1_ == 3)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63280));
            }
            else if(_loc1_ == 4)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63291));
            }
            BagItemsShow.otherobjShow();
            ItemsPanel.itemsPanel["touming"].visible = false;
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得宠物蛋");
            cwOK_2 = false;
         }
      }
      
      public function addListener() : *
      {
         this.addChild(menuTooltip);
         this.visible = false;
         ItemsPanel.itemsPanel["fhRMB"].visible = false;
         ItemsPanel.itemsPanel["xfRMB"].visible = false;
         ItemsPanel.itemsPanel["xfRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesXF);
         ItemsPanel.itemsPanel["xfRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,noXF);
         ItemsPanel.itemsPanel["xfRMB"]["no2_btn"].addEventListener(MouseEvent.CLICK,noXF);
         ItemsPanel.itemsPanel["fhRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesFH);
         ItemsPanel.itemsPanel["fhRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,noFH);
         ItemsPanel.itemsPanel["fhRMB"]["no2_btn"].addEventListener(MouseEvent.CLICK,noFH);
         ItemsPanel.itemsPanel["isFenJie"]["yesFJ"].addEventListener(MouseEvent.CLICK,yesFJ);
         ItemsPanel.itemsPanel["isFenJie"]["noFJ"].addEventListener(MouseEvent.CLICK,noFJ);
         ItemsPanel.itemsPanel["isFenJie"]["no2FJ"].addEventListener(MouseEvent.CLICK,noFJ);
         ItemsPanel.itemsPanel.addEventListener(BtnEvent.DO_CLICK,btnListen);
         ItemsPanel.itemsPanel["sellMenu"]["showPic"].addEventListener(MouseEvent.MOUSE_OVER,tipOpen);
         ItemsPanel.itemsPanel["sellMenu"]["showPic"].addEventListener(MouseEvent.MOUSE_OUT,tipClose);
         menuTooltip["menu_1"]["off_btn"].addEventListener(MouseEvent.CLICK,takeOff);
         menuTooltip["menu_11"]["ychh_btn"].addEventListener(MouseEvent.CLICK,ychh);
         menuTooltip["menu_12"]["xshh_btn"].addEventListener(MouseEvent.CLICK,xshh);
         menuTooltip["menu_2"]["wear_btn"].addEventListener(MouseEvent.CLICK,wear);
         menuTooltip["menu_2"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_2"]["all_Sell"].addEventListener(MouseEvent.CLICK,allSell);
         menuTooltip["menu_2"]["openHeCheng"].addEventListener(MouseEvent.CLICK,heChengOpen);
         menuTooltip["menu_2"]["openQiangHua"].addEventListener(MouseEvent.CLICK,qiangHuaOpen);
         menuTooltip["menu_2"]["openXiLian"].addEventListener(MouseEvent.CLICK,xiLianOpen);
         menuTooltip["menu_2"]["openXiangQian"].addEventListener(MouseEvent.CLICK,xiangQianOpen);
         menuTooltip["menu_3"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_3"]["key_btn1"].addEventListener(MouseEvent.CLICK,setKey_1);
         menuTooltip["menu_3"]["key_btn2"].addEventListener(MouseEvent.CLICK,setKey_2);
         menuTooltip["menu_3"]["key_btn3"].addEventListener(MouseEvent.CLICK,setKey_3);
         menuTooltip["menu_4"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_5"]["left_btn"].addEventListener(MouseEvent.CLICK,leftInto);
         menuTooltip["menu_5"]["right_btn"].addEventListener(MouseEvent.CLICK,rightInto);
         menuTooltip["menu_5"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_6"]["free_btn"].addEventListener(MouseEvent.CLICK,setFree);
         menuTooltip["menu_7"]["use_btn"].addEventListener(MouseEvent.CLICK,useOther);
         menuTooltip["menu_7"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_8"]["use_btn"].addEventListener(MouseEvent.CLICK,useOther);
         menuTooltip["menu_8"]["alluse_btn"].addEventListener(MouseEvent.CLICK,alluseOther);
         menuTooltip["menu_8"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_9"]["fuhua"].addEventListener(MouseEvent.CLICK,fuhua);
         menuTooltip["menu_9"]["fuhuaNow"].addEventListener(MouseEvent.CLICK,fuhuaNow);
         menuTooltip["menu_9"]["sell_btn"].addEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_10"]["xf_btn"].addEventListener(MouseEvent.CLICK,xufei);
         menuTooltip["menu_10"]["yc_btn"].addEventListener(MouseEvent.CLICK,yincang);
         menuTooltip["menu_10"]["xs_btn"].addEventListener(MouseEvent.CLICK,xianshi);
         menuTooltip["menu_10"]["off_btn"].addEventListener(MouseEvent.CLICK,takeOff);
      }
      
      public function removeListener() : *
      {
         ItemsPanel.itemsPanel["xfRMB"]["yes_btn"].addEventListener(MouseEvent.CLICK,yesXF);
         ItemsPanel.itemsPanel["xfRMB"]["no_btn"].addEventListener(MouseEvent.CLICK,noXF);
         ItemsPanel.itemsPanel["fhRMB"]["yes_btn"].removeEventListener(MouseEvent.CLICK,yesFH);
         ItemsPanel.itemsPanel["fhRMB"]["no_btn"].removeEventListener(MouseEvent.CLICK,noFH);
         ItemsPanel.itemsPanel["isFenJie"]["yesFJ"].removeEventListener(MouseEvent.CLICK,yesFJ);
         ItemsPanel.itemsPanel["isFenJie"]["noFJ"].removeEventListener(MouseEvent.CLICK,noFJ);
         ItemsPanel.itemsPanel.removeEventListener(BtnEvent.DO_CLICK,btnListen);
         ItemsPanel.itemsPanel["sellMenu"]["showPic"].removeEventListener(MouseEvent.MOUSE_OVER,tipOpen);
         ItemsPanel.itemsPanel["sellMenu"]["showPic"].removeEventListener(MouseEvent.MOUSE_OUT,tipClose);
         menuTooltip["menu_1"]["off_btn"].removeEventListener(MouseEvent.CLICK,takeOff);
         menuTooltip["menu_11"]["ychh_btn"].removeEventListener(MouseEvent.CLICK,ychh);
         menuTooltip["menu_12"]["xshh_btn"].removeEventListener(MouseEvent.CLICK,xshh);
         menuTooltip["menu_2"]["wear_btn"].removeEventListener(MouseEvent.CLICK,wear);
         menuTooltip["menu_2"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_2"]["all_Sell"].removeEventListener(MouseEvent.CLICK,allSell);
         menuTooltip["menu_2"]["openHeCheng"].removeEventListener(MouseEvent.CLICK,heChengOpen);
         menuTooltip["menu_2"]["openQiangHua"].removeEventListener(MouseEvent.CLICK,qiangHuaOpen);
         menuTooltip["menu_2"]["openXiLian"].removeEventListener(MouseEvent.CLICK,xiLianOpen);
         menuTooltip["menu_2"]["openXiangQian"].removeEventListener(MouseEvent.CLICK,xiangQianOpen);
         menuTooltip["menu_3"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_3"]["key_btn1"].removeEventListener(MouseEvent.CLICK,setKey_1);
         menuTooltip["menu_3"]["key_btn2"].removeEventListener(MouseEvent.CLICK,setKey_2);
         menuTooltip["menu_3"]["key_btn3"].removeEventListener(MouseEvent.CLICK,setKey_3);
         menuTooltip["menu_4"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_5"]["left_btn"].removeEventListener(MouseEvent.CLICK,leftInto);
         menuTooltip["menu_5"]["right_btn"].removeEventListener(MouseEvent.CLICK,rightInto);
         menuTooltip["menu_5"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_6"]["free_btn"].removeEventListener(MouseEvent.CLICK,setFree);
         menuTooltip["menu_7"]["use_btn"].removeEventListener(MouseEvent.CLICK,useOther);
         menuTooltip["menu_7"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_8"]["use_btn"].removeEventListener(MouseEvent.CLICK,useOther);
         menuTooltip["menu_8"]["alluse_btn"].removeEventListener(MouseEvent.CLICK,alluseOther);
         menuTooltip["menu_8"]["sell_btn"].removeEventListener(MouseEvent.CLICK,sell);
         menuTooltip["menu_9"]["fuhua"].removeEventListener(MouseEvent.CLICK,fuhua);
         menuTooltip["menu_9"]["fuhuaNow"].removeEventListener(MouseEvent.CLICK,fuhuaNow);
         menuTooltip["menu_10"]["xf_btn"].removeEventListener(MouseEvent.CLICK,xufei);
         menuTooltip["menu_10"]["yc_btn"].removeEventListener(MouseEvent.CLICK,yincang);
         menuTooltip["menu_10"]["xs_btn"].removeEventListener(MouseEvent.CLICK,xianshi);
         menuTooltip["menu_10"]["off_btn"].removeEventListener(MouseEvent.CLICK,takeOff);
      }
      
      public function setItemsMenu(param1:uint, param2:uint, param3:uint) : *
      {
         whichDo = param3;
         selectType = param1;
         oldNum = param2;
         menuTooltip["menu_1"].visible = false;
         menuTooltip["menu_2"].visible = false;
         menuTooltip["menu_3"].visible = false;
         menuTooltip["menu_4"].visible = false;
         menuTooltip["menu_5"].visible = false;
         menuTooltip["menu_6"].visible = false;
         menuTooltip["menu_7"].visible = false;
         menuTooltip["menu_8"].visible = false;
         menuTooltip["menu_9"].visible = false;
         menuTooltip["menu_10"].visible = false;
         menuTooltip["menu_11"].visible = false;
         menuTooltip["menu_12"].visible = false;
         switch(selectType)
         {
            case 1:
               menuTooltip["menu_2"].visible = true;
               break;
            case 2:
               menuTooltip["menu_3"].visible = true;
               break;
            case 3:
               if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getType() == 4)
               {
                  menuTooltip["menu_5"].visible = true;
               }
               else if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getType() == 5 || ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getType() == 6)
               {
                  menuTooltip["menu_7"].visible = true;
               }
               else
               {
                  menuTooltip["menu_4"].visible = true;
               }
               break;
            case 4:
               if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIsUse() == 1)
               {
                  menuTooltip["menu_7"].visible = true;
               }
               else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIsUse() == 0)
               {
                  menuTooltip["menu_4"].visible = true;
               }
               else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIsUse() == 3)
               {
                  menuTooltip["menu_8"].visible = true;
               }
               else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIsUse() == 4)
               {
                  menuTooltip["menu_9"].visible = true;
               }
               break;
            case 5:
               menuTooltip["menu_4"].visible = true;
         }
      }
      
      private function tipOpen(param1:MouseEvent) : void
      {
         ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsTooltip);
         ItemsPanel.itemsTooltip.x = ItemsPanel.itemsPanel.mouseX;
         ItemsPanel.itemsTooltip.y = ItemsPanel.itemsPanel.mouseY;
         ItemsPanel.itemsTooltip.gemTooltip(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum));
         ItemsPanel.itemsTooltip.visible = true;
      }
      
      private function tipClose(param1:MouseEvent) : void
      {
         ItemsPanel.itemsTooltip.visible = false;
      }
      
      private function getPart(param1:Number) : uint
      {
         switch(param1)
         {
            case 1:
               return 0;
            case 2:
               return 1;
            case 3:
               return 3;
            case 4:
               return 4;
            case 5:
               return 2;
            case 6:
               return 2;
            case 7:
               return 2;
            case 8:
               return 6;
            case 9:
               return 7;
            case 10:
               return 8;
            case 11:
               return 9;
            case 12:
               return 11;
            case 13:
               return 12;
            default:
               return null;
         }
      }
      
      public function setSlotMenu(param1:uint, param2:uint) : *
      {
         oldNum = param1;
         whichDo = param2;
         menuTooltip["menu_1"].visible = false;
         menuTooltip["menu_2"].visible = false;
         menuTooltip["menu_3"].visible = false;
         menuTooltip["menu_4"].visible = false;
         menuTooltip["menu_5"].visible = false;
         menuTooltip["menu_6"].visible = false;
         menuTooltip["menu_7"].visible = false;
         menuTooltip["menu_8"].visible = false;
         menuTooltip["menu_9"].visible = false;
         menuTooltip["menu_10"].visible = false;
         menuTooltip["menu_11"].visible = false;
         menuTooltip["menu_12"].visible = false;
         if(oldNum < 6)
         {
            menuTooltip["menu_1"].visible = true;
            menuTooltip["menu_10"].visible = false;
         }
         else
         {
            menuTooltip["menu_1"].visible = false;
            menuTooltip["menu_10"].visible = true;
            if(oldNum == 6)
            {
               if(Main["player_" + whichDo].skin_Z2_V)
               {
                  menuTooltip["menu_10"]["yc_btn"].visible = true;
               }
               else
               {
                  menuTooltip["menu_10"]["yc_btn"].visible = false;
               }
            }
            else if(oldNum == 7)
            {
               if(Main["player_" + whichDo].skin_Z3_V)
               {
                  menuTooltip["menu_10"]["yc_btn"].visible = true;
               }
               else
               {
                  menuTooltip["menu_10"]["yc_btn"].visible = false;
               }
            }
            if(Main["player" + whichDo].getEquipSlot().getEquipFromSlot(oldNum).getColor() >= 4)
            {
               menuTooltip["menu_10"]["xf_btn"].visible = false;
            }
            else
            {
               menuTooltip["menu_10"]["xf_btn"].visible = true;
            }
         }
         if(oldNum == 2 || oldNum == 5)
         {
            menuTooltip["menu_1"].visible = false;
            menuTooltip["menu_10"].visible = false;
            if(ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(oldNum).getHuanHua() == 0)
            {
               menuTooltip["menu_11"].visible = false;
            }
            else if(ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(oldNum).getHHVisible() == 0)
            {
               menuTooltip["menu_11"].visible = true;
               menuTooltip["menu_12"].visible = false;
            }
            else
            {
               menuTooltip["menu_11"].visible = false;
               menuTooltip["menu_12"].visible = true;
            }
         }
      }
      
      public function setSkillSlotMenu(param1:uint, param2:uint) : *
      {
         oldNum = param1;
         whichDo = param2;
         menuTooltip["menu_1"].visible = false;
         menuTooltip["menu_2"].visible = false;
         menuTooltip["menu_3"].visible = false;
         menuTooltip["menu_4"].visible = false;
         menuTooltip["menu_5"].visible = false;
         menuTooltip["menu_6"].visible = true;
         menuTooltip["menu_7"].visible = false;
         menuTooltip["menu_8"].visible = false;
         menuTooltip["menu_9"].visible = false;
         menuTooltip["menu_10"].visible = false;
         menuTooltip["menu_11"].visible = false;
         menuTooltip["menu_12"].visible = false;
      }
      
      private function bagNoBug() : *
      {
         if(whichDo == 1)
         {
            ItemsPanel.isPOne = true;
            ItemsPanel.itemsPanel["bagOne"].isClick = true;
         }
         else
         {
            ItemsPanel.isPOne = false;
            ItemsPanel.itemsPanel["bagTwo"].isClick = true;
         }
      }
      
      public function fuhua(param1:*) : *
      {
         var _loc2_:int = 0;
         if(ItemsPanel.myplayer.data.getPetSlot().backPetSlotNum() > 0)
         {
            _loc2_ = int(ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum).getValue_1());
            ItemsPanel.myplayer.data.getPetSlot().addPetSlot(PetFactory.creatPet(_loc2_));
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物栏空间不足");
         }
         BagItemsShow.otherobjShow();
      }
      
      public function fuhuaNow(param1:*) : *
      {
         ItemsPanel.itemsPanel["fhRMB"].visible = true;
         ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["fhRMB"]);
      }
      
      public function yesFH(param1:*) : *
      {
         if(ItemsPanel.myplayer.data.getPetSlot().backPetSlotNum() <= 0)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"宠物栏空间不足");
            return;
         }
         Api_4399_All.BuyObj(InitData.fuHua.getValue());
         menuTooltip["menu_9"]["fuhuaNow"].visible = false;
         moneyOK = true;
         ItemsPanel.itemsPanel["fhRMB"].visible = false;
      }
      
      public function noFH(param1:*) : *
      {
         ItemsPanel.itemsPanel["fhRMB"].visible = false;
      }
      
      public function wear(param1:MouseEvent) : *
      {
         var _loc2_:Equip = null;
         equipSlot = ItemsPanel.myplayer.data.getEquipSlot();
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getPosition() <= 4 && Main.water.getValue() != 1 || ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getPosition() >= 10 && Main.water.getValue() == 1)
         {
            return;
         }
         var _loc3_:uint = uint(getPart(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getPosition()));
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getDressLevel() <= ItemsPanel.myplayer.data.getLevel() || ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getDressLevel() == 100)
         {
            if(equipSlot.getEquipFromSlot(_loc3_) == null)
            {
               equipSlot.addToSlot(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum),_loc3_);
               ItemsPanel.myplayer.data.getBag().delEquip(oldNum);
            }
            else
            {
               _loc2_ = equipSlot.delSlot(_loc3_);
               equipSlot.addToSlot(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum),_loc3_);
               ItemsPanel.myplayer.data.getBag().delEquip(oldNum);
               ItemsPanel.myplayer.data.getBag().addToEquipBag(_loc2_,oldNum);
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"等级不足");
         }
         ItemsPanel.myplayer.LoadPlayerLvData();
         Player.getEquipDataXX();
         BagItemsShow.informationShow();
         BagItemsShow.equipShow();
         BagItemsShow.slotShow();
         ItemsPanel.changeModel(ItemsPanel.myplayer.data);
         if(Main.newPlay == 0)
         {
            ItemsPanel.itemsPanel["xinshou"].visible = false;
         }
      }
      
      public function ychh(param1:MouseEvent) : *
      {
         ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(oldNum).changeHH(1);
         ItemsPanel.changeModel(ItemsPanel.myplayer.data);
      }
      
      public function xshh(param1:MouseEvent) : *
      {
         ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(oldNum).changeHH(0);
         ItemsPanel.changeModel(ItemsPanel.myplayer.data);
      }
      
      public function takeOff(param1:MouseEvent) : *
      {
         equipSlot = ItemsPanel.myplayer.data.getEquipSlot();
         if(Main.water.getValue() != 1 && (oldNum == 0 || oldNum == 1 || oldNum == 3 || oldNum == 4))
         {
            oldNum += 8;
         }
         if(ItemsPanel.myplayer.data.getBag().backequipBagNum() > 0)
         {
            ItemsPanel.myplayer.data.getBag().addEquipBag(equipSlot.getEquipFromSlot(oldNum));
            equipSlot.delSlot(oldNum);
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         Player.getEquipDataXX();
         ItemsPanel.allFalse();
         ItemsPanel.itemsPanel["bg1_1"].isClick = true;
         ItemsPanel.itemsType = 1;
         BagItemsShow.equipShow();
         BagItemsShow.slotShow();
         BagItemsShow.informationShow();
         ItemsPanel.changeModel(ItemsPanel.myplayer.data);
      }
      
      public function leftInto(param1:MouseEvent) : *
      {
         var _loc2_:Gem = null;
         skillSlot = ItemsPanel.myplayer.data.getEquipSkillSlot();
         if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getUseLevel() <= ItemsPanel.myplayer.data.getLevel())
         {
            if(skillSlot.getGemFromSkillSlot(0) == null)
            {
               skillSlot.addToSkillSlot(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum),0);
               ItemsPanel.myplayer.data.getBag().delGem(oldNum,1);
            }
            else
            {
               _loc2_ = skillSlot.delSkillSlot(0);
               skillSlot.addToSkillSlot(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum),0);
               ItemsPanel.myplayer.data.getBag().delGem(oldNum,1);
               ItemsPanel.myplayer.data.getBag().addToGemBag(_loc2_,oldNum);
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         ItemsPanel.changeModel(ItemsPanel.myplayer.data);
         ItemsPanel.myplayer.energySlot.energyLeftNum.setValue(0);
         ItemsPanel.myplayer.energySlot.energyLeftMax.setValue(SkillFactory.getSkillById(skillSlot.getGemFromSkillSlot(0).getGemSkill()).getEp());
         BagItemsShow.skillSlotShow();
         BagItemsShow.gemShow();
      }
      
      public function rightInto(param1:MouseEvent) : *
      {
         var _loc2_:Gem = null;
         skillSlot = ItemsPanel.myplayer.data.getEquipSkillSlot();
         if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getUseLevel() <= ItemsPanel.myplayer.data.getLevel())
         {
            if(skillSlot.getGemFromSkillSlot(1) == null)
            {
               skillSlot.addToSkillSlot(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum),1);
               ItemsPanel.myplayer.data.getBag().delGem(oldNum,1);
            }
            else
            {
               _loc2_ = skillSlot.delSkillSlot(1);
               skillSlot.addToSkillSlot(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum),1);
               ItemsPanel.myplayer.data.getBag().delGem(oldNum,1);
               ItemsPanel.myplayer.data.getBag().addToGemBag(_loc2_,oldNum);
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         ItemsPanel.changeModel(ItemsPanel.myplayer.data);
         ItemsPanel.myplayer.energySlot.energyRightMax.setValue(SkillFactory.getSkillById(skillSlot.getGemFromSkillSlot(1).getGemSkill()).getEp());
         ItemsPanel.myplayer.energySlot.energyRightNum.setValue(0);
         BagItemsShow.skillSlotShow();
         BagItemsShow.gemShow();
      }
      
      public function setFree(param1:MouseEvent) : *
      {
         var _loc2_:Gem = null;
         skillSlot = ItemsPanel.myplayer.data.getEquipSkillSlot();
         if(ItemsPanel.myplayer.data.getBag().backGemBagNum() > 0)
         {
            ItemsPanel.myplayer.data.getBag().addGemBag(skillSlot.delSkillSlot(oldNum));
            if(oldNum == 0)
            {
               ItemsPanel.myplayer.energySlot.energyLeftMax.setValue(0);
               ItemsPanel.myplayer.energySlot.energyLeftNum.setValue(0);
            }
            else
            {
               ItemsPanel.myplayer.energySlot.energyRightMax.setValue(0);
               ItemsPanel.myplayer.energySlot.energyRightNum.setValue(0);
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         BagItemsShow.skillSlotShow();
         BagItemsShow.gemShow();
         ItemsPanel.allFalse();
         ItemsPanel.itemsPanel["bg1_3"].isClick = true;
         ItemsPanel.itemsType = 3;
      }
      
      public function allSell(param1:MouseEvent) : *
      {
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor() == 1)
         {
            colorNum = 1;
            ItemsPanel.itemsPanel["isAllSell"].visible = true;
            ItemsPanel.itemsPanel["isAllSell"]["selltxt"].text = "是否确定出售所有的白色品质装备";
            ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isAllSell"]);
         }
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor() == 2)
         {
            colorNum = 2;
            ItemsPanel.itemsPanel["isAllSell"].visible = true;
            ItemsPanel.itemsPanel["isAllSell"]["selltxt"].text = "是否确定出售所有的蓝色品质装备";
            ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isAllSell"]);
         }
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor() == 3)
         {
            colorNum = 3;
            ItemsPanel.itemsPanel["isAllSell"].visible = true;
            ItemsPanel.itemsPanel["isAllSell"]["selltxt"].text = "是否确定出售所有的粉色品质装备";
            ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isAllSell"]);
         }
         if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor() >= 4)
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"金色品质装备无法一键出售");
         }
      }
      
      public function sell(param1:MouseEvent) : *
      {
         if(selectType == 1)
         {
            if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getColor() <= 2)
            {
               ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getPrice());
               ItemsPanel.myplayer.data.getBag().delEquip(oldNum);
            }
            else
            {
               ItemsPanel.itemsPanel["isSell"].visible = true;
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isSell"]);
            }
            BagItemsShow.equipShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 2)
         {
            if(ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(oldNum).getColor() <= 2)
            {
               ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(oldNum).getPrice());
               ItemsPanel.myplayer.data.getBag().delSupplies(oldNum);
            }
            else
            {
               ItemsPanel.itemsPanel["isSell"].visible = true;
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isSell"]);
            }
            BagItemsShow.suppliesShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 3)
         {
            if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getTimes() > 1)
            {
               ItemsPanel.itemsPanel["sellMenu"].visible = true;
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["sellMenu"]);
               amount.setValue(1);
               ItemsPanel.itemsPanel["sellMenu"]["amount"].text = amount.getValue();
               ItemsPanel.itemsPanel["sellMenu"]["showPic"].gotoAndStop(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getFrame());
               ItemsPanel.itemsPanel["sellMenu"]["showPic"]["t_txt"].visible = false;
            }
            else if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getColor() <= 2)
            {
               ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getPrice());
               ItemsPanel.myplayer.data.getBag().delGem(oldNum,1);
            }
            else
            {
               ItemsPanel.itemsPanel["isSell"].visible = true;
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isSell"]);
            }
            BagItemsShow.gemShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 4)
         {
            if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getTimes() > 1)
            {
               ItemsPanel.itemsPanel["sellMenu"].visible = true;
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["sellMenu"]);
               amount.setValue(1);
               ItemsPanel.itemsPanel["sellMenu"]["amount"].text = amount.getValue();
               ItemsPanel.itemsPanel["sellMenu"]["showPic"].gotoAndStop(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getFrame());
               ItemsPanel.itemsPanel["sellMenu"]["showPic"]["t_txt"].visible = false;
            }
            else
            {
               ItemsPanel.itemsPanel["isSell"].visible = true;
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isSell"]);
            }
         }
         if(selectType == 5)
         {
            ItemsPanel.itemsPanel["isSell"].visible = true;
            ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["isSell"]);
         }
      }
      
      private function noAllSell() : *
      {
         bagNoBug();
         ItemsPanel.itemsPanel["isAllSell"].visible = false;
      }
      
      private function yesAllSell(param1:int = 1) : *
      {
         bagNoBug();
         var _loc2_:* = 0;
         while(_loc2_ < 48)
         {
            if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(_loc2_) != null)
            {
               if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(_loc2_).getColor() == param1 && ItemsPanel.myplayer.data.getBag().getEquipFromBag(_loc2_).getPosition() <= 7)
               {
                  ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getEquipFromBag(_loc2_).getPrice());
                  ItemsPanel.myplayer.data.getBag().delEquip(_loc2_);
               }
            }
            _loc2_++;
         }
         BagItemsShow.equipShow();
         BagItemsShow.informationShow();
         ItemsPanel.itemsPanel["isAllSell"].visible = false;
      }
      
      private function yesHandle() : *
      {
         bagNoBug();
         if(selectType == 1)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getEquipFromBag(oldNum).getPrice());
            ItemsPanel.myplayer.data.getBag().delEquip(oldNum);
            BagItemsShow.equipShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 2)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(oldNum).getPrice());
            ItemsPanel.myplayer.data.getBag().delSupplies(oldNum);
            BagItemsShow.suppliesShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 3)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getPrice());
            ItemsPanel.myplayer.data.getBag().delGem(oldNum,1);
            BagItemsShow.gemShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 4)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getGold());
            ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            BagItemsShow.otherobjShow();
            BagItemsShow.informationShow();
         }
         if(selectType == 5)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getQuestFromBag(oldNum).getGold());
            ItemsPanel.myplayer.data.getBag().delQuset(oldNum);
            BagItemsShow.questShow();
            BagItemsShow.informationShow();
         }
         ItemsPanel.itemsPanel["isSell"].visible = false;
      }
      
      public function btnListen(param1:BtnEvent) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         switch(_loc2_.name)
         {
            case "yesBtn_All":
               yesAllSell(colorNum);
               break;
            case "noBtn_All":
               noAllSell();
               break;
            case "closeAll":
               noAllSell();
               break;
            case "yesBtn":
               yesHandle();
               break;
            case "noBtn":
               bagNoBug();
               ItemsPanel.itemsPanel["isSell"].visible = false;
               break;
            case "noBtn2":
               bagNoBug();
               ItemsPanel.itemsPanel["isSell"].visible = false;
               break;
            case "sellUp":
               setUp();
               break;
            case "sellDown":
               setDown();
               break;
            case "sellBtn":
               sellBatch();
               bagNoBug();
               break;
            case "closeSellMenu":
               bagNoBug();
               ItemsPanel.itemsPanel["sellMenu"].visible = false;
         }
      }
      
      private function sellBatch() : void
      {
         if(selectType == 3)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getPrice() * amount.getValue());
            ItemsPanel.myplayer.data.getBag().delGem(oldNum,amount.getValue());
            BagItemsShow.gemShow();
            BagItemsShow.informationShow();
         }
         else if(selectType == 4)
         {
            ItemsPanel.myplayer.data.addGold(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getGold() * amount.getValue());
            ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,amount.getValue());
            BagItemsShow.otherobjShow();
            BagItemsShow.informationShow();
         }
         ItemsPanel.itemsPanel["sellMenu"].visible = false;
      }
      
      private function setUp() : void
      {
         if(selectType == 3)
         {
            if(amount.getValue() == ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getTimes())
            {
               amount.setValue(1);
            }
            else
            {
               amount.setValue(amount.getValue() + 1);
            }
         }
         else if(selectType == 4)
         {
            if(amount.getValue() == ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getTimes())
            {
               amount.setValue(1);
            }
            else
            {
               amount.setValue(amount.getValue() + 1);
            }
         }
         ItemsPanel.itemsPanel["sellMenu"]["amount"].text = amount.getValue();
      }
      
      private function setDown() : void
      {
         ItemsPanel.itemsPanel["sellMenu"]["amount"].text = amount.getValue();
         if(selectType == 3)
         {
            if(amount.getValue() == 1)
            {
               amount.setValue(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getTimes());
            }
            else
            {
               amount.setValue(amount.getValue() - 1);
            }
         }
         else if(selectType == 4)
         {
            if(amount.getValue() == 1)
            {
               amount.setValue(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getTimes());
            }
            else
            {
               amount.setValue(amount.getValue() - 1);
            }
         }
         ItemsPanel.itemsPanel["sellMenu"]["amount"].text = amount.getValue();
      }
      
      public function alluseOther(param1:*) : *
      {
         if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 11)
         {
            while(Boolean(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum)) && ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getTimes() > 0)
            {
               if(ItemsPanel.myplayer.data.getLevel() > Player.maxLevel)
               {
                  break;
               }
               if(ItemsPanel.myplayer.hp.getValue() > 0)
               {
                  ItemsPanel.myplayer.ExpUP(InitData.EXP_num.getValue(),2);
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
               }
            }
         }
         else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 31)
         {
            while(Boolean(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum)) && ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getTimes() > 0)
            {
               if(ItemsPanel.myplayer.data.getLevel() > Player.maxLevel)
               {
                  break;
               }
               if(ItemsPanel.myplayer.hp.getValue() > 0)
               {
                  ItemsPanel.myplayer.ExpUP(InitData.EXP_big_num.getValue(),2);
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
               }
            }
         }
         else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 9)
         {
            while(Boolean(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum)) && ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getTimes() > 0)
            {
               ItemsPanel.myplayer.data.killPoint.setValue(ItemsPanel.myplayer.data.killPoint.getValue() + InitData.BuyNum_300.getValue());
               ItemsPanel.myplayer.data.addGold(InitData.BuyNum_80000.getValue());
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               Main.Save();
            }
         }
         BagItemsShow.otherobjShow();
         BagItemsShow.informationShow();
      }
      
      public function useOther(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         if(selectType == 4)
         {
            if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 4)
            {
               InitData.EXPxTimeUp(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getRemaining());
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               Main.Save();
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 5)
            {
               InitData.DOWNxTimeUp(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getRemaining());
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               Main.Save();
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 7)
            {
               MakeData.open(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getId());
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功，解锁了该物品的使用权限");
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 9)
            {
               ItemsPanel.myplayer.data.killPoint.setValue(ItemsPanel.myplayer.data.killPoint.getValue() + InitData.BuyNum_300.getValue());
               ItemsPanel.myplayer.data.addGold(InitData.BuyNum_80000.getValue());
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               Main.Save();
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得300击杀点,80000金币");
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 10)
            {
               TaskData.otherUpdataTask();
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"每日任务重置成功");
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 11)
            {
               if(ItemsPanel.myplayer.data.getLevel() <= Player.maxLevel)
               {
                  if(ItemsPanel.myplayer.hp.getValue() > 0)
                  {
                     ItemsPanel.myplayer.ExpUP(InitData.EXP_num.getValue(),2);
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
                  }
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 31)
            {
               if(ItemsPanel.myplayer.data.getLevel() <= Player.maxLevel)
               {
                  if(ItemsPanel.myplayer.hp.getValue() > 0)
                  {
                     ItemsPanel.myplayer.ExpUP(InitData.EXP_big_num.getValue(),2);
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"使用成功");
                  }
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 17)
            {
               QiangHuaPanel.open(true,oldNum);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 18)
            {
               ItemsPanel.myplayer.data.getBadgeSlot().addToSlot(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum),0);
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 19)
            {
               ItemsPanel.myplayer.data.getBadgeSlot().addToSlot(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum),1);
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 20)
            {
               ItemsPanel.myplayer.data.getBadgeSlot().addToSlot(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum),2);
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 21)
            {
               ItemsPanel.myplayer.data.getBadgeSlot().addToSlot(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum),3);
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 22)
            {
               ItemsPanel.myplayer.data.getBadgeSlot().addToSlot(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum),4);
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 23)
            {
               ItemsPanel.myplayer.data.getBadgeSlot().addToSlot(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum),5);
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 24)
            {
               if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getId() == 63303 && (!PK_UI.jiFenArr[6] || PK_UI.jiFenArr[6] <= 0))
               {
                  Main.NoGame();
                  return;
               }
               if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getId() == 63303 && PK_UI.jiFenArr[6] > 0)
               {
                  --PK_UI.jiFenArr[6];
               }
               ItemsPanel.myplayer.data.getTitleSlot().addToSlot(TitleFactory.creatTitle(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getValue_1()));
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               ItemsPanel.myplayer.cengHao_mc.Show(1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 25)
            {
               ItemsPanel.myplayer.data.killPoint.setValue(ItemsPanel.myplayer.data.killPoint.getValue() + InitData.Temp50.getValue());
               ItemsPanel.myplayer.data.addGold(InitData.BuyNum_18000.getValue());
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得50击杀点,18000金币");
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 27)
            {
               if(ItemsPanel.myplayer.data.getElvesSlot().backElvesSlotNum() > 0)
               {
                  ItemsPanel.myplayer.data.getElvesSlot().addElvesSlot(ElvesFactory.creatElves(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getValue_1()));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵已进入精灵槽，点击精灵面板查看");
                  ItemsPanel.itemsPanel["jinglingOPEN"].visible = true;
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"精灵槽已满，请开启精灵界面扩充");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 29)
            {
               UpgradePanel.open(ItemsPanel.myplayer.data);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 26)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 4)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63138));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63155));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 28)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63195));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 32)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 9)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 10)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13524));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13424));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13724));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13624));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14311));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14211));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14111));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14450));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14433));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 34)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 4)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 22)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 8)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 12)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63234));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 92)
            {
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["fudai3"]);
               ItemsPanel.itemsPanel["fudai3"].visible = true;
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 35)
            {
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["fudai"]);
               ItemsPanel.itemsPanel["fudai"].visible = true;
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 39)
            {
               ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["fudai2"]);
               ItemsPanel.itemsPanel["fudai2"].visible = true;
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 37)
            {
               ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63237));
               _loc2_ = 0;
               while(_loc2_ < 10)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                  _loc2_++;
               }
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 38)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63242));
                  _loc2_ = 0;
                  while(_loc2_ < 10)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 33)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 6 && ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 6)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 23)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63105));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63106));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 10)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13427));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13527));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13627));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(13727));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14452));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14435));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 40)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63243));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14643));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14644));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 41)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 6 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63162));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63169));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63171));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63183));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63197));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63207));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 42)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 5)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14649));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14652));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 43)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14650));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14653));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 44)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 3 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
                  _loc2_ = 0;
                  while(_loc2_ < 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14650));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14653));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 45)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 3 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21116));
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21216));
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33512));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14667));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14668));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14669));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 46)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63209));
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33512));
                     _loc2_++;
                  }
                  _loc3_ = int(Math.random() * 9);
                  if(_loc3_ == 0)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14432));
                  }
                  else if(_loc3_ == 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14433));
                  }
                  else if(_loc3_ == 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14450));
                  }
                  else if(_loc3_ == 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14611));
                  }
                  else if(_loc3_ == 4)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14620));
                  }
                  else if(_loc3_ == 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14645));
                  }
                  else if(_loc3_ == 6)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14646));
                  }
                  else if(_loc3_ == 7)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14650));
                  }
                  else if(_loc3_ == 8)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14653));
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 48)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  _loc2_ = 0;
                  while(_loc2_ < 10)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31216));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14611));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14671));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 49)
            {
               _loc3_ = int(Math.random() * 2);
               if(_loc3_ == 0)
               {
                  _loc4_ = 30000 + Math.random() * 70000;
                  ItemsPanel.myplayer.data.addGold(_loc4_);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得" + _loc4_ + "金币！");
               }
               else
               {
                  _loc5_ = 200 + Math.random() * 300;
                  ItemsPanel.myplayer.data.AddKillPoint(_loc5_);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得" + _loc5_ + "击杀点!");
               }
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               Main.Save();
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 55)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 5 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63263));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63262));
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 56)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 9)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63162));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63169));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63171));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63183));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63197));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63207));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63246));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63257));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63268));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"消耗栏需要2格空间，宝石栏需要1格空间，其他栏需要9格空间");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 57)
            {
               Yayale_LingQue.DuiHuanOpen();
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 58)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21223));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"消耗栏需要2格空间，其他栏需要2格空间");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 60)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 4)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21225));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"消耗栏需要4格空间");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 61)
            {
               _loc5_ = 100;
               ItemsPanel.myplayer.data.AddKillPoint(_loc5_);
               NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得" + _loc5_ + "击杀点!");
               ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
               Main.Save();
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 64)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  cwOK = true;
                  Main.Save();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 80)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.itemsPanel["touming"].visible = true;
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  cwOK_2 = true;
                  Main.Save();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 65)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 5 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 4 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63141));
                  _loc2_ = 0;
                  while(_loc2_ < 4)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31217));
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 68)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14452));
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21216));
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21116));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 69)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63287));
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21224));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 70)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63243));
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21228));
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21228));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 74)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 3 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14113));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14213));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14313));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 75)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.AddKillPoint(300);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63294));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 76)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.addGold(80000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14612));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14621));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 77)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3)
               {
                  ItemsPanel.myplayer.data.addGold(120000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63255));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 78)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21229));
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21232));
                  PaiHang_Data.jiFenArr[1].setValue(PaiHang_Data.jiFenArr[1].getValue() + 5);
                  PaiHang_Data.jiFenArr[2].setValue(PaiHang_Data.jiFenArr[2].getValue() + 5);
                  PaiHang_Data.jiFenArr[3].setValue(PaiHang_Data.jiFenArr[3].getValue() + 5);
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 82)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 83)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.AddKillPoint(300);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 84)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 85)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 86)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 87)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.addGold(50000);
                  ItemsPanel.myplayer.data.AddKillPoint(300);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                  ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 88)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.addGold(80000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63323));
                  ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 89)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3)
               {
                  ItemsPanel.myplayer.data.addGold(120000);
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 90)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 2 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                  ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14643));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14644));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 93)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 2)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21232));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 94)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 10)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21232));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 81)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 3 && ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63105));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31217));
                     _loc2_++;
                  }
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63106));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63106));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14671));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足,其他栏需要3格，装备栏需要1格，宝石栏需要1格");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 51)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 1)
               {
                  _loc3_ = int(Math.random() * 4);
                  if(_loc3_ == 0)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14653));
                  }
                  else if(_loc3_ == 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14646));
                  }
                  else if(_loc3_ == 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14671));
                  }
                  else if(_loc3_ == 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14433));
                  }
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得翅膀，请在装备栏查看");
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 52)
            {
               if(ItemsPanel.myplayer.data.getBag().backequipBagNum() >= 1)
               {
                  _loc3_ = int(Math.random() * 6);
                  if(_loc3_ == 0)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14432));
                  }
                  else if(_loc3_ == 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14450));
                  }
                  else if(_loc3_ == 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14611));
                  }
                  else if(_loc3_ == 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14620));
                  }
                  else if(_loc3_ == 4)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14645));
                  }
                  else if(_loc3_ == 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addEquipBag(EquipFactory.createEquipByID(14650));
                  }
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得时装，请在装备栏查看");
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 53)
            {
               if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 4)
               {
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63260));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63261));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63262));
                  ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63263));
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"领取成功，物品已放入背包");
                  Main.Save();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 71)
            {
               if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1 && ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
               {
                  _loc3_ = int(Math.random() * 9);
                  if(_loc3_ == 0)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 复活药 ");
                  }
                  else if(_loc3_ == 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21223));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 野性之血 ");
                  }
                  else if(_loc3_ == 2)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31210));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 1级强化石");
                  }
                  else if(_loc3_ == 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31211));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 2级强化石");
                  }
                  else if(_loc3_ == 4)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31212));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 3级强化石");
                  }
                  else if(_loc3_ == 5)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 封印的星灵财宝 ");
                  }
                  else if(_loc3_ == 6)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 经验药水");
                  }
                  else if(_loc3_ == 7)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 合成添加剂");
                  }
                  else if(_loc3_ == 8)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21230));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"获得 疯狂月饼");
                  }
                  ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                  Main.Save();
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 73)
            {
               if(!PK_UI.jiFenArr[7] || PK_UI.jiFenArr[7] <= 0)
               {
                  Main.NoGame();
                  return;
               }
               _loc6_ = ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIntroduction().split("#");
               _loc7_ = _loc6_[1];
               HuanHuaPanel.open(ItemsPanel.myplayer.data,ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getId(),_loc7_);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 79)
            {
               _loc6_ = ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIntroduction().split("#");
               _loc7_ = _loc6_[1];
               HuanHuaPanel.open(ItemsPanel.myplayer.data,ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getId(),_loc7_);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 95)
            {
               _loc6_ = ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getIntroduction().split("#");
               _loc7_ = _loc6_[1];
               HuanHuaPanel.open(ItemsPanel.myplayer.data,ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getId(),_loc7_);
            }
            else if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(oldNum).getType() == 50)
            {
               _loc3_ = int(Math.random() * 18);
               if(_loc3_ == 0)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63203).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 1)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33213));
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(33213).getName());
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 2)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63211));
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63211).getName());
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 3)
               {
                  if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21222));
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + SuppliesFactory.getSuppliesById(21222).getName());
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 4)
               {
                  if(ItemsPanel.myplayer.data.getBag().backSuppliesBagNum() >= 3)
                  {
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     ItemsPanel.myplayer.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(21221));
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + SuppliesFactory.getSuppliesById(21221).getName());
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 5)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63105));
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63105).getName());
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 6)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63106));
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63106).getName());
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 7)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63100));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63100).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 8)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63155));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63155));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63155).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 9)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63147));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63147).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 10)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63141));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63141).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 11)
               {
                  if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     ItemsPanel.myplayer.data.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + OtherFactory.creatOther(63235).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 12)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31214));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31214));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31214));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(31214).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 13)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31215));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31215));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31215));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(31215).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 14)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31216));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31216));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31216));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(31216).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 15)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31217));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(31217));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(31217).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 16)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33512));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33512));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(33512).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
               else if(_loc3_ == 17)
               {
                  if(ItemsPanel.myplayer.data.getBag().backGemBagNum() >= 1)
                  {
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33511));
                     ItemsPanel.myplayer.data.getBag().addGemBag(GemFactory.creatGemById(33511));
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"恭喜你获得 " + GemFactory.creatGemById(33511).getName());
                     ItemsPanel.myplayer.data.getBag().delOtherobj(oldNum,1);
                     Main.Save();
                  }
                  else
                  {
                     NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
                  }
               }
            }
            BagItemsShow.badgeSlotShow();
            BagItemsShow.otherobjShow();
            BagItemsShow.informationShow();
         }
         else if(selectType == 3)
         {
            if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getType() == 5)
            {
               _loc8_ = uint(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getGemSkill());
               _loc9_ = ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getDescript();
               if(ItemsPanel.myplayer == Main.player_1)
               {
                  zengfuPanel.open(true,_loc9_,_loc8_,oldNum);
               }
               else
               {
                  zengfuPanel.open(false,_loc9_,_loc8_,oldNum);
               }
            }
            else if(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getType() == 6)
            {
               _loc10_ = int(ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getStrengthenLevel());
               _loc11_ = ItemsPanel.myplayer.data.getBag().getGemFromBag(oldNum).getDescript();
               if(ItemsPanel.myplayer == Main.player_1)
               {
                  upstarPanel.open(true,_loc11_,_loc10_,oldNum);
               }
               else
               {
                  upstarPanel.open(false,_loc11_,_loc10_,oldNum);
               }
            }
         }
      }
      
      public function yesFJ(param1:*) : *
      {
         ItemsPanel.itemsPanel["isFenJie"].visible = false;
         if(ItemsPanel.myplayer.data.getBag().backOtherBagNum() >= 1)
         {
            doFenJie();
            ItemsPanel.myplayer.data.getBag().delEquip(oldNum);
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"背包空间不足");
         }
         BagItemsShow.equipShow();
         BagItemsShow.informationShow();
      }
      
      public function noFJ(param1:*) : *
      {
         ItemsPanel.itemsPanel["isFenJie"].visible = false;
      }
      
      public function setKey_1(param1:MouseEvent) : *
      {
         su = ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(oldNum);
         ItemsPanel.myplayer.data.getSuppliesSlot().setToSuppliesSlot(su,0);
      }
      
      public function setKey_2(param1:MouseEvent) : *
      {
         su = ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(oldNum);
         ItemsPanel.myplayer.data.getSuppliesSlot().setToSuppliesSlot(su,1);
      }
      
      public function setKey_3(param1:MouseEvent) : *
      {
         su = ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(oldNum);
         ItemsPanel.myplayer.data.getSuppliesSlot().setToSuppliesSlot(su,2);
      }
      
      public function yesXF(param1:*) : *
      {
         Api_4399_All.BuyObj(InitData.fuHua.getValue());
         moneyOK2 = true;
         ItemsPanel.itemsPanel["xfRMB"].visible = false;
      }
      
      public function noXF(param1:*) : *
      {
         ItemsPanel.itemsPanel["xfRMB"].visible = false;
      }
      
      public function xufei(param1:MouseEvent) : *
      {
         ItemsPanel.itemsPanel["xfRMB"].visible = true;
         ItemsPanel.itemsPanel.addChild(ItemsPanel.itemsPanel["xfRMB"]);
      }
      
      public function xianshi(param1:MouseEvent) : *
      {
         if(oldNum == 6 && Main["player_" + whichDo].skin_Z2_V == false)
         {
            Main["player_" + whichDo].skin_Z2_V = true;
         }
         else if(oldNum == 7 && Main["player_" + whichDo].skin_Z3_V == false)
         {
            Main["player_" + whichDo].skin_Z3_V = true;
         }
         (Main["player_" + whichDo] as Player).noHead = false;
         Main["player_" + whichDo].newSkin();
      }
      
      public function yincang(param1:MouseEvent) : *
      {
         if(oldNum == 6 && Main["player_" + whichDo].skin_Z2_V == true)
         {
            Main["player_" + whichDo].skin_Z2_V = false;
         }
         else if(oldNum == 7 && Main["player_" + whichDo].skin_Z3_V == true)
         {
            Main["player_" + whichDo].skin_Z3_V = false;
         }
         Main["player_" + whichDo].newSkin();
      }
   }
}

