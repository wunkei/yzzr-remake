package src.tool
{
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import src.*;
   
   public class QianDao extends MovieClip
   {
      
      private static var loadData:ClassLoader;
      
      public static var _this:QianDao;
      
      private static var loadName:String = "QianDao_v2.swf";
      
      private static var OpenYN:Boolean = false;
      
      public static var year:uint = 0;
      
      public static var month:uint = 0;
      
      public static var day:uint = 0;
      
      public static var qdArr:Array = [];
      
      private static var qianDao_money:Boolean = false;
      
      private var skin:MovieClip;
      
      private var infoArr:Array = [["月份"],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品"
      ,3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[301,"高级道具兑换券\n可在特殊任务里的【兑换任务】兑换高级物品的珍贵道具。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[372,"炎煌铠甲(粉)\n传说中唯有进入死亡峡谷中浴火重生者，将得到火神认可，并赠予神赐装备之一“炎煌铠甲”",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[373,"炎煌之翼(紫)\n可以使陨石冲击滑行一段距离。两件相同翅膀可合成为一更高等级翅膀”",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质"
      ,5],[295,"复活药X10\n使用后可原地复活",10],[377,"风华之逝(粉)\n攻击时有几率释放强袭飓风。两件相同外套可合成为一更高等级外套。",1]],[[302,"星灵财宝\n在星灵财宝解封器可解封，解封后可获得珍贵道具，包括“高级道具兑换券”等稀有物品",3],[359,"星源方块\n蕴含巨大能量的神秘晶体,用于星灵附体的星源珠强化,强化时有一定几率提升星源珠的品质",5],[295,"复活药X10\n使用后可原地复活",10],[378,"风华之殇(粉)\n飓风存在时移动速度大幅提升。两件相同翅膀可合成为一更高等级翅膀。",1]]];
      
      public function QianDao()
      {
         super();
         this.LoadSkin();
         _this = this;
      }
      
      private static function InitOpen() : *
      {
         var _loc1_:QianDao = new QianDao();
         Main._stage.addChild(_loc1_);
         OpenYN = true;
         InitDataFun();
      }
      
      public static function Open() : *
      {
         if(year == 0)
         {
            TiaoShi.txtShow("系统时间未获取");
            return;
         }
         if(_this == null)
         {
            InitOpen();
         }
         else
         {
            _this.visible = true;
            _this.skin._BLACK_mc.visible = false;
            _this.x = _this.y = 0;
            _this.Show();
         }
      }
      
      public static function CloseX() : *
      {
         if(_this)
         {
            _this.visible = false;
            _this.x = _this.y = 5000;
         }
      }
      
      private static function InitDataFun() : *
      {
         var _loc1_:uint = 0;
         if(month != qdArr[32])
         {
            _loc1_ = 0;
            while(_loc1_ < 32)
            {
               qdArr[_loc1_] = false;
               _loc1_++;
            }
            qdArr[32] = month;
            qdArr[33] = qdArr[34] = qdArr[35] = qdArr[36] = false;
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 32)
            {
               if(!qdArr[_loc1_])
               {
                  qdArr[_loc1_] = false;
               }
               _loc1_++;
            }
         }
      }
      
      public static function GetMoneyOK() : *
      {
         var _loc1_:int = 0;
         if(qianDao_money)
         {
            qianDao_money = false;
            _loc1_ = int(_this.SelBuQian());
            qdArr[_loc1_] = true;
            _this.Show();
            _this.skin._BLACK_mc.visible = false;
         }
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
         Play_Interface.interfaceX["load_mc"].visible = false;
         var _loc2_:Class = loadData.getClass("Skin") as Class;
         this.skin = new _loc2_();
         addChild(skin);
         skin.qianDao_btn.addEventListener(MouseEvent.CLICK,QianDaoFun);
         skin.buQian_btn.addEventListener(MouseEvent.CLICK,BuQian);
         skin.LingQue_btn.addEventListener(MouseEvent.CLICK,LingQueFun);
         var _loc3_:int = 1;
         while(_loc3_ <= 4)
         {
            skin["_LingQue_" + _loc3_].mouseChildren = skin["_LingQue_" + _loc3_].mouseEnabled = false;
            _loc3_++;
         }
         skin._LingQue_Sel_1.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
         skin._LingQue_Sel_2.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
         skin._LingQue_Sel_3.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
         skin._LingQue_Sel_4.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
         skin._LingQue_Sel_1.addEventListener(MouseEvent.MOUSE_OUT,onMOUSE_OUT);
         skin._LingQue_Sel_2.addEventListener(MouseEvent.MOUSE_OUT,onMOUSE_OUT);
         skin._LingQue_Sel_3.addEventListener(MouseEvent.MOUSE_OUT,onMOUSE_OUT);
         skin._LingQue_Sel_4.addEventListener(MouseEvent.MOUSE_OUT,onMOUSE_OUT);
         skin.Close_btn.addEventListener(MouseEvent.CLICK,Close);
         if(OpenYN)
         {
            Open();
         }
         else
         {
            Close();
         }
      }
      
      private function onMOUSE_MOVE(param1:MouseEvent) : *
      {
         var _loc2_:int = int((param1.target.name as String).substr(13,1));
         skin.info_mc.x = 345;
         skin.info_mc.y = param1.target.y;
         skin.info_mc.visible = true;
         skin.info_mc.pic.gotoAndStop(infoArr[month][_loc2_ - 1][0]);
         skin.info_mc.txt.text = infoArr[month][_loc2_ - 1][1];
         skin.info_mc.pic.howNum.text = "x" + infoArr[month][_loc2_ - 1][2];
      }
      
      private function onMOUSE_OUT(param1:MouseEvent) : *
      {
         skin.info_mc.x = skin.info_mc.y = -2000;
         skin.info_mc.visible = false;
      }
      
      private function Close(param1:* = null) : *
      {
         CloseX();
      }
      
      public function Show() : *
      {
         var _loc6_:uint = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:uint = 0;
         skin._now_txt.text = year + "年" + month + "月";
         var _loc1_:Date = new Date(year,month - 1,1);
         var _loc2_:uint = _loc1_.day;
         var _loc3_:uint = 0;
         if(month == 2)
         {
            if(year % 4 == 0)
            {
               _loc3_ = 29;
            }
            else
            {
               _loc3_ = 28;
            }
         }
         else if(month == 4 || month == 6 || month == 9 || month == 11)
         {
            _loc3_ = 30;
         }
         else
         {
            _loc3_ = 31;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            _loc6_ = 0;
            while(_loc6_ < 7)
            {
               _loc7_ = this.skin["d_" + _loc4_ + _loc6_];
               _loc8_ = _loc4_ * 7 + _loc6_ - _loc2_ + 1;
               if(_loc8_ > 31 || _loc4_ == 0 && _loc6_ < _loc2_ || _loc4_ != 0 && _loc8_ > _loc3_)
               {
                  _loc7_._txt.text = "";
                  _loc7_.visible = false;
               }
               else
               {
                  _loc7_._txt.text = _loc8_;
                  if(_loc8_ <= day)
                  {
                     if(qdArr[_loc8_ - 1])
                     {
                        _loc7_.gotoAndStop(3);
                     }
                     else
                     {
                        _loc7_.gotoAndStop(2);
                     }
                  }
               }
               _loc6_++;
            }
            _loc4_++;
         }
         if(qdArr[36])
         {
            skin.LingQue_btn.visible = false;
         }
         SelBuQian();
         SelQianDao();
         SelLingQue();
         var _loc5_:* = Sel_Total_QianDao();
         skin.total_1.text = "已连续签到: " + _loc5_[0] + "次";
         skin.total_2.text = "已累计签到: " + _loc5_[1] + "次";
      }
      
      private function SelLingQue() : *
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 4)
         {
            if(!qdArr[32 + _loc1_])
            {
               skin["_LingQue_" + _loc1_].visible = false;
            }
            else
            {
               skin["_LingQue_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function Sel_Total_QianDao() : Array
      {
         var _loc1_:int = -1;
         var _loc2_:int = 0;
         var _loc3_:* = int(day - 1);
         while(_loc3_ >= 0)
         {
            if(_loc3_ < 0)
            {
               break;
            }
            if(qdArr[_loc3_])
            {
               _loc2_++;
            }
            if(_loc1_ < 0 && (!qdArr[_loc3_ - 1] || _loc3_ == 0))
            {
               _loc1_ = _loc2_;
            }
            _loc3_--;
         }
         return [_loc1_,_loc2_];
      }
      
      private function SelBuQian() : int
      {
         var _loc1_:* = int(day - 2);
         while(_loc1_ >= 0)
         {
            if(_loc1_ < 0)
            {
               skin.buQian_btn.visible = false;
               return -1;
            }
            if(!qdArr[_loc1_])
            {
               return _loc1_;
            }
            _loc1_--;
         }
         skin.buQian_btn.visible = false;
         return -1;
      }
      
      private function SelQianDao() : *
      {
         if(qdArr[day - 1])
         {
            skin.qianDao_btn.visible = false;
         }
      }
      
      private function QianDaoFun(param1:*) : *
      {
         qdArr[day - 1] = true;
         var _loc2_:Array = Sel_Total_QianDao();
         var _loc3_:uint = uint(_loc2_[0]);
         if(_loc3_ > 7)
         {
            _loc3_ = 7;
         }
         _loc3_ *= InitData.LingQue_10.getValue();
         Main.player1.AddKillPoint(_loc3_);
         if(Main.P1P2)
         {
            Main.player2.AddKillPoint(_loc3_);
         }
         NewMC.Open("文字提示",this,400,400,30,0,true,2,"获得" + _loc3_ + "击杀点");
         Show();
         Main.Save();
      }
      
      private function BuQian(param1:*) : *
      {
         if(SelBuQian() != -1)
         {
            GetMoney();
         }
      }
      
      private function GetMoney() : *
      {
         if(Shop4399.moneyAll.getValue() >= 12)
         {
            skin._BLACK_mc.visible = true;
            qianDao_money = true;
            Api_4399_All.BuyObj(InitData.BuyNum_119.getValue());
         }
         else
         {
            NewMC.Open("文字提示",this,400,400,30,0,true,2,"点券不足");
            skin._BLACK_mc.visible = false;
         }
      }
      
      private function LingQueFun(param1:*) : *
      {
         var _loc2_:* = Sel_Total_QianDao();
         var _loc3_:int = 1;
         while(_loc3_ <= 4)
         {
            if(!qdArr[32 + _loc3_] && _loc2_[1] >= InitData["LingQue_" + _loc3_].getValue())
            {
               LingQueObj(_loc3_ - 1);
               Show();
               return;
            }
            _loc3_++;
         }
      }
      
      private function LingQueObj(param1:int) : *
      {
         var _loc2_:int = 0;
         TiaoShi.txtShow("~~~领取累计奖励" + param1);
         if(param1 == 0)
         {
            if(Main.player1.getBag().backOtherBagNum() < 1)
            {
               NewMC.Open("文字提示",this,400,400,30,0,true,2,"其他类背包空间不足!");
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.LingQue_X0.getValue()));
               _loc2_++;
            }
            qdArr[33 + param1] = true;
         }
         else if(param1 == 1)
         {
            if(Main.player1.getBag().backOtherBagNum() < 1)
            {
               NewMC.Open("文字提示",this,400,400,30,0,true,2,"其他类背包空间不足!");
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.LingQue_X1.getValue()));
               _loc2_++;
            }
            qdArr[33 + param1] = true;
         }
         else if(param1 == 2)
         {
            if(Main.player1.getBag().backSuppliesBagNum() < 1)
            {
               NewMC.Open("文字提示",this,400,400,30,0,true,2,"消耗类背包空间不足!");
               return;
            }
            Main.player1.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(InitData.LingQue_X2.getValue()));
            qdArr[33 + param1] = true;
         }
         else if(param1 == 3)
         {
            if(month >= 1 && month <= 8)
            {
               if(Main.player1.getBag().backOtherBagNum() < 1)
               {
                  NewMC.Open("文字提示",this,400,400,30,0,true,2,"其他类背包空间不足!");
                  return;
               }
               Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(InitData.LingQue_X3[month].getValue()));
               qdArr[33 + param1] = true;
            }
            else
            {
               if(Main.player1.getBag().backequipBagNum() < 1)
               {
                  NewMC.Open("文字提示",this,400,400,30,0,true,2,"装备类背包空间不足!");
                  return;
               }
               Main.player1.getBag().addEquipBag(EquipFactory.createEquipByID(InitData.LingQue_X3[month].getValue()));
               qdArr[33 + param1] = true;
            }
         }
      }
   }
}

