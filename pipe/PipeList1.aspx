<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PipeList1.aspx.cs" Inherits="order_QryOrderList1" %>

<!--#include file="../checkLog.inc" -->
<!--
//*******************************
//** 设计人员：   Enjsky
//** 设计日期：   2010-07-31
//** 联系邮箱：   enjsky@163.com
//*******************************
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML XMLNS:ELEMENT>
<head>
<title>查询管道信息列表</title>
<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../css/efs-all.css" />
<script type="text/javascript" src="../js/loadmask.js"></script>
<script type="text/javascript" src="../js/efs-all.js"></script>
<SCRIPT LANGUAGE="JavaScript">

Efs.onReady(function(){
  Efs.getDom("ordList").setAttribute("txtXML",Efs.Common.getQryXml());
  Efs.getExt("ordgrid").getStore().reload();
});

var ordid = "";
function doGridClick(data)
{
  ordid = data["ORDID"];
  Efs.getDom("orderProStore").setAttribute("txtXML",ordid);
  Efs.getExt("orderProGrid").getStore().reload();
  
  Efs.getExt("cmdEdit").enable();
  Efs.getExt("cmdDel").enable();
}

var orderProDom;

function orderEdit()
{
   // 查询订单基本信息并回填
   Efs.Common.ajax("../sysadmin/baseRefWeb.aspx?method=OrdersDetail",ordid,function(succ,xml_http,options){
   if(succ){ // 是否成功
     var xmlReturnDoc = xml_http.responseXML;
     
     Efs.Common.setEditValue(xmlReturnDoc,Efs.getExt("frmPost"), "QUERYINFO");
   }
   else{
     alert("订单基本信息查询失败!");
   }
  });
  
  
   // 回填订单商品列表
   Efs.Common.ajax("../sysadmin/baseRefWeb.aspx?method=OrdersProList",ordid,function(succ,xml_http,options){
   if(succ){ // 是否成功
     orderProDom = xml_http.responseXML;     
     Efs.getExt("ordprogrid_2").getStore().loadData(orderProDom);
   }
   else{
     alert("订单基本信息查询失败!");
   }
  });
  
  Efs.getExt("ordersEdit").show();
}


function doEditSubmit()
{
  if(Efs.getExt("frmPost").isValid())
  {
    if(orderProDom.getElementsByTagName("ORDERSPRO").length == 0)
    {
      alert("订单至少要包含一个商品");
      return false;
    }

    // 修改时给ordid 赋值
    Efs.getDom("ordid").value = ordid ;
    
    // 组织标准的xml
    var frmPostDom = Efs.Common.getOpXml("frmPost",true);
    
    var dataNode = frmPostDom.getElementsByTagName("DATAINFO")[0];
    var nodeNum = orderProDom.getElementsByTagName("ORDERSPRO").length;
    for(var i = 0 ; i< nodeNum;i++)
    {
      var  clone_node = orderProDom.getElementsByTagName("ORDERSPRO")[i].cloneNode(true);
      dataNode.appendChild(clone_node);
    }
    
    Efs.getExt("frmPost").submit(Efs.Common.getXML(frmPostDom));
  }
}


// 获取异步提交的返回监听函数
function frmPostSubBack(bln,from,action)
{  
  if(bln)
  {
    alert("操作成功");
    Efs.getExt("ordgrid").getStore().reload();
    Efs.getExt("orderProGrid").getStore().reload();
    
    Efs.getExt("ordersEdit").hide();
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

function doOrderProAdd()
{
  Efs.getExt("frmPro").reset();
  Efs.getExt("orderProAdd").show();
}

function doOrderProOk()
{
  if(Efs.getExt("frmPro").isValid())
  {
    // 修改时给ordid 赋值
    Efs.getDom("proordid").value = ordid;
    
    var frmProDom = Efs.Common.getOpXml("frmPro",true);
    
    orderProDom.getElementsByTagName("QUERYINFO")[0].appendChild(frmProDom.getElementsByTagName("ORDERSPRO")[0]);
    
    Efs.getExt("orderProAdd").hide();
    Efs.getExt("ordprogrid_2").getStore().loadData(orderProDom);
  }
}


var nodeIndex = -1;
// 记录当前选择的是第几条数据
function doProGridClick(data,grid,rowIndex)
{
  nodeIndex = rowIndex
}

function doProDel()
{
  if(nodeIndex != -1 )
  {    
    orderProDom.getElementsByTagName("QUERYINFO")[0].removeChild(orderProDom.getElementsByTagName("ORDERSPRO")[nodeIndex]);
    
    nodeIndex = -1;
    
    Efs.getExt("ordprogrid_2").getStore().loadData(orderProDom);
  }
}

function cnEdit()
{
  Efs.getExt("ordersEdit").hide();
}

function ordersDel()
{
  Efs.getExt("frmPro").submit(ordid);
}

</SCRIPT>
</HEAD>
<BODY>
<div region="center">
  <div xtype="tbar">
    <div text="修改#E" iconCls="icon-edit" id="cmdEdit" onEfsClick="orderEdit()" disabled="true"></div> 
    <div text="-"></div>
    <div text="删除#D" iconCls="icon-del" id="cmdDel" onEfsClick="ordersDel()" disabled="true"></div>
  </div>

  <div iconCls="icon-panel" title="海底管道数据列表" id="ordgrid" region="center" xtype="grid" pagingBar="true" pageSize="25" onEfsRowClick="doGridClick()">
    <div id="ordList" xtype="store" url="../sysadmin/baseRefWeb.aspx?method=OrdersList" txtXML="" autoLoad="false">
      <div xtype="xmlreader" fieldid="ORDID" record="ROW" totalRecords="QUERYINFO@records">
        <div name="DATA1"></div>
        <div name="DATA2"></div>
        <div name="DATA3"></div>
        <div name="DATA4"></div>
        <div name="DATA5"></div>
        <div name="DATA6"></div>
        <div name="DATA7"></div>
        <div name="DATA8"></div>
        <div name="DATA9"></div>
        <div name="DATA10"></div>
        <div name="DATA11"></div>
        <div name="DATA12"></div>
      </div>
    </div>
    <div xtype="colmodel">
      <div header="管道名称" width="80" sortable="true" dataIndex="DATA1"></div>
      <div header="所属油田" width="80" sortable="true" dataIndex="DATA2"></div>
      <div header="所属海域" width="80" sortable="true" dataIndex="DATA3"></div>
      <div header="所属公司" width="80" sortable="true" dataIndex="DATA4"></div>
      <div header="设计单位" width="40" sortable="true" dataIndex="DATA5"></div>
      <div header="建造单位" width="80" sortable="true" dataIndex="DATA6"></div>
      <div header="安装单位" width="80" sortable="true" dataIndex="DATA7"></div>
      <div header="评估单位" width="80" sortable="true" dataIndex="DATA8"></div>
      <div header="安装日期" width="80" sortable="true" dataIndex="DATA9"></div>
      <div header="调试日期" width="40" sortable="true" dataIndex="DATA10"></div>
      <div header="评估日期" width="80" sortable="true" dataIndex="DATA11"></div>
      <div header="录入日期" width="80" sortable="true" dataIndex="DATA12"></div>
    </div>
  </div>


  <div iconCls="icon-panel" title="订单商品列表" id="orderProGrid"  width="300" xtype="grid" autoScroll="true" split="true">
    <div id="orderProStore" xtype="store" url="../sysadmin/baseRefWeb.aspx?method=OrdersProList" txtXML="" autoLoad="false">
      <div xtype="xmlreader" fieldid="ROWNUM" record="ORDERSPRO" tabName="ORDERSPRO" totalRecords="QUERYINFO@records">
        <div name="ORDID"></div>
        <div name="PRONAME"></div>
        <div name="BUYNUM"></div>
        <div name="PRICE"></div>
        <div name="PRODES"></div>
      </div>
    </div>
    <div xtype="colmodel">
      <div header="订单编号" width="80" sortable="true" dataIndex="ORDID"></div>
      <div header="商品名称" width="80" sortable="true" dataIndex="PRONAME"></div>
      <div header="购买数量" width="60" sortable="true" dataIndex="BUYNUM"></div>
      <div header="单价" width="80" sortable="true" dataIndex="PRICE"></div>
      <div header="描述" width="100" sortable="true" dataIndex="PRODES"></div>
    </div>
  </div>
</div>


<div iconCls="icon-panel" id="ordersEdit" xtype="window" width="500" height="400" title="修改订单" modal="true">
  
  <div xtype="panel" region="north" height="90" iconCls="icon-panel" border="false" autoScroll="true">
    <form id="frmPost" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
        <TABLE class="formArea">
          <tr>
            <td>业务员</td>
            <td><input type="text" kind="text" fieldname="ORDERS/OPER" must="true"></td>
            <td>购买人</td>
            <td><input type="text" id="classid" kind="text" fieldname="ORDERS/BUYER" must="true"></td>
          </tr>
          <tr>
            <td>总金额</td>
            <td><input type="text" kind="text" fieldname="ORDERS/TOTALAMOUNT" datatype="1" must="true"></td>
            <td>购买时间</td>
            <td><input type="text" kind="datetime" fieldname="ORDERS/BUYTIME" datatype="4"></td>
          </tr>
        </TABLE>
        <input type="hidden" kind="text" fieldname="ORDERS/ORDID" operation="1" writeevent="0" state="5">
        <!--构造一个标准的删除订单商品信息的xml-->
        <input id="ordid" type="hidden" kind="text" fieldname="ORDERSPRO/ORDID" operation="2" writeevent="0" state="5">
	  </form>
  </div>


  <div iconCls="icon-panel" title="订单商品" id="ordprogrid_2" region="center" xtype="grid" onEfsRowClick="doProGridClick()" buttonAlign="center">
    <div xtype="tbar">
      <div text="->"></div>
      <div iconCls="icon-add" id="cmdAdd" text="添加商品#A" onEfsClick="doOrderProAdd()"></div>
      <div iconCls="icon-del" id="Div1" text="删除商品#G" onEfsClick="doProDel()"></div>
    </div>
    <div id="ordProList" xtype="store" autoLoad="false">
      <div xtype="xmlreader" fieldid="PRONAME" record="ORDERSPRO" tabName="ORDERSPRO" totalRecords="QUERYINFO@records">
        <div name="PRONAME"></div>
        <div name="BUYNUM"></div>
        <div name="PRICE"></div>
        <div name="PRODES"></div>
      </div>
    </div>
    <div xtype="colmodel">
      <div header="商品名称" width="80" sortable="true" dataIndex="PRONAME"></div>
      <div header="购买数量" width="80" sortable="true" dataIndex="BUYNUM"></div>
      <div header="单价" width="80" sortable="true" dataIndex="PRICE"></div>
      <div header="备注" width="80" sortable="true" dataIndex="PRODES"></div>
    </div>

	   <div xtype="buttons">
     	  <div text="确定修改" onEfsClick="doEditSubmit()"></div>
     	  <div text="取消修改" onEfsClick="cnEdit()"></div>
     </div>

  </div>
</div>



<div iconCls="icon-panel" id="orderProAdd" xtype="window" width="500" height="140" title="添加商品" modal="true">
  <div xtype="tbar">
    <div text="->"></div>
    <div iconCls="icon-ok" text="确定" onEfsClick="doOrderProOk()"></div>
  </div>
   <form id="frmPro" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=OrdersDel" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
      <TABLE class="formArea">
        <tr>
          <td>商品名称</td>
          <td><input type="text" kind="text" fieldname="ORDERSPRO/PRONAME" must="true"></td>
          <td>商品数量</td>
          <td><input type="text" kind="int" fieldname="ORDERSPRO/BUYNUM" datatype="1" must="true"></td>
        </tr>
        <tr>
          <td>单价</td>
          <td><input type="text" kind="float" fieldname="ORDERSPRO/PRICE" datatype="1" must="true"></td>
          <td>备注</td>
          <td><input type="text" kind="text" fieldname="ORDERSPRO/PRODES"></td>
        </tr>
      </TABLE>
      <input id="proordid" type="hidden" kind="text" fieldname="ORDERSPRO/ORDID" operation="0" writeevent="0">
	</form>     
</div>


</BODY>
</HTML>