<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PipeList.aspx.cs" Inherits="PipeList" %>
<!--#include file="../checkLog.inc" -->
<!--
//*******************************
//** �����Ա��   Enjsky
//** ������ڣ�   2009-10-28
//** ��ϵ���䣺   enjsky@163.com
//*******************************
-->
<HTML>
<head>
<title>���������б�</title>
<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../css/efs-all.css" />
<script type="text/javascript" src="../js/loadmask.js"></script>
<script type="text/javascript" src="../js/efs-all.js"></script>

<SCRIPT language="JavaScript">
Efs.onReady(function () {
    Efs.getDom("affList").setAttribute("txtXML", Efs.Common.getQryXml());
    Efs.getExt("affgrid").getStore().reload();
});
var PIPEID = "";
function onEditEx()
{
  if(PIPEID != "")
      location.href = "PipeEdit.aspx?PIPEID=" + PIPEID;
}

function onAddEx()
{
    location.href = "PipeAdd.aspx";
}
function Look3D() {
    location.href = "../MyTestPage.html";
}


var g_XML = Efs.Common.getQryXml();

function doGridClick(data){
    PIPEID = data["PIPEID"];
    if (PIPEID != "") {
    Efs.getExt("cmdEdit").enable();
    Efs.getExt("cmdDel").enable();
  }
}

function onDel()
{
    if(confirm("ȷ��ɾ����"))
    {
        var strXml = Efs.getExt("affgrid").getDelXml();
        //var strXml = Efs.getExt("affgrid").getSelectedXml();
         //alert(strXml);
         Efs.getExt("frmDel").submit(strXml);

    }
  
}
// ��ȡ�첽�ύ�ķ��ؼ�������
function frmPostSubBack(bln,from,action)
{
  if(bln)
  {
    Efs.getExt("affgrid").store.reload();
  }
  else
  {
    var xml_http = action.response;
    if(xml_http != null )
    {
      var strRet = xml_http.responseText;
      var objXML = Efs.Common.createDocument(strRet);
      
      alert("����ʧ�ܣ�" + Efs.Common.getNodeValue(objXML,"//FUNCERROR",0));
      objXML = null;
    }
    xml_http = null;
  }
}

function doQry() {
    var strXml = Efs.Common.getQryXml(Efs.getExt("frmQry"))

    Efs.getDom("affList").setAttribute("txtXML", strXml);
    Efs.getExt("affgrid").store.load();
}
function doExcel() {
    Efs.getExt("winExcel").show();
}
function doExcelSubmit() {
    Efs.getExt("frmExcel").submit();
}
//excel���뷵��
function frmExcelSubBack(bln, frm, action) {
    var xml_http = action.response;
    if (xml_http != null) {
        var obj = Ext.decode(xml_http.responseText);
        if (obj.success) {
            alert("�ϴ��ɹ�");
            Efs.getExt("winExcel").hide();
            Efs.getExt("affgrid").store.reload();
        }
        else {
            alert("�ϴ�ʧ��:" + obj.message);
        }
    }
    xml_http = null;
}
//����excel
function doExpExcel() {
    Efs.Msg.wait();
    Efs.Common.ajax("../sysadmin/baseRefWeb.aspx?method=ExpExcel", "", function (succ, xml_http, options) {
        if (succ) { // �Ƿ�ɹ�
            var xmlReturnDoc = xml_http.responseXML;

            Efs.Msg.alert("��Ϣ��ʾ", "����Excel�ɹ���<a href='upload_files/" + xmlReturnDoc.selectSingleNode("//FUNCERROR").text + "' target='_blank'>��������.</a>");

        }
        else {
            alert("��������ʧ��!");
        }
    });

}
function doRet() {
    Efs.getExt("frmQry").reset();
}
</SCRIPT>
</HEAD>
<BODY>
<div id="roleTab" region="north" height="80" xtype="panel" border="false" title="���׹ܵ������б�">
   <form id="frmQry" method="post">
    <TABLE class="formAreaTop" width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td width="60">�ܵ�����</td>
          <td width="100"><input type="text" class="Edit" fieldname="DATA1" operation="like" hint="ģ����ѯ"></td>
          <td width="60">��������</td>
          <td width="100"><input type="text" class="Edit" fieldname="DATA2"></td>   
          <td width="60">��������</td>
          <td width="100"><INPUT type="text" kind="dic" src="DIC_DATA3" fieldname="DATA3" >           
          <td><input iconCls="icon-qry" type="button" value="�� ѯ" onEfsClick="doQry()"></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td width="60">������˾</td>
          <td width="100"><input type="text" kind="dic" src="DIC_DATA4" fieldname="DATA4" ></td>
          <td width="60">��Ƶ�λ</td>
          <td width="100"><input type="text" kind="dic" src="DIC_DATA5" fieldname="DATA5" ></td>   
          <td width="60">������λ</td>
          <td width="100"><input type="text" kind="dic" src="DIC_DATA8" fieldname="DATA8" ></td>            
          <td><input type="button" value="�� ��" onEfsClick="doRet()"></div></td>
          <td>&nbsp;</td>
        </tr>
        
      </TABLE>
    </form>
</div>
<div iconCls="icon-panel" id="affgrid" region="center" xtype="grid" pagingBar="true" pageSize="25" onEfsRowClick="doGridClick()" onEfsRowDblClick="onEditEx()">
     <div xtype="tbar">
       <div text="->"></div>
       <div iconCls="icon-qry" id="Div1" text="�鿴��άģ��" onEfsClick="Look3D()"></div>
       <div text="->"></div>
       <div iconCls="icon-excel" id="cmdExcel" text="����Excel" onEfsClick="doExcel()"></div>
       <div text="-"></div>
       <div iconCls="icon-excel" id="cmdExpExcel" text="����Excel" onEfsClick="doExpExcel()"></div>
       <div text="-"></div>
       <div iconCls="icon-add" text="���" onEfsClick="onAddEx()"></div>
      <div text="-"></div>
       <div iconCls="icon-edit" id="cmdEdit" text="�༭" onEfsClick="onEditEx()" disabled="true"></div>
      <div text="-"></div>
       <div iconCls="icon-del" id="cmdDel" text="ɾ��" onEfsClick="onDel()" disabled="true"></div>
     </div>
    <div id="affList" xtype="store" url="../sysadmin/baseRefWeb.aspx?method=OrdersList" txtXML="" autoLoad="false">
      <div xtype="xmlreader" fieldid="PIPEID" record="ROW" tabName="PIPELINE" totalRecords="QUERYINFO@records">
         <div name="PIPEID"></div>
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
    <div type="checkbox"></div>
      <div header="�ܵ�����" width="80" sortable="true" dataIndex="DATA1"></div>
      <div header="��������" width="80" sortable="true" dataIndex="DATA2"></div>
      <div header="��������" width="80" sortable="true" dataIndex="DATA3"></div>
      <div header="������˾" width="80" sortable="true" dataIndex="DATA4"></div>
      <div header="��Ƶ�λ" width="40" sortable="true" dataIndex="DATA5"></div>
      <div header="���쵥λ" width="80" sortable="true" dataIndex="DATA6"></div>
      <div header="��װ��λ" width="80" sortable="true" dataIndex="DATA7"></div>
      <div header="������λ" width="80" sortable="true" dataIndex="DATA8"></div>
      <div header="��װ����" width="80" sortable="true" dataIndex="DATA9"></div>
      <div header="��������" width="40" sortable="true" dataIndex="DATA10"></div>
      <div header="��������" width="80" sortable="true" dataIndex="DATA11"></div>
      <div header="¼������" width="80" sortable="true" dataIndex="DATA12"></div>
    </div>
  </div>
<FORM id="frmPost" name="frmPost" url="" method="post" style="display:none;" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
    <INPUT type="hidden" name="txtDicName" value="AFFAIRTYPE">
  </FORM>

     <form id="frmDel" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
     </form>
  <div xtype="window" id="winExcel" height="200" width="500" title="����������Ϣ(Excel)">

  <form id="frmExcel" class="efs-box" method="post" url="UploadFile.aspx" method="post" onEfsSuccess="frmExcelSubBack(true)" onEfsFailure="frmExcelSubBack(false)" fileUpload="true">
    ��ѡ��һ��Excel��<input type="file" name="file" style="width:300px">
  </form>

  <div xtype="buttons">
    <div text="ȷ  ��" onEfsClick="doExcelSubmit()"></div>
  </div>
  
</div>
</BODY>
</HTML>