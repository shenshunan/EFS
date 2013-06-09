<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PipeEdit.aspx.cs" Inherits="Pipe_orderEdit" %>
<!--#include file="../checkLog.inc" -->
<!--
//*******************************
//** 设计人员：   Enjsky
//** 设计日期：   2010-08-24
//** 联系邮箱：   enjsky@163.com
//*******************************
-->
<%
    string PIPEID = Request["PIPEID"];
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML XMLNS:ELEMENT>
<head>
<title>修改管道数据</title>
<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../css/efs-all.css" />
<script type="text/javascript" src="../js/loadmask.js"></script>
<script type="text/javascript" src="../js/efs-all.js"></script>

<SCRIPT LANGUAGE="JavaScript">
    Efs.onReady(function () {
        // 查询基本信息并回填
        Efs.Common.ajax("../sysadmin/baseRefWeb.aspx?method=OrdersDetail","<%=PIPEID%>", function (succ, xml_http, options) {
            if (succ) { // 是否成功
                var xmlReturnDoc = xml_http.responseXML;

                Efs.Common.setEditValue(xmlReturnDoc, Efs.getExt("frmPost"), "QUERYINFO");
            }
            else {
                alert("信息查询失败!");
            }
        });

        // 回填订单明细表
        Efs.Common.ajax("../sysadmin/baseRefWeb.aspx?method=OrdersProList","<%=PIPEID%>", function (succ, xml_http, options) {
            if (succ) { // 是否成功
                orderProDom = xml_http.responseXML;
                Efs.getExt("ordprogrid").getStore().loadData(orderProDom);
            }
            else {
                alert("内检数据查询失败!");
            }
        });

    });
function doOrderProAdd()
{
  Efs.getExt("frmPro").reset();
  Efs.getExt("orderProAdd").show();
}
function doOrderProAdd1() {
    Efs.getExt("frmPro1").reset();
    Efs.getExt("orderProAdd1").show();
}
//var orderProDom = Efs.Common.createDocument("<DATAINFO/>");

function doOrderProOk()
{
if (Efs.getExt("frmPro").isValid()) {

    Efs.getDom("proordid").value = "<%=PIPEID%>";
    var frmProDom = Efs.Common.getOpXml("frmPro", true);

    orderProDom.getElementsByTagName("QUERYINFO")[0].appendChild(frmProDom.getElementsByTagName("PIPELINEDETAIL")[0]);

    Efs.getExt("orderProAdd").hide();
    Efs.getExt("ordprogrid").getStore().loadData(orderProDom);
}
}
function doOrderProOk1() {
    if (Efs.getExt("frmPro1").isValid()) {

        Efs.getDom("proordid1").value = "<%=PIPEID%>";
        var frmProDom = Efs.Common.getOpXml("frmPro1", true);

        orderProDom.getElementsByTagName("QUERYINFO")[0].appendChild(frmProDom.getElementsByTagName("PIPELINEDETAIL1")[0]);

        Efs.getExt("orderProAdd1").hide();
        Efs.getExt("ordprogrid1").getStore().loadData(orderProDom);
    }
}

function doSubmit()
{
  if(Efs.getExt("frmPost").isValid()) {

//      Efs.getDom("ordid").value = "<%=PIPEID%>";
    // 组织标准的xml
    var frmPostDom = Efs.Common.getOpXml("frmPost",true);
    
    var dataNode = frmPostDom.getElementsByTagName("DATAINFO")[0];
    var nodeNum = orderProDom.getElementsByTagName("PIPELINEDETAIL").length;
    for(var i = 0 ; i< nodeNum;i++)
    {
        var clone_node = orderProDom.getElementsByTagName("PIPELINEDETAIL")[i].cloneNode(true);
      dataNode.appendChild(clone_node);
    }

  var nodeNum1 = orderProDom.getElementsByTagName("PIPELINEDETAIL1").length;
  for (var i = 0; i < nodeNum1; i++) {
      var clone_node1 = orderProDom.getElementsByTagName("PIPELINEDETAIL1")[i].cloneNode(true);
      dataNode.appendChild(clone_node1);
  }    
    Efs.getExt("frmPost").submit(Efs.Common.getXML(frmPostDom));
  }
}

// 获取异步提交的返回监听函数
function frmPostSubBack(bln,from,action)
{  
  if(bln)
  {
    alert("成功");
    location.href = "PipeList.aspx";
  }
  else
  {
    var xml_http = action.response;
    if(xml_http != null)
    {
      var objXML = xml_http.responseXML;
      
      alert("添加失败：" + Efs.Common.getNodeValue(objXML,"//FUNCERROR",0));
      objXML = null;
      xml_http = null;
    }
  }
}


var nodeIndex = -1;
// 记录当前选择的是第几条数据
function doGridClick(data,grid,rowIndex)
{
  nodeIndex = rowIndex
}

function doDel()
{
  if(nodeIndex != -1 )
  {
      orderProDom.getElementsByTagName("DATAINFO")[0].removeChild(orderProDom.getElementsByTagName("PIPELINEDETAIL")[nodeIndex]);
    
    nodeIndex = -1;
    
    Efs.getExt("ordprogrid").getStore().loadData(orderProDom);
  }
}

function doDel1() {
    if (nodeIndex != -1) {
        orderProDom.getElementsByTagName("DATAINFO")[0].removeChild(orderProDom.getElementsByTagName("PIPELINEDETAIL1")[nodeIndex]);

        nodeIndex = -1;

        Efs.getExt("ordprogrid1").getStore().loadData(orderProDom);
    }
}
function doRet() {
    location.href = "PipeList.aspx";
}
//-->
</SCRIPT>

</HEAD>
<BODY>
<div xtype="tabpanel" region="center"   height="215" iconCls="icon-panel" title="添加管道数据" border="true">
  <div id="tab1" title="管道概况">
  <form id="frmPost" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
      <TABLE class="formArea">
        <tr>
          <td>管道名称</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA1" must="true" datatype="0" ></td>
          <td>所属油田</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA2" datatype="0" ></td>
          <td>所属海域</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA3"  ></td>
          <td>所属公司</td>
          <td><input type="text" id="dic" kind="text" src="DIC_TEST" fieldname="PIPELINE/DATA4"  ></td>
        </tr>
        <tr>
          <td>设计单位</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA5"  ></td>
          <td>建造单位</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA6" ></td>
          <td>安装单位</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA7"  ></td>
          <td>评估单位</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA8" ></td>
        </tr>
        <tr>
          <td>安装日期</td>
          <td><input type="text" kind="date" fieldname="PIPELINE/DATA9" datatype="3"  ></td>
          <td>调试日期</td>
          <td><input type="text" kind="date" fieldname="PIPELINE/DATA10" datatype="3"></td>
          <td>评估日期</td>
          <td><input type="text" kind="date" fieldname="PIPELINE/DATA11" datatype="3"  ></td>
          <td>录入日期</td>
          <td><input type="text" kind="date" fieldname="PIPELINE/DATA12" datatype="3"></td>
        </tr>
        <tr>
          <td>管道长度</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA13" datatype="1"  ></td>
          <td>设计寿命</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA14" datatype="1"></td>
          <td>设计系数</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA15" datatype="1"  ></td>
          <td>输送介质</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA16"></td>
        </tr>
        <tr>
          <td>入口压力</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA17" datatype="1"  ></td>
          <td>入口温度</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA18" datatype="1"></td>
          <td>许用压强</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA19" datatype="1"  ></td>
          <td>操作压强</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA20" datatype="1"></td>
        </tr>
        <tr>
          <td>所处工况</td>
          <td><input type="text" kind="dic" src="DIC_TEST" fieldname="PIPELINE/DATA21"></td>
          <td>水压试验内压</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA22" datatype="1"></td>
          <td>试验介质密度</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA23" datatype="1"  ></td>
          <td>水压试验埋深</td>
          <td><input type="text" kind="float" fieldname="PIPELINE/DATA24" datatype="1"></td>
        </tr>
      </TABLE>
      <input id="personid" type="hidden" kind="text" fieldname="PIPELINE/PIPEID" operation="1" state="5" writeevent="0">
     <%-- <input id="ordid" type="hidden" kind="text" fieldname="PIPELINEDETAIL/PIPEID" operation="2" writeevent="0" state="5">--%>
	</form>    
   </div>
   <div id="tab2" title="管体参数">
  <form id="Form1" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
      <TABLE class="formArea">
        <tr>
          <td colspan="8">管段(KP位置)</td>       
        </tr>       
        <tr>
          <td>大于等于/km</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA25"  ></td>
          <td>小于/km</td>
          <td><input type="text" id="Text2" kind="text" fieldname="PIPELINE/DATA26"  ></td>         
          <td colspan="4"></td>
        </tr>
        <tr>
          <td colspan="8">套管</td>       
        </tr>
        <tr>
          <td>标称外径/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA27" datatype="1"  ></td>
          <td>标称壁厚/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA28" datatype="4"></td>
          <td>材料类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA29" datatype="1"  ></td>
          <td>材料等级</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA30" datatype="4"></td>
        </tr>
        <tr>
          <td>腐蚀裕量/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA31" datatype="1"  ></td>
          <td>钢材密度/kg·m^-3</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA32" datatype="4"></td>
          <td>钢材杨氏模量/MPa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA33" datatype="1"  ></td>
          <td>最小屈服强度/MPa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA34" datatype="4"></td>
        </tr>
        <tr>
          <td>最小拉伸强度/Mpa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA35" datatype="1"  ></td>
          <td>泊松比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA36" datatype="4"></td>
          <td>S-N曲线类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA37" datatype="1"  ></td>
          <td>考虑频率的安全系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA38" datatype="4"></td>
        </tr>
        <tr>
          <td>结构阻尼比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA39" datatype="1"  ></td>
          <td>振动幅值</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA40" datatype="4"></td>
          <td>凹损容许值/%</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA41" datatype="1"  ></td>
          <td>热膨胀系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA42" datatype="4"></td>
        </tr>
        <tr>
          <td>热衰减系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA43" datatype="1"  ></td>
          <td>温度膨胀系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA44" datatype="4"></td>
          <td>轴向压应力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA45" datatype="1"  ></td>
          <td>残余应力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA46" datatype="4"></td>
        </tr>
        <tr>
          <td>标称外径/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA47" datatype="1"  ></td>
          <td>标称壁厚/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA48" datatype="4"></td>
          <td>轴向压应力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA49" datatype="1"  ></td>
          <td>残余应力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA50" datatype="4"></td>
        </tr>
        <tr>
          <td colspan="8">输送管</td>       
        </tr>
        <tr>
          <td>标称外径/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA51" datatype="1"  ></td>
          <td>标称壁厚/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA52" datatype="4"></td>
          <td>材料类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA53" datatype="1"  ></td>
          <td>材料等级</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA54" datatype="4"></td>
        </tr>
        <tr>
          <td>Cr在钢中百分比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA55" datatype="1"  ></td>
          <td>C在钢中百分比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA56" datatype="4"></td>
          <td>内壁粗糙度/m</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA57" datatype="1"  ></td>
          <td>腐蚀裕量/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA58" datatype="4"></td>
        </tr>
        <tr>
          <td>钢材密度/kg·m^-3</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA59" datatype="1"  ></td>
          <td>钢材杨氏模量/MPa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA60" datatype="4"></td>
          <td>最小屈服强度/MPa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA61" datatype="1"  ></td>
          <td>最小拉伸强度/Mpa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA62" datatype="4"></td>
        </tr>
        <tr>
          <td>泊松比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA63" datatype="1"  ></td>
          <td>S-N曲线类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA64" datatype="4"></td>
          <td>考虑频率的安全系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA65" datatype="1"  ></td>
          <td>结构阻尼比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA66" datatype="4"></td>
        </tr>
        <tr>
          <td>振动幅值</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA67" datatype="1"  ></td>
          <td>凹损容许值/%</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA68" datatype="4"></td>
          <td>热膨胀系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA69" datatype="1"  ></td>
          <td>热衰减系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA70" datatype="4"></td>
        </tr>
        <tr>
          <td>温度膨胀系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA71" datatype="1"  ></td>
          <td>轴向压应力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA72" datatype="4"></td>       
          <td>残余应力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA73" datatype="4"></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td colspan="8">混泥土层</td>       
        </tr>
        <tr>
          <td>混凝土层厚度/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA74" datatype="1"  ></td>
          <td>混凝土层密度/kg·m^-3</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA75" datatype="4"></td>
          <td>混凝土杨氏模块/Mpa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA76" datatype="1"  ></td>
          <td>混凝土剪切强度/MPa</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA77" datatype="4"></td>
        </tr>
        <tr>
          <td>混凝土层摩擦因子</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA78" datatype="1"  ></td>
          <td colspan="6"></td>          
        </tr>
         <tr>
          <td colspan="8">防腐层</td>       
        </tr>
        <tr>
          <td>防腐层类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA79" datatype="1"  ></td>
          <td>防腐层厚度/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA80" datatype="4"></td>
          <td>防腐层密度/kg·m^-3</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA81" datatype="1"  ></td>
          <td>防腐涂层摩擦因子</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA82" datatype="4"></td>
        </tr>
          <tr>
          <td colspan="8">保温层</td>       
        </tr>
        <tr>
          <td>绝缘层厚度/mm</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA83" datatype="1"  ></td>
          <td>绝缘层密度/kg·m^-3</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA84" datatype="4"></td>
          <td colspan="4"></td>      
        </tr>
        <tr>
          <td colspan="8">管道接头参数</td>       
        </tr>
        <tr>
          <td>接头长度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA85" datatype="1"  ></td>
          <td>接头缩减长度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA86" datatype="4"></td>
          <td>接头填充物密度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA87" datatype="1"  ></td>
          <td>填充物附属需求</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA88" datatype="4"></td>
        </tr>
      </TABLE>     
	</form>    
   </div>
  <div id="tab3" title="环境参数">
  <form id="Form2" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
      <TABLE class="formArea">
        <tr>
          <td colspan="8">管段(KP位置)</td>       
        </tr>       
        <tr>
          <td>大于等于/km</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA89"  ></td>
          <td>小于/km</td>
          <td><input type="text" id="Text3" kind="text" fieldname="PIPELINE/DATA90"  ></td>         
          <td colspan="4"></td>
        </tr>
        <tr>
          <td colspan="8">海水参数</td>       
        </tr>
        <tr>
          <td>海水密度/kg·m^-3</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA91" datatype="1"  ></td>
          <td>海水运动粘度/m^2·s^-1</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA92" datatype="4"></td>
          <td>表面流速/m·s^-1</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA93" datatype="1"  ></td>
          <td>1年内最大波高/m</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA94" datatype="4"></td>
        </tr>
        <tr>
          <td>1年内波峰周期/s</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA95" datatype="1"  ></td>
          <td>100年内参考流速/m·s-1</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA96" datatype="4"></td>
          <td>参考流高/m</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA97" datatype="1"  ></td>
          <td>波攻角/°</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA98" datatype="4"></td>
        </tr>
        <tr>
          <td>流攻角/°</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA99" datatype="1"  ></td>
          <td>环境温度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA100" datatype="4"></td>
          <td colspan="4"></td>
        </tr>      
        <tr>
          <td colspan="8">土壤参数</td>       
        </tr>
        <tr>
          <td>土壤类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA101" datatype="1"  ></td>
          <td>海床粗糙度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA102" datatype="4"></td>
          <td>土壤刚度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA103" datatype="1"  ></td>
          <td>土壤阻尼比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA104" datatype="4"></td>
        </tr>
        <tr>
          <td>砂子内摩擦角</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA105" datatype="1"  ></td>
          <td>液限粘土粘性剪切强度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA106" datatype="4"></td>
          <td>土壤抗剪强度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA107" datatype="1"  ></td>
          <td>土壤浮容重</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA108" datatype="4"></td>
        </tr>
        <tr>
          <td>土壤含水量</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA109" datatype="1"  ></td>
          <td>土壤单位干重</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA110" datatype="4"></td>
          <td>土壤单位淹没重量</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA111" datatype="1"  ></td>
          <td>固体土壤颗粒比重</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA112" datatype="4"></td>
        </tr>
        <tr>
          <td>静止土压力系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA113" datatype="1"  ></td>
          <td>回填土深度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA114" datatype="4"></td>
          <td>回填土容重</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA115" datatype="1"  ></td>
          <td>回填土土壤粘结力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA116" datatype="4"></td>
        </tr>
        <tr>
          <td>轴向摩擦系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA117" datatype="1"  ></td>
          <td>侧向摩擦系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA118" datatype="4"></td>
          <td colspan="4"></td>          
        </tr>      
        <tr>
          <td colspan="8">悬跨参数</td>       
        </tr>
        <tr>
          <td>沟槽深度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA119" datatype="1"  ></td>
          <td>沟槽角度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA120" datatype="4"></td>
          <td>悬跨长度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA121" datatype="1"  ></td>
          <td>管道与浪相对角</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA122" datatype="4"></td>
        </tr>
        <tr>
          <td>管道与流相对角</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA123" datatype="1"  ></td>
          <td colspan="6"></td>          
        </tr>
         <tr>
          <td colspan="8">地震参数</td>       
        </tr>
        <tr>
          <td>地面震动加速度峰值</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA124" datatype="1"  ></td>
          <td>地面震动速度和加速度峰值比</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA125" datatype="4"></td>
          <td>地震波传播速度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA126" datatype="1"  ></td>
          <td>地震波应变系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA127" datatype="4"></td>
        </tr>
          <tr>
          <td colspan="8">人类活动参数</td>       
        </tr>
        <tr>
          <td>人类活动</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA128" datatype="1"  ></td>
          <td>区域类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA129" datatype="4"></td>
          <td>区域等级</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA130" datatype="1"  ></td>
          <td>安全系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA131" datatype="4"></td>
        </tr>
        <tr>
          <td>一年内过往船只数量</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA132" datatype="1"  ></td>
          <td>船只穿过管道最短路径</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA133" datatype="4"></td>
          <td>预期拖网密度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA134" datatype="1"  ></td>
          <td>拖网类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA135" datatype="4"></td>
        </tr>
        <tr>
          <td>拖网速度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA136" datatype="1"  ></td>
          <td>暴露于拖网区的管长比例</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA137" datatype="4"></td>
          <td>拖网方向与管道夹角</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA138" datatype="1"  ></td>
          <td>抛锚类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA139" datatype="4"></td>
        </tr>
        <tr>
          <td>锚重</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA140" datatype="1"  ></td>
          <td>锚附加质量系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA141" datatype="4"></td>
          <td>拖曳力系数</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA142" datatype="1"  ></td>
          <td colspan="2"></td>
        </tr>
      </TABLE>     
	</form>    
   </div>
   <div id="tab4" title="介质参数">
  <form id="Form3" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
      <TABLE class="formArea">
        <tr>
          <td>介质类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA143" must="true"></td>
          <td>介质密度</td>
          <td><input type="text" id="Text4" kind="text" fieldname="PIPELINE/DATA144" ></td>
          <td>介质的流速</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA145"  ></td>
          <td>管道内温度</td>
          <td><input type="text" id="Text5" kind="text" fieldname="PIPELINE/DATA146"  ></td>
        </tr>
        <tr>
          <td>系统总压力</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA147" datatype="1"  ></td>
          <td>CO2的体积百分比</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA148" datatype="4"></td>
          <td>CO2质量流</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA149" datatype="1"  ></td>
          <td>总的质量流</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA150" datatype="4"></td>
        </tr>
        <tr>
          <td>含水率</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA151" datatype="1"  ></td>
          <td>转化点含水率</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA152" datatype="4"></td>
          <td>油的粘度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA153" datatype="1"  ></td>
          <td>气体粘度</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA154" datatype="4"></td>
        </tr>
        <tr>
          <td>最大相对粘度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA155" datatype="1"  ></td>
          <td>水的密度</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA156" datatype="4"></td>
          <td>油的密度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA157" datatype="1"  ></td>
          <td>气体体积流量</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA158" datatype="4"></td>
        </tr>
        <tr>
          <td>液体体积流量</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA159" datatype="1"  ></td>
          <td>气体压缩系数</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA160" datatype="4"></td>
          <td>乙二醇浓度</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA161" datatype="1"  ></td>
          <td>缓蚀剂效能</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA162" datatype="4"></td>
        </tr>
        <tr>
          <td>气体相对大气比重</td>
          <td><input type="text" kind="text" fieldname="PIPELINE/DATA163" datatype="1"  ></td>
          <td>实际pH值</td>
          <td><input type="text" kind="datetime" fieldname="PIPELINE/DATA164" datatype="4"></td>
          <td colspan="4"></td>
        </tr>
      </TABLE>
	</form>    
   </div>
</div>

<div region="south" xtype="tabpanel" split="true" region="south" height="300">
<div title="内检记录" iconCls="icon-panel" id="ordprogrid"  xtype="grid" onEfsRowClick="doGridClick()" buttonAlign="center">
  <div xtype="tbar">
    <div text="->"></div>
    <div iconCls="icon-add" id="cmdAdd" text="添加记录" onEfsClick="doOrderProAdd()"></div>
    <div iconCls="icon-del" id="cmdDel" text="删除记录" onEfsClick="doDel()"></div>
  </div>
  <div id="psnList" xtype="store" autoLoad="false">
    <div xtype="xmlreader" fieldid="DATA1" record="PIPELINEDETAIL" tabName="PIPELINEDETAIL" totalRecords="QUERYINFO@records">
      <div name="DATA1"></div>
      <div name="DATA2"></div>
      <div name="DATA3"></div>
      <div name="DATA4"></div>
      <div name="DATA5"></div>
      <div name="DATA6"></div>
      <div name="DATA7"></div>
      <div name="DATA8"></div>
      <div name="DATA9"></div>
    </div>
  </div>
  <div xtype="colmodel">
    <div header="检测日期" width="80" sortable="true" dataIndex="DATA1"></div>
    <div header="检测目的" width="80" sortable="true" dataIndex="DATA2"></div>
    <div header="检测单位" width="80" sortable="true" dataIndex="DATA3"></div>
    <div header="检测人员" width="80" sortable="true" dataIndex="DATA4"></div>
    <div header="检测设备" width="80" sortable="true" dataIndex="DATA5"></div>
    <div header="检测方法" width="80" sortable="true" dataIndex="DATA6"></div>
    <div header="绝对法精度" width="80" sortable="true" dataIndex="DATA7"></div>
    <div header="相对法精度" width="80" sortable="true" dataIndex="DATA8"></div>
    <div header="信度水平" width="80" sortable="true" dataIndex="DATA9"></div>
  </div>
	 <div xtype="buttons">
     	<div text="提  交" onEfsClick="doSubmit()"></div>
     	<div text="返  回" onEfsClick="doRet()"></div>
   </div>

</div>
<div title="外检记录" iconCls="icon-panel" id="ordprogrid1"  xtype="grid" onEfsRowClick="doGridClick()" buttonAlign="center">
  <div xtype="tbar">
    <div text="->"></div>
    <div iconCls="icon-add" id="cmdAdd1" text="添加记录" onEfsClick="doOrderProAdd1()"></div>
    <div iconCls="icon-del" id="cmdDel1" text="删除记录" onEfsClick="doDel1()"></div>
  </div>
  <div id="Div4" xtype="store" autoLoad="false">
    <div xtype="xmlreader" fieldid="DATA1" record="PIPELINEDETAIL1" tabName="PIPELINEDETAIL1" totalRecords="QUERYINFO@records">
      <div name="DATA1"></div>
      <div name="DATA2"></div>
      <div name="DATA3"></div>
      <div name="DATA4"></div>
    </div>
  </div>
  <div xtype="colmodel">
    <div header="检测日期" width="80" sortable="true" dataIndex="DATA1"></div>
    <div header="检测单位" width="80" sortable="true" dataIndex="DATA2"></div>
    <div header="检测人员" width="80" sortable="true" dataIndex="DATA3"></div>
    <div header="检测设备" width="80" sortable="true" dataIndex="DATA4"></div>
  </div>
	 <div xtype="buttons">
     	<div text="提  交" onEfsClick="doSubmit()"></div>
     	<div text="返  回" onEfsClick="doRet()"></div>
   </div>

</div>
</div>

<div iconCls="icon-panel" id="orderProAdd" xtype="window" width="760" height="300" title="添加内检记录">
  <div xtype="tbar">
    <div text="->"></div>
    <div iconCls="icon-ok" text="确定" onEfsClick="doOrderProOk()"></div>
  </div>
   <form id="frmPro" class="efs-box" method="post">
      <TABLE class="formArea">
        <tr>
          <td>检测日期</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA1"  ></td>
          <td>检测目的</td>
          <td><input type="text" kind="int" fieldname="PIPELINEDETAIL/DATA2" datatype="1"  ></td>
          <td>检测单位</td>
          <td><input type="text" kind="int" fieldname="PIPELINEDETAIL/DATA3" datatype="1"  ></td>
        </tr>
        <tr>
          <td>检测人员</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA4" datatype="1"  ></td>
          <td>检测设备</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA5"></td>
          <td>检测方法</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA6"></td>
        </tr>
        <tr>
          <td>绝对法精度</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA7" datatype="1"  ></td>
          <td>相对法精度</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA8"></td>
          <td>信度水平</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA9"></td>
        </tr>
        <tr>
          <td>备注</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA10" datatype="1"  ></td>
          <td>检测类型</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA11"></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>KP位置(km)</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA12" datatype="1"  ></td>
          <td>事件</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA13"></td>
          <td>管节序号</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA14"></td>
        </tr>
        <tr>
          <td>管节长度</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA15" datatype="1"  ></td>
          <td>到上一焊缝距离</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA16"></td>
          <td>钟点位置</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA17"></td>
        </tr>
         <tr>
          <td>缺陷壁厚损失</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA18" datatype="1"  ></td>
          <td>缺陷长度</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA19"></td>
          <td>缺陷宽度</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA20"></td>
        </tr>
        <tr>
          <td>ERF值</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL/DATA21" datatype="1"  ></td>
          <td>是否内缺陷</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL/DATA22"></td>
          <td></td>
          <td></td>
        </tr>
      </TABLE>      
      <input id="proordid" type="hidden" kind="text" fieldname="PIPELINEDETAIL/PIPEID" operation="0" writeevent="0">      
	</form>     
</div>

<div iconCls="icon-panel" id="orderProAdd1" xtype="window" width="760" height="300" title="添加外检记录">
  <div xtype="tbar">
    <div text="->"></div>
    <div iconCls="icon-ok" text="确定" onEfsClick="doOrderProOk1()"></div>
  </div>
   <form id="frmPro1" class="efs-box" method="post">
      <TABLE class="formArea">
        <tr>
          <td>检测日期</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL1/DATA1"  ></td>
          <td>检测单位</td>
          <td><input type="text" kind="int" fieldname="PIPELINEDETAIL1/DATA2" datatype="1"  ></td>
          <td>检测人员</td>
          <td><input type="text" kind="int" fieldname="PIPELINEDETAIL1/DATA3" datatype="1"  ></td>
        </tr>
        <tr>
          <td>检测设备</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL1/DATA4" datatype="1"  ></td>
          <td>备注</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL1/DATA5"></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>KP位置(km)</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL1/DATA6" datatype="1"  ></td>
          <td>平面坐标Y(m)</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL1/DATA7"></td>
          <td>平面坐标X(m)</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL1/DATA8"></td>
        </tr>
        <tr>
          <td>海水深度(m)</td>
          <td><input type="text" kind="float" fieldname="PIPELINEDETAIL1/DATA9" datatype="1"  ></td>
          <td>管线顶端距泥面高度(m)裸露悬跨为负值</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL1/DATA10"></td>
          <td>管线状态</td>
          <td><input type="text" kind="text" fieldname="PIPELINEDETAIL1/DATA11"></td>
        </tr>      
      </TABLE>
      <input id="proordid1" type="hidden" kind="text" fieldname="PIPELINEDETAIL1/PIPEID" operation="0" writeevent="0">
	</form>     
</div>

</BODY>
</HTML>

