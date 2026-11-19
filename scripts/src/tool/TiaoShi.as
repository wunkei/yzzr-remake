package src.tool
{
   import com.*;
   import com.ByteArrayXX.*;
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.models.pet.*;
   import com.hotpoint.braveManIII.models.task.*;
   import com.hotpoint.braveManIII.repository.chest.*;
   import com.hotpoint.braveManIII.repository.equip.*;
   import com.hotpoint.braveManIII.repository.equipShop.*;
   import com.hotpoint.braveManIII.repository.gem.*;
   import com.hotpoint.braveManIII.repository.other.*;
   import com.hotpoint.braveManIII.repository.pet.*;
   import com.hotpoint.braveManIII.repository.petEquip.*;
   import com.hotpoint.braveManIII.repository.quest.*;
   import com.hotpoint.braveManIII.repository.supplies.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import com.hotpoint.braveManIII.views.setProfession.*;
   import com.hotpoint.braveManIII.views.skillPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import src.*;
   import src._data.*;
   
   public class TiaoShi extends MovieClip
   {
      
      public static var _this:TiaoShi;
      
      public static var tempVar:String;
      
      private static var traceYN:Boolean = true;
      
      public static var chuanSongYN:Boolean = false;
      
      public static var XXX:Array = [];
      
      public function TiaoShi()
      {
         super();
         _this = this;
         if(!CeShi._this || !Main.tiaoShiYN)
         {
            this.x = this.y = -5000;
            this.visible = false;
            return;
         }
         if(Main.NoLog)
         {
            JieChu_txt.text = "已锁定";
         }
         else
         {
            JieChu_txt.text = "未锁定";
         }
         this.x = 916;
         this.y = 556;
         get_1_btn.addEventListener(MouseEvent.CLICK,GetP1Obj);
         get_2_btn.addEventListener(MouseEvent.CLICK,GetP2Obj);
         Op_btn.addEventListener(MouseEvent.CLICK,OP);
         KaiQi_btn.addEventListener(MouseEvent.CLICK,KaiQi);
         KaiQi_All_btn.addEventListener(MouseEvent.CLICK,KaiQiAll);
         P1_btn.addEventListener(MouseEvent.CLICK,P1_ZhuangTai);
         P2_btn.addEventListener(MouseEvent.CLICK,P2_ZhuangTai);
         tet_btn.addEventListener(MouseEvent.CLICK,Txt_show);
         sysTime_btn.addEventListener(MouseEvent.CLICK,sysTime);
         buy1.addEventListener(MouseEvent.CLICK,BuyOpenNum);
         buy2.addEventListener(MouseEvent.CLICK,BuyOpenNum);
         buy3.addEventListener(MouseEvent.CLICK,BuyOpenNum);
         buy4.addEventListener(MouseEvent.CLICK,BuyOpenNum);
         Q_buy1.addEventListener(MouseEvent.CLICK,Q_BuyOpenNum);
         name_btn.addEventListener(MouseEvent.CLICK,NewName);
         JieChu_btn.addEventListener(MouseEvent.CLICK,JieChu_Fun);
         ChongWu1_btn.addEventListener(MouseEvent.CLICK,CW_Fun1);
         ChongWu2_btn.addEventListener(MouseEvent.CLICK,CW_Fun2);
         ChongWu_close1_btn.addEventListener(MouseEvent.CLICK,CW_Fun1_C);
         ChongWu_close2_btn.addEventListener(MouseEvent.CLICK,CW_Fun2_C);
         other_btn.addEventListener(MouseEvent.CLICK,other_Fun);
         other2_btn.addEventListener(MouseEvent.CLICK,other_Fun2);
         X61_btn.addEventListener(MouseEvent.CLICK,XX61Fun);
         CJ_0_btn.addEventListener(MouseEvent.CLICK,CJ0_Fun);
         liBaoPoint_btn.addEventListener(MouseEvent.CLICK,SetLiBaoPoint);
         liBaoPoint2_btn.addEventListener(MouseEvent.CLICK,SetLiBaoPoint2);
         PaiHangTiJiao_btn.addEventListener(MouseEvent.CLICK,PaiHangTiJiao);
         Sel_btn.addEventListener(MouseEvent.CLICK,SEL_PaiHangTiJiao);
         NewData_btn.addEventListener(MouseEvent.CLICK,NewDataXXX);
         temp_btn.addEventListener(MouseEvent.CLICK,TempFun);
         QingKong_btn.addEventListener(MouseEvent.CLICK,QingKong_Fun);
         chunSong_btn.addEventListener(MouseEvent.CLICK,ChuanSong_Fun);
         GoGame_btn.addEventListener(MouseEvent.CLICK,GoGame_Fun);
         Map0_btn.addEventListener(MouseEvent.CLICK,Map0Fun);
         sysTime_txt.text = Main.serverTime.getValue();
         tiaozan_btn.addEventListener(MouseEvent.CLICK,TiaoZhan0);
         trace_btn.addEventListener(MouseEvent.CLICK,TraceFun);
      }
      
      public static function ShowPaiHang(param1:String = "") : *
      {
         if(Boolean(_this) && Boolean(_this.temp_txt))
         {
            _this.temp_txt.text += "\n回调信息:" + param1;
         }
      }
      
      public static function txtShow(param1:String) : *
      {
         if(Boolean(_this) && Boolean(_this.temp_txt) && Boolean(traceYN))
         {
            _this.temp_txt.text += "\n" + param1;
         }
      }
      
      private function TraceFun(param1:*) : *
      {
         if(traceYN)
         {
            traceYN = false;
            trace_btn.label = "关闭打印";
         }
         else
         {
            traceYN = true;
            trace_btn.label = "开启打印";
         }
      }
      
      private function TiaoZhan0(param1:*) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = int(tiaozhan0.text);
         if(PaiHang_Data.sArr2[0][_loc2_])
         {
            (PaiHang_Data.sArr2[0][_loc2_] as VT).setValue(0);
         }
         if(PaiHang_Data.sArr2[1][_loc2_])
         {
            (PaiHang_Data.sArr2[1][_loc2_] as VT).setValue(0);
         }
         if(PaiHang_Data.sArr2[2][_loc2_])
         {
            (PaiHang_Data.sArr2[2][_loc2_] as VT).setValue(0);
         }
         for(_loc3_ in PaiHang_Data.sArr2)
         {
            if(PaiHang_Data.sArr2[_loc3_])
            {
               for(_loc4_ in PaiHang_Data.sArr2[_loc3_])
               {
                  if(PaiHang_Data.sArr2[_loc3_][_loc4_])
                  {
                     TiaoShi.txtShow(_loc3_ + "," + _loc4_ + " = " + PaiHang_Data.sArr2[_loc3_][_loc4_].getValue());
                  }
               }
            }
         }
      }
      
      private function Map0Fun(param1:*) : *
      {
         if(Main.water.getValue() == 1)
         {
            Map0_txt.text = "海底";
            Main.water.setValue(Math.random() * 999 + 1);
         }
         else
         {
            Map0_txt.text = "地面";
            Main.water = VT.createVT(1);
         }
      }
      
      private function GoGame_Fun(param1:*) : *
      {
         GameData.winYN = false;
         Main.gameNum.setValue(uint(GuanKa1_txt.text));
         Main.gameNum2.setValue(uint(GuanKa2_txt.text));
         GameData.gameLV = uint(GuanKa3_txt.text);
         Main._this.Loading();
      }
      
      private function ChuanSong_Fun(param1:*) : *
      {
         if(chuanSongYN)
         {
            chuanSongYN = false;
         }
         else
         {
            chuanSongYN = true;
         }
      }
      
      private function QingKong_Fun(param1:*) : *
      {
         temp_txt.text = "";
      }
      
      private function OP(param1:*) : *
      {
         if(this.x != 0)
         {
            this.x = this.y = 0;
         }
         else
         {
            this.x = 916;
            this.y = 556;
         }
      }
      
      private function GetP1Obj(param1:*) : *
      {
         var _loc2_:int = 0;
         if(get_1_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num1_txt.text))
            {
               Main.player_1.data.getBag().addEquipBag(EquipFactory.createEquipByID(int(get_1_txt.text)));
               _loc2_++;
            }
         }
         if(get_2_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num2_txt.text))
            {
               Main.player_1.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(int(get_2_txt.text)));
               _loc2_++;
            }
         }
         if(get_3_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num3_txt.text))
            {
               Main.player_1.data.getBag().addGemBag(GemFactory.creatGemById(int(get_3_txt.text)));
               _loc2_++;
            }
         }
         if(get_4_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num4_txt.text))
            {
               Main.player_1.data.getBag().addOtherobjBag(OtherFactory.creatOther(int(get_4_txt.text)));
               _loc2_++;
            }
         }
         if(get_5_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num5_txt.text))
            {
               Main.player_1.data.getBag().addQuestBag(QuestFactory.creatQust(int(get_5_txt.text)));
               _loc2_++;
            }
            TaskData.setOk(int(get_5_txt.text));
         }
      }
      
      private function GetP2Obj(param1:*) : *
      {
         var _loc2_:int = 0;
         if(!Main.P1P2)
         {
            return;
         }
         if(get_1_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num1_txt.text))
            {
               Main.player_2.data.getBag().addEquipBag(EquipFactory.createEquipByID(int(get_1_txt.text)));
               _loc2_++;
            }
         }
         if(get_2_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num1_txt.text))
            {
               Main.player_2.data.getBag().addSuppliesBag(SuppliesFactory.getSuppliesById(int(get_2_txt.text)));
               _loc2_++;
            }
         }
         if(get_3_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num1_txt.text))
            {
               Main.player_2.data.getBag().addGemBag(GemFactory.creatGemById(int(get_3_txt.text)));
               _loc2_++;
            }
         }
         if(get_4_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num1_txt.text))
            {
               Main.player_2.data.getBag().addOtherobjBag(OtherFactory.creatOther(int(get_4_txt.text)));
               _loc2_++;
            }
         }
         if(get_5_txt.text != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < int(get_num1_txt.text))
            {
               Main.player_2.data.getBag().addQuestBag(QuestFactory.creatQust(int(get_5_txt.text)));
               _loc2_++;
            }
            TaskData.setOk(int(get_5_txt.text));
         }
      }
      
      private function KaiQiAll(param1:*) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < 150)
         {
            Main.guanKa[_loc2_] = int(GuanKa3_txt.text);
            _loc2_++;
         }
      }
      
      private function KaiQi(param1:*) : *
      {
         Main.guanKa[int(GuanKa1_txt.text)] = int(GuanKa2_txt.text);
      }
      
      private function P1_ZhuangTai(param1:*) : *
      {
         if(int(p1_txt.text) != -1)
         {
            Main.player_1.data.setLevel(int(p1_txt.text));
         }
         if(int(p2_txt.text) != -1)
         {
            Main.player_1.data.killPoint.setValue(int(p2_txt.text));
         }
         if(int(p3_txt.text) != -1)
         {
            Main.player1.gold.setValue(int(p3_txt.text));
         }
         if(int(p4_txt.text) != -1)
         {
            Main.player_1.data.points.setValue(int(p4_txt.text));
         }
         if(int(p5_txt.text) != -1)
         {
            Enemy.gongJiPOWER.setValue(int(p5_txt.text));
         }
         if(int(p6_txt.text) != -1)
         {
            Main.player_1.fangYuPOWER.setValue(int(p6_txt.text));
         }
         if(int(p7_txt.text) != -1)
         {
            Main.player_1.ExpUP(int(p7_txt.text),2);
         }
         if(int(p8_txt.text) != -1)
         {
            HitXX.baoJiUP.setValue(int(p8_txt.text));
         }
         if(int(p9_txt.text) != -1)
         {
            PaiHang_Data.jiFenArr[1] = VT.createVT(int(p9_txt.text));
            PaiHang_Data.jiFenArr[2] = VT.createVT(int(p9_txt.text));
            PaiHang_Data.jiFenArr[3] = VT.createVT(int(p9_txt.text));
            PaiHang_Data.jiFenArr[4] = VT.createVT(int(p9_txt.text));
         }
      }
      
      private function P2_ZhuangTai(param1:*) : *
      {
         if(!Main.P1P2)
         {
            return;
         }
         if(int(p1_txt.text) != -1)
         {
            Main.player_2.data.setLevel(int(p1_txt.text));
         }
         if(int(p2_txt.text) != -1)
         {
            Main.player_2.data.AddKillPoint(int(p2_txt.text));
         }
         if(int(p3_txt.text) != -1)
         {
            Main.player2.addGold(int(p3_txt.text));
         }
         if(int(p4_txt.text) != -1)
         {
            Main.player_2.data.addPoint(int(p4_txt.text));
         }
         if(int(p5_txt.text) != -1)
         {
            Enemy.gongJiPOWER.setValue(int(p5_txt.text));
         }
         if(int(p6_txt.text) != -1)
         {
            Main.player_2.fangYuPOWER.setValue(int(p6_txt.text));
         }
         if(int(p7_txt.text) != -1)
         {
            Main.player_2.ExpUP(int(p7_txt.text),2);
         }
         if(int(p8_txt.text) != -1)
         {
            HitXX.baoJiUP.setValue(int(p8_txt.text));
         }
         if(int(p9_txt.text) != -1)
         {
         }
      }
      
      private function sysTime(param1:*) : *
      {
         if(int(sysTime_txt.text) != -1)
         {
            Main.serverTime.setValue(int(sysTime_txt.text));
         }
         QianDao.year = sysTime_txt.text.substr(0,4);
         QianDao.month = sysTime_txt.text.substr(4,2);
         QianDao.day = sysTime_txt.text.substr(6,2);
         txtShow("设置时间: " + QianDao.year + "." + QianDao.month + "." + QianDao.day);
      }
      
      private function BuyOpenNum(param1:MouseEvent) : *
      {
         ShopKillPoint.KaiQiShopArr2[0] = 0;
         var _loc2_:int = int((param1.target.name as String).substr(3,1));
         if(ShopKillPoint.KaiQiShopArr2[_loc2_] == true)
         {
            ShopKillPoint.KaiQiShopArr2[_loc2_] = false;
            ShopKillPoint.shopX["shopX_" + _loc2_]["skin"].visible = true;
         }
         else
         {
            ShopKillPoint.KaiQiShopArr2[_loc2_] = true;
            ShopKillPoint.shopX["shopX_" + _loc2_]["skin"].visible = false;
         }
      }
      
      private function Q_BuyOpenNum(param1:MouseEvent) : *
      {
         if(Q_buy_txt.text == "1")
         {
            Main.player1.getStampSlot().setKeySlot11();
         }
         else if(Q_buy_txt.text == "2")
         {
            Main.player2.getStampSlot().setKeySlot11();
         }
         else if(Q_buy_txt.text == "0")
         {
            Main.player1.getStampSlot().setKeySlot11();
            Main.player2.getStampSlot().setKeySlot11();
         }
      }
      
      private function NewName(param1:*) : *
      {
         if(name_txt.text != 0)
         {
            Main.logName = name_txt.text;
            Main.logNameSave = "";
            Main.varX_old = 0;
         }
         if(var_txt.text != 0)
         {
            Main.varX = int(var_txt.text);
         }
      }
      
      private function JieChu_Fun(param1:*) : *
      {
         Main.noSave = -43998785;
         Main.NoLog = 0;
         Main.NoLogInfo = new Array();
      }
      
      private function CW_Fun1(param1:*) : *
      {
         Main.player_1.playerCW = null;
         Main.player1.getPetSlot().addPetSlot(PetFactory.creatPet(73101));
         Main.player1.getPetSlot().addPetSlot(PetFactory.creatPet(73500));
      }
      
      private function CW_Fun2(param1:*) : *
      {
         Main.player_2.playerCW = null;
         Main.player2.getPetSlot().addPetSlot(PetFactory.creatPet(73101));
         Main.player2.getPetSlot().addPetSlot(PetFactory.creatPet(73500));
      }
      
      private function CW_Fun1_C(param1:*) : *
      {
         if(Boolean(Main.player_1.playerCW) && Boolean(Main.player_1.playerCW.data.addExp(99999)))
         {
            NewMC.Open("宠物升级",Main.player_1.playerCW);
         }
         if(Boolean(Main.player_1.playerJL) && Boolean(Main.player_1.playerJL.data.addExp(99999)))
         {
            NewMC.Open("宠物升级",Main.player_1.playerCW);
         }
      }
      
      private function CW_Fun2_C(param1:*) : *
      {
         if(Main.player_2.playerCW.data.addExp(99999))
         {
            NewMC.Open("宠物升级",Main.player_2.playerCW);
         }
      }
      
      private function ShowInfo() : *
      {
         temp_txt.text += "logName = " + Main.logName + "\n";
         temp_txt.text += "Uid = " + Main.userId + "\n";
         temp_txt.text += "当前版本 = " + Main.varX + " ,存档版本 = " + Main.varX_old + "\n";
         if(Main.logNameSave == "" && Main.varX_old < 182 || Boolean(MD5contrast.contrast(Main.logName,Main.logNameSave,Main.saveNum)))
         {
            temp_txt.text += "存档:" + (int(Main.logNameSave.substr(5,1)) + 1) + ", sn:" + Main.logNameSave.substr(6,8) + "\n" + "验证信息: " + MD5contrast.contrastID + "\n";
         }
         else
         {
            temp_txt.text += "验证失败!!\n" + "存档:" + (int(Main.logNameSave.substr(5,1)) + 1) + ", sn:" + Main.logNameSave.substr(6,8) + "\n" + "验证信息: 错误#" + MD5contrast.errorID + "\n";
         }
         if(Main.NoLog == 0)
         {
            temp_txt.text += "作弊检测:验证通过\n";
         }
         else if(Main.NoLog >= 2)
         {
            temp_txt.text += "\n>>>>>>>>>>>>>>>>>>>\n\n\n 作弊检测:已锁定 \n";
            if(Main.NoLogInfo[2])
            {
               temp_txt.text += "\n #2 修改攻击倍数" + Main.NoLogInfo[2] + "\n";
            }
            if(Main.NoLogInfo[3])
            {
               temp_txt.text += "\n #3 修改金币" + Main.NoLogInfo[3] + "\n";
            }
            if(Main.NoLogInfo[4])
            {
               temp_txt.text += "\n #4 物品堆叠上限" + Main.NoLogInfo[4] + "\n";
            }
            if(Main.NoLogInfo[5])
            {
               temp_txt.text += "\n #5 防复制" + Main.NoLogInfo[5] + "\n";
            }
            if(Main.NoLogInfo[7])
            {
               temp_txt.text += "\n #7 宝石类复制" + Main.NoLogInfo[7] + "\n";
            }
            if(Main.NoLogInfo[8])
            {
               temp_txt.text += "\n #8 其他类复制" + Main.NoLogInfo[8] + "\n";
            }
            if(Main.NoLogInfo[10])
            {
               temp_txt.text += "\n #10 修改技能表XML \n";
            }
            if(Main.NoLogInfo[11])
            {
               temp_txt.text += "\n #11 修改暴击闪避" + Main.NoLogInfo[11] + " \n";
            }
            if(Main.NoLogInfo[12] is int)
            {
               temp_txt.text += "\n #12 点券不足 领取礼包\n";
            }
            if(Main.NoLogInfo[13])
            {
               temp_txt.text += "\n #13 Vip称号\n";
            }
            if(Main.NoLogInfo[15])
            {
               temp_txt.text += "\n #15 跳关修改!\n";
            }
            temp_txt.text += "\n #Main.NoLog = " + Main.NoLog + ", NoLogInfo = " + Main.NoLogInfo;
            temp_txt.text += "\n\n\n>>>>>>>>>>>>>>>>>>>\n";
         }
         temp_txt.text += "\n已领取礼包 = " + Main.lingQueArr + ", length" + Main.lingQueArr.length;
         temp_txt.text += "\n已领取累计礼包 = " + Main.lingQueArr2 + ", length" + Main.lingQueArr.length;
         temp_txt.text += "\n活动礼包领取 = " + TeShuHuoDong.TeShuHuoDongArr + ", length" + Main.lingQueArr.length + "\n";
         temp_txt.text += "\n充值活动圣灵驹领取 = " + ChongZhi_Interface.lingQu3 + "\n";
         if(Shop4399.totalRecharged.getValue() != -2)
         {
            temp_txt.text += "\n累计充值:" + Shop4399.totalRecharged.getValue() + "点券";
            temp_txt.text += "\n礼包前充值:" + Shop_LiBao.HDpoint.getValue() + "点券";
            temp_txt.text += "\n活动赠送卷:" + TeShuHuoDong.TeShuHuoDongArr[0] + "点券";
         }
         else
         {
            temp_txt.text += "请稍候再试\n";
         }
         CheckTest.Testing();
         CheckTest.TestingOther();
         Main.wts.wantedTaskComplete();
         temp_txt.text += "\n Main.noSave = " + Main.noSave;
         temp_txt.text += "Shop4399.ShopArr.length = " + ShopFactory.GetObjData_AllNum();
      }
      
      private function XX61Fun(param1:*) : *
      {
         AchData.cjPoint_1.setValue(int(X61info_txt.text));
         AchData.cjPoint_2.setValue(int(X61_txt.text));
      }
      
      private function other_Fun(param1:*) : *
      {
         Main.lingQueArr = [];
         Main.lingQueArr2 = [];
         TeShuHuoDong.TeShuHuoDongArr = [];
      }
      
      private function other_Fun2(param1:*) : *
      {
         ChongZhi_Interface.HDpoint5.setValue(int(liBaoPoint_txt.text));
         ChongZhi_Interface.lingQu = false;
         ChongZhi_Interface.lingQu2 = false;
         ChongZhi_Interface.lingQu3 = false;
      }
      
      private function CJ0_Fun(param1:*) : *
      {
         AchData.initAllAc();
      }
      
      private function SetLiBaoPoint(param1:*) : *
      {
         Shop_LiBao.HDpoint.setValue(int(liBaoPoint2_txt.text));
      }
      
      private function SetLiBaoPoint2(param1:*) : *
      {
         Shop4399.totalRecharged.setValue(int(liBaoPoint3_txt.text));
      }
      
      private function SEL_PaiHangTiJiao(param1:*) : *
      {
         PK_UI.Open();
      }
      
      private function PaiHangTiJiao(param1:*) : *
      {
         var _loc2_:Array = [];
         _loc2_[0] = new Object();
         _loc2_[0].rId = int(PaiHangID_txt.text);
         _loc2_[0].score = uint(PaiHangTiJiao_txt.text);
         Api_4399_All.SubmitScore(Main.saveNum,_loc2_);
      }
      
      private function NewDataXXX(param1:*) : *
      {
         TiaoShi.txtShow(TimeBox.TimeXX(CeShiMd5_PLayerData));
      }
      
      private function CeShiMd5_PLayerData() : *
      {
         TiaoShi.txtShow("Main.player1 - md5:" + MD5contrast.getObj_MD5String(Main.player1));
      }
      
      private function TempShow() : *
      {
         temp_txt.text = "";
         MD5contrast.getObj_MD5String(Main.player_1.data.getBag());
      }
      
      private function TempFun(param1:*) : *
      {
         TiaoShi.txtShow("怪物数据验证 md5:" + Data2.Enemy_md5_2);
         TiaoShi.txtShow("技能列表验证 md5:" + Data2.skill_md5_2);
         TiaoShi.txtShow("任务列表验证 md5:" + Data2.renWu_md5_2);
         TiaoShi.txtShow("飞行道具" + equipShopFactory.allData.length);
      }
      
      private function Txt_show(param1:*) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         temp_txt.text = "";
         if(int(type_txt.text) == 1)
         {
            ShowInfo();
         }
         else if(int(type_txt.text) == 2)
         {
            GongHui_Interface.Open();
         }
         else if(int(type_txt.text) == 3)
         {
            Api_4399_GongHui.getList(1);
         }
         else if(int(type_txt.text) == 4)
         {
            Api_4399_GongHui.upNum(15);
         }
         else if(int(type_txt.text) == 5)
         {
            _loc2_ = [15];
            Api_4399_GongHui.getNum(_loc2_);
         }
         else if(int(type_txt.text) == 6)
         {
            NewPetPanel.tiaoshi();
         }
         else if(int(type_txt.text) == 7)
         {
            NewPetPanel.testSkillxx();
         }
         else if(int(type_txt.text) == 8)
         {
            Play_Interface.TiShiShow(false,110097);
         }
         else if(int(type_txt.text) == 9)
         {
            NewPetPanel.bag.addPetBag(PetEquipFactory.creatPetEquip(int(type2_txt.text)));
         }
         else if(int(type_txt.text) == 10)
         {
            Main.player1.getPetSlot().addPetSlot(PetFactory.creatPet(int(type2_txt.text)));
         }
         else if(int(type_txt.text) == 11)
         {
            Main.wts.getWantedTaskFromSlot(1).addTimes(50);
            Main.wts.getWantedTaskFromSlot(4).addTimes(50);
            Main.wts.getWantedTaskFromSlot(7).addTimes(50);
            Main.wts.getWantedTaskFromSlot(10).addTimes(50);
            Main.wts.getWantedTaskFromSlot(13).addTimes(50);
            Main.wts.getWantedTaskFromSlot(16).addTimes(50);
            Main.wts.getWantedTaskFromSlot(19).addTimes(50);
         }
         else if(int(type_txt.text) == 12)
         {
            Yayale_LingQue.Open();
         }
         else if(int(type_txt.text) == 13)
         {
            Yayale_LingQue.DuiHuanOpen();
         }
         else if(int(type_txt.text) == 14)
         {
            _loc2_ = [47];
            Api_4399_GongHui.getNum(_loc2_);
         }
         else if(int(type_txt.text) == 15)
         {
            _loc2_ = [48];
            Api_4399_GongHui.getNum(_loc2_);
         }
         else if(int(type_txt.text) == 16)
         {
            _loc2_ = [49];
            Api_4399_GongHui.getNum(_loc2_);
         }
         else if(int(type_txt.text) == 17)
         {
            _loc2_ = [50];
            Api_4399_GongHui.getNum(_loc2_);
         }
         else if(int(type_txt.text) == 18)
         {
            _loc2_ = [127,126];
            Api_4399_GongHui.getNum(_loc2_);
         }
         else if(int(type_txt.text) == 20)
         {
            SixOne_Interface.okTimes.setValue(int(type2_txt.text));
         }
         else if(int(type_txt.text) == 21)
         {
            _loc3_ = NewLoad.OtherData.getClass("_PK_UI") as Class;
            _loc4_ = new _loc3_();
            Main._stage.addChild(xx);
         }
         else if(int(type_txt.text) == 22)
         {
            JiFenLingQue2.DengLuUp();
         }
         else if(int(type_txt.text) == 23)
         {
            TiaoShi.txtShow("清除转职");
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
               if(Main.player1._transferArr[_loc6_])
               {
                  _loc5_++;
               }
               _loc6_++;
            }
            if(_loc5_ > 1)
            {
               TiaoShi.txtShow("清除转职---------> 1P");
               SkillPanel.open();
               SkillPanel.close();
               SkillPanel._instance.aginP1();
               _loc6_ = 0;
               while(_loc6_ < 3)
               {
                  if(Main.player1._transferArr[_loc6_])
                  {
                     Main.player1._transferArr[_loc6_] = false;
                  }
                  _loc6_++;
               }
               TiaoShi.txtShow("清除转职---------> 1P end");
            }
         }
         else if(int(type_txt.text) == 24 && int(type2_txt.text) == 99)
         {
            GengXin.saveTime = "2014/7/10";
            Api_4399_GongHui.upNum(57);
            Api_4399_GongHui.upNum(58);
            Api_4399_GongHui.getNum([57,58]);
            GengXin.CaXun();
         }
         else if(int(type_txt.text) == 25)
         {
            if(int(type2_txt.text) == 1)
            {
               JiFenLingQue3.Post(true);
            }
            else
            {
               JiFenLingQue3.Post();
            }
         }
         else if(int(type_txt.text) == 26)
         {
            Main.player_1.playerJL.jiNengBD_ID = int(type2_txt.text);
            TiaoShi.txtShow("精灵被动技能 = " + int(type2_txt.text));
         }
         else if(int(type_txt.text) == 27)
         {
            TiaoShi.txtShow("精灵主动技能 = " + int(Main.player_1.playerJL.jiNengZD_ID));
         }
         else if(int(type_txt.text) == 28)
         {
            _loc5_ = int(TaskData.zhuXianNum());
            TiaoShi.txtShow("主线任务完成数量 = " + _loc5_);
         }
         else if(int(type_txt.text) == 29)
         {
            SJ_Interface.Open();
         }
         else if(int(type_txt.text) == 30)
         {
            _loc6_ = 0;
            while(_loc6_ <= 4)
            {
               if(PaiHang_Data.sArr2[_loc6_])
               {
                  TiaoShi.txtShow("i=" + _loc6_ + "\n");
                  if(PaiHang_Data.sArr2[_loc6_].length > 0)
                  {
                     _loc7_ = 1;
                     while(_loc6_ < PaiHang_Data.sArr2[_loc6_].length)
                     {
                        TiaoShi.txtShow(PaiHang_Data.sArr2[_loc6_][_loc7_].getValue() + ",");
                        _loc7_++;
                     }
                  }
                  TiaoShi.txtShow("\n");
               }
               _loc6_++;
            }
         }
         else if(int(type_txt.text) == 31)
         {
            ZhuanPan.saveTime = 0;
            ZhuanPan.Open();
         }
         else if(int(type_txt.text) == 32)
         {
            ZhuanPan.Num1time = 27 * 30;
         }
         else if(int(type_txt.text) == 33)
         {
            Main.player1.getElvesSlot().addSlotNum(1);
         }
         else if(int(type_txt.text) == 34)
         {
            Main.player1.getElvesSlot().getElvesFromSlot(int(type2_txt.text)).delPinkEquip();
         }
         else if(int(type_txt.text) == 35)
         {
            Main.player1.getElvesSlot().getElvesFromSlot(0).delPinkEquip();
         }
         else if(int(type_txt.text) == 36)
         {
            PK_UI.xPk_Player_min = int(type2_txt.text);
         }
         else if(int(type_txt.text) == 37)
         {
            PK_UI.jiFenArr[1].setValue(int(type2_txt.text));
         }
         else if(int(type_txt.text) == 38)
         {
            PK_UI.Pk_timeNum = int(type2_txt.text);
         }
         else if(int(type_txt.text) == 40)
         {
            TiaoShi.txtShow("调试#40 !!竞技场重新刷新玩家~~~~~~~~~~~~~~~~~~~~~");
            PK_UI.reAddOtherPlayer();
         }
         else if(int(type_txt.text) == 41)
         {
            ChongZhi_Interface.HDpoint8.setValue(int(type2_txt.text));
            TiaoShi.txtShow("调试HDpoint8 = " + ChongZhi_Interface.HDpoint8.getValue());
         }
         else if(int(type_txt.text) == 42)
         {
            TiaoShi.txtShow(PK_UI.jiFenArr[7]);
            ++PK_UI.jiFenArr[7];
            Main.player1.getBag().addOtherobjBag(OtherFactory.creatOther(63300));
         }
         else if(int(type_txt.text) == 43)
         {
            TiaoShi.txtShow("查询" + Api_4399_All.xxxArr.length + ":" + Api_4399_All.xxxArr);
         }
         else if(int(type_txt.text) == 44)
         {
            Main.player1.getPetSlot().addPetSlot(Pet.creatPet(int(type2_txt.text)));
            Main.player1.getPetSlot().getPetFromSlot(0).setLv(20);
         }
         else if(int(type_txt.text) == 45)
         {
            Main.player1.getPetSlot().getPetFromSlot(0).setSkill(int(type2_txt.text));
         }
         else if(int(type_txt.text) == 46)
         {
            NewYear_Interface.addJuan();
            NewYear_Interface.addKey();
         }
         else if(int(type_txt.text) == 47)
         {
            for(_loc6_ in Enemy.All)
            {
               (Enemy.All[_loc6_] as Enemy).life.setValue(2);
            }
         }
         else if(int(type_txt.text) == 48)
         {
            ChestFactory.getDataByPro(int(type2_txt.text));
         }
         else
         {
            TiaoShi.txtShow("参数错误");
         }
      }
   }
}

