package src
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class NewYear_Interface extends MovieClip
   {
      
      public static var loadData:ClassLoader;
      
      private static var _this:NewYear_Interface;
      
      public static var key:VT = VT.createVT(0);
      
      public static var juan:VT = VT.createVT(0);
      
      public static var allJiangLi:Array = [];
      
      public static var openYesNo:Array = [];
      
      public static var NYOK15:Boolean = false;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "NewYear.swf";
      
      private var skin:MovieClip;
      
      public function NewYear_Interface()
      {
         super();
         LoadSkin();
         _this = this;
      }
      
      private static function InitOpen() : *
      {
         var _loc1_:NewYear_Interface = new NewYear_Interface();
         Main._stage.addChild(_loc1_);
         OpenYN = true;
      }
      
      public static function Open() : *
      {
         if(_this)
         {
            _this.visible = true;
            _this.skin.visible = true;
            _this.x = _this.y = 0;
            showAll();
         }
         else
         {
            InitOpen();
         }
      }
      
      public static function CloseX() : *
      {
         if(_this)
         {
            _this.skin.visible = false;
         }
      }
      
      public static function addKey() : *
      {
         key.setValue(key.getValue() + 1);
      }
      
      public static function addJuan() : *
      {
         juan.setValue(juan.getValue() + 1);
      }
      
      private static function Close(param1:*) : *
      {
         CloseX();
      }
      
      private static function bxOVER(param1:MouseEvent) : *
      {
         _this.skin["kuang"].visible = true;
         _this.skin["kuang"].x = param1.target.x - 250;
         _this.skin["kuang"].y = param1.target.y;
      }
      
      private static function bxOUT(param1:*) : *
      {
         _this.skin["kuang"].visible = false;
      }
      
      private static function showAll() : *
      {
         for(i in openYesNo)
         {
            if(openYesNo[i] == 0)
            {
               _this.skin["b" + i].visible = true;
               _this.skin["k" + i].visible = false;
            }
            else
            {
               _this.skin["b" + i].visible = false;
               _this.skin["k" + i].visible = true;
            }
         }
         _this.skin["juan_txt"].text = "年兽大作战邀请函:" + juan.getValue();
         _this.skin["key_txt"].text = "我的宝箱钥匙:" + key.getValue();
      }
      
      private static function tiaozhanIn(param1:*) : *
      {
         if(juan.getValue() > 0)
         {
            Main.gameNum.setValue(2015);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            Main._this.Loading();
            CloseX();
            juan.setValue(juan.getValue() - 1);
            Main.Save();
         }
         else if(Shop4399.moneyAll.getValue() >= 15)
         {
            Api_4399_All.BuyObj(InitData.newyear15.getValue());
            NYOK15 = true;
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"缺少年兽大作战邀请函");
         }
      }
      
      public static function newYearInRMB() : *
      {
         if(NYOK15)
         {
            Main.gameNum.setValue(2015);
            Main.gameNum2.setValue(1);
            GameData.gameLV = 4;
            Main._this.Loading();
            CloseX();
            NYOK15 = false;
         }
      }
      
      private static function kaiBaoXiang(param1:*) : *
      {
         var _loc2_:SimpleButton = null;
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         if(key.getValue() > 0)
         {
            _loc2_ = param1.target as SimpleButton;
            _loc3_ = uint(_loc2_.name.substr(1,1));
            if(allJiangLi[_loc3_] == 0)
            {
               if(Main.player1.getBag().backOtherBagNum() > 2 && Main.player1.getBag().backGemBagNum() > 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63328));
                  _loc4_ = 0;
                  while(_loc4_ < 5)
                  {
                     Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                     _loc4_++;
                  }
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31216));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31216));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31216));
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得 宠物蛋（年兽）、3级强化石*3、洗练券*5");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 1)
            {
               if(Main.player1.getBag().backOtherBagNum() > 1 && Main.player1.getBag().backGemBagNum() > 1)
               {
                  _loc4_ = 0;
                  while(_loc4_ < 5)
                  {
                     Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63326));
                     _loc4_++;
                  }
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31217));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31217));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31217));
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得 极限炼狱入场券*5、4级强化石*3");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 2)
            {
               if(Main.player1.getBag().backOtherBagNum() > 2)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  _loc4_ = 0;
                  while(_loc4_ < 5)
                  {
                     Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63155));
                     _loc4_++;
                  }
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得黑暗炼狱入场券*5、封印的星灵财宝*3");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 3)
            {
               if(Main.player1.getBag().backOtherBagNum() > 2)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得高级道具兑换券、封印的星灵财宝*2");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 4)
            {
               if(Main.player1.getBag().backOtherBagNum() > 2)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63204));
                  _loc4_ = 0;
                  while(_loc4_ < 5)
                  {
                     Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63235));
                     _loc4_++;
                  }
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得高级道具兑换券、星源方块*5");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 5)
            {
               if(Main.player1.getBag().backOtherBagNum() > 2 && Main.player1.getBag().backGemBagNum() > 1)
               {
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63140));
                  _loc4_ = 0;
                  while(_loc4_ < 5)
                  {
                     Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63210));
                     _loc4_++;
                  }
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31215));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31215));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(31215));
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得击杀点礼包、2级强化石*5、洗练券*5");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 6)
            {
               if(Main.player1.getBag().backGemBagNum() > 2)
               {
                  _loc4_ = 0;
                  while(_loc4_ < 10)
                  {
                     Main.player1.getBag().addGemBag(GemFactory.creatGemById(31214));
                     _loc4_++;
                  }
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(33213));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(33213));
                  Main.player1.getBag().addGemBag(GemFactory.creatGemById(33213));
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得卓越的4级强化石*3、1级强化石*10");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 7)
            {
               if(Main.player1.getBag().backOtherBagNum() > 1 && Main.player1.getBag().backGemBagNum() > 1)
               {
                  _loc4_ = 0;
                  while(_loc4_ < 5)
                  {
                     Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63203));
                     Main.player1.getBag().addGemBag(GemFactory.creatGemById(31217));
                     _loc4_++;
                  }
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得封印的星灵财宝*5、4级强化石*5");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
            else if(allJiangLi[_loc3_] == 8)
            {
               if(Main.player1.getBag().backOtherBagNum() > 1)
               {
                  Main.player1.addGold(50000);
                  Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63181));
                  openYesNo[_loc3_] = 1;
                  key.setValue(key.getValue() - 1);
                  Main.Save();
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"获得50000金币、击杀点礼包（小）*1");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"物品栏空间不足，请清理");
               }
            }
         }
         else
         {
            NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"缺少宝箱钥匙！");
         }
         showAll();
      }
      
      internal function randomizeArray(param1:Array) : Array
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = uint(int(Math.random() * param1.length));
            param1.push(param1.splice(_loc3_,1)[0]);
            _loc2_++;
         }
         return param1;
      }
      
      private function LoadSkin() : *
      {
         if(!skin && !loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onLoadingOK);
            LoadInGame.Open(loadData);
         }
      }
      
      private function onLoadingOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("nyPanel") as Class;
         this.skin = new _loc2_();
         skin.addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
         addChild(skin);
         booltemp = true;
         if(OpenYN)
         {
            Open();
         }
         else
         {
            Close();
         }
      }
      
      private function Close(param1:*) : *
      {
         this.visible = false;
         this.x = this.y = 5000;
      }
      
      private function onADDED_TO_STAGE(param1:*) : *
      {
         if(allJiangLi.length <= 0)
         {
            openYesNo = [0,0,0,0,0,0,0,0,0];
            allJiangLi = [0,1,2,3,4,5,6,7,8];
            randomizeArray(allJiangLi);
         }
         _this.skin["tiaozhan"].addEventListener(MouseEvent.CLICK,tiaozhanIn);
         var _loc2_:* = 0;
         while(_loc2_ < 9)
         {
            _this.skin["b" + _loc2_].addEventListener(MouseEvent.CLICK,kaiBaoXiang);
            _this.skin["b" + _loc2_].addEventListener(MouseEvent.MOUSE_OVER,bxOVER);
            _this.skin["b" + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,bxOUT);
            _loc2_++;
         }
         _this.skin["close_btn"].addEventListener(MouseEvent.CLICK,Close);
         _this.skin["kuang"].visible = false;
      }
   }
}

