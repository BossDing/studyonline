<%@ page language="java" pageEncoding="GB2312"
	contentType="text/html; charset=UTF-8"%>
<html>
	<head>
		<title>�����ҵ�¼</title>
		<link rel="stylesheet" type="text/css"
			href="${pageContext.request.contextPath }/css/styles.css">
		<script language="javascript">
			function showMess(mess){
				document.getElementById("mess").innerHTML="<font color='red'>"+mess+"</font>";
			}
			//����û����Ƿ��¼
			function checkUserIsExits(){
				var objName = document.myform.name;
				
				if(objName.value==""){
					objName.focus();
					showMess("�������û���!");
					return;
				}else{
					for(var i=0;i<objName.value.length;i++){
						var ch = objName.value.charAt(i);
						if(ch=='<' || ch =='>' || ch=='-' || ch=='/' || ch=='\\'){
							objName.focus();
							showMess("���ܺ���<,>,-�������ַ���");
							return;
						}
					}
				}
				var url = "${pageContext.request.contextPath}/checkUser.do?user="+objName.value;
				sendRequest(url);
			}
			
			//����XMLHttpRequest����
			var xmlRequest;
			//��������
			function createXMLHttpRequest(){
				if(window.XMLHttpRequest) { //Mozilla �����
					xmlRequest = new XMLHttpRequest();
				}else if (window.ActiveXObject) { // IE�����
					try {
						xmlRequest = new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try {
							xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e) {}
					}
				}
			}
			
			//����������
			function sendRequest(url){
				createXMLHttpRequest(); //��������
				url=encodeURI(url); 
				url=encodeURI(url); 
				xmlRequest.open("GET",url,true);
				xmlRequest.onreadystatechange = checkResponse; //��Ӧ�ĺ���
				xmlRequest.send(null);
			}
			
			//��Ӧ�ĺ���
			function checkResponse(){
				if(xmlRequest.readyState==4){
					if(xmlRequest.status ==200) {
						//��Ϣ�Ѿ��ɹ�����
						showloginInfo();
					}else{
						showMess("���������ҳ�����쳣��");
					}
				}
			}
			
			//��ʾ����
			function showloginInfo(){
				//ȡ�� checkUser.jsp���ص�XML�ı�  
				var message = xmlRequest.responseXML.getElementsByTagName("userinfo")[0].firstChild.nodeValue;
				showMess(message);
				//��Ϊ֮ǰ����XML һֱ���ִ��� ���Ը�����XML�ı�  ����ʾ ��ȡ����
				if(message=="����ʹ��"){
					showMess("<font color='blue'>����ʹ�ø����ƣ�</font>");
					document.getElementById("sub").disabled=false; //ʹ��ť����
				}
			}
		</script>
	</head>
	<body>
		<div id="mainDiv">
			<form action="${pageContext.request.contextPath}/doLogin.do"
				name="myform" method="post">
				<table align="left" width="300">
					<caption align="left">
						<font color="blue" size="6" face="����">o ��ȤС�������� O</font>
					</caption>
					<tr>
						<td>
							�û���:
						</td>
						<td>
							<input type="text" class="normalTxt" name="name"
								onblur="checkUserIsExits()">
						</td>
					</tr>

					<tr>
						<td colspan="2">
							<input type="submit" id="sub" class="normalBtn" value="��  ¼"
								disabled="true">
							&nbsp;
							<input type="reset" class="normalBtn" value="��  ��">
							&nbsp;
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right">
							<label id="mess">
								&nbsp;
							</label>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<br>
							<br>
							<br>
							<a href="javascript:close()">�˳�</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>
